
package editor.asset {

   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   import flash.events.Event;
   import flash.events.FocusEvent;
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
   
   import editor.display.sprite.CursorCrossingLine;
   import editor.display.sprite.EditingEffect;
   import editor.display.sprite.EffectCrossingAiming;
   import editor.display.sprite.EffectMessagePopup;
   
   import editor.EditorContext;
   
   import common.Define;
   import common.Version;
   
   public class AssetManagerPanel extends UIComponent
   {
      protected var mBackgroundLayer:Sprite;
      protected var mAssetLinksLayer:Sprite;
      protected var mAssetManager:AssetManager = null;
      protected var mAssetIDsLayer:Sprite;
      protected var mEditingEffectLayer:Sprite;
      protected var mFloatingMessageLayer:Sprite;
      public var mForegroundLayer:Sprite; // some intents will access it.
      
      public function AssetManagerPanel ()
      {
         enabled = true;
         mouseFocusEnabled = true;
         
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         addEventListener(Event.RESIZE, OnResize);
         
         //...
         
         mBackgroundLayer = new Sprite ();
         addChild (mBackgroundLayer);
         
         mAssetLinksLayer = new Sprite ();
         addChild (mAssetLinksLayer);
         
         mAssetLinksLayer = new Sprite ();
         addChild (mAssetLinksLayer);
         
         // [asser manager] must close under mAssetIDsLayer
         
         mAssetIDsLayer = new Sprite ();
         addChild (mAssetIDsLayer);
         
         mEditingEffectLayer = new Sprite ();
         addChild (mEditingEffectLayer);
         
         mFloatingMessageLayer = new Sprite ();
         addChild (mFloatingMessageLayer);
         
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
            addChildAt (mAssetManager, getChildIndex (mAssetIDsLayer));
            
            mAssetManager.SetAssetLinksChangedCallback (RepaintAllAssetLinks);
            
            RepaintAllAssetLinks ();
         }
         
         BuildContextMenu ();
      }
      
      public function MoveManagerTo (managerX:Number, managerY:Number):void
      {
         if (mAssetManager != null)
         {
            mAssetManager.SetPosition (managerX, managerY);
            
            mCurrentManagerX = mAssetManager.GetPositionX ();
            mCurrentManagerY = mAssetManager.GetPositionY ();
         }
      }
      
      public function MoveManager (dx:Number, dy:Number):void
      {
         if (mAssetManager != null)
         {
            MoveManagerTo (mAssetManager.GetPositionX () + dx, mAssetManager.GetPositionY () + dy);
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
      
      public static const kMouseWheelFunction_None:int = 0;
      public static const kMouseWheelFunction_Zoom:int = 1;
      public static const kMouseWheelFunction_Scroll:int = 2;
      
      public function GetMouseWheelFunction ():int
      {
         return kMouseWheelFunction_Zoom;
      }
      
      public function ScaleManagerTo (managerScale:Number):void
      {
         if (mAssetManager != null)
         {
            if (managerScale < GetMinAllowedScale ())
               managerScale = GetMinAllowedScale ();
            if (managerScale > GetMaxAllowedScale ())
               managerScale = GetMaxAllowedScale ();
            
            mAssetManager.SetScale (managerScale);
            
            mCurrentManagerScale = mAssetManager.GetScale ();
         }
      }
      
      public function ScaleManager (scale:Number):void
      {
         if (mAssetManager != null)
         {
            ScaleManagerTo (mAssetManager.scaleX * scale);
         }
      }
      
      // used for undo
      private var mCurrentManagerX:Number = 0;
      private var mCurrentManagerY:Number = 0;
      private var mCurrentManagerScale:Number = 1.0;
      
      public function GetCurrentManagerX ():Number
      {
         return mCurrentManagerX;
      }
      
      public function GetCurrentManagerY ():Number
      {
         return mCurrentManagerY;
      }
      
      public function GetCurrentManagerScale ():Number
      {
         return mCurrentManagerScale;
      }
      
      public function GetPanelCenterWorldPoint ():Point
      {
         return ViewToManager (new Point (0.5 * GetPanelWidth (), 0.5 * GetPanelHeight ()));
      }
      
//=================================================================================
// coordinates. (Manager <-> Panel)
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
      
      //todo: set mParentWidth and mParentHeight private. And mContentMaskWidth-> mPanelWidth
      
      private function OnAddedToStage (event:Event):void 
      {
         mParentWidth  = parent.width;
         mParentHeight = parent.height;
         UpdateBackgroundAndContentMaskSprites ();
         
         // ...
         addEventListener (Event.ENTER_FRAME, OnEnterFrame);
         
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
         
         //addEventListener (MouseEvent.CLICK, OnMouseClick);
         //addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         
         addEventListener (MouseEvent.MOUSE_WHEEL, OnMouseWheel);
         
         addEventListener (KeyboardEvent.KEY_DOWN, OnKeyDown);
      }
      
      public function GetPanelWidth ():Number
      {
         return mContentMaskWidth;
      }
      
      public function GetPanelHeight ():Number
      {
         return mContentMaskHeight;
      }
      
      private var mContentMaskSprite:Shape = null;
      private var mContentMaskWidth :Number = 0;
      private var mContentMaskHeight:Number = 0;
      
      protected function UpdateBackgroundAndContentMaskSprites ():void
      {
         if (mParentWidth != mContentMaskWidth || mParentHeight != mContentMaskHeight)
         {
            mContentMaskWidth  = mParentWidth;
            mContentMaskHeight = mParentHeight;
            
            if (mContentMaskSprite == null)
            {
               mContentMaskSprite = new Shape ();
               addChild (mContentMaskSprite);
               mask = mContentMaskSprite;
            }
            
            GraphicsUtil.ClearAndDrawRect (mBackgroundLayer, 0, 0, mContentMaskWidth - 1, mContentMaskHeight - 1, 0x0, 1, true, 0xFFFFFF);
            GraphicsUtil.ClearAndDrawRect (mContentMaskSprite, 0, 0, mContentMaskWidth - 1, mContentMaskHeight - 1, 0x0, 1, true);
            
            if (mAssetManager != null)
            {
               mAssetManager.SetViewportSize (mContentMaskWidth, mContentMaskHeight);
            }
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
         
         UpdateInternal (mStepTimeSpan.GetLastSpan ());
         
         UpdateAssetLinkLines ();
         
         UpdateEffects ();
      }
      
      protected function UpdateInternal (dt:Number):void
      {
      }
      
//=====================================================================
// context menu
//=====================================================================
      
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
         
         if (mAssetManager != null)
         {
            mAssetManager.BuildContextMenuInternal (theContextMenu.customItems);
         }
         
         theContextMenu.customItems.push (EditorContext.GetAboutContextMenuItem ());
      }
      
//==================================================================================
// intent
//==================================================================================
      
      // edit mode
      protected var mCurrentIntent:Intent = null;
      
      public function SetCurrentIntent (intent:Intent):void
      {
         if (mCurrentIntent != null)
         {
             // use tempIntent to avoid dead loop sometimes.
            var tempIntent:Intent = mCurrentIntent;
            mCurrentIntent = null;
            tempIntent.Terminate ();
         }
         
         mCurrentIntent = intent;
      }
      
      public function GetCurrentIntent ():Intent
      {
         return mCurrentIntent;
      }
      
//==================================================================================
// mode
//==================================================================================
      
      protected var mInMoveManagerMode:Boolean = false;
      protected var mInCookieSelectMode:Boolean = false;
      
      protected var mShowAllAssetIDs:Boolean = false;
      protected var mShowAllAssetLinks:Boolean = false;
      
      public function SetMoveManagerMode (moveManagerMode:Boolean):void
      {
         mInMoveManagerMode = moveManagerMode;
      }
      
      public function SetCookieSelectMode (cookieMode:Boolean):void
      {
         mInCookieSelectMode = cookieMode;
      }
      
      public function SetShowAllAssetIDs (show:Boolean):void
      {
         if (mShowAllAssetIDs != show)
         {
            mShowAllAssetIDs = show;
            RepaintAllAssetIDs ();
         }
      }
      
      public function SetShowAllAssetLinks (show:Boolean):void
      {
         if (mShowAllAssetLinks != show)
         {
            mShowAllAssetLinks = show;
            RepaintAllAssetLinks ();
         }
      }
      
//==================================================================================
// mouse and key events
//==================================================================================
      
      protected var mHandleCookieModeOnMouseUp:Boolean = false;
      protected var mIsCtrlDownOnMouseDown:Boolean = false;
      protected var mIsShiftDownOnMouseDown:Boolean = false;
      
      public function IsMouseZeroMove ():Boolean
      {
         return mHandleCookieModeOnMouseUp;
      }
      
      final public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         mHandleCookieModeOnMouseUp = false;
         mIsCtrlDownOnMouseDown = event.ctrlKey;
         mIsShiftDownOnMouseDown = event.shiftKey;
         
         if (mCurrentIntent != null)
         {
            if (! mCurrentIntent.IsTerminated ())
            {
               mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
            }

            return;
         }
         
         if (mIsShiftDownOnMouseDown || mInMoveManagerMode)
         {
            SetCurrentIntent (new IntentPanManager (this));
            mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
            
            return;
         }
         
         OnMouseDownInternal (mAssetManager.mouseX, mAssetManager.mouseY, event.ctrlKey, event.shiftKey);
      }
      
      protected function OnMouseDownInternal (managerX:Number, managerY:Number, mIsCtrlDownOnMouseDown:Boolean, mIsShiftDownOnMouseDown:Boolean):void
      {
         // control points
         
         var controlPoints:Array = mAssetManager.GetControlPointsAtPoint (managerX, managerY);
         if (controlPoints.length > 0)
         {
            var selectCPs:Array = new Array (1);
            selectCPs [0] = controlPoints [0] as ControlPoint;
            mAssetManager.SetSelectedControlPoints (selectCPs);
            SetCurrentIntent (new IntentMoveControlPoint (controlPoints [0] as ControlPoint));
            mCurrentIntent.OnMouseDown (managerX, managerY);
            
            return;
         }
         
         // linkables
         
         var linkable:Linkable = mAssetManager.GetFirstLinkablesAtPoint (managerX, managerY);
         if (linkable != null && linkable.CanStartCreatingLink (managerX, managerY))
         {
            SetCurrentIntent (new IntentDragLink (this, linkable));
            mCurrentIntent.OnMouseDown (managerX, managerY);
            
            return;
         }
         
         // assets
         
         if (mAssetManager.AreSelectedAssetsContainingPoint (managerX, managerY))
         {
            mHandleCookieModeOnMouseUp = mInCookieSelectMode;
            
            SetCurrentIntent (new IntentMoveSelectedAssets (this, mIsCtrlDownOnMouseDown));
            mCurrentIntent.OnMouseDown (managerX, managerY);
          
            return;
         }
         
         // ... 
         
         if (! mAssetManager.SupportSelectingEntitiesWithMouse ())
            return;
         
         var oldSelectedAssets:Array = mAssetManager.GetSelectedAssets ();
         
         if (mInCookieSelectMode)
         {
            //mAssetManager.AddAssetSelections (oldSelectedAssets);
            SetCurrentIntent (new IntentRegionSelectAssets (this, oldSelectedAssets));
            mCurrentIntent.OnMouseDown (managerX, managerY);
            
            return;
         }

         if (PointSelectAsset (managerX, managerY))
         {
            SetCurrentIntent (new IntentMoveSelectedAssets (this, mIsCtrlDownOnMouseDown));
            mCurrentIntent.OnMouseDown (managerX, managerY);
   
            return;
         }
         else
         {
            //mAssetManager.AddAssetSelections (oldSelectedAssets);
            SetCurrentIntent (new IntentRegionSelectAssets (this, oldSelectedAssets));
            mCurrentIntent.OnMouseDown (managerX, managerY);
            
            return;
         }
      }
      
      public function OnMouseMove (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         mHandleCookieModeOnMouseUp = false;
         
         if (mCurrentIntent != null)
         {
            if (! mCurrentIntent.IsTerminated ())
            {
               mCurrentIntent.OnMouseMove (mAssetManager.mouseX, mAssetManager.mouseY, event.buttonDown);
            }

            return;
         }
         
         OnMouseMoveInternal (mAssetManager.mouseX, mAssetManager.mouseY, event.buttonDown, event.ctrlKey, event.shiftKey);
      }
      
      protected function OnMouseMoveInternal (managerX:Number, managerY:Number, isHold:Boolean, mIsCtrlDownOnMouseDown:Boolean, mIsShiftDownOnMouseDown:Boolean):void
      {
      }
      
      public function OnMouseUp (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         var toPointSelectAssetIfMouseZeroMove:Boolean = true;
         
         if (mCurrentIntent != null)
         {
            if (! mCurrentIntent.IsTerminated ())
            {
               mCurrentIntent.OnMouseUp (mAssetManager.mouseX, mAssetManager.mouseY);
            }
            
            //if (mHandleCookieModeOnMouseUp && (mCurrentIntent is IntentMoveSelectedAssets) && mCurrentIntent.IsTerminated ())
            //{
            //   PointSelectAsset (mAssetManager.mouseX, mAssetManager.mouseY);
            //} 
            
            if (! mCurrentIntent.IsTerminated ())
            {
               return;
            }
         }
         
         if (mHandleCookieModeOnMouseUp)
         {
            PointSelectAsset (mAssetManager.mouseX, mAssetManager.mouseY);
         }
         
         OnMouseUpInternal (mAssetManager.mouseX, mAssetManager.mouseY, event.ctrlKey, event.shiftKey);
      }
      
      protected function OnMouseUpInternal (managerX:Number, managerY:Number, mIsCtrlDownOnMouseDown:Boolean, mIsShiftDownOnMouseDown:Boolean):void
      {
      }
      
      protected function OnMouseWheel (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         //stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         var mouseWheelFunction:int = GetMouseWheelFunction ();
         
         if (mouseWheelFunction == kMouseWheelFunction_Zoom && (! event.ctrlKey))
         {
            var oldMouseManagerPoint:Point = new Point (mAssetManager.mouseX, mAssetManager.mouseY);
   
            ScaleManager (event.delta > 0 ? 1.1 : 0.9);
   
            var newMousePoint:Point = DisplayObjectUtil.LocalToLocal (mAssetManager, this, oldMouseManagerPoint);
            
            MoveManager (mouseX - newMousePoint.x, mouseY - newMousePoint.y);
         }
         else if (mouseWheelFunction == kMouseWheelFunction_Scroll)
         {
            MoveManager (0, 10.0 * event.delta / mAssetManager.GetScale ());
         }
      }
      
      final public function OnKeyDown (event:KeyboardEvent):void
      {
         if (OnKeyDownInternal (event.keyCode))
         {
            event.stopPropagation ();
         }
      }
      
      // return true to indicate handled successfully
      protected function OnKeyDownInternal (keyCode:int):Boolean
      {
         return false;
      }
      
//=================================================================================
//   
//=================================================================================
      
      public function UpdateInterface ():void
      {
         // to override
         
         // to call ExternalUpdateInterface ()
         // ExternalUpdateInterface will check the status of this panel
      }

//=================================================================================
//   asset selection (todo: move SelectionList from AssetManager to here)
//=================================================================================
      
      public function OnAssetSelectionsChanged (passively:Boolean = false):void
      {
         if (mAssetManager == null)
            return;
         
         SetScaleRotateFlipHandlersVisible (mAssetManager.GetNumSelectedAssets () > 0);
         
         if (mAssetManager.GetNumSelectedAssets () == 1)
         {
            var assets:Array = new Array (1);
            assets [0] = mAssetManager.GetTheFirstSelectedAsset ();
            mAssetManager.SetAssetsShowingControlPoints (assets);
            if (! mShowAllAssetLinks)
            {
               mAssetManager.SetAssetsShowingInternalLinkables (assets);
            }
         }
         else
         {
            mAssetManager.SetAssetsShowingControlPoints (null);
            if (! mShowAllAssetLinks)
            {
               mAssetManager.SetAssetsShowingInternalLinkables (null);
            }
         }
         
         if (! mShowAllAssetLinks)
         {
            RepaintAllAssetLinks ();
         }
         
         UpdateInterface ();
      }
      
      public function CancelAllAssetSelections ():void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.CancelAllAssetSelections ();
         OnAssetSelectionsChanged ();
      }
      
      public function PointSelectAsset (managerX:Number, managerY:Number):Boolean
      {
         if (mAssetManager == null)
            return false;
         
         var assetArray:Array = mAssetManager.GetAssetsAtPoint (managerX, managerY);
         if (assetArray != null && assetArray.length > 0)
         {
            var asset:Asset = assetArray[0] as Asset;
            
            if (mIsCtrlDownOnMouseDown || mInCookieSelectMode)
            {
               mAssetManager.ToggleAssetSelected (asset);
               OnAssetSelectionsChanged ();
            }
            else
            {
               if (mAssetManager.SetSelectedAsset (asset))
               {
                  OnAssetSelectionsChanged ();
               }
            }
            
            return true;
         }
         else
         {
            if (! mIsCtrlDownOnMouseDown)
            {
               mAssetManager.CancelAllAssetSelections ();
         
               OnAssetSelectionsChanged ();
            }
            
            return false;
         }
      }
      
      public function RegionSelectAssets (left:Number, top:Number, right:Number, bottom:Number, oldSelectedAssets:Array):void
      {
         if (mAssetManager == null)
            return;
         
         var newSelectedAssets:Array = mAssetManager.GetAssetsIntersectWithRegion (left, top, right, bottom);
         
         if (mIsCtrlDownOnMouseDown || mInCookieSelectMode)
         {
            if (mAssetManager.SetSelectedAssetsByToggleTwoAssetArrays (oldSelectedAssets, newSelectedAssets))
            {
               OnAssetSelectionsChanged ();
            }
         }
         else
         {
            if (mAssetManager.SetSelectedAssets (newSelectedAssets))
            {
               OnAssetSelectionsChanged ();
            }
         }
      }
      
//=================================================================================
//   asset scale / rotate / flip handlers
//=================================================================================
      
      protected function SupportScaleRotateFlipTransforms ():Boolean
      {
         if (mAssetManager == null)
            return false;
         
         return mAssetManager.SupportScaleRotateFlipTransforms ();
      }
      
      protected static const ScaleRotateFlipCircleRadius:Number = 100;
      protected var mScaleRotateFlipHandlersContainer:Sprite = null;
      
      protected function SetScaleRotateFlipHandlersVisible (isVisible:Boolean):void
      {
         if (! SupportScaleRotateFlipTransforms ())
         {
            if (mScaleRotateFlipHandlersContainer != null && mScaleRotateFlipHandlersContainer.visible)
            {
               mScaleRotateFlipHandlersContainer.visible = false;
            }
            
            return;
         }
         
         if (mScaleRotateFlipHandlersContainer == null)
         {
            mScaleRotateFlipHandlersContainer = new Sprite ();
            mForegroundLayer.addChild (mScaleRotateFlipHandlersContainer);
            
            var handlersBaseCircle:Sprite = new Sprite ();
            var rotateBothHandler:Sprite = new Sprite ();
            var rotateSelfHandler:Sprite = new Sprite ();
            var rotatePosHandler:Sprite = new Sprite ();
            var scaleBothHandler:Sprite = new Sprite ();
            var scaleSelfHandler:Sprite = new Sprite ();
            var scalePosHandler:Sprite = new Sprite ();
            var flipHorizontallyHandler:Sprite = new Sprite ();
            var flipVerticallyHandler:Sprite = new Sprite ();
            var crossingShape:Shape = new Shape ();
            
            mScaleRotateFlipHandlersContainer.addChild (handlersBaseCircle);
            mScaleRotateFlipHandlersContainer.addChild (rotateBothHandler);
            mScaleRotateFlipHandlersContainer.addChild (scaleBothHandler);
            mScaleRotateFlipHandlersContainer.addChild (flipHorizontallyHandler);
            mScaleRotateFlipHandlersContainer.addChild (rotateSelfHandler);
            mScaleRotateFlipHandlersContainer.addChild (scaleSelfHandler);
            mScaleRotateFlipHandlersContainer.addChild (rotatePosHandler);
            mScaleRotateFlipHandlersContainer.addChild (flipVerticallyHandler);
            mScaleRotateFlipHandlersContainer.addChild (scalePosHandler);
            mScaleRotateFlipHandlersContainer.addChild (crossingShape);
            
            handlersBaseCircle.addEventListener (MouseEvent.MOUSE_DOWN, OnStartMoveScaleRotateFlipHandlers);
            rotateBothHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartRotateSelecteds);
            rotateSelfHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartRotateSelectedSelves);
            rotatePosHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartRotateSelectedPositions);
            scaleBothHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartScaleSelecteds);
            scaleSelfHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartScaleSelectedSelves);
            scalePosHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartScaleSelectedPositions);
            flipHorizontallyHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnFlipSelecteds);
            flipVerticallyHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnFlipSelectedsVertically);
            
            var contextMenuFlipHorizontally:ContextMenu = new ContextMenu ();
            contextMenuFlipHorizontally.hideBuiltInItems ();
            contextMenuFlipHorizontally.builtInItems.print = true;
            flipHorizontallyHandler.contextMenu = contextMenuFlipHorizontally;
            var menuItemFlipSelectedsPositionsOnly:ContextMenuItem = new ContextMenuItem("Horizontal-Flip Selected Entities (Positions Only)");
            menuItemFlipSelectedsPositionsOnly.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnFlipSelecteds_PositionsOnly);
            contextMenuFlipHorizontally.customItems.push (menuItemFlipSelectedsPositionsOnly);
            var menuItemFlipSelectedsWithoutPositions:ContextMenuItem = new ContextMenuItem("Horizontal-Flip Selected Entities (Without Flipping Positions)");
            menuItemFlipSelectedsWithoutPositions.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnFlipSelecteds_WithoutPositions);
            contextMenuFlipHorizontally.customItems.push (menuItemFlipSelectedsWithoutPositions);
            
            var contextMenuFlipVertically:ContextMenu = new ContextMenu ();
            contextMenuFlipVertically.hideBuiltInItems ();
            contextMenuFlipVertically.builtInItems.print = true;
            flipVerticallyHandler.contextMenu = contextMenuFlipVertically;
            var menuItemFlipSelectedsPositionsOnlyVertically:ContextMenuItem = new ContextMenuItem("Vertical-Flip Selected Entities (Positions Only)");
            menuItemFlipSelectedsPositionsOnlyVertically.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnFlipSelectedsVertically_PositionsOnly);
            contextMenuFlipVertically.customItems.push (menuItemFlipSelectedsPositionsOnlyVertically);
            var menuItemFlipSelectedsWithoutPositionsVertically:ContextMenuItem = new ContextMenuItem("Vertical-Flip Selected Entities (Without Flipping Positions)");
            menuItemFlipSelectedsWithoutPositionsVertically.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnFlipSelectedsVertically_WithoutPositions);
            contextMenuFlipVertically.customItems.push (menuItemFlipSelectedsWithoutPositionsVertically);
            
            var halfHandlerSize:Number = 6;
            var handlerRadius:Number = halfHandlerSize * 1.2;
            var handlerSize:Number = halfHandlerSize + halfHandlerSize;
            
            GraphicsUtil.ClearAndDrawCircle (rotateBothHandler, 0, 0, handlerRadius, 0x0, 0, true, 0x0000FF);
            GraphicsUtil.ClearAndDrawCircle (rotateSelfHandler, 0, 0, handlerRadius, 0x0, 0, true, 0x00FF00);
            GraphicsUtil.ClearAndDrawCircle (rotatePosHandler, 0, 0, handlerRadius, 0x0, 0, true, 0xFF0000);
            GraphicsUtil.ClearAndDrawRect (scaleBothHandler, -halfHandlerSize, -3, handlerSize, handlerSize, 0x0, 0, true, 0x0000FF, false);
            GraphicsUtil.ClearAndDrawRect (scaleSelfHandler, -halfHandlerSize, -halfHandlerSize, handlerSize, handlerSize, 0x0, 0, true, 0x00FF00, false);
            GraphicsUtil.ClearAndDrawRect (scalePosHandler, -halfHandlerSize, -halfHandlerSize, handlerSize, handlerSize, 0x0, 0, true, 0xFF0000, false);
            GraphicsUtil.ClearAndDrawRect (flipHorizontallyHandler, -halfHandlerSize, -halfHandlerSize, handlerSize, handlerSize, 0x0, 0, true, 0x0000FF, false);
               GraphicsUtil.DrawLine (flipHorizontallyHandler, -halfHandlerSize, -halfHandlerSize, halfHandlerSize, halfHandlerSize, 0xFFFFFF, 0);
            GraphicsUtil.ClearAndDrawRect (flipVerticallyHandler, -halfHandlerSize, -halfHandlerSize, handlerSize, handlerSize, 0x0, 0, true, 0xFF9900, false);
               GraphicsUtil.DrawLine (flipVerticallyHandler, -halfHandlerSize, -halfHandlerSize, halfHandlerSize, halfHandlerSize, 0xFFFFFF, 0);
            flipHorizontallyHandler.rotation = 45;
            flipVerticallyHandler.rotation = 135;
            GraphicsUtil.ClearAndDrawLine (crossingShape, 0, -5, 0, 5, 0x008000, 0);
            GraphicsUtil.DrawLine (crossingShape, -5, 0, 5, 0, 0x008000, 0);
         }
         
         mScaleRotateFlipHandlersContainer.visible = isVisible;
         if (! isVisible)
            return;
         
         RepositionScaleRotateFlipHandlersContainer ();
         RepositionScaleRotateFlipHandlers (1.0, 0);
      }
      
      protected function RepositionScaleRotateFlipHandlersContainer ():void
      {
         var selectedAssets:Array = mAssetManager.GetSelectedAssets ();
         if (selectedAssets.length == 0)
         {
            mScaleRotateFlipHandlersContainer.visible = false;
            return;
         }
         
         var centerX:Number = 0;
         var centerY:Number = 0;

         for (var i:uint = 0; i < selectedAssets.length; ++ i)
         {
            var asset:Asset = selectedAssets[i] as Asset;
            
            var bounding:Rectangle = asset.getBounds (mAssetManager);
            //centerX += asset.GetPositionX ();
            //centerY += asset.GetPositionY ();
            centerX += 0.5 * (bounding.left + bounding.right);
            centerY += 0.5 * (bounding.top + bounding.bottom);
         }
      
         centerX /= selectedAssets.length;
         centerY /= selectedAssets.length;
         
         var panelPoint:Point = DisplayObjectUtil.LocalToLocal (mAssetManager, mForegroundLayer, new Point (centerX, centerY));
         
         mScaleRotateFlipHandlersContainer.x = panelPoint.x;
         mScaleRotateFlipHandlersContainer.y = panelPoint.y;
      }
      
      public function RepositionScaleRotateFlipHandlers (radiusScale:Number, rotationRadians:Number):void
      {
         var radius:Number = ScaleRotateFlipCircleRadius * radiusScale;
         var handlersBaseCircle:Sprite = mScaleRotateFlipHandlersContainer.getChildAt (0) as Sprite;
         GraphicsUtil.ClearAndDrawCircle (handlersBaseCircle, 0, 0, radius, 0xC0FFC0, 8, false);
         var deltaRadians:Number = 0.25 * Math.PI;
         for (var i:int = 1; i <= 8; ++ i)
         {
            var displayObject:DisplayObject = mScaleRotateFlipHandlersContainer.getChildAt (i);
            displayObject.x = radius * Math.cos (rotationRadians);
            displayObject.y = radius * Math.sin (rotationRadians);
            rotationRadians += deltaRadians;
         }
      }
      
      protected function OnStartMoveScaleRotateFlipHandlers(event:MouseEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         SetCurrentIntent (new IntentMovemScaleRotateFlipHandlers (this));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      public function MoveScaleRotateFlipHandlers (dx:Number, dy:Number):void
      {
         if (mCurrentIntent != null)
            return;
         
         mScaleRotateFlipHandlersContainer.x += dx;
         mScaleRotateFlipHandlersContainer.y += dy;
      }
      
      protected function OnStartRotateSelecteds(event:MouseEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartRotateSelectedSelves(event:MouseEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, false, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartRotateSelectedPositions(event:MouseEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, true, false));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelecteds(event:MouseEvent):void
      {  
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelectedSelves(event:MouseEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, false, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelectedPositions(event:MouseEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, true, false));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnFlipSelecteds(event:MouseEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         var handlerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y + ScaleRotateFlipCircleRadius));
         SetCurrentIntent (new IntentFlipSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, handlerPoint.y, true, true, false));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnFlipSelectedsVertically(event:MouseEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         var handlerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y - ScaleRotateFlipCircleRadius));
         SetCurrentIntent (new IntentFlipSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, handlerPoint.y, true, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      private function OnFlipSelecteds_PositionsOnly (event:ContextMenuEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         
         FlipSelectedAssets (false, managerPoint.x, true, false, true);
      }
      
      private function OnFlipSelecteds_WithoutPositions (event:ContextMenuEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         
         FlipSelectedAssets (false, managerPoint.x, false, true, true);
      }
      
      private function OnFlipSelectedsVertically_PositionsOnly (event:ContextMenuEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         
         RotateSelectedAssets (false, managerPoint.x, managerPoint.y, Math.PI, true, false, false);
         FlipSelectedAssets (false, managerPoint.x, true, false, true);
      }
      
      private function OnFlipSelectedsVertically_WithoutPositions (event:ContextMenuEvent):void
      {
         if (mCurrentIntent != null)
            return;
         
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         
         RotateSelectedAssets (false, managerPoint.x, managerPoint.y, Math.PI, false, true, false);
         FlipSelectedAssets (false, managerPoint.x, false, true, true);
      }
      
//=================================================================================
//   edit selected assets
//=================================================================================
      
      protected function DeleteSelectedControlPoints ():void
      {  
         if (mAssetManager == null)
            return;
         
         mAssetManager.DeleteSelectedControlPoints ();
         
         UpdateInterface ();
         RepaintAllAssetLinks ();
      }
      
      protected function InsertControlPoint ():void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.InsertControlPoint ();
         
         UpdateInterface ();
         RepaintAllAssetLinks ();
      }
      
//=================================================================================
//   edit selected assets
//=================================================================================
      
      public function DeleteSelectedAssets ():void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.DeleteSelectedAssets ();
         
         UpdateInterface ();
         RepaintAllAssetLinks ();
      }
      
      public function MoveSelectedAssets (moveBodyTexture:Boolean, offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.MoveSelectedAssets (moveBodyTexture, offsetX, offsetY, updateSelectionProxy);
         
         UpdateInterface ();
         RepaintAllAssetLinks ();
      }
      
      public function RotateSelectedAssets (rotateBodyTexture:Boolean, centerX:Number, centerY:Number, r:Number, rotatePosition:Boolean, rotateSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.RotateSelectedAssets (rotateBodyTexture, updateSelectionProxy, r, rotateSelf, rotatePosition, centerX, centerY);
         
         UpdateInterface ();
         RepaintAllAssetLinks ();
      }
      
      public function ScaleSelectedAssets (scaleBodyTexture:Boolean, centerX:Number, centerY:Number, s:Number, scalePosition:Boolean, scaleSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.ScaleSelectedAssets (scaleBodyTexture, updateSelectionProxy, s, scaleSelf, scalePosition, centerX, centerY);
         
         UpdateInterface ();
         RepaintAllAssetLinks ();
      }
      
      public function FlipSelectedAssets (flipBodyTexture:Boolean, planeX:Number, flipPosition:Boolean, flipSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.FlipSelectedAssets (flipBodyTexture, updateSelectionProxy, flipSelf, flipPosition, planeX);
         
         UpdateInterface ();
         RepaintAllAssetLinks ();
      }

//=====================================================================
// asset links and ids, effects, ...
//=====================================================================
      
      // todo: hold/release a button to show/hide ids
      protected function RepaintAllAssetIDs ():void
      {
         if (mAssetManager == null)
         {
            mAssetLinksLayer.visible = false;
            return;
         }
         
         mAssetLinksLayer.visible = mShowAllAssetIDs;
         
         while (mAssetLinksLayer.numChildren > 0)
            mAssetLinksLayer.removeChildAt (0);
         
         if (mShowAllAssetIDs)
         {
            mAssetManager.DrawAssetIds (mAssetIDsLayer);
            
            if (mAssetIDsLayer.scaleX != mAssetManager.scaleX)
               mAssetIDsLayer.scaleX = mAssetManager.scaleX;
            if (mAssetIDsLayer.scaleY != mAssetManager.scaleY)
               mAssetIDsLayer.scaleY = mAssetManager.scaleY;
            if ((int (20.0 * mAssetIDsLayer.x)) != (int (20.0 * mAssetManager.x)))
               mAssetIDsLayer.x = mAssetManager.x;
            if ((int (20.0 * mAssetIDsLayer.y)) != (int (20.0 * mAssetManager.y)))
               mAssetIDsLayer.y = mAssetManager.y;
         }
      }
      
      protected function UpdateAllAssetIDs ():void
      {
         // todo: corrent id positions
      }
      
      public function CreateOrBreakAssetLink (startLinkable:Linkable, mStartManagerX:Number, mStartManagerY:Number, endManagerX:Number, endManagerY:Number):void
      {
         // ...
      }
      
      private var mAssetLinksNeedRepaint:Boolean = false;
      
      protected function RepaintAllAssetLinks ():void
      {
         mAssetLinksNeedRepaint = true;
      }
      
      protected function UpdateAssetLinkLines ():void
      {
         if (mAssetManager == null)
         {
            mAssetLinksLayer.visible = false;
            return;
         }
         
         mAssetLinksLayer.visible = true;
         
         if (mAssetLinksNeedRepaint)
         {
            mAssetLinksNeedRepaint = false;
            
            mAssetLinksLayer.graphics.clear ();
            mAssetManager.DrawAssetLinks (mAssetLinksLayer, mShowAllAssetLinks);
         }
         
         if (mAssetLinksLayer.scaleX != mAssetManager.scaleX)
            mAssetLinksLayer.scaleX = mAssetManager.scaleX;
         if (mAssetLinksLayer.scaleY != mAssetManager.scaleY)
            mAssetLinksLayer.scaleY = mAssetManager.scaleY;
         if ((int (20.0 * mAssetLinksLayer.x)) != (int (20.0 * mAssetManager.x)))
            mAssetLinksLayer.x = mAssetManager.x;
         if ((int (20.0 * mAssetLinksLayer.y)) != (int (20.0 * mAssetManager.y)))
            mAssetLinksLayer.y = mAssetManager.y;
      }
      
      public function PushFloatingMessage (popupMessage:EffectMessagePopup):void
      {
         mFloatingMessageLayer.addChild (popupMessage);
      }
      
      protected function UpdateEffects ():void
      {
         // reverse order for some effects will remove itself
         var effect:EditingEffect;
         var i:int;
         
         for (i = mEditingEffectLayer.numChildren - 1; i >= 0; -- i)
         {
            effect = mEditingEffectLayer.getChildAt (i) as EditingEffect;
            if (effect != null)
            {
               effect.Update ();
            }
         }
         
         for (i = mFloatingMessageLayer.numChildren - 1; i >= 0; -- i)
         {
            effect = mFloatingMessageLayer.getChildAt (i) as EditingEffect;
            if (effect != null)
            {
               effect.Update ();
            }
         }
         
         EffectMessagePopup.UpdateMessagesPosition (mFloatingMessageLayer);
      }

//=====================================================================
// pick asset
//=====================================================================
      
      public function EnterPickAssetIntent (onPick:Function, onEnd:Function):void
      {
         if (mAssetManager != null)
         {
            SetCurrentIntent (new IntentPickAsset (this, onPick, onEnd));
            mAssetManager.NotifyPickingStatusChanged (true);
         }
      }
      
      public function ExitPickAssetIntent ():void
      {
         if (mAssetManager != null)
         {
            SetCurrentIntent (null);
            mAssetManager.NotifyPickingStatusChanged (false);
         }
      }
      
      public function PickAssetAtPosition (managerX:Number, managerY:Number):Asset
      {
         if (mAssetManager != null)
         {
            var assetArray:Array = mAssetManager.GetAssetsAtPoint (managerX, managerY);
            if (assetArray != null && assetArray.length >= 1)
            {
               return assetArray [0] as Asset;
            }
         }
         
         return null;
      }
      
   }
}
