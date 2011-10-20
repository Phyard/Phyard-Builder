package player.module {

   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;

   public class SequencedModuleInstance extends ModuleInstance
   {
      protected var mSequencedModule:SequencedModule;
         // must NOT be null
         
      protected var mFrameIndex:int = 0;
      protected var mFrameStep:int = 0;
      
      public function SequencedModuleInstance (sequencedModule:SequencedModule)
      {
         super (sequencedModule);
         
         mSequencedModule = sequencedModule;
      }
      
      // return needs call BuildCurrentFrame or not
      public function Step ():Boolean
      {
         var frameDutation:int = mSequencedModule.GetFrameDuration (mFrameIndex);
         if (mFrameStep ++ >= frameDutation)
         {
            if (mFrameIndex ++ >= mSequencedModule.GetNumFrames ())
               mFrameIndex = 0;
            
            return true;
         }
         
         return false;
      }
      
      override public function BuildFrameSprite (container:Sprite, transform:Transform2D):void
      {
         mSequencedModule.BuildFrameAppearance (mFrameIndex, container, transform);
      }
      
      override public function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         mSequencedModule.BuildFramePhysicsProxy (mFrameIndex, physicsBodyProxy, transform);
      }
   }
}
