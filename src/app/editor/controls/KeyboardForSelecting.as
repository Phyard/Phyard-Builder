
package editor.controls {
   
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import mx.core.UIComponent;
   
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.runtime.Resource;
   
   import common.KeyCodes;

   public class KeyboardForSelecting extends UIComponent 
   {
      private static var sKeyBitmapClasses:Array = null;
      private static var sKeyRegions:Array = null;
      
      private static function InitStaticData ():void
      {
         if (sKeyBitmapClasses != null)
            return;
         
         sKeyBitmapClasses = new Array (256);
         
         sKeyBitmapClasses [KeyCodes.Key_A] = Resource.KeyA;
         sKeyBitmapClasses [KeyCodes.Key_D] = Resource.KeyD;
         sKeyBitmapClasses [KeyCodes.Key_S] = Resource.KeyS;
         sKeyBitmapClasses [KeyCodes.Key_W] = Resource.KeyW;
         sKeyBitmapClasses [Keyboard.UP   ] = Resource.KeyUp;
         sKeyBitmapClasses [Keyboard.DOWN ] = Resource.KeyDown;
         sKeyBitmapClasses [Keyboard.LEFT ] = Resource.KeyLeft;
         sKeyBitmapClasses [Keyboard.RIGHT] = Resource.KeyRight;
         sKeyBitmapClasses [Keyboard.SPACE] = Resource.KeySpace;
         
      // ...
         
         sKeyRegions = new Array (256);
         sKeyRegions [KeyCodes.Key_A] = [52, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_D] = [102, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_S] = [77, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_W] = [71, 48, 22, 22];
         sKeyRegions [Keyboard.UP   ] = [401, 97, 22, 22];
         sKeyRegions [Keyboard.DOWN ] = [401, 121, 22, 22];
         sKeyRegions [Keyboard.LEFT ] = [377, 121, 22, 22];
         sKeyRegions [Keyboard.RIGHT] = [426, 121, 22, 22];
         sKeyRegions [Keyboard.SPACE] = [114, 120, 146, 22];
      }
      
   // ...
      
      private var mKeyboardBitmap:Bitmap = new Resource.KeyboardSpaceAndWASD ();
      private var mSelectedKeyBitmaps:Array = new Array (256);
      
   // ...
      
      private var mSelectedKeyCodes:Array = new Array ();
      
      public function KeyboardForSelecting ()
      {
         addChild (mKeyboardBitmap);
         //mKeyboardBitmap.x = - 0.5 * mKeyboardBitmap.width;
         //mKeyboardBitmap.y = - 0.5 * mKeyboardBitmap.height;
         
         if (sKeyBitmapClasses == null)
            InitStaticData ();
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         
         //alpha = 0.3;
      }
      
      private function OnAddedToStage (event:Event):void 
      {
         addEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         addEventListener (MouseEvent.CLICK, OnMouseClick);
      }
      
      private function OnRemovedFromStage (event:Event):void 
      {
         removeEventListener (MouseEvent.CLICK, OnMouseClick);
         removeEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         removeEventListener (MouseEvent.CLICK, OnMouseClick);
      }
      
      public function get selectedKeyCodes ():Array
      {
         return mSelectedKeyCodes;
      }
      
      public function RebuildAppearance ():void
      {
         var i:int = 0;
         var keyCode:int;
         var bitmap:Bitmap;
         var region:Array;
         
         for (keyCode = 0; keyCode < 256; ++ keyCode)
         {
            if (mSelectedKeyBitmaps [keyCode] != null)
               mSelectedKeyBitmaps [keyCode].visible = false;
         }
         
         for (i = 0; i < mSelectedKeyCodes.length; ++ i)
         {
            keyCode = mSelectedKeyCodes [i];
            if (mSelectedKeyBitmaps [keyCode] == null)
            {
               bitmap = new sKeyBitmapClasses [keyCode] ();
               mSelectedKeyBitmaps [keyCode] = bitmap;
               addChild (bitmap);
               region = sKeyRegions [keyCode];
               bitmap.x += mKeyboardBitmap.x + region [0];
               bitmap.y += mKeyboardBitmap.y + region [1];
            }
            
            mSelectedKeyBitmaps [keyCode].visible = true;
         }
      }
      
      public function set selectedKeyCodes (keyCodes:Array):void
      {
         var i:int = 0;
         var keyCode:int;
         
         mSelectedKeyCodes.splice (0, mSelectedKeyCodes.length);
         
         for (i = 0; i < keyCodes.length; ++ i)
         {
            keyCode = int (keyCodes [i]);
            if (keyCode >= 0 && keyCode < 256 && mSelectedKeyCodes.indexOf (keyCode) < 0)
            {
               mSelectedKeyCodes.push (keyCode);
            }
         }
         
         RebuildAppearance ();
      }
      
      private function OnMouseClick (event:MouseEvent):void
      {
         //if (event.eventPhase != EventPhase.BUBBLING_PHASE)
         //   return;
         
         var point:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, this, new Point (event.localX, event.localY) );
         var px:Number = point.x - mKeyboardBitmap.x;
         var py:Number = point.y - mKeyboardBitmap.y;
         
         var keyCode:int = -1;
         var region:Array;
         var left:Number;
         var right:Number;
         var top:Number;
         var bottom:Number;
         
         for (var i:int = 0; i < 256; ++ i)
         {
            region = sKeyRegions [i];
            if (region == null)
               continue;
            
            left   = region [0];
            right  = region [2] + left;
            top    = region [1];
            bottom = region [3] + top;
            
            if (px > left && px < right && py > top && py < bottom)
            {
               keyCode = i;
               break;
            }
         }
         
//trace ("px = " + px + ", py = " + py + ", keyCode = " + keyCode);
         if (keyCode >= 0)
         {
            var index:int = mSelectedKeyCodes.indexOf (keyCode);
            if (index < 0)
               mSelectedKeyCodes.push (keyCode);
            else
               mSelectedKeyCodes.splice (index, 1);
            
            RebuildAppearance ();
         }
      }
   }
}
