
package com.tapirgames.util {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   
   import flash.display.PixelSnapping;
   
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
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
      
      // here, the display1 and display2 are not essentially the children of this world
      public static function LocalToLocal (display1:DisplayObject, display2:DisplayObject, point:Point):Point
      {
         // seems flash will auto postions of displayobjects. so the current implementings of this
         // function is not very accurate!
         
         
         //
         var matrix:Matrix = display2.transform.concatenatedMatrix.clone();
         matrix.invert();
         return matrix.transformPoint (display1.transform.concatenatedMatrix.transformPoint (point));
         
         //return display2.globalToLocal ( display1.localToGlobal (point) );
      }
      
      
      
   }
}