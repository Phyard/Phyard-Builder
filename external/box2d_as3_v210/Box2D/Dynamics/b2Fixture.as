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

//#ifndef B2_FIXTURE_H
//#define B2_FIXTURE_H


package Box2D.Dynamics
{

	//#include <Box2D/Dynamics/b2Body.h>
	//#include <Box2D/Collision/b2Collision.h>
	//#include <Box2D/Collision/Shapes/b2Shape.h>
	
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Vec2;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2BroadPhase;
	import Box2D.Collision.b2Collision;
	import Box2D.Collision.b2RayCastOutput;
	import Box2D.Collision.b2RayCastInput;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;

	/// A fixture is used to attach a shape to a body for collision detection. A fixture
	/// inherits its transform from its parent. Fixtures hold additional non-geometric data
	/// such as friction, collision filters, etc.
	/// Fixtures are created via b2Body::CreateFixture.
	/// @warning you cannot reuse fixtures.
	public class b2Fixture
	{
		include "b2Fixture.cpp";
		
	// public:
	
		/// Get the type of the child shape. You can use this to down cast to the concrete shape.
		/// @return the shape type.
		//b2Shape::Type GetType() const;

		/// Get the child shape. You can modify the child shape, however you should not change the
		/// number of vertices because this will crash some collision caching mechanisms.
		//b2Shape* GetShape();
		//const b2Shape* GetShape() const;

		/// Set if this fixture is a sensor.
		//void SetSensor(bool sensor);

		/// Is this fixture a sensor (non-solid)?
		/// @return the true if the shape is a sensor.
		//bool IsSensor() const;

		/// Set the contact filtering data. This will not update contacts until the next time
		/// step when either parent body is active and awake.
		//void SetFilterData(const b2Filter& filter);

		/// Get the contact filtering data.
		//const b2Filter& GetFilterData() const;

		/// Get the parent body of this fixture. This is NULL if the fixture is not attached.
		/// @return the parent body.
		//b2Body* GetBody();
		//const b2Body* GetBody() const;

		/// Get the next fixture in the parent body's fixture list.
		/// @return the next shape.
		//b2Fixture* GetNext();
		//const b2Fixture* GetNext() const;

		/// Get the user data that was assigned in the fixture definition. Use this to
		/// store your application specific data.
		//void* GetUserData();

		/// Set the user data. Use this to store your application specific data.
		//void* GetUserData() const;

		/// Test a point for containment in this fixture.
		/// @param xf the shape world transform.
		/// @param p a point in world coordinates.
		//bool TestPoint(const b2Vec2& p) const;

		/// Cast a ray against this shape.
		/// @param output the ray-cast results.
		/// @param input the ray-cast input parameters.
		//bool RayCast(b2RayCastOutput* output, const b2RayCastInput& input) const;

		/// Get the mass data for this fixture. The mass data is based on the density and
		/// the shape. The rotational inertia is about the shape's origin. This operation
		/// may be expensive.
		//void GetMassData(b2MassData* massData) const;

		/// Set the density of this fixture. This will _not_ automatically adjust the mass
		/// of the body. You must call b2Body::ResetMassData to update the body's mass.
		//void SetDensity(float32 density);

		/// Get the density of this fixture.
		//float32 GetDensity() const;

		/// Get the coefficient of friction.
		//float32 GetFriction() const;

		/// Set the coefficient of friction.
		//void SetFriction(float32 friction);

		/// Get the coefficient of restitution.
		//float32 GetRestitution() const;

		/// Set the coefficient of restitution.
		//void SetRestitution(float32 restitution);

		/// Get the fixture's AABB. This AABB may be enlarge and/or stale.
		/// If you need a more accurate AABB, compute it using the shape and
		/// the body transform.
		//const b2AABB& GetAABB() const;

	//protected:


		
		//b2Fixture();
		//~b2Fixture();

		// We need separation create/destroy functions from the constructor/destructor because
		// the destructor cannot access the allocator or broad-phase (no destructor arguments allowed by C++).
		//void Create(b2BlockAllocator* allocator, b2Body* body, const b2Transform& xf, const b2FixtureDef* def);
		//void Destroy(b2BlockAllocator* allocator);

		//void Synchronize(b2BroadPhase* broadPhase, const b2Transform& xf1, const b2Transform& xf2);

		public var m_massData:b2MassData = new b2MassData ();

		public var m_aabb:b2AABB = new b2AABB ();

		public var m_density:Number;

		public var m_next:b2Fixture;
		public var m_body:b2Body;

		public var m_shape:b2Shape;

		public var m_friction:Number;
		public var m_restitution:Number;

		public var m_proxyId:int; //int32
		public var m_filter:b2Filter = new b2Filter ();

		public var m_isSensor:Boolean;

		public var m_userData:Object;

	// inline
		
		public function GetType():int
		{
			return m_shape.GetType();
		}

		public function GetShape():b2Shape
		{
			return m_shape;
		}

		//inline const b2Shape* b2Fixture::GetShape() const
		//{
		//	return m_shape;
		//}

		public function IsSensor():Boolean
		{
			return m_isSensor;
		}

		public function GetFilterData():b2Filter
		{
			return m_filter;
		}

		public function GetUserData():Object
		{
			return m_userData;
		}

		public function SetUserData(data:Object):void
		{
			m_userData = data;
		}

		public function GetBody():b2Body
		{
			return m_body;
		}

		//inline const b2Body* b2Fixture::GetBody() const
		//{
		//	return m_body;
		//}

		public function GetNext():b2Fixture
		{
			return m_next;
		}

		//inline const b2Fixture* b2Fixture::GetNext() const
		//{
		//	return m_next;
		//}

		public function SetDensity(density:Number):void
		{
			m_density = density;
			
			// the following doesn't exit in c++ version
			if (m_body != null)
			{
				m_body.OnMassDataChanged ();
			}
		}

		public function GetDensity():Number
		{
			return m_density;
		}

		public function GetFriction():Number
		{
			return m_friction;
		}

		public function SetFriction(friction:Number):void
		{
			m_friction = friction;
		}

		public function GetRestitution():Number
		{
			return m_restitution;
		}

		public function SetRestitution(restitution:Number):void
		{
			m_restitution = restitution;
		}

		public function TestPoint(p:b2Vec2):Boolean
		{
			return m_shape.TestPoint(m_body.GetTransform(), p);
		}

		public function RayCast(output:b2RayCastOutput, input:b2RayCastInput):Boolean
		{
			return m_shape.RayCast(output, input, m_body.GetTransform());
		}

		public function GetMassData(massData:b2MassData):void
		{
			m_shape.ComputeMass(massData, m_density);
		}

		public function GetAABB():b2AABB
		{
			return m_aabb;
		}

	} // class
} // package
//#endif
