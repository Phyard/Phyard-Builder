
package editor.display.panel {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import flash.net.URLRequest;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import mx.managers.PopUpManager;
   import mx.containers.TitleWindow;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.WorldView;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetSoundEditingPanel extends TitleWindow 
   {
      private static var sAssetSoundEditingPanel:AssetSoundEditingPanel = null;
      public static function ShowAssetSoundEditingPanel ():void
      {
         if (sAssetSoundEditingPanel == null)
            sAssetSoundEditingPanel = new AssetSoundEditingPanel ();
            
         PopUpManager.addPopUp (sAssetSoundEditingPanel, Runtime.GetApplication (), false);
         PopUpManager.centerPopUp (sAssetSoundEditingPanel);
      }
      
      public static function HideAssetSoundEditingPanel ():void
      {
         PopUpManager.removePopUp(sAssetSoundEditingPanel);
      }
      
//============================================================================
//  
//============================================================================
      
      public function AssetSoundEditingPanel ()
      {
         title = "Sound Assets";
         showCloseButton = true;
         
         width = 500;
         height = 500;
         
         enabled = true;
         mouseFocusEnabled = true;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         addEventListener(Event.CLOSE, OnClose);
         
         //
         BuildContextMenu ();
      }
      
//============================================================================
//   stage event
//============================================================================
      
      private function OnClose (event:Event):void 
      {
         HideAssetSoundEditingPanel ();
      }
      
      private function OnAddedToStage (event:Event):void
      {
         // ...
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         addEventListener (MouseEvent.CLICK, OnMouseClick);
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      }
      
      //private var mContentMaskSprite:Shape = null;
      
      private function OnResize (event:Event):void 
      {
         var parentWidth :Number = parent.width;
         var parentHeight:Number = parent.height;
         
         //GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, parentWidth - 1, parentHeight - 1, 0x0, 1, true, 0xDDDDA0);
         
         // mask
         /*
         {
            if (mContentMaskSprite == null)
            {
               mContentMaskSprite = new Shape ();
               addChild (mContentMaskSprite);
            }
            
            mContentMaskSprite.graphics.clear ();
            mContentMaskSprite.graphics.beginFill(0x0);
            mContentMaskSprite.graphics.drawRect (0, 0, parentWidth, parentHeight);
            mContentMaskSprite.graphics.endFill ();
            
            mask = mContentMaskSprite;
         }
         */
      }
      
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function OnEnterFrame (event:Event):void 
      {
         //
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
      }

//=================================================================================
// coordinates
//=================================================================================
      
      public function ViewToManager (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (this, null, point);
      }
      
      public function ManagerToView (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (null, this, point);
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      private var _mouseEventCtrlDown:Boolean = false;
      private var _mouseEventShiftDown:Boolean = false;
      private var _mouseEventAltDown:Boolean = false;
      
      private var _isZeroMove:Boolean = false;
      
      private function CheckModifierKeys (event:MouseEvent):void
      {
         _mouseEventCtrlDown   = event.ctrlKey;
         _mouseEventShiftDown = event.shiftKey;
         _mouseEventAltDown     = event.altKey;
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      public function OnMouseClick (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
      }
      
      public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
      }
      
      public function OnMouseOut (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
      }
      
      public function OnMouseWheel (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
         if (! Runtime.IsActiveView (this))
            return;
         
         if (Runtime.HasSettingDialogOpened ())
            return;
         
         if (Runtime.HasInputFocused ())
            return;
         
         switch (event.keyCode)
         {
            case Keyboard.ESCAPE:
               break;
            case Keyboard.SPACE:
               break;
            default:
               break;
         }
      }
      
//=====================================================================
// context menu
//=====================================================================
      
      private var mMenuItemAbout:ContextMenuItem;
      
      private function BuildContextMenu ():void
      {
         var theContextMenu:ContextMenu = new ContextMenu ();
         theContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = theContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = theContextMenu;
         
         // need flash 10
         //theContextMenu.clipboardMenu = true;
         //var clipboardItems:ContextMenuClipboardItems = theContextMenu.builtInItems;
         //clipboardItems.clear = true;
         //clipboardItems.cut = false;
         //clipboardItems.copy = true;
         //clipboardItems.paste = true;
         //clipboardItems.selectAll = false;
            
         
         var majorVersion:int = (Version.VersionNumber & 0xFF00) >> 8;
         var minorVersion:Number = (Version.VersionNumber & 0xFF) >> 0;
         
         mMenuItemAbout = new ContextMenuItem("About Phyard Builder v" + majorVersion.toString (16) + (minorVersion < 16 ? ".0" : ".") + minorVersion.toString (16)); //, true);
         theContextMenu.customItems.push (mMenuItemAbout);
         mMenuItemAbout.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemAbout:
               WorldView.OpenAboutLink ();
               break;
            default:
               break;
         }
      }
      
   }
}
