
package com.tapirgames.util {
   
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.events.ContextMenuEvent;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
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
      public static function AppendContextMenuItem (sprite:InteractiveObject, caption:String, selectedListener:Function, addSeperator:Boolean = false):ContextMenuItem
      {
         if (sprite.contextMenu == null)
         {
            sprite.contextMenu = new ContextMenu ();
            sprite.contextMenu.hideBuiltInItems ();
         }
         
         var menuItem:ContextMenuItem = new ContextMenuItem(caption, addSeperator);
         if (selectedListener != null)
            menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, selectedListener);
         if (sprite.contextMenu != null) // sometimes, null for air app
            sprite.contextMenu.customItems.push (menuItem);
         
         return menuItem;
      }

      public static function CreateCacheDisplayObject (displayObject:DisplayObject):Bitmap
      {
         var cachedBitmap:Bitmap = new Bitmap ();
         
         CreateCacheDisplayObjectInBitmap (displayObject, cachedBitmap);
         
         return cachedBitmap;
      }
      
      public static function CreateCacheDisplayObjectInBitmap (displayObject:DisplayObject, bitmap:Bitmap):void
      {
         if (displayObject != null)
         {
            //trace ("displayObject.width = " + displayObject.width + ", displayObject.height = "  + displayObject.height);
            
            var bitmapData:BitmapData;
            
            try
            {
               bitmapData = new BitmapData (displayObject.width, displayObject.height, true, 0x00FFFFFF);
               bitmapData.draw (displayObject);
            }
            catch (error:Error)
            {
               bitmapData = new BitmapData (1, 1);
               
               //if (Compile::Is_Debugging)
               //   throw error;
            }
            
            bitmap.bitmapData = bitmapData;
            bitmap.smoothing = true;
            bitmap.pixelSnapping = PixelSnapping.AUTO;
         }
         else
         {
            bitmap.bitmapData = null;
         }
      }
      
      // here, the display1 and display2 must be add in stage
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
      
      // here, the display1 and display2 must be add in stage
      public static function LocalVectorToLocalVector (display1:DisplayObject, display2:DisplayObject, vector:Point):Point
      {
         // seems flash will auto postions of displayobjects. so the current implementings of this
         // function is not very accurate!
         
         
         var point1:Point = LocalToLocal (display1, display2, new Point (0, 0));
         var point2:Point = LocalToLocal (display1, display2, vector);
         
         return new Point (point2.x - point1.x, point2.y - point1.y);
      }
      
//=================================================================================================
//      
//=================================================================================================

   }
}