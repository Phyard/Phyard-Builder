/*
* Copyright (c) 2007-2009 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

//#include <Box2D/Collision/b2Collision.h>
//#include <Box2D/Collision/b2Distance.h>
//#include <Box2D/Collision/b2TimeOfImpact.h>
//#include <Box2D/Collision/Shapes/b2CircleShape.h>
//#include <Box2D/Collision/Shapes/b2PolygonShape.h>

//#include <cstdio>

public static var b2_toiCalls:int, b2_toiIters:int, b2_toiMaxIters:int;
public static var b2_toiRootIters:int, b2_toiMaxRootIters:int;

//struct b2SeparationFunction
//{
	//@see b2SeparationFunction.as
//};

// CCD via the secant method.
public static function b2TimeOfImpact_(input:b2TOIInput):Number
{
	++b2_toiCalls;

	var proxyA:b2DistanceProxy = input.proxyA;
	var proxyB:b2DistanceProxy = input.proxyB;

	var sweepA:b2Sweep = input.sweepA.Clone ();
	var sweepB:b2Sweep = input.sweepB.Clone ();

	//b2Assert(sweepA.t0 == sweepB.t0);
	//b2Assert(1.0f - sweepA.t0 > b2Settings.b2_epsilon);

	var radius:Number = proxyA.m_radius + proxyB.m_radius;
	var tolerance:Number = input.tolerance;

	var alpha:Number = 0.0;

	const k_maxIterations:int = 1000;	// TODO_ERIN b2Settings
	var iter:int = 0;
	var target:Number = 0.0;

	// Prepare input for distance query.
	var cache:b2SimplexCache = new b2SimplexCache ();
	cache.count = 0;
	var distanceInput:b2DistanceInput = new b2DistanceInput ();
	distanceInput.proxyA.CopyFrom (input.proxyA);
	distanceInput.proxyB.CopyFrom (input.proxyB);
	distanceInput.useRadii = false;

	for(;;)
	{
		var xfA:b2Transform = new b2Transform (), xfB:b2Transform = new b2Transform ();
		sweepA.GetTransform(xfA, alpha);
		sweepB.GetTransform(xfB, alpha);

		// Get the distance between shapes.
		distanceInput.transformA.CopyFrom (xfA);
		distanceInput.transformB.CopyFrom (xfB);
		var distanceOutput:b2DistanceOutput = new b2DistanceOutput ();
		b2Distance.b2Distance_ (distanceOutput, cache, distanceInput);

		if (distanceOutput.distance <= 0.0)
		{
			alpha = 1.0;
			break;
		}

		var fcn:b2SeparationFunction = new b2SeparationFunction ();
		fcn.Initialize(cache, proxyA, xfA, proxyB, xfB);

		var separation:Number = fcn.Evaluate(xfA, xfB);
		if (separation <= 0.0)
		{
			alpha = 1.0;
			break;
		}

		if (iter == 0)
		{
			// Compute a reasonable target distance to give some breathing room
			// for conservative advancement. We take advantage of the shape radii
			// to create additional clearance.
			if (separation > radius)
			{
				target = Math.max(radius - tolerance, 0.75 * radius);
			}
			else
			{
				target = Math.max(separation - tolerance, 0.02 * radius);
			}
		}

		if (separation - target < 0.5 * tolerance)
		{
			if (iter == 0)
			{
				alpha = 1.0;
				break;
			}

			break;
		}

//#if 0
//		// Dump the curve seen by the root finder
//		{
//			const int32 N = 100;
//			float32 dx = 1.0f / N;
//			float32 xs[N+1];
//			float32 fs[N+1];
//
//			float32 x = 0.0f;
//
//			for (int32 i = 0; i <= N; ++i)
//			{
//				sweepA.GetTransform(&xfA, x);
//				sweepB.GetTransform(&xfB, x);
//				float32 f = fcn.Evaluate(xfA, xfB) - target;
//
//				printf("%g %g\n", x, f);
//
//				xs[i] = x;
//				fs[i] = f;
//
//				x += dx;
//			}
//		}
//#endif

		// Compute 1D root of: f(x) - target = 0
		var newAlpha:Number = alpha;
//		{
			var x1:Number = alpha, x2:Number = 1.0;

			var f1:Number = separation;

			sweepA.GetTransform(xfA, x2);
			sweepB.GetTransform(xfB, x2);
			var f2:Number = fcn.Evaluate(xfA, xfB);

			// If intervals don't overlap at t2, then we are done.
			if (f2 >= target)
			{
				alpha = 1.0;
				break;
			}

			// Determine when intervals intersect.
			var rootIterCount:int = 0;
			for (;;)
			{
				// Use a mix of the secant rule and bisection.
				var x:Number;
				if ((rootIterCount & 1) != 0)
				{
					// Secant rule to improve convergence.
					x = x1 + (target - f1) * (x2 - x1) / (f2 - f1);
				}
				else
				{
					// Bisection to guarantee progress.
					x = 0.5 * (x1 + x2);
				}

				sweepA.GetTransform(xfA, x);
				sweepB.GetTransform(xfB, x);

				var f:Number = fcn.Evaluate(xfA, xfB);

				if (Math.abs(f - target) < 0.025 * tolerance)
				{
					newAlpha = x;
					break;
				}

				// Ensure we continue to bracket the root.
				if (f > target)
				{
					x1 = x;
					f1 = f;
				}
				else
				{
					x2 = x;
					f2 = f;
				}

				++rootIterCount;
				++b2_toiRootIters;

				if (rootIterCount == 50)
				{
					break;
				}
			}

			b2_toiMaxRootIters = b2Math.b2Max_int (b2_toiMaxRootIters, rootIterCount);
//		}

		// Ensure significant advancement.
		if (newAlpha < (1.0 + 100.0 * b2Settings.b2_epsilon) * alpha)
		{
			break;
		}

		alpha = newAlpha;

		++iter;
		++b2_toiIters;

		if (iter == k_maxIterations)
		{
			break;
		}
	}

	b2_toiMaxIters = b2_toiMaxIters > iter ? b2_toiMaxIters : iter;

	return alpha;
}
