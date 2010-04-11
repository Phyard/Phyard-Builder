
package editor.display {
   
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
      
      //
      public static const kMessageBoxHeightInterval:Number = 26.0;
      public static const kDeltaFadeAlpha:Number = 0.006;
      public static const kToppestY:Number = 3.0;
      
//======================================================
//
//======================================================
      
      //
      private static var sEffectMessages:Array = new Array (20); //
      
      public static function UpdateMessagesPosition ():void
      {
         var i:int;
         var len:int = sEffectMessages.length;
         var effect:EffectMessagePopup;
         
         var finalY:Number = kToppestY;
         
         for (i = 0; i < len; ++ i)
         {
            effect = sEffectMessages [i] as EffectMessagePopup;
            if (effect != null)
            {
               if (effect.mTargetY > finalY)
               {
                  effect.mTargetY -= 2;
                  if (effect.mTargetY < finalY)
                  {
                     effect.mTargetY = finalY;
                  }
               }
               
               finalY = effect.mTargetY + kMessageBoxHeightInterval;
            }
         }
      }
      
//======================================================
//
//======================================================
      
      internal var mTargetX:Number;
      internal var mTargetY:Number;
      
      public function EffectMessagePopup (text:String, initX:Number, initY:Number, bgColor:uint, yIsCenter:Boolean = true, textColor:uint = 0x0):void
      {
         // creating a bitmap instead of text filed os for the alpha of text field is unchangeable.
         var textBitemp:Bitmap = DisplayObjectUtil.CreateCacheDisplayObject (TextFieldEx.CreateTextField (text, true, bgColor, textColor, false, 0, false, false));
         GraphicsUtil.ClearAndDrawRect (this, 0, 0, textBitemp.width + 1, textBitemp.height + 1, 0, 1, true, bgColor);
         addChild (textBitemp);
         textBitemp.x = 1;
         textBitemp.y = 1;
         
         var i:int;
         var len:int = sEffectMessages.length;
         for (i = len - 1; i >= 0; -- i)
         {
            if (sEffectMessages [i] != null)
            {
               break;
            }
         }
         
         ++ i;
         if (i == len)
         {
            sEffectMessages.push (this);
         }
         else
         {
            sEffectMessages [i] = this;
         }
         
         mTargetX = 3;
         mTargetY = (i == 0) ? kToppestY : (sEffectMessages [i - 1] as EffectMessagePopup).mTargetY + kMessageBoxHeightInterval;
         
         x = initX - 0.5 * textBitemp.width;
         y = initY;
         if (yIsCenter)
         {
            y -= 0.5 * textBitemp.height;
         }
      }
      
      override public function Update ():void
      {
         if (alpha < 1.0)
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
         }
         
         alpha -= kDeltaFadeAlpha;
         if (alpha <= 0.0 )
         {
            var index:int = sEffectMessages.indexOf (this);
            if (index >= 0)
            {
               sEffectMessages [index] = null;
            }
            
            parent.removeChild (this);
         }
      }
   }
   
}
