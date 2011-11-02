package player.module {

   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;

   public class ModuleInstance
   {
      protected var mModule:Module;
         // must NOT be null
         
      protected var mFrameIndex:int = 0;
      protected var mFrameStep:int = 0;
      protected var mNumLoops:int = 0;
      
      public function ModuleInstance (module:Module)
      {
         mModule = module;
      }
      
      // return needs call BuildCurrentFrame or not
      public function Step ():Boolean
      {
         var frameDutation:int = mModule.GetFrameDuration (mFrameIndex);
         
         ++ mFrameStep;
         if (frameDutation > 0 && mFrameStep >= frameDutation)
         {
            if (mFrameIndex ++ >= mModule.GetNumFrames ())
               mFrameIndex = 0;
            
            return true;
         }
         
         return false;
      }
      
      public function RebuildAppearance (container:Sprite, transform:Transform2D):void
      {
         mModule.BuildAppearance (mFrameIndex, container, transform);
      }
      
      public function RebuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         mModule.BuildPhysicsProxy (mFrameIndex, physicsBodyProxy, transform);
      }
   }
}

