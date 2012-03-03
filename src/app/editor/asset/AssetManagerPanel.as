
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
   import editor.runtime.KeyboardListener;
   
   import common.Define;
   import common.Version;
   
   public class AssetManagerPanel extends UIComponent implements KeyboardListener
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
         
         BuildContextMenu ();
      }
      
      public function MoveManager (dx:Number, dy:Number):void
      {
         if (mAssetManager != null)
         {
            mAssetManager.SetPosition (mAssetManager.x + dx, mAssetManager.y + dy);
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
      
      public function IsZoomSupported ():Boolean
      {
         return true;
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
            
            mAssetManager.SetScale (currentScale);
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
      }
      
      private var mContentMaskSprite:Shape = null;
      private var mParentContainerWidth :Number = -1;
      private var mParentContainerHeight:Number = -1;
      
      protected function UpdateBackgroundAndContentMaskSprites ():void
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
            
            if (mAssetManager != null)
            {
               mAssetManager.SetViewportSize (mParentContainerWidth, mParentContainerHeight);
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
         
         theContextMenu.customItems.push (Runtime.GetAboutContextMenuItem ());
      }
      
//==================================================================================
// edit mode
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
// mouse and key events
//==================================================================================
      
      protected var mIsMouseZeroMove:Boolean = false;
      protected var mIsCtrlDownOnMouseDown:Boolean = false;
      protected var mIsShiftDownOnMouseDown:Boolean = false;
      
      public function IsMouseZeroMove ():Boolean
      {
         return mIsMouseZeroMove;
      }
      
      final public function OnMouseDown (event:MouseEvent):void
      {
         if (event.eventPhase != EventPhase.BUBBLING_PHASE)
            return;
         
         Runtime.SetKeyboardListener (this);
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         mIsMouseZeroMove = true;
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
         
         if (mIsShiftDownOnMouseDown)
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
            SetCurrentIntent (new IntentMoveSelectedAssets (this, mIsCtrlDownOnMouseDown));
            mCurrentIntent.OnMouseDown (managerX, managerY);
          
            return;
         }
         
         mIsMouseZeroMove = false; // avoid some handing in OnMouseUp
         
         // ...
         
         if (! mAssetManager.SupportSelectingEntitiesWithMouse ())
            return;
         
         var oldSelectedAssets:Array = mAssetManager.GetSelectedAssets ();

         var assetArray:Array = mAssetManager.GetAssetsAtPoint (managerX, managerY);
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
         
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         mIsMouseZeroMove = false;
         
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
         
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         var toPointSelectAssetIfMouseZeroMove:Boolean = true;
         
         if (mCurrentIntent != null)
         {
            if (! mCurrentIntent.IsTerminated ())
            {
               mCurrentIntent.OnMouseUp (mAssetManager.mouseX, mAssetManager.mouseY);
            }
            
            if (mIsMouseZeroMove && (mCurrentIntent is IntentMoveSelectedAssets) && mCurrentIntent.IsTerminated ())
            {
               PointSelectAsset (mAssetManager.mouseX, mAssetManager.mouseY);
            } 

            return;
         }
         
         if (mIsMouseZeroMove)
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
         
         stage.focus = this;
         
         if (mAssetManager == null)
            return;
         
         if (IsZoomSupported () && (! event.ctrlKey))
         {
            var oldMouseManagerPoint:Point = new Point (mAssetManager.mouseX, mAssetManager.mouseY);
   
            ScaleManager (event.delta > 0 ? 1.1 : 0.9);
   
            var newMousePoint:Point = DisplayObjectUtil.LocalToLocal (mAssetManager, this, oldMouseManagerPoint);
            
            MoveManager (mouseX - newMousePoint.x, mouseY - newMousePoint.y);
         }
         else
         {
            MoveManager (0, 10.0 * event.delta / mAssetManager.GetScale ());
         }
      }
      
      public function OnKeyDown (event:KeyboardEvent):void
      {
         switch (event.keyCode)
         {
            case Keyboard.ESCAPE:
               SetCurrentIntent (null);
               break;
            //case Keyboard.SPACE:
            //   OpenEntitySettingDialog ();
            //   break;
            case Keyboard.DELETE:
               if (event.ctrlKey)
                  DeleteSelectedControlPoints ();
               //else
               //   DeleteSelectedEntities ();
               break;
            case Keyboard.INSERT:
               if (event.ctrlKey)
                  InsertVertexController ();
               //else
               //   CloneSelectedEntities ();
               break;
            default:
               break;
         }
      }
      
//=================================================================================
//   
//=================================================================================
      
      public function UpdateInterface ():void
      {
         // to override
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
            mAssetManager.SetAssetsWithControlPointsShown (assets);
         }
         else
         {
            mAssetManager.SetAssetsWithControlPointsShown (null);
         }
         
         UpdateInterface ();
      } 
      
      public function PointSelectAsset (managerX:Number, managerY:Number):Boolean
      {
         if (mAssetManager == null)
            return false;
         
         var assetArray:Array = mAssetManager.GetAssetsAtPoint (managerX, managerY);
         if (assetArray != null && assetArray.length > 0)
         {
            var asset:Asset = assetArray[0] as Asset;
            
            if (mIsCtrlDownOnMouseDown)
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
               mAssetManager.ClearAssetSelections ();
         
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
         
         if (mIsCtrlDownOnMouseDown)
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
      
      final protected function SupportScaleRotateFlipTransforms ():Boolean
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
            var menuItemFlipSelectedsWioutPositions:ContextMenuItem = new ContextMenuItem("Horizontal-Flip Selected Entities (Without Flipping Positions)");
            menuItemFlipSelectedsWioutPositions.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnFlipSelecteds_WioutPositions);
            contextMenuFlipHorizontally.customItems.push (menuItemFlipSelectedsWioutPositions);
            
            var contextMenuFlipVertically:ContextMenu = new ContextMenu ();
            contextMenuFlipVertically.hideBuiltInItems ();
            contextMenuFlipVertically.builtInItems.print = true;
            flipVerticallyHandler.contextMenu = contextMenuFlipVertically;
            var menuItemFlipSelectedsPositionsOnlyVertically:ContextMenuItem = new ContextMenuItem("Vertical-Flip Selected Entities (Positions Only)");
            menuItemFlipSelectedsPositionsOnlyVertically.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnFlipSelectedsVertically_PositionsOnly);
            contextMenuFlipVertically.customItems.push (menuItemFlipSelectedsPositionsOnlyVertically);
            var menuItemFlipSelectedsWioutPositionsVertically:ContextMenuItem = new ContextMenuItem("Vertical-Flip Selected Entities (Without Flipping Positions)");
            menuItemFlipSelectedsWioutPositionsVertically.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnFlipSelectedsVertically_WioutPositions);
            contextMenuFlipVertically.customItems.push (menuItemFlipSelectedsWioutPositionsVertically);
            
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
         SetCurrentIntent (new IntentMovemScaleRotateFlipHandlers (this));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      public function MoveScaleRotateFlipHandlers (dx:Number, dy:Number):void
      {
         mScaleRotateFlipHandlersContainer.x += dx;
         mScaleRotateFlipHandlersContainer.y += dy;
      }
      
      protected function OnStartRotateSelecteds(event:MouseEvent):void
      {
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartRotateSelectedSelves(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, false, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartRotateSelectedPositions(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, true, false));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelecteds(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelectedSelves(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, false, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelectedPositions(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, true, false));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnFlipSelecteds(event:MouseEvent):void
      {
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         var handlerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y + ScaleRotateFlipCircleRadius));
         SetCurrentIntent (new IntentFlipSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, handlerPoint.y, true, true, false));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnFlipSelectedsVertically(event:MouseEvent):void
      {
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         var handlerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y - ScaleRotateFlipCircleRadius));
         SetCurrentIntent (new IntentFlipSelectedAssets (this, event.ctrlKey, managerPoint.x, managerPoint.y, handlerPoint.y, true, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      private function OnFlipSelecteds_PositionsOnly (event:ContextMenuEvent):void
      {
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         
         FlipSelectedAssets (false, managerPoint.x, true, false, true);
      }
      
      private function OnFlipSelecteds_WioutPositions (event:ContextMenuEvent):void
      {
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         
         FlipSelectedAssets (false, managerPoint.x, false, true, true);
      }
      
      private function OnFlipSelectedsVertically_PositionsOnly (event:ContextMenuEvent):void
      {
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         
         RotateSelectedAssets (false, managerPoint.x, managerPoint.y, Math.PI, true, false, false);
         FlipSelectedAssets (false, managerPoint.x, true, false, true);
      }
      
      private function OnFlipSelectedsVertically_WioutPositions (event:ContextMenuEvent):void
      {
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
      }
      
      protected function InsertVertexController ():void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.InsertVertexController ();
         
         UpdateInterface ();
         
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
      }
      
      public function MoveSelectedAssets (moveBodyTexture:Boolean, offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.MoveSelectedAssets (moveBodyTexture, offsetX, offsetY, updateSelectionProxy);
         
         UpdateInterface ();
      }
      
      public function RotateSelectedAssets (rotateBodyTexture:Boolean, centerX:Number, centerY:Number, r:Number, rotatePosition:Boolean, rotateSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.RotateSelectedAssets (rotateBodyTexture, updateSelectionProxy, r, rotateSelf, rotatePosition, centerX, centerY);
         
         UpdateInterface ();
      }
      
      public function ScaleSelectedAssets (scaleBodyTexture:Boolean, centerX:Number, centerY:Number, s:Number, scalePosition:Boolean, scaleSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.ScaleSelectedAssets (scaleBodyTexture, updateSelectionProxy, s, scaleSelf, scalePosition, centerX, centerY);
         
         UpdateInterface ();
      }
      
      public function FlipSelectedAssets (flipBodyTexture:Boolean, planeX:Number, flipPosition:Boolean, flipSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.FlipSelectedAssets (flipBodyTexture, updateSelectionProxy, flipSelf, flipPosition, planeX);
         
         UpdateInterface ();
      }
      
      public function CreateOrBreakLink (startLinkable:Linkable, endManagerX:Number, endManagerY:Number):void
      {
         // ...
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
