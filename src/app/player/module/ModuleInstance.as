package player.module {

   import common.display.ModuleSprite;
   
   import player.physics.PhysicsProxyShape;
   
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
      
      public function GetModule ():Module
      {
         return mModule;
      }
      
      // return needs call BuildCurrentFrame or not
      public function Step (callbackOnReachesSequenceEnd:Function = null, onSwitchFrame:Function = null):void
      {
         var frameDutation:int = mModule.GetFrameDuration (mFrameIndex);
         
         ++ mFrameStep;
         if (frameDutation > 0 && mFrameStep >= frameDutation)
         {
            var oldFrameIndex:int = mFrameIndex;
            
            if (++ mFrameIndex >= mModule.GetNumFrames ())
            {
               if (callbackOnReachesSequenceEnd != null && callbackOnReachesSequenceEnd (mModule))
               {
                  // module changed.
                  return;
               }
                      
               mFrameIndex = 0;
            }
            
            mFrameStep = 0;
            
            if (mFrameIndex != oldFrameIndex && onSwitchFrame != null)
            {
               onSwitchFrame (! mModule.IsConstantPhysicsGeom ());
            }
         }
      }
      
      public function RebuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D):void
      {
         mModule.BuildAppearance (mFrameIndex, moduleSprite, transform, 1.0);
      }
      
      public function RebuildPhysicsProxy (physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
         mModule.BuildPhysicsProxy (mFrameIndex, physicsShapeProxy, transform);
      }
   }
}

