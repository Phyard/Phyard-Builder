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
      
      public function GetNumFrames ():int
      {
         return 1; // sequenced module will override it
      }
      
      public function GetFrameDuration (frameIndex:int):int
      {
         return 0; // 0 means for ever, sequenced module will override it
      }
      
      // frameIndex should be always 0 for non-sequenced modules
      public function BuildAppearance (frameIndex:int, container:Sprite, transform:Transform2D):void
      {
         // to override
      }
      
      // frameIndex should be always 0 for non-sequenced modules
      public function BuildPhysicsProxy (frameIndex:int, physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         // to override
      }

   }
}
