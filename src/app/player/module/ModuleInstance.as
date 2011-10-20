package player.module {

   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;

   public class ModuleInstance
   {
      protected var mModule:Module;
         // must NOT be null
      
      public function ModuleInstance (module:Module)
      {
         mModule = module;
      }
      
      // return if needs ot not to call BuildAppearance and BuildPhysicsProxy
      public function Step ():Boolean
      {
         return false;
      }
      
      public function BuildAppearance (container:Sprite, transform:Transform2D):void
      {
         mModule.BuildAppearance (container, transform);
      }
      
      public function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         mModule.BuildPhysicsProxy (physicsBodyProxy, transform);
      }
   }
}

