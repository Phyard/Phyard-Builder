package player.module {

   import common.display.ModuleSprite;
   
   import player.physics.PhysicsProxyShape;
   
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
      public function BuildAppearance (frameIndex:int, moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         // to override
      }
      
      // frameIndex should be always 0 for non-sequenced modules
      public function BuildPhysicsProxy (frameIndex:int, physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
         // to override
      }

   }
}
