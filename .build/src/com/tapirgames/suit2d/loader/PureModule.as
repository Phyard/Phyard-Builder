package com.tapirgames.suit2d.loader {
   
   import flash.utils.ByteArray;
   
   import flash.display.DisplayObjectContainer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class PureModule extends Module
   {
      private var mModuleImage:ModuleImage;
      private var mRegion:Rectangle;
      
      public function PureModule (x:int, y:int, w:int, h:int)
      {
         mRegion = new Rectangle (x, y, w, h);
      }
      
      public function SetModuleImage (moduleImage:ModuleImage):void
      {
         mModuleImage = moduleImage;
      }
      
      // temp, not supprt palette
      
      private var _BitmapData:BitmapData = null;
      
      // temp, palette and scale are not supported
      override public function Render (displayObjectContainer:DisplayObjectContainer, posX:int, posY:int, flipX:Boolean, flipY:Boolean):void
      {
         if (_BitmapData == null)
            _BitmapData = mModuleImage.GetRegionBitmapData (mRegion);
         
         var bitmap:Bitmap = new Bitmap (_BitmapData);
         bitmap.x = posX;
         bitmap.y = posY;
         bitmap.scaleX = flipX ? -1.0 : 1.0;
         bitmap.scaleY = flipY ? -1.0 : 1.0;
         
         displayObjectContainer.addChild (bitmap);
      }
   }
}