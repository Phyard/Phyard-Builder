
package com.tapirgames.suit2d.loader {
   
   import flash.utils.ByteArray;
   
   import flash.display.DisplayObjectContainer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class CompositedModule extends Module
   {
      public var mModuleParts:Array;
      
      public function CompositedModule (moduleParts:Array)
      {
         mModuleParts = moduleParts;
      }
      
      // temp, palette and scale are not supported
      override public function Render (displayObjectContainer:DisplayObjectContainer, posX:int, posY:int, flipX:Boolean, flipY:Boolean):void
      {
         if (mModuleParts == null)
            return;
         
         for (var partID:int = 0; partID < mModuleParts.length; ++ partID)
         {
            var modulePart:ModulePart = mModuleParts [partID];
            
            if (modulePart.mModule == null)
               return;
            
            var x:int = posX;
            var y:int = posY;
            
            if (flipX)
               x -= modulePart.mOffsetX;
            else
               x += modulePart.mOffsetX;
            
            if (flipY)
               y -= modulePart.mOffsetY;
            else
               y += modulePart.mOffsetY;
            
            modulePart.mModule.Render (displayObjectContainer, x, y, flipX != modulePart.mFlipX, flipY != modulePart.mFlipY);
         }
      }
   }
   
   
}