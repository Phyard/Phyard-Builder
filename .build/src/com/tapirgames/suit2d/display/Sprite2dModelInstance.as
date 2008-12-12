package com.tapirgames.suit2d.display {
   
   import flash.display.Sprite;
   
   import com.tapirgames.suit2d.loader.Sprite2dFile;
   import com.tapirgames.suit2d.loader.AnimatedModule;
   import com.tapirgames.suit2d.loader.ModuleSequence;
   import com.tapirgames.suit2d.loader.Module;

   
   public class Sprite2dModelInstance extends Sprite
   {
      private var mSprite2dFile:Sprite2dFile;
      private var mAnimatedModuleGroup:Array;
      private var mAnimationID:int;
      private var mAnimatedModule:AnimatedModule;
      private var mSequenceID:int;
      private var mSequenceTick:int;
      
      private var mLoopPlaying:Boolean;
      private var mLoopCycles:uint;
      
      
      private var mIgnoreSequenceOffset:Boolean;
      
      public function Sprite2dModelInstance (sprite2dFile:Sprite2dFile, modelID:uint)
      {
         mSprite2dFile        = sprite2dFile;
         mAnimatedModuleGroup = sprite2dFile.GetAnimatedModuleGroup (modelID);
      }
      
      public function SetIgnoreSequenceOffset (ignore:Boolean):void
      {
         mIgnoreSequenceOffset = ignore;
      }
      
      private function Rebuild ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         if (mAnimatedModule == null)
            return;
         
         var moduleSequence:ModuleSequence = mAnimatedModule.GetModuleSequence (mSequenceID);
         if (moduleSequence == null)
            return;
            
         var module:Module = moduleSequence.mModule;

         if (module != null)
         {
            module.Render (this, 
               mIgnoreSequenceOffset ? 0 : moduleSequence.mOffsetX, 
               mIgnoreSequenceOffset ? 0 : moduleSequence.mOffsetY, 
               moduleSequence.mFlipX, 
               moduleSequence.mFlipY);
         }
      }
      
      public function SetAnimationID (animationID:int):void
      {
         mAnimationID = animationID;
         mAnimatedModule = null;
         if (mAnimationID >= 0 && mAnimationID < mAnimatedModuleGroup.length)
            mAnimatedModule = mAnimatedModuleGroup [animationID];
         mSequenceID = 0;
         mSequenceTick = 0;
         
         mLoopCycles = 0;
         mLoopPlaying = true;
         
         Rebuild ();
      }
      
      public function GetAnimationID ():int
      {
         return mAnimationID;
      }
      
      public function SetLoopPlaying (loop:Boolean):void
      {
         mLoopPlaying = loop;
      }
      
      public function GetLoopCycles ():uint
      {
         return mLoopCycles;
      }
      
      public function UpdateAnimation (dur:Number):void
      {
         if (mAnimatedModule == null)
            return;
         
         var moduleSequence:ModuleSequence = mAnimatedModule.GetModuleSequence (mSequenceID);
         if (moduleSequence == null)
            return;

         ++ mSequenceTick;
         if (mSequenceTick < moduleSequence.mDuration)
            return;
         
         mSequenceTick = 0;
         ++ mSequenceID;
         if ( mSequenceID >= mAnimatedModule.GetModuleSequencesCount () )
         {
            if (mLoopPlaying)
            {
               ++ mLoopCycles;
               mSequenceID = 0;
            }
            else
            {
               mLoopCycles = 1;
               return;
            }
         }
         
         Rebuild ();
      }
   }
}