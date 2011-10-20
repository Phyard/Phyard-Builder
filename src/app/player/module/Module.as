package player.module {

   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;

   public class Module
   {
      
      public function CreateInstance ():ModuleInstance
      {
         return new ModuleInstance (this); // some subclasses need to override this
      }
      
      public function BuildAppearance (container:Sprite, transform:Transform2D):void
      {
         // to override
      }
      
      public function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         // to override
      }

   }
}
