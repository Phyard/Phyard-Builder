package player.physics {

	import Box2D.Common.b2BlockAllocator;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2dEx.Joint.b2eDummyJoint;
	import Box2dEx.Joint.b2eDummyJointDef;

	public class _JointFactory
	{
		public static function Create (def:b2JointDef, allocator:b2BlockAllocator = null):b2Joint
		{
			var joint:b2Joint = null;

			if (def is b2eDummyJointDef)
			{
				joint = new b2eDummyJoint (def as b2eDummyJointDef);
			}
			
			return joint;
		}
		
		public static function Destroy (joint:b2Joint, allocator:b2BlockAllocator = null):void
		{
			//joint->~b2Joint();
			joint.Destructor ();
			
			if (joint is b2eDummyJoint)
			{
				
			}
		}
		
	}
}
