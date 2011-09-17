
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
      
      public function IsMouseZeroMove ():Boolean
      {
         return mIsMouseZeroMove;
      }
      
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
         
         var oldMouseManagerPoint:Point = new Point (mAssetManager.mouseX, mAssetManager.mouseY);

         ScaleManager (event.delta > 0 ? 1.1 : 0.9);

         var newMousePoint:Point = DisplayObjectUtil.LocalToLocal (mAssetManager, this, oldMouseManagerPoint);
         
         MoveManager (mouseX - newMousePoint.x, mouseY - newMousePoint.y);
      }
      
//=================================================================================
//   select
//=================================================================================
      
      public function PointSelectAsset (managerX:Number, managerY:Number):Boolean
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
         
         SetScaleRotateFlipHandlersVisible (mAssetManager.GetNumSelectedAssets () > 0);
      }
      
//=================================================================================
//   scale / rotate / flip handlers
//=================================================================================
      
      protected static const ScaleRotateFlipCircleRadius:Number = 100;
      protected var mScaleRotateFlipHandlersContainer:Sprite = null;
      
      protected function SetScaleRotateFlipHandlersVisible (isVisible:Boolean):void
      {
         if (mScaleRotateFlipHandlersContainer == null)
         {
            mScaleRotateFlipHandlersContainer = new Sprite ();
            mForegroundLayer.addChild (mScaleRotateFlipHandlersContainer);
            
            var rotateBothHandler:Sprite = new Sprite ();
            var rotateSelfHandler:Sprite = new Sprite ();
            var rotatePosHandler:Sprite = new Sprite ();
            var scaleBothHandler:Sprite = new Sprite ();
            var scaleSelfHandler:Sprite = new Sprite ();
            var scalePosHandler:Sprite = new Sprite ();
            var flipBothHandler:Sprite = new Sprite ();
            var flipOptionsHandler:Sprite = new Sprite ();
            
            mScaleRotateFlipHandlersContainer.addChild (rotateBothHandler);
            mScaleRotateFlipHandlersContainer.addChild (scaleBothHandler);
            mScaleRotateFlipHandlersContainer.addChild (flipBothHandler);
            mScaleRotateFlipHandlersContainer.addChild (rotateSelfHandler);
            mScaleRotateFlipHandlersContainer.addChild (scaleSelfHandler);
            mScaleRotateFlipHandlersContainer.addChild (rotatePosHandler);
            mScaleRotateFlipHandlersContainer.addChild (flipOptionsHandler);
            mScaleRotateFlipHandlersContainer.addChild (scalePosHandler);
            
            rotateBothHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartRotateSelecteds);
            rotateSelfHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartRotateSelectedSelves);
            rotatePosHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartRotateSelectedPositions);
            scaleBothHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartScaleSelecteds);
            scaleSelfHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartScaleSelectedSelves);
            scalePosHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnStartScaleSelectedPositions);
            flipBothHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnFlipSelecteds);
            flipOptionsHandler.addEventListener (MouseEvent.MOUSE_DOWN, OnFlipSelectedsOptions);
            
            var halfHandlerSize:Number = 6;
            var handlerSize:Number = halfHandlerSize + halfHandlerSize;
            
            GraphicsUtil.ClearAndDrawCircle (rotateBothHandler, 0, 0, halfHandlerSize, 0x0, 0, true, 0x0000FF);
            GraphicsUtil.ClearAndDrawCircle (rotateSelfHandler, 0, 0, halfHandlerSize, 0x0, 0, true, 0x00FF00);
            GraphicsUtil.ClearAndDrawCircle (rotatePosHandler, 0, 0, halfHandlerSize, 0x0, 0, true, 0xFF0000);
            GraphicsUtil.ClearAndDrawRect (scaleBothHandler, -halfHandlerSize, -3, handlerSize, handlerSize, 0x0, 0, true, 0x0000FF, false);
            GraphicsUtil.ClearAndDrawRect (scaleSelfHandler, -halfHandlerSize, -halfHandlerSize, handlerSize, handlerSize, 0x0, 0, true, 0x00FF00, false);
            GraphicsUtil.ClearAndDrawRect (scalePosHandler, -halfHandlerSize, -halfHandlerSize, handlerSize, handlerSize, 0x0, 0, true, 0xFF0000, false);
            GraphicsUtil.ClearAndDrawRect (flipBothHandler, -halfHandlerSize, -halfHandlerSize, handlerSize, handlerSize, 0x0, 0, true, 0x0000FF, false);
               GraphicsUtil.DrawLine (flipBothHandler, -halfHandlerSize, -halfHandlerSize, halfHandlerSize, halfHandlerSize, 0xFFFFFF, 0);
            GraphicsUtil.ClearAndDrawRect (flipOptionsHandler, -halfHandlerSize, -halfHandlerSize, handlerSize, handlerSize, 0x0, 0, true, 0xFF9900, false);
               GraphicsUtil.DrawLine (flipOptionsHandler, -halfHandlerSize, -halfHandlerSize, halfHandlerSize, halfHandlerSize, 0xFFFFFF, 0);
            flipBothHandler.rotation = 45;
            flipOptionsHandler.rotation = 45;
         }
         
         mScaleRotateFlipHandlersContainer.visible = isVisible;
         if (! isVisible)
            return;
         
         RepositionScaleRotateFlipHandlersContainer ();
         RepositionScaleRotateFlipHandlers (ScaleRotateFlipCircleRadius, 0);
      }
      
      protected function RepositionScaleRotateFlipHandlersContainer ():void
      {
         var centerX:Number = 0;
         var centerY:Number = 0;
         
         var selectedAssets:Array = mAssetManager.GetSelectedAssets ();
         var count:uint = selectedAssets.length;
         if (count == 0)
         {
            mScaleRotateFlipHandlersContainer.visible = false;
            return;
         }
         
         count = 0;
         for (var i:uint = 0; i < selectedAssets.length; ++ i)
         {
            var asset:Asset = selectedAssets[i] as Asset;
            
            if (asset != null)
            {
               centerX += asset.GetPositionX ();
               centerY += asset.GetPositionY ();
               ++ count;
            }
         }
         
         if (count == 0)
         {
            mScaleRotateFlipHandlersContainer.visible = false;
            return;
         }
         
         centerX /= count;
         centerY /= count;
         
         var panelPoint:Point = DisplayObjectUtil.LocalToLocal (mAssetManager, mForegroundLayer, new Point (centerX, centerY));
         
         mScaleRotateFlipHandlersContainer.x = panelPoint.x;
         mScaleRotateFlipHandlersContainer.y = panelPoint.y;
      }
      
      protected function RepositionScaleRotateFlipHandlers (radius:Number, rotationDegrees:Number):void
      {
         GraphicsUtil.ClearAndDrawCircle (mScaleRotateFlipHandlersContainer, 0, 0, radius, 0xC0FFC0, 5, false);
         var rotationRadians:Number = rotationDegrees * Math.PI / 180.0;
         var deltaRadians:Number = 0.25 * Math.PI;
         for (var i:int = 0; i < mScaleRotateFlipHandlersContainer.numChildren; ++ i)
         {
            var displayObject:DisplayObject = mScaleRotateFlipHandlersContainer.getChildAt (i);
            displayObject.x = radius * Math.cos (rotationRadians);
            displayObject.y = radius * Math.sin (rotationRadians);
            rotationRadians += deltaRadians;
         }
      }
      
      protected function OnStartRotateSelecteds(event:MouseEvent):void
      {
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, managerPoint.x, managerPoint.y, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartRotateSelectedSelves(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, managerPoint.x, managerPoint.y, false, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartRotateSelectedPositions(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentRotateSelectedAssets (this, managerPoint.x, managerPoint.y, true, false));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelecteds(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, managerPoint.x, managerPoint.y, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelectedSelves(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, managerPoint.x, managerPoint.y, false, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnStartScaleSelectedPositions(event:MouseEvent):void
      {  
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y));
         SetCurrentIntent (new IntentScaleSelectedAssets (this, managerPoint.x, managerPoint.y, true, false));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnFlipSelecteds(event:MouseEvent):void
      {
         var managerPoint:Point = ViewToManager (new Point (mScaleRotateFlipHandlersContainer.x, mScaleRotateFlipHandlersContainer.y + ScaleRotateFlipCircleRadius));
         SetCurrentIntent (new IntentFlipSelectedAssets (this, managerPoint.x, managerPoint.y, true, true));
         mCurrentIntent.OnMouseDown (mAssetManager.mouseX, mAssetManager.mouseY);
      }
      
      protected function OnFlipSelectedsOptions(event:MouseEvent):void
      {
      }
      
//=================================================================================
//   edit selected assets
//=================================================================================
      
      public function DeleteSelectedAssets ():void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.DeleteSelectedAssets ();
      }
      
      public function MoveSelectedAssets (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.MoveSelectedAssets (offsetX, offsetY, updateSelectionProxy);
      }
      
      public function RotateSelectedAssets (centerX:Number, centerY:Number, r:Number, rotatePosition:Boolean, rotateSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.RotateSelectedAssets (updateSelectionProxy, r, rotateSelf, rotatePosition, centerX, centerY);
      }
      
      public function ScaleSelectedAssets (centerX:Number, centerY:Number, s:Number, scalePosition:Boolean, scaleSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.ScaleSelectedAssets (updateSelectionProxy, s, scaleSelf, scalePosition, centerX, centerY);
      }
      
      public function FlipSelectedAssets (planeX:Number, flipPosition:Boolean, flipSelf:Boolean, updateSelectionProxy:Boolean):void
      {
         if (mAssetManager == null)
            return;
         
         mAssetManager.FlipSelectedAssets (updateSelectionProxy, flipSelf, flipPosition, planeX);
      }
      
      public function CreateOrBreakLink (startLinkable:Linkable, endManagerX:Number, endManagerY:Number):void
      {
         // ...
      }
      
   }
}
