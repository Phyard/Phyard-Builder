
package editor.display.control {
   
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
   
   import editor.Resource;
   
   import common.KeyCodes;

   public class KeyboardForSelecting extends UIComponent 
   {
      private static var sKeyBitmapClasses:Array = null;
      private static var sKeyRegions:Array = null;
      
      private static function InitStaticData ():void
      {
         if (sKeyBitmapClasses != null)
            return;
         
         sKeyBitmapClasses = new Array (KeyCodes.kNumKeys);
         
         sKeyBitmapClasses [KeyCodes.Escape] = Resource.KeyEscape;
         
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
         sKeyBitmapClasses [Keyboard.BACKSPACE] = Resource.KeyBackspace;
         //sKeyBitmapClasses [KeyCodes.ControlLeft] = Resource.KeyCtrl;
         //sKeyBitmapClasses [KeyCodes.ControlRight] = Resource.KeyCtrl;
         //sKeyBitmapClasses [KeyCodes.ShiftLeft] = Resource.KeyShift;
         //sKeyBitmapClasses [KeyCodes.ShiftRight] = Resource.KeyShift;
         sKeyBitmapClasses [Keyboard.CAPS_LOCK] = Resource.KeyCaps;
         sKeyBitmapClasses [Keyboard.TAB] = Resource.KeyTab;
         sKeyBitmapClasses [Keyboard.ENTER] = Resource.KeyEnter;
         
         sKeyBitmapClasses [KeyCodes.Key_0] = Resource.Key0;
         sKeyBitmapClasses [KeyCodes.Key_1] = Resource.Key1;
         sKeyBitmapClasses [KeyCodes.Key_2] = Resource.Key2;
         sKeyBitmapClasses [KeyCodes.Key_3] = Resource.Key3;
         sKeyBitmapClasses [KeyCodes.Key_4] = Resource.Key4;
         sKeyBitmapClasses [KeyCodes.Key_5] = Resource.Key5;
         sKeyBitmapClasses [KeyCodes.Key_6] = Resource.Key6;
         sKeyBitmapClasses [KeyCodes.Key_7] = Resource.Key7;
         sKeyBitmapClasses [KeyCodes.Key_8] = Resource.Key8;
         sKeyBitmapClasses [KeyCodes.Key_9] = Resource.Key9;
         
         sKeyBitmapClasses [KeyCodes.Quote] = Resource.KeyQuote;
         sKeyBitmapClasses [KeyCodes.BackQuote] = Resource.KeyBackquote;
         sKeyBitmapClasses [KeyCodes.Slash] = Resource.KeySlash;
         sKeyBitmapClasses [KeyCodes.BackSlash] = Resource.KeyBackslash;
         sKeyBitmapClasses [KeyCodes.Comma] = Resource.KeyComma;
         sKeyBitmapClasses [KeyCodes.Period] = Resource.KeyPeriod;
         sKeyBitmapClasses [KeyCodes.Semicolon] = Resource.KeySemicolon;
         sKeyBitmapClasses [KeyCodes.Add] = Resource.KeyAdd;
         sKeyBitmapClasses [KeyCodes.Subtract] = Resource.KeySubtract;
         sKeyBitmapClasses [KeyCodes.SquareBracketLeft] = Resource.KeySquareBracketLeft;
         sKeyBitmapClasses [KeyCodes.SquareBracketRight] = Resource.KeySquareBracketRight;
         
         sKeyBitmapClasses [Keyboard.INSERT] = Resource.KeyInsert;
         sKeyBitmapClasses [Keyboard.DELETE] = Resource.KeyDel;
         sKeyBitmapClasses [Keyboard.HOME] = Resource.KeyHome;
         sKeyBitmapClasses [Keyboard.END] = Resource.KeyEnd;
         sKeyBitmapClasses [Keyboard.PAGE_UP] = Resource.KeyPageup;
         sKeyBitmapClasses [Keyboard.PAGE_DOWN] = Resource.KeyPagedown;
         
      // ...
         
         sKeyRegions = new Array (KeyCodes.kNumKeys);
         
         sKeyRegions [KeyCodes.Escape] = [8, 7, 26, 16];

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
         
         sKeyRegions [KeyCodes.Key_Z] = [64, 96, 22, 22];
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
         sKeyRegions [Keyboard.BACKSPACE] = [330, 24, 35, 23];
         
         //sKeyRegions [KeyCodes.ControlLeft] = [9, 120, 35, 23];
         //sKeyRegions [KeyCodes.ControlRight] = [330, 120, 35, 23];
         //sKeyRegions [KeyCodes.ShiftLeft] = [9, 96, 54, 23];
         //sKeyRegions [KeyCodes.ShiftRight] = [311, 96, 54, 23];
         sKeyRegions [Keyboard.CAPS_LOCK] = [9, 72, 41, 23];
         sKeyRegions [Keyboard.TAB] = [9, 49, 35, 23];
         sKeyRegions [Keyboard.ENTER] = [323, 72, 42, 23];
         
         
         sKeyRegions [KeyCodes.Key_0] = [256, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_1] = [34, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_2] = [60, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_3] = [83, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_4] = [108, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_5] = [132, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_6] = [157, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_7] = [182, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_8] = [208, 24, 22, 22];
         sKeyRegions [KeyCodes.Key_9] = [232, 24, 22, 22];
         
         sKeyRegions [KeyCodes.Quote]     = [299, 72, 22, 22];
         sKeyRegions [KeyCodes.BackQuote] = [9, 24, 22, 22];
         sKeyRegions [KeyCodes.Slash]     = [287, 96, 22, 22];
         sKeyRegions [KeyCodes.BackSlash] = [342, 49, 22, 22];
         sKeyRegions [KeyCodes.Comma]     = [237, 96, 22, 22];
         sKeyRegions [KeyCodes.Period]    = [262, 96, 22, 22];
         sKeyRegions [KeyCodes.Semicolon] = [274, 72, 22, 22];
         sKeyRegions [KeyCodes.Add]       = [305, 24, 22, 22];
         sKeyRegions [KeyCodes.Subtract]  = [280, 24, 22, 22];
         sKeyRegions [KeyCodes.SquareBracketLeft]  = [293, 49, 22, 22];
         sKeyRegions [KeyCodes.SquareBracketRight] = [317, 49, 22, 22];
         
         sKeyRegions [Keyboard.INSERT] = [377, 24, 22, 22];
         sKeyRegions [Keyboard.DELETE] = [377, 48, 22, 22];
         sKeyRegions [Keyboard.HOME] = [401, 24, 22, 22];
         sKeyRegions [Keyboard.END] = [401, 48, 22, 22];
         sKeyRegions [Keyboard.PAGE_UP] = [426, 24, 22, 22];
         sKeyRegions [Keyboard.PAGE_DOWN] = [426, 48, 22, 22];
      }
      
   // ...
      
      private var mKeyboardBitmap:Bitmap = new Resource.Keyboard ();
      private var mSelectedKeyBitmaps:Array = new Array (KeyCodes.kNumKeys);
      
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
      
      override protected function measure ():void
      {
         measuredWidth = mKeyboardBitmap.width;
         measuredHeight = mKeyboardBitmap.height;
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
         
         for (keyCode = 0; keyCode < KeyCodes.kNumKeys; ++ keyCode)
         {
            if (mSelectedKeyBitmaps [keyCode] != null)
               mSelectedKeyBitmaps [keyCode].visible = false;
         }
         
         for (i = 0; i < mSelectedKeyCodes.length; ++ i)
         {
            keyCode = mSelectedKeyCodes [i];
            if (mSelectedKeyBitmaps [keyCode] == null && sKeyBitmapClasses [keyCode] != null)
            {
               bitmap = new sKeyBitmapClasses [keyCode] ();
               mSelectedKeyBitmaps [keyCode] = bitmap;
               addChild (bitmap);
               region = sKeyRegions [keyCode];
               bitmap.x += mKeyboardBitmap.x + region [0];
               bitmap.y += mKeyboardBitmap.y + region [1];
            }
            
            if (mSelectedKeyBitmaps [keyCode] != null)
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
            if (keyCode >= 0 && keyCode < KeyCodes.kNumKeys && mSelectedKeyCodes.indexOf (keyCode) < 0)
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
         
         for (var i:int = 0; i < KeyCodes.kNumKeys; ++ i)
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
