/*
* Copyright (c) 2006-2009 Erin Catto http://www.gphysics.com
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

//#ifndef B2_SETTINGS_H
//#define B2_SETTINGS_H

package Box2D.Common
{
	//#include <cassert>
	//#include <cmath>

	public class b2Settings
	{
		include "b2Settings.cpp";

		//#define B2_NOT_USED(x) x
		public static function B2_NOT_USED (x:Object):void
		{
		}
		
		//#define b2Assert(A) assert(A)
		public static function b2Assert (A:Boolean):void
		{
			//if (!A) trace ("assert failed!");
		}

		//typedef signed char	int8;
		//typedef signed short int16;
		//typedef signed int int32;
		//typedef unsigned char uint8;
		//typedef unsigned short uint16;
		//typedef unsigned int uint32;
		//typedef float float32;

		//#define	B2_FLT_MAX	FLT_MAX
		//#define	B2_FLT_EPSILON	FLT_EPSILON
		//#define b2_pi						3.14159265359f

		public static const b2_maxFloat   :Number = Number.MAX_VALUE; // in the c++ version, the value is max float32 (3.402823466e+38), but all numbers in as3 are float64
		public static const b2_epsilon    :Number = 1.192092896e-07;
		public static const b2_pi         :Number = Math.PI;          // in the c++ version the value is 3.14159265359f
		
		// moved from b2Collision.h
		public static const UCHAR_MAX:int = 0xFF;

		/// @file
		/// Global tuning constants based on meters-kilograms-seconds (MKS) units.
		///

		// Collision

		/// The maximum number of contact points between two convex shapes.
		public static const b2_maxManifoldPoints:int = 2;

		/// The maximum number of vertices on a convex polygon.
		public static const b2_maxPolygonVertices:int = 8;

		/// This is used to fatten AABBs in the dynamic tree. This allows proxies
		/// to move by a small amount without triggering a tree adjustment.
		/// This is in meters.
		public static const b2_aabbExtension:Number = 0.1;

		/// This is used to fatten AABBs in the dynamic tree. This is used to predict
		/// the future position based on the current displacement.
		/// This is a dimensionless multiplier.
		public static const b2_aabbMultiplier:Number = 2.0;

		/// A small length used as a collision and constraint tolerance. Usually it is
		/// chosen to be numerically significant, but visually insignificant.
		public static const b2_linearSlop:Number = 0.005;

		/// A small angle used as a collision and constraint tolerance. Usually it is
		/// chosen to be numerically significant, but visually insignificant.
		public static const b2_angularSlop:Number = (2.0 / 180.0 * b2Settings.b2_pi);

		/// The radius of the polygon/edge shape skin. This should not be modified. Making
		/// this smaller means polygons will have an insufficient buffer for continuous collision.
		/// Making it larger may create artifacts for vertex collision.
		public static const b2_polygonRadius:Number = (2.0 * b2Settings.b2_linearSlop);


		// Dynamics

		/// Maximum number of contacts to be handled to solve a TOI impact.
		public static const b2_maxTOIContacts:int = 32;

		/// A velocity threshold for elastic collisions. Any collision with a relative linear
		/// velocity below this threshold will be treated as inelastic.
		public static const b2_velocityThreshold:Number = 1.0;

		/// The maximum linear position correction used when solving constraints. This helps to
		/// prevent overshoot.
		public static const b2_maxLinearCorrection:Number = 0.2;

		/// The maximum angular position correction used when solving constraints. This helps to
		/// prevent overshoot.
		public static const b2_maxAngularCorrection:Number = (8.0 / 180.0 * b2Settings.b2_pi);

		/// The maximum linear velocity of a body. This limit is very large and is used
		/// to prevent numerical problems. You shouldn't need to adjust this.
		public static const b2_maxTranslation       :Number = 2.0;
		public static const b2_maxTranslationSquared:Number = (b2_maxTranslation * b2_maxTranslation);

		/// The maximum angular velocity of a body. This limit is very large and is used
		/// to prevent numerical problems. You shouldn't need to adjust this.
		public static const b2_maxRotation       :Number = (0.5 * b2Settings.b2_pi);
		public static const b2_maxRotationSquared:Number = (b2_maxRotation * b2_maxRotation);

		/// This scale factor controls how fast overlap is resolved. Ideally this would be 1 so
		/// that overlap is removed in one time step. However using values close to 1 often lead
		/// to overshoot.
		public static const b2_contactBaumgarte:Number = 0.2;

		// Sleep

		/// The time that a body must be still before it will go to sleep.
		public static const b2_timeToSleep:Number = 0.5;

		/// A body cannot sleep if its linear velocity is above this tolerance.
		public static const b2_linearSleepTolerance:Number = 0.01;

		/// A body cannot sleep if its angular velocity is above this tolerance.
		public static const b2_angularSleepTolerance:Number = (2.0 / 180.0 * b2Settings.b2_pi);

		// Memory Allocation

		/// The current number of bytes allocated through b2Alloc.
		//extern int32 b2_byteCount;

		/// Implement this function to use your own memory allocator.
		//void* b2Alloc(int32 size);

		/// If you implement b2Alloc, you should also implement this function.
		//void b2Free(void* mem);

		/// Version numbering scheme.
		/// See http://en.wikipedia.org/wiki/Software_versioning
		//struct b2Version
		//{
			// @see b2Version class
		//};

		/// Friction mixing law. Feel free to customize this.
		public static function b2MixFriction(friction1:Number, friction2:Number):Number
		{
			return Math.sqrt (friction1 * friction2);
		}

		/// Restitution mixing law. Feel free to customize this.
		public static function b2MixRestitution(restitution1:Number, restitution2:Number):Number
		{
			return restitution1 > restitution2 ? restitution1 : restitution2;
		}

	}// class
} // pacakge
//#endif
