package common.display
{
   import flash.display.Sprite;

   public class ModuleSprite extends Sprite
   {
      protected var mAdjustShapeVisualSize:Boolean = true;
      protected var mScale:Number = 1.0;
      
      public function ModuleSprite ()
      {
      }
      
      public function IsAdjustShapeVisualSize ():Boolean
      {
         return mAdjustShapeVisualSize;
      }
      
      public function GetScale ():Number
      {
         return mScale;
      }
      
      public function SetScale (scale:Number):void
      {
         mScale = scale;
         
         scaleX = scale;
         scaleY = scale;
      }
      
   }
}
