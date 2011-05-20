/*
* Copyright (c) 2006-2009 Erin Catto http://www.box2d.org
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

//#ifndef B2_TIME_STEP_H
//#define B2_TIME_STEP_H

package Box2D.Dynamics
{
	//#include <Box2D/Common/b2Settings.h>

	/// This is an internal structure.
	//struct b2TimeStep
	public class b2TimeStep
	{
		// this function doesn't exist in the c++ version
		public function Clone ():b2TimeStep
		{
			var timeStep:b2TimeStep = new b2TimeStep ();
			timeStep.CopyFrom (this);

			return timeStep;
		}
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2TimeStep):void
		{
			dt = another.dt;
			inv_dt = another.inv_dt;
			dtRatio = another.dtRatio;
			velocityIterations = another.velocityIterations;
			positionIterations = another.positionIterations;
			warmStarting = another.warmStarting;
		}

		public var dt:Number;			// time step
		public var inv_dt:Number;		// inverse time step (0 if dt == 0).
		public var dtRatio:Number;	// dt * inv_dt0
		public var velocityIterations:int;
		public var positionIterations:int;
		public var warmStarting:Boolean;
	} // class
} // package

//#endif
