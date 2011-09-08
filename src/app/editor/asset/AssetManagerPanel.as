
package editor.asset {

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
   
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import mx.core.UIComponent;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetManagerPanel extends UIComponent 
   {
      public var mBackgroundLayer:Sprite;
      public var mFriendLinksLayer:Sprite;
      public var mForegroundLayer:Sprite;
      
      protected var mAssetManager:AssetManager = null;
      
      public function AssetManagerPanel ()
      {
         enabled = true;
         mouseFocusEnabled = true;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         //...
         
         mBackgroundLayer = new Sprite ();
         addChild (mBackgroundLayer);
         
         mFriendLinksLayer = new Sprite ();
         addChild (mFriendLinksLayer);
         
         mForegroundLayer = new Sprite ();
         addChild (mForegroundLayer);
      }
      
      public function SetAssetManager (assetManager:AssetManager):void
      {
         if (mAssetManager == assetManager)
            return;
         
         if (mAssetManager != null && contains (mAssetManager))
         {
            mAssetManager.SetAssetLinksChangedCallback (null);
            removeChild (mAssetManager);
         }
         
         mAssetManager = assetManager;
         
         if (mAssetManager != null)
         {
            addChildAt (mAssetManager, getChildIndex (mForegroundLayer));
            //mAssetManager.SetAssetLinksChangedCallback (UpdateAssetLinkLines);
         }
      }
      
      public function MoveManager (dx:Number, dy:Number):void
      {
         if (mAssetManager != null)
         {
            mAssetManager.x += dx;
            mAssetManager.y += dy;
         }
      }
      
      protected function GetMaxAllowedScale ():Number
      {
         return 4.0;
      }
      
      protected function GetMinAllowedScale ():Number
      {
         return 1.0 / 4.0;
      }
      
      public function ScaleManager (scale:Number):void
      {
         if (mAssetManager != null)
         {
            var currentScale:Number = mAssetManager.scaleX;
            currentScale *= scale;
            if (currentScale < GetMinAllowedScale ())
               currentScale = GetMinAllowedScale ();
            if (currentScale > GetMaxAllowedScale ())
               currentScale = GetMaxAllowedScale ();
            
            mAssetManager.scaleX = mAssetManager.scaleY = currentScale;
         }
      }
      
//=================================================================================
// coordinates
//=================================================================================
      
      public function ViewToManager (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (this, mAssetManager, point);
      }
      
      public function ManagerToView (point:Point):Point
      {
         return DisplayObjectUtil.LocalToLocal (mAssetManager, this, point);
      }
      
//============================================================================
//   stage event
//============================================================================
      
      private function OnAddedToStage (event:Event):void 
      {
         UpdateBackgroundAndContentMaskSprites ();
         
         // ...
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         
         //addEventListener (MouseEvent.CLICK, OnMouseClick);
         //addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         
         addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         //stage.addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
         
         //
         BuildContextMenu ();
      }
      
      private var mContentMaskSprite:Shape = null;
      private var mParentContainerWidth :Number = -1;
      private var mParentContainerHeight:Number = -1;
      
      private function UpdateBackgroundAndContentMaskSprites ():void
      {
         if (mParentWidth != mParentContainerWidth || mParentHeight != mParentContainerHeight)
         {
            mParentContainerWidth  = mParentWidth;
            mParentContainerHeight = mParentHeight;
            
            if (mContentMaskSprite == null)
            {
               mContentMaskSprite = new Shape ();
               addChild (mContentMaskSprite);
               mask = mContentMaskSprite;
            }
            
            GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, mParentContainerWidth - 1, mParentContainerHeight - 1, 0x0, 1, true, 0xFFFFFF);
            GraphicsUtil.ClearAndDrawRect (mContentMaskSprite, 0, 0, mParentContainerWidth - 1, mParentContainerHeight - 1, 0x0, 1, true);
         }
      }
      
      protected var mParentWidth:Number = 0;
      protected var mParentHeight:Number = 0;
      
      protected function OnResize (event:Event):void 
      {
         mParentWidth  = parent.width;
         mParentHeight = parent.height;
         UpdateBackgroundAndContentMaskSprites ();
      }
      
      private var mStepTimeSpan:TimeSpan = new TimeSpan ();
      
      private function OnEnterFrame (event:Event):void 
      {
         //
         mStepTimeSpan.End ();
         mStepTimeSpan.Start ();
         
         if (mCurrentIntent != null && mCurrentIntent.IsTerminated ())
         {
            SetCurrentIntent (null);
         }
      
         if (mAssetManager != null)
         {
            mAssetManager.Update (mStepTimeSpan.GetLastSpan ());
         }
      }
      
//=====================================================================
// context menu
//=====================================================================
      
      private var mMenuItemAbout:ContextMenuItem;
      
      final private function BuildContextMenu ():void
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
         mMenuItemAbout.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);

         theContextMenu.customItems.push (mMenuItemAbout);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemAbout:
               Runtime.OpenAboutLink ();
               break;
            default:
               break;
         }
      }
      
//==================================================================================
// edit mode
//==================================================================================
      
      // edit mode
      protected var mCurrentIntent:Intent = null;
      
      public function SetCurrentIntent (mode:Intent):void
      {
         if (mCurrentIntent != null)
         {
            mCurrentIntent.Terminate ();
            mCurrentIntent = null;
         }
         
         mCurrentIntent = mode;
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      protected var mIsMouseZeroMove:Boolean = false;
      protected var mIsCtrlDownOnMouseDown:Boolean = false;
      protected var mIsShiftDownOnMouseDown:Boolean = false;
      
      final public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         mIsMouseZeroMove = true;
         mIsCtrlDownOnMouseDown = event.ctrlKey;
         mIsShiftDownOnMouseDown = event.shiftKey;
         
         var managerPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mAssetManager, new Point (event.localX, event.localY));
         
         if (mCurrentIntent != null)
         {
            if (! mCurrentIntent.IsTerminated ())
            {
               mCurrentIntent.OnMouseDown (managerPoint.x, managerPoint.y);
            }

            return;
         }
         
         if (mIsShiftDownOnMouseDown)
         {
            SetCurrentIntent (new IntentPanManager (this));
            mCurrentIntent.OnMouseDown (managerPoint.x, managerPoint.y);
            
            return;
         }
         
         OnMouseDownInternal (managerPoint.x, managerPoint.y, event.ctrlKey, event.shiftKey);
      }
      
      protected function OnMouseDownInternal (managerX:Number, managerY:Number, mIsCtrlDownOnMouseDown:Boolean, mIsShiftDownOnMouseDown:Boolean):void
      {  
         var linkable:Linkable = mAssetManager.GetFirstLinkablesAtPoint (managerX, managerY);
         if (linkable != null && linkable.CanStartCreatingLink (managerX, managerY))
         {
            SetCurrentIntent (new IntentDragLink (this, linkable));
            mCurrentIntent.OnMouseDown (managerX, managerY);
            
            return;
         }
         
         if (mAssetManager.AreSelectedAssetsContainingPoint (managerX, managerY))
         {
            SetCurrentIntent (new IntentMoveSelectedAssets (this));
            mCurrentIntent.OnMouseDown (managerX, managerY);
          
            return;
         }
         
         mIsMouseZeroMove = false; // avoid some handing in OnMouseUp
         
         var oldSelectedAssets:Array = mAssetManager.GetSelectedAssets ();

         var assetArray:Array = mAssetManager.GetAssetsAtPoint (managerX, managerY);
         if (PointSelectAsset (managerX, managerY))
         {
            SetCurrentIntent (new IntentMoveSelectedAssets (this));
            mCurrentIntent.OnMouseDown (managerX, managerY);

            return;
         }
         else
         {
            mAssetManager.AddSelectedAssets (oldSelectedAssets);
            SetCurrentIntent (new IntentRegionSelectAssets (this, oldSelectedAssets));
            mCurrentIntent.OnMouseDown (managerX, managerY);
            
            return;
         }
      }
      
      protected function PointSelectAsset (managerX:Number, managerY:Number):Boolean
      {
         mAssetManager.ClearSelectedAssets ();
         var assetArray:Array = mAssetManager.GetAssetsAtPoint (managerX, managerY);
         if (assetArray != null && assetArray.length > 0)
         {
            var asset:Asset = assetArray[0] as Asset;
            mAssetManager.SetSelectedAsset (asset);
            
            return true;
         }
         
         return false;
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         mIsMouseZeroMove = false;
         
         var managerPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mAssetManager, new Point (event.localX, event.localY));
         
         if (mCurrentIntent != null)
         {
            if (! mCurrentIntent.IsTerminated ())
            {
               mCurrentIntent.OnMouseMove (managerPoint.x, managerPoint.y, event.buttonDown);
            }

            return;
         }
         
         OnMouseMoveInternal (managerPoint.x, managerPoint.y, event.buttonDown, event.ctrlKey, event.shiftKey);
      }
      
      protected function OnMouseMoveInternal (managerX:Number, managerY:Number, isHold:Boolean, mIsCtrlDownOnMouseDown:Boolean, mIsShiftDownOnMouseDown:Boolean):void
      {
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         var managerPoint:Point = DisplayObjectUtil.LocalToLocal (event.target as DisplayObject, mAssetManager, new Point (event.localX, event.localY));
         
         var toPointSelectAssetIfMouseZeroMove:Boolean = true;
         
         if (mCurrentIntent != null)
         {
            if (! mCurrentIntent.IsTerminated ())
            {
               mCurrentIntent.OnMouseUp (managerPoint.x, managerPoint.y);
            }
            
            if (mIsMouseZeroMove)
            {
               PointSelectAsset (managerPoint.x, managerPoint.y);
            }

            return;
         }
         
         if (mIsMouseZeroMove)
         {
            PointSelectAsset (managerPoint.x, managerPoint.y);
         }
         
         OnMouseUpInternal (managerPoint.x, managerPoint.y, event.ctrlKey, event.shiftKey);
      }
      
      protected function OnMouseUpInternal (managerX:Number, managerY:Number, mIsCtrlDownOnMouseDown:Boolean, mIsShiftDownOnMouseDown:Boolean):void
      {
      }
      
      protected function OnMouseWheel (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         var oldMouseManagerPoint:Point = DisplayObjectUtil.LocalToLocal (this, mAssetManager, new Point (mouseX, mouseY));

         ScaleManager (event.delta > 0 ? 1.1 : 0.9);

         var newMousePoint:Point = DisplayObjectUtil.LocalToLocal (mAssetManager, this, oldMouseManagerPoint);
         
         MoveManager (mouseX - newMousePoint.x, mouseY - newMousePoint.y);
      }
      
//=================================================================================
//   select
//=================================================================================
      
      public function RegionSelectAssets (left:Number, top:Number, right:Number, bottom:Number, oldSelectedAssets:Array):void
      {
         if (mAssetManager == null)
            return;
         
         var newSelectedAssets:Array = mAssetManager.GetAssetsIntersectWithRegion (left, top, right, bottom);
         
         mAssetManager.ClearSelectedAssets ();

         if (mIsCtrlDownOnMouseDown)
         {
            mAssetManager.AddSelectedAssets (oldSelectedAssets);
            mAssetManager.ToggleAssetsSelected (newSelectedAssets);
         }
         else
         {
            mAssetManager.AddSelectedAssets (newSelectedAssets);
         }
      }
      
//=================================================================================
//   edit selected assets
//=================================================================================
      
      public function MoveSelectedAssets (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.MoveSelectedAssets (offsetX, offsetY, updateSelectionProxy);
      }
      
      public function DeleteSelectedAssets ():void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.DeleteSelectedAssets ();
      }
      
      public function CreateOrBreakLink (startLinkable:Linkable, endManagerX:Number, endManagerY:Number):void
      {
         // ...
      }
      
   }
}
