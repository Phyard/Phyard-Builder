
package editor.display.sprite {
   
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   public class EffectMessagePopup extends EditingEffect 
   {
      
      public static const kBgColor_General:uint = 0xFFFFC0;
      public static const kBgColor_OK:uint = 0xC0FFC0;
      public static const kBgColor_Error:uint = 0xFFC0C0;
      public static const kBgColor_Special:uint = 0xC0C0FF;
      
      //
      public static const kMessageBoxHeightInterval:Number = 26.0;
      public static const kDeltaFadeAlpha:Number = 0.0025;
      public static const kToppestY:Number = 3.0;
      public static const kLeftestX:Number = 3.0;
      
//======================================================
//
//======================================================
      
      public static function UpdateMessagesPosition (container:Sprite):void
      {
         var len:int = container.numChildren;
         
         if (len == 0)
            return;
         
         var i:int;
         var effect:EffectMessagePopup;
         
         var finalY:Number = kToppestY + kMessageBoxHeightInterval;
         
         for (i = len - 2; i >= 0; -- i)
         {
            effect = container.getChildAt (i) as EffectMessagePopup;
            if (effect.mTargetY < finalY)
            {
               effect.mTargetY += 5;
               if (effect.mTargetY > finalY)
               {
                  effect.mTargetY = finalY;
               }
            }
            
            finalY = effect.mTargetY + kMessageBoxHeightInterval;
         }
      }
      
//======================================================
//
//======================================================
      
      internal var mAutoFade:Boolean;
      
      internal var mTargetX:Number;
      internal var mTargetY:Number;
      
      public function EffectMessagePopup (text:String, bgColor:uint, textColor:uint, initialX:Number):void
      {
         Rebuild (text, bgColor, textColor);
         
         mTargetX = kLeftestX;
         mTargetY = kToppestY;
         
         x = initialX - 0.5 * width;
         y = kToppestY;
         
         mAutoFade = true;
      }
      
      public function SetAutoFade (autoFade:Boolean):void
      {
         mAutoFade = autoFade;
      }
      
      public function Remove ():void
      {
         alpha = 0.0;
      }
      
      public function Rebuild (text:String, bgColor:uint, textColor:uint = 0x0):void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         // creating a bitmap instead of text filed os for the alpha of text field is unchangeable.
         var textBitemp:Bitmap = DisplayObjectUtil.CreateCacheDisplayObject (TextFieldEx.CreateTextField (text, true, bgColor, textColor, false, 0, false, false));
         GraphicsUtil.ClearAndDrawRect (this, 0, 0, textBitemp.width + 1, textBitemp.height + 1, 0, 1, true, bgColor);
         addChild (textBitemp);
         textBitemp.x = 1;
         textBitemp.y = 1;
      }
      
      override public function Update ():void
      {
         var dx:Number = mTargetX - x;
         var dy:Number = mTargetY - y;
         var length:Number = Math.sqrt (dx * dx + dy * dy);
         
         var speed:Number = 32;
         
         if (length < speed)
         {
            x = mTargetX;
            y = mTargetY;
         }
         else
         {
            x += dx * speed / length;
            y += dy * speed / length;
         }
         
         if (mAutoFade)
            alpha -= kDeltaFadeAlpha;
         
         if (alpha <= 0.0 )
         {
            parent.removeChild (this);
         }
      }
      
   }
   
}
