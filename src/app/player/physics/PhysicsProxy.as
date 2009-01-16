
package player.physics {
   
   
   
   public class PhysicsProxy
   {
      
      protected var mPhysicsEngine:PhysicsEngine;
      
      private var mUserData:Object = null;
      
      public function PhysicsProxy (phyEngine:PhysicsEngine):void
      {
         mPhysicsEngine = phyEngine;
         
         
      }
      
      public function GetPhysicsEngie ():PhysicsEngine
      {
         return mPhysicsEngine;
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
