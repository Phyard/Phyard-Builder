
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
         sKeyBitmapClasses [KeyCodes.Key_B] = Resource.KeyB;
         sKeyBitmapClasses [KeyCodes.Key_C] = Resource.KeyC;
         sKeyBitmapClasses [KeyCodes.Key_D] = Resource.KeyD;
         sKeyBitmapClasses [KeyCodes.Key_E] = Resource.KeyE;
         sKeyBitmapClasses [KeyCodes.Key_F] = Resource.KeyF;
         sKeyBitmapClasses [KeyCodes.Key_G] = Resource.KeyG;
         sKeyBitmapClasses [KeyCodes.Key_H] = Resource.KeyH;
         sKeyBitmapClasses [KeyCodes.Key_I] = Resource.KeyI;
         sKeyBitmapClasses [KeyCodes.Key_J] = Resource.KeyJ;
         sKeyBitmapClasses [KeyCodes.Key_K] = Resource.KeyK;
         sKeyBitmapClasses [KeyCodes.Key_L] = Resource.KeyL;
         sKeyBitmapClasses [KeyCodes.Key_M] = Resource.KeyM;
         sKeyBitmapClasses [KeyCodes.Key_N] = Resource.KeyN;
         sKeyBitmapClasses [KeyCodes.Key_O] = Resource.KeyO;
         sKeyBitmapClasses [KeyCodes.Key_P] = Resource.KeyP;
         sKeyBitmapClasses [KeyCodes.Key_Q] = Resource.KeyQ;
         sKeyBitmapClasses [KeyCodes.Key_R] = Resource.KeyR;
         sKeyBitmapClasses [KeyCodes.Key_S] = Resource.KeyS;
         sKeyBitmapClasses [KeyCodes.Key_T] = Resource.KeyT;
         sKeyBitmapClasses [KeyCodes.Key_U] = Resource.KeyU;
         sKeyBitmapClasses [KeyCodes.Key_V] = Resource.KeyV;
         sKeyBitmapClasses [KeyCodes.Key_W] = Resource.KeyW;
         sKeyBitmapClasses [KeyCodes.Key_X] = Resource.KeyX;
         sKeyBitmapClasses [KeyCodes.Key_Y] = Resource.KeyY;
         sKeyBitmapClasses [KeyCodes.Key_Z] = Resource.KeyZ;
         sKeyBitmapClasses [Keyboard.UP   ] = Resource.KeyUp;
         sKeyBitmapClasses [Keyboard.DOWN ] = Resource.KeyDown;
         sKeyBitmapClasses [Keyboard.LEFT ] = Resource.KeyLeft;
         sKeyBitmapClasses [Keyboard.RIGHT] = Resource.KeyRight;
         sKeyBitmapClasses [Keyboard.SPACE] = Resource.KeySpace;
         sKeyBitmapClasses [Keyboard.CONTROL] = Resource.KeyCtrl;
         sKeyBitmapClasses [Keyboard.SHIFT] = Resource.KeyShift;
         sKeyBitmapClasses [Keyboard.CAPS_LOCK] = Resource.KeyCaps;
         sKeyBitmapClasses [Keyboard.TAB] = Resource.KeyTab;
         
      // ...
         
         sKeyRegions = new Array (256);
         
         sKeyRegions [KeyCodes.Key_Q] = [46, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_W] = [71, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_E] = [95, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_R] = [120, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_T] = [145, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_Y] = [169, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_U] = [194, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_I] = [219, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_O] = [243, 48, 22, 22];
         sKeyRegions [KeyCodes.Key_P] = [268, 48, 22, 22];
         
         sKeyRegions [KeyCodes.Key_A] = [52, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_S] = [77, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_D] = [102, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_F] = [126, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_G] = [151, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_H] = [176, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_J] = [200, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_K] = [225, 72, 22, 22];
         sKeyRegions [KeyCodes.Key_L] = [250, 72, 22, 22];
         
         sKeyRegions [KeyCodes.Key_Z] = [65, 96, 22, 22];
         sKeyRegions [KeyCodes.Key_X] = [89, 96, 22, 22];
         sKeyRegions [KeyCodes.Key_C] = [114, 96, 22, 22];
         sKeyRegions [KeyCodes.Key_V] = [139, 96, 22, 22];
         sKeyRegions [KeyCodes.Key_B] = [163, 96, 22, 22];
         sKeyRegions [KeyCodes.Key_N] = [188, 96, 22, 22];
         sKeyRegions [KeyCodes.Key_M] = [213, 96, 22, 22];
         
         sKeyRegions [Keyboard.UP   ] = [401, 97, 22, 22];
         sKeyRegions [Keyboard.DOWN ] = [401, 121, 22, 22];
         sKeyRegions [Keyboard.LEFT ] = [377, 121, 22, 22];
         sKeyRegions [Keyboard.RIGHT] = [426, 121, 22, 22];
         sKeyRegions [Keyboard.SPACE] = [114, 120, 146, 22];
         
         sKeyRegions [Keyboard.CONTROL] = [9, 120, 35, 23];
         sKeyRegions [Keyboard.SHIFT] = [9, 96, 54, 23];
         sKeyRegions [Keyboard.CAPS_LOCK] = [9, 72, 41, 23];
         sKeyRegions [Keyboard.TAB] = [9, 49, 35, 23];
      }
      
   // ...
      
      private var mKeyboardBitmap:Bitmap = new Resource.Keyboard ();
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
