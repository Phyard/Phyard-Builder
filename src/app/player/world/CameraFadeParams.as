package player.world {
   
   import flash.display.DisplayObject;
   
   import player.trigger.entity.ScriptHolder;
   
   public class CameraFadeParams 
   {
      public var mCurrentAlpha:Number = 0.0;
      
      private var mCurrentStep:int = 0;
      private var mStage:int = -1; // -1: fade out, 0 : call action, 1: fade in
      
      public var mFadeColor:uint = 0xFFFFFFFF;
      private var mFadeOutSteps:int = 0;
      private var mFadeInSteps:int = 0;
      private var mFadeStayingSteps:int = 0;
      private var mScriptToRun:ScriptHolder = null;
      
      private var mFadeMaskSprite:DisplayObject = null;
      
      public function CameraFadeParams (fadeColor:uint, stepsFadeOut:int, stepsFadeIn:int, stepsFadeStaying:int, scriptToRun:ScriptHolder)
      {
         mFadeColor = fadeColor;
         mFadeOutSteps = stepsFadeOut;
         mFadeInSteps = stepsFadeIn;
         mFadeStayingSteps = stepsFadeStaying;
         mScriptToRun = scriptToRun;
         
         if (mFadeOutSteps > 0)
         {
            mStage = -1;
            mCurrentAlpha = 0.0;
         }
         else
         {
            mStage = 0;
            mCurrentAlpha = 1.0;
         }
      }
      
      public function Step ():Boolean
      {
         if (mStage < 0)
         {
            ++ mCurrentStep;
            
            mCurrentAlpha = Number (mCurrentStep) / Number (mFadeOutSteps);
            
            if (mCurrentStep >= mFadeOutSteps)
            {
               mStage = 0;
               mCurrentStep = 0;
            }
         }
         else if (mStage > 0)
         {
            -- mCurrentStep;
            
            mCurrentAlpha = Number (mCurrentStep) / Number (mFadeInSteps);
            
            if (mCurrentStep <= 0)
               return true;
         }
         else
         {
            ++ mCurrentStep;
            
            if (mCurrentStep >= mFadeStayingSteps)
            {
               if (mScriptToRun != null)
                  mScriptToRun.RunScript ();
               
               if (mFadeInSteps > 0)
               {
                  mStage = 1;
                  mCurrentStep = mFadeInSteps;
               }
               else
               {
                  mCurrentAlpha = 0.0;
                  
                  return true;
               }
            }
         }
         
         return false;
      }
   }
}
