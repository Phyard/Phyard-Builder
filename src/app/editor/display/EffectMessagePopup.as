
package editor.display {
   
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   public class EffectMessagePopup extends EditingEffect 
   {
      //
      public static const kMessageBoxHeightInterval:Number = 26.0;
      public static const kDeltaFadeAlpha:Number = 0.006;
      public static const kToppestY:Number = 3.0;
      
      public static const kColorDesignChanged:uint = 0xFFDDDD;
      
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
               if (effect.y > finalY)
               {
                  effect.y -= 2;
                  if (effect.y < finalY)
                  {
                     effect.y = finalY;
                  }
               }
               
               finalY = effect.y + kMessageBoxHeightInterval;
            }
         }
      }
      
//======================================================
//
//======================================================
      
      public function EffectMessagePopup (text:String, bgColor:uint, textColor:uint = 0x0):void
      {
         // creating a bitmap instead of text filed os for the alpha of text field is unchangeable.
         var textBitemp:Bitmap = DisplayObjectUtil.CreateCacheDisplayObject (TextFieldEx.CreateTextField (text, true, bgColor, textColor, false, 0, false, false))
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
         
         x = 3;
         y = (i == 0) ? kToppestY : (sEffectMessages [i - 1] as EffectMessagePopup).y + kMessageBoxHeightInterval;
      }
      
      override public function Update ():void
      {
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
