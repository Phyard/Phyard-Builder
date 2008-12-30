
package player.physics {

   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Collision.Shapes.b2Shape;

   import Box2D.Dynamics.b2DestructionListener;
   
   
   public class _DestructionListener extends b2DestructionListener
   {
   
      private var mPhysicsEngine:PhysicsEngine;
      
      public function _DestructionListener (phyEngine:PhysicsEngine)
      {
         mPhysicsEngine = phyEngine;
      }
      
      /// Called when any joint is about to be destroyed due
      /// to the destruction of one of its attached bodies.
      override public virtual function SayGoodbyeJoint(joint:b2Joint) : void
      {
         var userdata:Object = joint.GetUserData ();
         
         mPhysicsEngine.OnJointRemoved (userdata as PhysicsProxyJoint);
      }
      
      /// Called when any shape is about to be destroyed due
      /// to the destruction of its parent body.
      override public virtual function SayGoodbyeShape(shape:b2Shape) : void
      {
         var userdata:Object = shape.GetUserData ();
         
         mPhysicsEngine.OnShapeRemoved (userdata as PhysicsProxyShape);
      }
      
   }
 }

