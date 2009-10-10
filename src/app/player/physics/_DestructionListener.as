
package player.physics {

   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Dynamics.*;
   //import Box2D.Common.*;
   import Box2D.Common.*;
   
   
   public class _DestructionListener implements b2DestructionListener
   {
   
      private var mPhysicsEngine:PhysicsEngine;
      
      public function _DestructionListener (phyEngine:PhysicsEngine)
      {
         mPhysicsEngine = phyEngine;
      }
      
//=====================================================================
// v2.10
//=====================================================================

      /// Called when any joint is about to be destroyed due
      /// to the destruction of one of its attached bodies.
      public function SayGoodbye_Joint (joint:b2Joint):void 
      {
         var proxyJoint:PhysicsProxyJoint = joint.GetUserData () as PhysicsProxyJoint;
         
         if (proxyJoint != null)
         {
         }
      }

      /// Called when any fixture is about to be destroyed due
      /// to the destruction of its parent body.
      public function SayGoodbye_Fixture (fixture:b2Fixture):void 
      {
         var proxyShape:PhysicsProxyShape = fixture.GetUserData () as PhysicsProxyShape;
         
         if (proxyShape != null)
         {
         }
      }
   }
 }

