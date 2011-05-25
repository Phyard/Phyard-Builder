package Box2dEx.Joint
{

	//#include <Box2D/Dynamics/Joints/b2Joint.h>
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointEdge;

	public class b2eDummyJoint extends b2Joint
	{
		public var m_localAnchor1:b2Vec2 = new b2Vec2 ();
		public var m_localAnchor2:b2Vec2 = new b2Vec2 ();

		public function b2eDummyJoint (def:b2eDummyJointDef)
		//: b2Joint(def)
		{
			super (def);
			
			m_localAnchor1.CopyFrom (def.localAnchorA);
			m_localAnchor2.CopyFrom (def.localAnchorB);
		}

		override public function InitVelocityConstraints (step:b2TimeStep):void
		{
		}

		override public function SolveVelocityConstraints (step:b2TimeStep):void
		{
		}

		override public function SolvePositionConstraints(baumgarte:Number):Boolean
		{
			return true;
		}

		override public function GetAnchorA():b2Vec2
		{
			return m_bodyA.GetWorldPoint(m_localAnchor1);
		}

		override public function GetAnchorB():b2Vec2
		{
			return m_bodyB.GetWorldPoint(m_localAnchor2);
		}

//***********************************************************************
// hackings
//***********************************************************************
		
		// call by b2Body
		override public function OnBodyLocalCenterChanged (dx:Number, dy:Number, jointEdge:b2JointEdge):void
		{
			if (jointEdge == m_edgeA)
			{
				m_localAnchor1.x += dx;
				m_localAnchor1.y += dy;
			}
			else if (jointEdge == m_edgeB)
			{
				m_localAnchor2.x += dx;
				m_localAnchor2.y += dy;
			}
		}
		
      override public function NotifyAnchorPositionChanged (newWorldX:Number, newWorldY:Number, isAnchorA:Boolean):void
      {
         worldAnchor.x = newWorldX; worldAnchor.y = newWorldY;
         
         if (isAnchorA)
         {
            m_bodyA.GetLocalPoint_Output (worldAnchor, m_localAnchor1);
         }
         else
         {
            m_bodyB.GetLocalPoint_Output (worldAnchor, m_localAnchor2);
         }
      } 

		private static var worldAnchor:b2Vec2 = new b2Vec2 ();
			
		override protected function NotifyBodyChanged (oldBody:b2Body, isBodyA:Boolean):void
		{
			if (isBodyA)
			{
				oldBody.GetWorldPoint_Output (m_localAnchor1, worldAnchor);
				m_bodyA.GetLocalPoint_Output (worldAnchor, m_localAnchor1);
			}
			else
			{
				oldBody.GetWorldPoint_Output (m_localAnchor2, worldAnchor);
				m_bodyB.GetLocalPoint_Output (worldAnchor, m_localAnchor2);
			}
		}

	} // class
} // package
