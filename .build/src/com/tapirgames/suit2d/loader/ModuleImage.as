

package com.tapirgames.suit2d.loader {
   
   import flash.utils.ByteArray;
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   import flash.geom.Rectangle;
   import flash.geom.Point;
   
   public class ModuleImage
   {
      public var mBitmapData:BitmapData;
      
      public function ModuleImage (bitmapData:BitmapData)
      {
         mBitmapData = bitmapData;
      }
      
      public function GetWidth ():uint
      {
         return mBitmapData == null ? 0 : mBitmapData.width;
      }
      
      public function GetHeight ():uint
      {
         return mBitmapData == null ? 0 : mBitmapData.height;
      }
      
      public function GetRegionBitmapData (region:Rectangle):BitmapData
      {
         var bitmapData:BitmapData = new BitmapData (region.width, region.height);
         
         // temp, suppose region is valid
         
         // 
         bitmapData.copyPixels (mBitmapData, region, new Point (0, 0));
         
         return bitmapData;
      }
   }
   
   
}


