
package player.physics {
   
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class PhysicsProxy
   {
      
      protected var mPhysicsEngine:PhysicsEngine;
      
      private var mUserData:Object = null;
      
      public function PhysicsProxy (phyEngine:PhysicsEngine):void
      {
         mPhysicsEngine = phyEngine;
         
         
      }
      
      public function Destroy ():void
      {
      }
      
      public function SetUserData (userData:Object):void
      {
         mUserData = userData;
      }
      
      public function GetUserData ():Object
      {
         return mUserData;
      }
      
   }
   
}
