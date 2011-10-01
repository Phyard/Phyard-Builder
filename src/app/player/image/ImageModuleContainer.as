package player.image {

   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;

   public class BitmapModuleContainer exteends BitmapModule
   {
      protected var mBitmapModuleParts:Array; // BitmapModuleBasic, BitmapModuleContainer or BitmapModuleAnimation. Should not be blank.

      //protected var mJudgeDirectAnimationsReachingEndMethod:int;
         // 1. when the longest one is end
         // 2. when all direct child aniations reach end at the same step.

      // ...
      //protected var mContainsAnimationChildren:Boolean; // to optimize
      
      public function BitmapModuleContainer ()
      {
      }
      
      override public function OnSequenceStart ():void
      {
         var numParts:int = mBitmapModuleParts.length;
         for (var i:int = 0; i < numParts; ++ i)
         {
             (mBitmapModuleParts [i] as BitmapModule).OnSequenceStart ();
         }
      }
      
      override public function Step ():Boolean
      {
         var result:Boolean = true;
         
         var numParts:int = mBitmapModuleParts.length;
         for (var i:int = 0; i < numParts; ++ i)
         {
            result &= (mBitmapModuleParts [i] as BitmapModule).Step ();
         }
         
         return result;
      }
      
      override public function BuildAppearance (contianer:Sprite):void
      {
         var numParts:int = mBitmapModuleParts.length;
         for (var i:int = 0; i < numParts; ++ i)
         {
             (mBitmapModuleParts [i] as BitmapModule).BuildAppearance (contianer);
         }
      }
   }
}
