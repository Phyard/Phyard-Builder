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

public static var b2_toiMaxOptIters:int;

//struct b2SeparationFunction
//{
	//@see b2SeparationFunction.as
//};

private static var sSimplexCache:b2SimplexCache = new b2SimplexCache ();
private static var sDistanceInput:b2DistanceInput = new b2DistanceInput ();
private static var sDistanceOutput:b2DistanceOutput = new b2DistanceOutput ();

private static var xfA:b2Transform = new b2Transform ();
private static var xfB:b2Transform = new b2Transform ();

private static var sSeparationFunction:b2SeparationFunction = new b2SeparationFunction ();
private static var sFindMinSeparationOutput:b2FindMinSeparationOutput = new b2FindMinSeparationOutput ();

// CCD via the local separating axis method. This seeks progression
// by computing the largest time at which separation is maintained.
public static function b2TimeOfImpact_ (output:b2TOIOutput, input:b2TOIInput):void
{
	++b2_toiCalls;

	output.state = b2TOIOutput.e_unknown;
	output.t = input.tMax;

	const proxyA:b2DistanceProxy = input.proxyA;
	const proxyB:b2DistanceProxy = input.proxyB;

	var sweepA:b2Sweep = input.sweepA; //.Clone ();
	var sweepB:b2Sweep = input.sweepB; //.Clone ();

	// Large rotations can make the root finder fail, so we normalize the
	// sweep angles.
	sweepA.Normalize();
	sweepB.Normalize();

	var tMax:Number = input.tMax;

	var totalRadius:Number = proxyA.m_radius + proxyB.m_radius;
	var target:Number = Math.max(b2Settings.b2_linearSlop, totalRadius - 3.0 * b2Settings.b2_linearSlop);
	var tolerance:Number = 0.25 * b2Settings.b2_linearSlop;
	//b2Assert(target > tolerance);

	var t1:Number = 0.0;
	const k_maxIterations:int = 20;	// TODO_ERIN b2Settings
	var iter:int = 0;

	// Prepare input for distance query.
	var cache:b2SimplexCache = sSimplexCache;
	cache.count = 0;
	var distanceInput:b2DistanceInput = sDistanceInput;
	distanceInput.proxyA = input.proxyA; // .Clone () // hacking
	distanceInput.proxyB = input.proxyB; // .Clone () // hacking
	distanceInput.useRadii = false;

	// The outer loop progressively attempts to compute new separating axes.
	// This loop terminates when an axis is repeated (no progress is made).
	for(;;)
	{
		sweepA.GetTransform(xfA, t1);
		sweepB.GetTransform(xfB, t1);

		// Get the distance between shapes. We can also use the results
		// to get a separating axis.
		distanceInput.transformA = xfA; // .CopyFrom // hacking
		distanceInput.transformB = xfB; // .CopyFrom // hacking
		var distanceOutput:b2DistanceOutput = sDistanceOutput;
		b2Distance.b2Distance_ (distanceOutput, cache, distanceInput);

		// If the shapes are overlapped, we give up on continuous collision.
		if (distanceOutput.distance <= 0.0)
		{
			// Failure!
			output.state = b2TOIOutput.e_overlapped;
			output.t = 0.0;
			break;
		}

		if (distanceOutput.distance < target + tolerance)
		{
			// Victory!
			output.state = b2TOIOutput.e_touching;
			output.t = t1;
			break;
		}

		// Initialize the separating axis.
		var fcn:b2SeparationFunction = sSeparationFunction;
		fcn.Initialize(cache, proxyA, sweepA, proxyB, sweepB, t1);

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

		// Compute the TOI on the separating axis. We do this by successively
		// resolving the deepest point. This loop is bounded by the number of vertices.
		var done:Boolean = false;
		var t2:Number = tMax;
		var pushBackIter:int = 0;
		for (;;)
		{
			// Find the deepest point at t2. Store the witness point indices.
			fcn.FindMinSeparation(sFindMinSeparationOutput, t2);
			var indexA:int = sFindMinSeparationOutput.indexA, 
				indexB:int = sFindMinSeparationOutput.indexB;
			var s2:Number = sFindMinSeparationOutput.separation;

			// Is the final configuration separated?
			if (s2 > target + tolerance)
			{
				// Victory!
				output.state = b2TOIOutput.e_separated;
				output.t = tMax;
				done = true;
				break;
			}

			// Has the separation reached tolerance?
			if (s2 > target - tolerance)
			{
				// Advance the sweeps
				t1 = t2;
				break;
			}

			// Compute the initial separation of the witness points.
			var s1:Number = fcn.Evaluate(indexA, indexB, t1);

			// Check for initial overlap. This might happen if the root finder
			// runs out of iterations.
			if (s1 < target - tolerance)
			{
				output.state = b2TOIOutput.e_failed;
				output.t = t1;
				done = true;
				break;
			}

			// Check for touching
			if (s1 <= target + tolerance)
			{
				// Victory! t1 should hold the TOI (could be 0.0).
				output.state = b2TOIOutput.e_touching;
				output.t = t1;
				done = true;
				break;
			}

			// Compute 1D root of: f(x) - target = 0
			var rootIterCount:int = 0;
			var a1:Number = t1, a2:Number = t2;
			for (;;)
			{
				// Use a mix of the secant rule and bisection.
				var t:Number;
				if ( (rootIterCount & 1) != 0)
				{
					// Secant rule to improve convergence.
					t = a1 + (target - s1) * (a2 - a1) / (s2 - s1);
				}
				else
				{
					// Bisection to guarantee progress.
					t = 0.5 * (a1 + a2);
				}

				var s:Number = fcn.Evaluate(indexA, indexB, t);

				if (Math.abs (s - target) < tolerance)
				{
					// t2 holds a tentative value for t1
					t2 = t;
					break;
				}

				// Ensure we continue to bracket the root.
				if (s > target)
				{
					a1 = t;
					s1 = s;
				}
				else
				{
					a2 = t;
					s2 = s;
				}

				++rootIterCount;
				++b2_toiRootIters;

				if (rootIterCount == 50)
				{
					break;
				}
			}

			b2_toiMaxRootIters = Math.max (b2_toiMaxRootIters, rootIterCount);
			
			++pushBackIter;
			
			if (pushBackIter == b2Settings.b2_maxPolygonVertices)
			{
				break;
			}
		}

		++iter;
		++b2_toiIters;

		if (done)
		{
			break;
		}

		if (iter == k_maxIterations)
		{
			// Root finder got stuck. Semi-victory.
			output.state = b2TOIOutput.e_failed;
			output.t = t1;
			break;
		}
	}

	b2_toiMaxIters = Math.max (b2_toiMaxIters, iter);
}
