
package Box2D.Dynamics
{
	import Box2D.Dynamics.Joints.b2Joint;
	
	/// Joints and fixtures are destroyed when their associated
	/// body is destroyed. Implement this listener so that you
	/// may nullify references to these joints and shapes.
	public interface b2DestructionListener
	{
		/// Called when any joint is about to be destroyed due
		/// to the destruction of one of its attached bodies.
		function SayGoodbye_Joint (joint:b2Joint):void;

		/// Called when any fixture is about to be destroyed due
		/// to the destruction of its parent body.
		function SayGoodbye_Fixture (fixture:b2Fixture):void;
		
	} // class
} // package
