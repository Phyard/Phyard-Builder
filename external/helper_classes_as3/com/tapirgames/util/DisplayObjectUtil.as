
package com.tapirgames.util {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   import flash.display.Shape;
   
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   
   import flash.display.PixelSnapping;
   
   public class DisplayObjectUtil
   {
   
      public static function CreateCacheDisplayObject (displayObject:DisplayObject):Bitmap
      {
         var cachedBitmap:Bitmap = new Bitmap ();
         
         if (displayObject != null)
         {
            var bitmapData:BitmapData = new BitmapData (displayObject.width, displayObject.height, true, 0x00FFFFFF);
            bitmapData.draw (displayObject);
            
            cachedBitmap.bitmapData = bitmapData;
            cachedBitmap.smoothing = true;
            cachedBitmap.pixelSnapping = PixelSnapping.AUTO;
         }
         
         return cachedBitmap;
      }
   }
}