
package com.tapirgames.display {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   import flash.display.Shape;
   
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   
   import flash.display.PixelSnapping;
   
   public class TextFieldEx extends TextField 
   {
      public function TextFieldEx ()
      {
         // textField
         autoSize        = TextFieldAutoSize.LEFT;
         selectable      = false;
         background      = true;
         backgroundColor = 0xFFFFFF;
         textColor       = 0x0;
         multiline       = true;
         wordWrap        = false;
      }
      
      public function SetFixedWidth (w:int):void
      {
         width    = w;
         wordWrap = true;
      }
      
      
      public static function CreateTextField (htmlText:String, hasBg:Boolean = false, bgColor:uint = 0xFFFFFF, textColor:uint = 0x0, wordWrap:Boolean = false, fixedWidth:int = 300, selectable:Boolean = false, drawBorder:Boolean = false, borderColor:uint = 0x0):TextFieldEx
      {
         if (fixedWidth < 10)
            fixedWidth = 10;
         
         var textField:TextFieldEx = new TextFieldEx ();
         textField.textColor = textColor;
         textField.htmlText = htmlText;
         textField.background = hasBg;
         textField.backgroundColor = bgColor;
         textField.border = drawBorder;
         textField.borderColor = borderColor;
         textField.wordWrap = wordWrap;
         if (wordWrap)
            textField.width = fixedWidth;
         textField.selectable = selectable;
         
         return textField;
      }
   }

}