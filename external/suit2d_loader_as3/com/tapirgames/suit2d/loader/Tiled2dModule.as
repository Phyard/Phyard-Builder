
package com.tapirgames.suit2d.loader {
   
   import flash.utils.ByteArray;
   
   import flash.display.DisplayObjectContainer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class Tiled2dModule extends Module
   {
      public var mModuleRef:ModuleRef;
      
      public var mIndex:uint; // for physical layer
      
      public function Tiled2dModule (moduleRef:ModuleRef, index:uint)
      {
         mModuleRef = moduleRef;
         
         mIndex = index;
      }
      
      // temp, palette and scale are not supported
      override public function Render (displayObjectContainer:DisplayObjectContainer, posX:int, posY:int, flipX:Boolean, flipY:Boolean):void
      {
         // will not be called.
      }
   }
   
   
}