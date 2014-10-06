package editor.entity.dialog {
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
   
   import flash.system.Capabilities;
   
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.MathUtil;
   
   import editor.world.Filters;
   
   import editor.asset.Asset;
   import editor.asset.AssetManagerPanel;
   import editor.asset.Linkable;
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   import editor.asset.IntentDrag;
   import editor.asset.IntentTaps;
   
   import editor.entity.Scene;
   import editor.entity.*;
   import editor.trigger.entity.*;
   
   import editor.trigger.CodeSnippet;
   
   import editor.display.sprite.EffectMessagePopup;
   import editor.display.sprite.EffectCrossingAiming;
   import editor.display.dialog.*;
   
   import editor.ccat.CollisionCategoryManager;
   
   import editor.EditorContext;
   
   import common.trigger.CoreEventIds;
   
   import common.ValueAdjuster;
   import common.ViewerDefine;
   import common.Define;
   import common.Version;
   
   public class SceneEditPanel extends AssetManagerPanel
   {  
      private var mScene:Scene = null;
      
      public function SceneEditPanel ()
      {
         super ();
      }
      
//============================================================================
//   
//============================================================================
      
      public function GetScene ():Scene
      {
         return mScene;
      }
      
      public function SetScene (scene:Scene):void
      {
         mScene = scene;
         
         super.SetAssetManager (scene);
         
         SetGridShown (mScene != null);
         
         if (mScene != null)
         {
            FocusManagerAtManagerPoint (mScene.GetCameraCenterX (), mScene.GetCameraCenterY ());
         }
      }
      
      private function FocusManagerAtManagerPoint (managerX:Number, managerY:Number):void
      {
         var panelPoint:Point = ManagerToPanel (new Point (managerX, managerY));
         MoveManager (0.5 * GetPanelWidth () - panelPoint.x, 0.5 * GetPanelHeight () - panelPoint.y);
      }
      
      override public function MoveManagerTo (managerPanelX:Number, managerPanelY:Number):void
      {
         // validate
                  
         if (! mScene.IsInfiniteSceneSize ())
         {
            var sceneLeft:Number   = mScene.GetWorldLeft ();
            var sceneTop:Number    = mScene.GetWorldTop ();
            var sceneWidth:Number  = mScene.GetWorldWidth ();
            var sceneHeight:Number = mScene.GetWorldHeight ();
            
            var topLeft:Point = ManagerToPanel (new Point (sceneLeft, sceneTop));
            var bottomRight:Point = ManagerToPanel (new Point (sceneLeft + sceneWidth, sceneTop + sceneHeight));
            
            var panelCenterX:Number = 0.5 * GetPanelWidth ();
            var panelCenterY:Number = 0.5 * GetPanelHeight ();
            
            var maxAllowedDx:Number = panelCenterX - topLeft.x;
            var minAllowedDx:Number = panelCenterX - bottomRight.x;
            var maxAllowedDy:Number = panelCenterY - topLeft.y;
            var minAllowedDy:Number = panelCenterY - bottomRight.y;
            
            var dx:Number = managerPanelX - mScene.GetPositionX ();
            var dy:Number = managerPanelY - mScene.GetPositionY ();
            
            if (dx < minAllowedDx)
               dx = minAllowedDx;
            else if (dx > maxAllowedDx)
               dx = maxAllowedDx;
            if (dy < minAllowedDy)
               dy = minAllowedDy;
            else if (dy > maxAllowedDy)
               dy = maxAllowedDy;
            
            managerPanelX = mScene.GetPositionX () + dx;
            managerPanelY = mScene.GetPositionY () + dy;
         }
         
         super.MoveManagerTo (managerPanelX, managerPanelY);

         var sceneCameraCenter:Point = PanelToManager (new Point (0.5 * GetPanelWidth (), 0.5 * GetPanelHeight ()));
         mScene.SetCameraCenterX (sceneCameraCenter.x);
         mScene.SetCameraCenterY (sceneCameraCenter.y);
      }
      
//============================================================================
//   
//============================================================================
      
      override protected function GetMaxAllowedScale ():Number
      {
         return ViewerDefine.MaxWorldZoomScale;
      }
      
      override protected function GetMinAllowedScale ():Number
      {
         return ViewerDefine.MinWorldZoomScale;
      }
      
      override protected function OnResize (event:Event):void 
      {
         super.OnResize (event);
         
         if (mScene != null)
            FocusManagerAtManagerPoint (mScene.GetCameraCenterX (), mScene.GetCameraCenterY ());
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mScene != null)
         {
            var sceneLeft  :Number;
            var sceneTop   :Number;
            var sceneWidth :Number;
            var sceneHeight:Number;
            
            if (mScene.IsInfiniteSceneSize ())
            {
               sceneLeft   = -1000000000; // about half of - 0x7FFFFFFF;
               sceneTop    = -1000000000; // about half of - 0x7FFFFFFF;
               sceneWidth  = 2000000000; // about half of uint (0xFFFFFFFF);
               sceneHeight = 2000000000; // about half of uint (0xFFFFFFFF);
            }
            else
            {
               sceneLeft   = mScene.GetWorldLeft ();
               sceneTop    = mScene.GetWorldTop ();
               sceneWidth  = mScene.GetWorldWidth ();
               sceneHeight = mScene.GetWorldHeight ();
            }
            
            UpdateGridSprite (true, 0xA0A0A0,
                              false, 
                              sceneLeft, sceneTop, sceneWidth, sceneHeight,
                              true, mScene.GetBackgroundColor (), 
                              mScene.IsBuildBorder (), mScene.GetBorderColor (), 
                              mScene.GetWorldBorderLeftThickness (), mScene.GetWorldBorderTopThickness (), mScene.GetWorldBorderRightThickness (), mScene.GetWorldBorderBottomThickness ()
                             );
         }
      }
      
      // return true to indicate handled successfully
      override protected function OnKeyDownInternal (keyCode:int, ctrlHold:Boolean, shiftHold:Boolean):Boolean
      {
         var handled:Boolean = true;
         
         switch (keyCode)
         {
            case Keyboard.ESCAPE:
               SetCurrentIntent (null);
               break;
            case Keyboard.SPACE:
               ShowEntitySettingsDialog ();
               break;
            case Keyboard.DELETE:
               if (ctrlHold)
                  DeleteSelectedControlPoints ();
               else
                  DeleteSelectedEntities ();
               break;
            case Keyboard.INSERT:
               if (ctrlHold) 
                  InsertControlPoint ();
               else
                  CloneSelectedEntities ();
               break;
            case 88: // X
               //if (ctrlHold)
                  AlignControlPointsVertically ();
               break;
            case 89: // Y
               //if (ctrlHold)
                  AlignControlPointsHorizontally ();
               break;
            case 67: // C
               if (ctrlHold)
                  handled = false;
               else
                  CloneSelectedEntities ();
               
               break;
            case 68: // D
               DeleteSelectedEntities ();
               break;
            case 187:// +
            case Keyboard.NUMPAD_ADD:
               if (ctrlHold)
                  AlignTextureCenterWithShapeCenter ();
               else
                  AlignCenterSelectedEntities ();
               break;
            case 189:// -
            case Keyboard.NUMPAD_SUBTRACT:
               RoundPositionForSelectedEntities ();
               break;
            case 75: // K
            case 190: // >
               if (ctrlHold && shiftHold)
                  ConvertOldRegisterVariablesToGlobalVariables ();
               break;
            case 78: // N
               SnapSelectedEnttiesToGrid ();
               break;
            /*
            case 66: // B
               if (ctrlHold && shiftHold)
                  SetCurrentIntent (new IntentPutAsset (CreateNewEventHandler (CoreEventIds.ID_OnSystemBack), OnPutCreating, OnCreatingCancelled));
               break;
            case 71: // G
               if (ctrlHold && shiftHold)
                  SetCurrentIntent (new IntentPutAsset (CreateNewEventHandler (CoreEventIds.ID_OnMouseGesture), OnPutCreating, OnCreatingCancelled));
               break;
            case 77: // M
               if (ctrlHold && shiftHold)
                  SetCurrentIntent (new IntentPutAsset (CreateNewEventHandler (CoreEventIds.ID_OnSequencedModuleLoopToEnd), OnPutCreating, OnCreatingCancelled));
               break;
            case 80: // P
               if (ctrlHold && shiftHold)
                  SetCurrentIntent (new IntentPutAsset (CreateNewEventHandler (CoreEventIds.ID_OnWorldBeforeRepainting), OnPutCreating, OnCreatingCancelled));
               break;
            case 87: // W
               if (ctrlHold && shiftHold)
                  SetCurrentIntent (new IntentPutAsset (CreateNewEventHandler (CoreEventIds.ID_OnMultiplePlayerInstanceInfoChanged), OnPutCreating, OnCreatingCancelled));
               break;
            */
            default:
            {
               handled = false;
               break;
            }
         }
         
         if (handled)
            return true;
         
         return super.OnKeyDownInternal (keyCode, ctrlHold, shiftHold);
      }
      
//=====================================================================
// context menu
//=====================================================================
      
      // used in panel and assets
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemSetGridCellSize:ContextMenuItem = new ContextMenuItem("Set Grid Cell Size ...", true);
         
         menuItemSetGridCellSize.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnSetGridCellSize);

         customMenuItemsStack.push (menuItemSetGridCellSize);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }

//=====================================================================
// undo point
//=====================================================================

      override public function CreateUndoPoint (undoPointName:String):void
      {
         //EditorContext.GetEditorApp ().CreateWorldSnapshot (undoPointName);
         EditorContext.GetEditorApp ().CreateSceneSnapshot (mScene, undoPointName);
      }

//============================================================================
//   
//============================================================================
      
      private var mOnEndCreatingEntityCallback:Function = null; // external callback passed by dialog
      
      public function OnStartCreatingEntity (entityType:String, params:Object, endCreatingCallback:Function):void
      {  
         SetCurrentIntent (null);
         
         if (mOnEndCreatingEntityCallback != null)
            OnCreatingCancelled ();
         
         if (entityType == null)
            return;
         
         CancelAllAssetSelections ();
         
         switch (entityType)
         {
            case "RectangleShape":
               var rectangle:EntityVectorShapeRectangle = mScene.CreateEntityVectorShapeRectangle (params.mAiType, true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingShape, OnCreatingCancelled));
               break;
            case "CircleShape":
               var circle:EntityVectorShapeCircle = mScene.CreateEntityVectorShapeCircle (params.mAiType, true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingShape, OnCreatingCancelled));
               break;
            case "PolygonShape":
               mScene.CreateEntityVectorShapePolygon (params.mAiType, true);
               SetCurrentIntent (new IntentTaps (this, OnCreatingShape, OnTapsCreatingShape, OnCreatingCancelled));
               break;
            case "PolylineShape":
               mScene.CreateEntityVectorShapePolyline (params.mAiType, true);
               SetCurrentIntent (new IntentTaps (this, OnCreatingShape, OnTapsCreatingShape, OnCreatingCancelled));
               break;
            case "HingeJoint":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityJointHinge (true), 
                                 OnPutCreatingOneAnchorJoint, OnCreatingCancelled));
               break;
            case "WeldJoint":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityJointWeld (true), 
                                 OnPutCreatingOneAnchorJoint, OnCreatingCancelled));
               break;
            case "SliderJoint":
               mScene.CreateEntityJointSlider (true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingTwoAnchorsJoint, OnCreatingCancelled));
               break;
               
            case "DistanceJoint":
               mScene.CreateEntityJointDistance (true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingTwoAnchorsJoint, OnCreatingCancelled));
               break;
            case "SpringJoint":
               mScene.CreateEntityJointSpring (true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingTwoAnchorsJoint, OnCreatingCancelled));
               break;
            case "DummyJoint":
               mScene.CreateEntityJointDummy (true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingTwoAnchorsJoint, OnCreatingCancelled));
               break;
               
            case "PowerSource":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityUtilityPowerSource (params.mPowerSourceType, true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "Camera":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityUtilityCamera (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "ForceField":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityVectorShapeGravityController (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "Text":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityVectorShapeText (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "TextButton":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityVectorShapeTextButton (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "ImageModule":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityShapeImageModule (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "ImageModuleButton":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityShapeImageModuleButton (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
               
            case "Action":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityAction (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "Task":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityTask(true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "Condition":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityCondition (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "ConditionDoor":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityConditionDoor (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "ManualSelector":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityInputEntityAssigner (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "ManualPairSelector":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityInputEntityPairAssigner (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "ScriptSelector":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityInputEntityScriptFilter (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "ScriptPairSelector":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityInputEntityPairScriptFilter (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
               
            case "EventHandler":
               SetCurrentIntent (new IntentPutAsset (CreateNewEventHandler (params.mDefaultEventId), OnPutCreating, OnCreatingCancelled));
               break;
            default:
               return;
         }
         
         mOnEndCreatingEntityCallback = endCreatingCallback;
      }
         
      private function CreateNewEventHandler (eventId:int):EntityEventHandler
      {
         var handler:EntityEventHandler;
         
         switch (eventId)
         {
            case CoreEventIds.ID_OnWorldTimer:
               handler = mScene.CreateEntityEventHandler_Timer (eventId, null, true);
               break;
            case CoreEventIds.ID_OnEntityTimer:
            case CoreEventIds.ID_OnEntityPairTimer:
               handler = mScene.CreateEntityEventHandler_TimerWithPrePostHandling (eventId, null, true);
               break;
            case CoreEventIds.ID_OnPhysicsShapeMouseRightDown:
            case CoreEventIds.ID_OnPhysicsShapeMouseRightUp:
            case CoreEventIds.ID_OnPhysicsShapeMouseDown:
            case CoreEventIds.ID_OnPhysicsShapeMouseUp:
            case CoreEventIds.ID_OnEntityMouseRightClick:
            case CoreEventIds.ID_OnEntityMouseRightDown:
            case CoreEventIds.ID_OnEntityMouseRightUp:
            case CoreEventIds.ID_OnEntityMouseDown:
            case CoreEventIds.ID_OnEntityMouseUp:
            case CoreEventIds.ID_OnEntityMouseClick:
            case CoreEventIds.ID_OnEntityMouseMove:
            case CoreEventIds.ID_OnEntityMouseEnter:
            case CoreEventIds.ID_OnEntityMouseOut:
            case CoreEventIds.ID_OnWorldMouseClick:
            case CoreEventIds.ID_OnWorldMouseDown:
            case CoreEventIds.ID_OnWorldMouseUp:
            case CoreEventIds.ID_OnWorldMouseRightClick:
            case CoreEventIds.ID_OnWorldMouseRightDown:
            case CoreEventIds.ID_OnWorldMouseRightUp:
            case CoreEventIds.ID_OnWorldMouseMove:
               handler = mScene.CreateEntityEventHandler_Mouse (eventId, null, true);
               break;
            case CoreEventIds.ID_OnWorldKeyDown:
            case CoreEventIds.ID_OnWorldKeyUp:
            case CoreEventIds.ID_OnWorldKeyHold:
               handler = mScene.CreateEntityEventHandler_Keyboard (eventId, null, true);
               break;
            case CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting:
            case CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting:
            case CoreEventIds.ID_OnTwoPhysicsShapesEndContacting:
               handler = mScene.CreateEntityEventHandler_Contact (eventId, null, true);
               break;
            case CoreEventIds.ID_OnJointReachLowerLimit:
            case CoreEventIds.ID_OnJointReachUpperLimit:
               handler = mScene.CreateEntityEventHandler_JointReachLimit (eventId, null, true);
               break;
            case CoreEventIds.ID_OnSequencedModuleLoopToEnd:
               handler = mScene.CreateEntityEventHandler_ModuleLoopToEnd (eventId, null, true);
               break;
            case CoreEventIds.ID_OnGameActivated:
            case CoreEventIds.ID_OnGameDeactivated:
               handler = mScene.CreateEntityEventHandler_GameLostOrGotFocus (eventId, null, true);
               break;
            case CoreEventIds.ID_OnMouseGesture:
               handler = mScene.CreateEntityEventHandler_MouseGesture (eventId, null, true);
               break;
            default:
            {
               handler = mScene.CreateEntityEventHandler (eventId, null, true);
               break;
            }
         }
         
         return handler;
      }
      
      private function TryToCallOnEndCreatingEntityCallback ():void
      {
         if (mOnEndCreatingEntityCallback != null)
         {
            mOnEndCreatingEntityCallback ();
            mOnEndCreatingEntityCallback = null;
         }
      }
      
//============================================================================
//   
//============================================================================
      
      private function OnCreatingFinished ():void
      {
         TryToCallOnEndCreatingEntityCallback ();
         
         OnAssetSelectionsChanged ();
         
         CreateUndoPoint ("Create new entity");
      }
      
      private function OnCreatingCancelled ():void
      {
         TryToCallOnEndCreatingEntityCallback ();
         
         DeleteSelectedAssets ();
         OnAssetSelectionsChanged ();
      }
      
      protected function OnDragCreatingShape (startX:Number, startY:Number, endX:Number, endY:Number, done:Boolean):void
      {
         var points:Array = new Array (2);
         points [0] = new Point (startX, startY);
         points [1] = new Point (endX, endY);
         
         OnCreatingShape (points, done);
      }
      
      protected function OnTapsCreatingShape (points:Array, currentX:Number, currentY:Number, isHoldMouse:Boolean):void
      {
         points.push (new Point (currentX, currentY));
         
         OnCreatingShape (points, false);
      }
      
      protected function OnCreatingShape (points:Array, done:Boolean):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         if (selectedEntities == null || selectedEntities.length != 1)
         {
            OnCreatingCancelled ();
            return;
         }
         
         var vectorShapeEntity:EntityVectorShape = selectedEntities [0] as EntityVectorShape;
         if (vectorShapeEntity == null)
         {
            OnCreatingCancelled ();
            return;
         }
         
         var pos:Point = vectorShapeEntity.OnCreating (points);
         if (pos != null)
            vectorShapeEntity.SetPosition (pos.x, pos.y);
         
         if (done)
         {
            if (vectorShapeEntity.IsValid ())
            {
               vectorShapeEntity.UpdateSelectionProxy ();
               
               OnCreatingFinished ();
            }
            else
            {
               OnCreatingCancelled ();
            }
         }
         
         vectorShapeEntity.UpdateAppearance ();
      }
      
      protected function OnDragCreatingTwoAnchorsJoint (startX:Number, startY:Number, endX:Number, endY:Number, done:Boolean):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         if (selectedEntities == null || selectedEntities.length != 1)
         {
            OnCreatingCancelled ();
            return;
         }
         
         var joint:EntityJoint = selectedEntities [0] as EntityJoint;
         if (joint is EntityJointSlider)
         {
            (joint as EntityJointSlider).GetAnchor1 ().MoveTo (startX, startY);
            (joint as EntityJointSlider).GetAnchor2 ().MoveTo (endX, endY);
            if (done)
            {
               (joint as EntityJointSlider).GetAnchor1 ().OnTransformIntentDone ();
               (joint as EntityJointSlider).GetAnchor2 ().OnTransformIntentDone ();
               mScene.SetSelectedAsset  ((joint as EntityJointSlider).GetAnchor2 ());
               //mScene.AddAssetSelection ((joint as EntityJointSlider).GetAnchor1 ());
            }
         }
         else if (joint is EntityJointDistance)
         {
            (joint as EntityJointDistance).GetAnchor1 ().MoveTo (startX, startY);
            (joint as EntityJointDistance).GetAnchor2 ().MoveTo (endX, endY);
            if (done)
            {
               (joint as EntityJointDistance).GetAnchor1 ().OnTransformIntentDone ();
               (joint as EntityJointDistance).GetAnchor2 ().OnTransformIntentDone ();
               mScene.SetSelectedAsset  ((joint as EntityJointDistance).GetAnchor2 ());
               //mScene.AddAssetSelection ((joint as EntityJointDistance).GetAnchor1 ());
            }
         }
         else if (joint is EntityJointSpring)
         {
            (joint as EntityJointSpring).GetAnchor1 ().MoveTo (startX, startY);
            (joint as EntityJointSpring).GetAnchor2 ().MoveTo (endX, endY);
            if (done)
            {
               (joint as EntityJointSpring).GetAnchor1 ().OnTransformIntentDone ();
               (joint as EntityJointSpring).GetAnchor2 ().OnTransformIntentDone ();
               mScene.SetSelectedAsset  ((joint as EntityJointSpring).GetAnchor2 ());
               //mScene.AddAssetSelection ((joint as EntityJointSpring).GetAnchor1 ());
            }
         }
         else if (joint is EntityJointDummy)
         {
            (joint as EntityJointDummy).GetAnchor1 ().MoveTo (startX, startY);
            (joint as EntityJointDummy).GetAnchor2 ().MoveTo (endX, endY);
            if (done)
            {
               (joint as EntityJointDummy).GetAnchor1 ().OnTransformIntentDone ();
               (joint as EntityJointDummy).GetAnchor2 ().OnTransformIntentDone ();
               mScene.SetSelectedAsset  ((joint as EntityJointDummy).GetAnchor2 ());
               //mScene.AddAssetSelection ((joint as EntityJointDummy).GetAnchor1 ());
            }
         }
         else
         {
            OnCreatingCancelled ();
            return;
         }
         
         if (done)
         {
            OnCreatingFinished ();
         }
      }
      
      protected function OnPutCreating (asset:Asset, done:Boolean):void
      {
         if (done)
         {
            OnCreatingFinished ();
         }
      }
      
      protected function OnPutCreatingOneAnchorJoint (asset:Asset, done:Boolean):void
      {
         if (asset is EntityJointHinge)
         {
            (asset as EntityJointHinge).GetAnchor ().MoveTo (asset.GetPositionX (), asset.GetPositionY ());
            if (done)
            {
               (asset as EntityJointHinge).GetAnchor ().OnTransformIntentDone ();
               mScene.SetSelectedAsset ((asset as EntityJointHinge).GetAnchor ());
            }
         }
         else if (asset is EntityJointWeld)
         {
            (asset as EntityJointWeld).GetAnchor ().MoveTo (asset.GetPositionX (), asset.GetPositionY ());
            if (done)
            {
               (asset as EntityJointWeld).GetAnchor ().OnTransformIntentDone ();
               mScene.SetSelectedAsset ((asset as EntityJointWeld).GetAnchor ());
            }
         }
         
         OnPutCreating (asset, done);
      }
      
//============================================================================
//   for playing
//============================================================================
      
      //private var mMaskPlayerField:Boolean = false;
      //
      //public function IsMaskPlayerField ():Boolean
      //{
      //   return mMaskPlayerField;
      //}
      //
      //public function SetMaskPlayerField (mask:Boolean):void
      //{
      //   mMaskPlayerField = mask;
      //}
      
//============================================================================
//   
//============================================================================
      
      private var mDialogCallbacks:Object = null; // must not be null
      
      public function SetDialogCallbacks (callbacks:Object):void
      {
         mDialogCallbacks = callbacks;
      }
      
      override protected function OnMousePositionChanged ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.SetMousePosition == null)
            return;
         
         if (mScene == null)
         {
            mDialogCallbacks.SetMousePosition (null);
            return;
         }
         
         var mousePositionInfo:Object = new Object ();
         mousePositionInfo.mPixelX = mScene.mouseX;
         mousePositionInfo.mPixelY = mScene.mouseY;
         mousePositionInfo.mPhysicsX = mScene.GetCoordinateSystem ().D2P_PositionX (mScene.mouseX);
         mousePositionInfo.mPhysicsY = mScene.GetCoordinateSystem ().D2P_PositionY (mScene.mouseY);
         
         mDialogCallbacks.SetMousePosition (mousePositionInfo);
      }
      
      override protected function OnManagerScaleChanged ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.SetCurrentSceneScale == null)
            return;
         
         mDialogCallbacks.SetCurrentSceneScale (mScene == null ? 1.0 : mScene.GetZoomScale ());
      }
      
      override public function UpdateInterface ():void
      {
         if (mDialogCallbacks == null || mDialogCallbacks.UpdateInterface == null)
            return;
         
         if (mScene == null)
         {
            mDialogCallbacks.UpdateInterface (null);
            return;
         }
         
         var selectionsInfo:Object = new Object ();
         
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         
         var numEntities:int = 0;
            var numShapes:int = 0;
               var numAreaShapes:int = 0;
                  var numCircles:int = 0;
                  var numRectanges:int = 0;
                  var numPolylines:int = 0;
            var numJoints:int = 0;
         
         var entity:Entity;
         for (var j:int = 0; j < selectedEntities.length; ++ j)
         {
            entity = selectedEntities [j] as Entity;
            //if (entity != null)
            //{
               ++ numEntities;
               
               //if (entity is EntityVectorShape)
               if (entity is EntityShape)
               {
                  ++ numShapes;
                  
                  if (entity is EntityVectorShapeCircle)
                  {
                     ++ numCircles;
                     ++ numAreaShapes;
                  }
                  else if (entity is EntityVectorShapeRectangle)
                  {
                     ++ numRectanges;
                     ++ numAreaShapes;
                  }
                  else if (entity is EntityVectorShapePolygon)
                  {
                     ++ numAreaShapes;
                  }
                  else if (entity is EntityVectorShapePolyline)
                  {
                     ++ numPolylines;
                  }
               }
               else if (entity is SubEntityJointAnchor)
               {
                  ++ numJoints;
               }
            //}
         }
         
         selectionsInfo.mNumSelectedEntities = numEntities;
         selectionsInfo.mNumSelectedJoints = numJoints;
         selectionsInfo.mNumSelectedShapes = numShapes;
         selectionsInfo.mNumSelectedAreaShapes = numAreaShapes;
         selectionsInfo.mNumSelectedCircleShapes = numCircles;
         selectionsInfo.mNumSelectedRectangleShapes = numRectanges;
         selectionsInfo.mNumSelectedPolylineShapes = numPolylines;
         
         if (selectedEntities.length == 0)
            selectionsInfo.mSelectedEntitiesInfos = "";
         else if (selectedEntities.length == 1)
         {
            entity = selectedEntities [0] as Entity;
            selectionsInfo.mSelectedEntitiesInfos = "<" + entity.GetCreationOrderId () + "> " + entity.GetTypeName () + ": "+ entity.GetInfoText ();
         }
         else
            selectionsInfo.mSelectedEntitiesInfos = selectedEntities.length + " entities are selected.";
         
         mDialogCallbacks.UpdateInterface (selectionsInfo);
      }
      
      private var mMaskFieldInPlaying:Boolean = false;
      
      public function IsMaskFieldInPlaying ():Boolean
      {
         return mMaskFieldInPlaying;
      }
      
      public function SetMaskFieldInPlaying (mask:Boolean):void
      {
         mMaskFieldInPlaying = mask; 
      }
      
      public function ResetScene ():void
      {
         mScene.DestroyAllAssets ();
         
         OnAssetSelectionsChanged ();
          
         CreateUndoPoint ("Reset Scene");
      }
      
      public function ClearAllEntities ():void
      {
         mScene.DestroyAllEntities ();
         
         OnAssetSelectionsChanged ();
          
         CreateUndoPoint ("Clear Entities");
      }

      public function ShowLevelRulesEditDialog ():void
      {
         var info:Object = new Object ();
         
         info.mIsPauseOnFocusLost = mScene.IsPauseOnFocusLost ();
         info.mIsCiRulesEnabled = mScene.IsCiRulesEnabled ();
         info.mRemovePinksOnMouseDown = mScene.IsRemovePinksOnMouseDown ();
         info.mSupportMoreMouseEvents = mScene.IsSupportMoreMouseEvents ();
         
         EditorContext.OpenSettingsDialog (WorldLevelRulesSettingDialog, SetLevelRulesInfo, info);
      }
      
      private function SetLevelRulesInfo (info:Object):void
      {  
         mScene.SetPauseOnFocusLost (info.mIsPauseOnFocusLost);
         mScene.SetCiRulesEnabled (info.mIsCiRulesEnabled);
         mScene.SetRemovePinksOnMouseDown (info.mRemovePinksOnMouseDown);
         mScene.SetSupportMoreMouseEvents (info.mSupportMoreMouseEvents);
         
         CreateUndoPoint ("World rules are changed");
      }

      public function ShowLevelPhysicsEditDialog ():void
      {
         var info:Object = new Object ();
         
         info.mPreferredFPS = mScene.GetPreferredFPS ();
         info.mPhysicsSimulationEnabled = mScene.IsPhysicsSimulationEnabled ();
         info.mPhysicsSimulationStepTimeLength = mScene.GetPhysicsSimulationStepTimeLength ();
         info.mVelocityIterations = mScene.GetPhysicsSimulationVelocityIterations ();
         info.mPositionIterations = mScene.GetPhysicsSimulationPositionIterations ();
         info.mCheckTimeOfImpact = mScene.IsCheckTimeOfImpact ();
         info.mInitialSpeedX = mScene.GetInitialSpeedX ();
         info.mAutoSleepingEnabled = mScene.IsAutoSleepingEnabled ();
         info.mDefaultGravityAccelerationMagnitude = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (mScene.GetDefaultGravityAccelerationMagnitude ()), 6);
         info.mDefaultGravityAccelerationAngle = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_RotationDegrees (mScene.GetDefaultGravityAccelerationAngle ()), 6);
         
         EditorContext.OpenSettingsDialog (WorldPhysicsSettingDialog, SetLevelPhysicsProperties, info);
      }
      
      private function SetLevelPhysicsProperties (info:Object):void
      {
         mScene.SetPreferredFPS (info.mPreferredFPS);
         mScene.SetPhysicsSimulationEnabled (info.mPhysicsSimulationEnabled);
         mScene.SetPhysicsSimulationStepTimeLength (info.mPhysicsSimulationStepTimeLength);
         mScene.SetPhysicsSimulationIterations (info.mVelocityIterations, info.mPositionIterations);
         mScene.SetCheckTimeOfImpact (info.mCheckTimeOfImpact);
         mScene.SetInitialSpeedX (info.mInitialSpeedX);
         mScene.SetAutoSleepingEnabled (info.mAutoSleepingEnabled);
         mScene.SetDefaultGravityAccelerationMagnitude (mScene.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (info.mDefaultGravityAccelerationMagnitude));
         mScene.SetDefaultGravityAccelerationAngle (mScene.GetCoordinateSystem ().P2D_RotationDegrees (info.mDefaultGravityAccelerationAngle));
         
         CreateUndoPoint ("World physics settings are changed");
      }

      public function ShowLevelCoordinateSystemEditDialog ():void
      {
         var info:Object = new Object ();
         
         info.mIsRightHand = mScene.GetCoordinateSystem ().IsRightHand ();
         info.mScale = mScene.GetCoordinateSystem ().GetScale ();
         info.mOriginX = mScene.GetCoordinateSystem ().GetOriginX ();
         info.mOroginY = mScene.GetCoordinateSystem ().GetOriginY ();
         
         EditorContext.OpenSettingsDialog (WorldCoordinateSystemSettingDialog, SetLevelCoordinateSystemInfo, info);
      }
      
      private function SetLevelCoordinateSystemInfo (info:Object):void
      {
         mScene.RebuildCoordinateSystem (
                  info.mOriginX,
                  info.mOroginY,
                  info.mScale,
                  info.mIsRightHand
               );
         
         CreateUndoPoint ("Coordinate system is modified");
      }

      public function ShowLevelAppearanceEditDialog ():void
      {
         var info:Object = new Object ();
         
         info.mIsInfiniteSceneSize = mScene.IsInfiniteSceneSize ();
         info.mWorldLeft = mScene.GetWorldLeft ();
         info.mWorldTop = mScene.GetWorldTop ();
         info.mWorldWidth = mScene.GetWorldWidth ();
         info.mWorldHeight = mScene.GetWorldHeight ();
         
         info.mBackgroundColor = mScene.GetBackgroundColor ();
         info.mBorderColor = mScene.GetBorderColor ();
         info.mIsBuildBorder = mScene.IsBuildBorder ();
         info.mIsBorderAtTopLayer = mScene.IsBorderAtTopLayer ();
         info.mWorldBorderLeftThickness = mScene.GetWorldBorderLeftThickness ();
         info.mWorldBorderTopThickness = mScene.GetWorldBorderTopThickness ();
         info.mWorldBorderRightThickness  = mScene.GetWorldBorderRightThickness ();
         info.mWorldBorderBottomThickness = mScene.GetWorldBorderBottomThickness ();
         
         info.mViewportWidth = mScene.GetViewportWidth ();
         info.mViewportHeight = mScene.GetViewportHeight ();
         
         EditorContext.OpenSettingsDialog (WorldAppearanceSettingDialog, SetLevelAppearanceInfo, info);
      }
      
      private function SetLevelAppearanceInfo (info:Object):void
      {
         mScene.SetInfiniteSceneSize (info.mIsInfiniteSceneSize);
         mScene.SetWorldLeft (info.mWorldLeft);
         mScene.SetWorldTop (info.mWorldTop);
         mScene.SetWorldWidth (info.mWorldWidth);
         mScene.SetWorldHeight (info.mWorldHeight);
         
         mScene.SetBackgroundColor (info.mBackgroundColor);
         mScene.SetBorderColor (info.mBorderColor);
         mScene.SetBuildBorder (info.mIsBuildBorder);
         mScene.SetBorderAtTopLayer (info.mIsBorderAtTopLayer);
         mScene.SetWorldBorderLeftThickness (info.mWorldBorderLeftThickness);
         mScene.SetWorldBorderTopThickness (info.mWorldBorderTopThickness);
         mScene.SetWorldBorderRightThickness (info.mWorldBorderRightThickness);
         mScene.SetWorldBorderBottomThickness (info.mWorldBorderBottomThickness);
         
         CreateUndoPoint ("World appearance is changed");
      }

      public function ShowLevelViewportEditDialog ():void
      {
         var info:Object = new Object ();
         
         info.mViewerUiFlags = mScene.GetViewerUiFlags ();
         info.mPlayBarColor = mScene.GetPlayBarColor ();
         
         info.mViewportWidth = mScene.GetViewportWidth ();
         info.mViewportHeight = mScene.GetViewportHeight ();
         
         info.mCameraRotatingEnabled = mScene.IsCameraRotatingEnabled ();
         
         EditorContext.OpenSettingsDialog (ViewportSettingDialog, SetLevelViewportInfo, info);
      }
      
      private function SetLevelViewportInfo (info:Object):void
      {
         mScene.SetViewerUiFlags (info.mViewerUiFlags);
         mScene.SetPlayBarColor (info.mPlayBarColor);
         
         mScene.SetViewportWidth (info.mViewportWidth);
         mScene.SetViewportHeight (info.mViewportHeight);
         
         mScene.SetCameraRotatingEnabled (info.mCameraRotatingEnabled);
         
         CreateUndoPoint ("World appearance is changed");
      }
      
      // find entity
      
      public function SearchEntitiesByIDs (entityIds:Array, addSelections:Boolean, selectBrothers:Boolean):void
      {
         if (! addSelections)
            CancelAllAssetSelections ();
         
         var numIds:int = entityIds.length;
         
         for (var i:int = 0; i < numIds; ++ i)
         {
            var entityId:int = entityIds [i] as int;
            
            if (entityId < 0 || entityId >= mScene.GetNumAssets ())
               continue;
            
            var entity:Entity = mScene.GetAssetByCreationId (entityId) as Entity;
            
            var posX:Number = entity.GetPositionX ();
            var posY:Number = entity.GetPositionY ();
            
            if (i == 0)
            {
               var viewPoint:Point = ManagerToPanel (new Point (posX, posY));
               if (viewPoint.x < 0 || viewPoint.x >= GetPanelWidth () || viewPoint.y < 0 || viewPoint.y >= GetPanelHeight ())
               {
                  FocusManagerAtManagerPoint (posX, posY);
               }
            }
            
            var selectableEntites:Array =  entity.GetSelectableAssets ();
            for each (var selectableEntity:Entity in selectableEntites)
            {
                mScene.AddAssetSelection (selectableEntity);
            }
            
            // aiming effect
            PushEditingEffect (new EffectCrossingAiming (entity));
         }
         
         if (numIds > 0)
         {
            OnAssetSelectionsChanged (! selectBrothers);
         }
      }
      
      // clone / delete
      
      public function CloneSelectedEntities ():void
      {
         if (mScene.GetNumSelectedAssets () > 0)
         {
            mScene.CloneSelectedEntities (Define.BodyCloneOffsetX, Define.BodyCloneOffsetY);
            
            OnAssetSelectionsChanged ();
            
            CreateUndoPoint ("Clone");
         }
      }
      
      public function DeleteSelectedEntities ():void
      {
         DeleteSelectedAssets ();
      }
      
      // move to top/bottom 
      
      public function MoveSelectedEntitiesToTop ():void
      {
         mScene.MoveSelectedAssetsToTop ();
         
         CreateUndoPoint ("Move entities to the most top layer");
      }
      
      public function MoveSelectedEntitiesToBottom ():void
      {
         mScene.MoveSelectedAssetsToBottom ();
         
         CreateUndoPoint ("Move entities to the most bottom layer");
      }
      
      // brothers
      
      public function MakeBrothers ():void
      {
         mScene.MakeSelectedAssetsBrothers ();
         
         CreateUndoPoint ("Make brothers");
      }
      
      public function BreakApartBrothers ():void
      {
         mScene.BreakBrothersApartBwtweenSelectedAssets ();
         
         CreateUndoPoint ("Break brothers");
      }
      
      // entity settings
      
      private function RetrieveShapePhysicsProperties (shape:EntityShape, values:Object):void
      {        
         values.mCollisionCategoryIndex = shape.GetCollisionCategoryIndex ();
         values.mCollisionCategoryListDataProvider = mScene.GetCollisionCategoryManager ().GetCollisionCategoryListDataProvider (false, false);
         values.mCollisionCategoryListSelectedIndex = CollisionCategoryManager.CollisionCategoryIndex2SelectListSelectedIndex (false, shape.GetCollisionCategoryIndex (), values.mCollisionCategoryListDataProvider);
         
         values.mIsPhysicsEnabled = shape.IsPhysicsEnabled ();
         values.mIsSensor = shape.mIsSensor;
         values.mIsStatic = shape.IsStatic ();
         values.mIsBullet = shape.mIsBullet;
         values.mIsHollow = shape.IsHollow ();
         values.mBuildBorder = shape.IsBuildBorder ();
         values.mDensity = ValueAdjuster.Number2Precision (shape.mDensity, 6);
         values.mFriction = ValueAdjuster.Number2Precision (shape.mFriction, 6);
         values.mRestitution = ValueAdjuster.Number2Precision (shape.mRestitution, 6);
         
         values.mLinearVelocityMagnitude = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (shape.GetLinearVelocityMagnitude ()), 6);
         values.mLinearVelocityAngle = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_RotationDegrees (shape.GetLinearVelocityAngle ()), 6);
         values.mAngularVelocity = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_AngularVelocity (shape.GetAngularVelocity ()), 6);
         values.mLinearDamping = ValueAdjuster.Number2Precision (shape.GetLinearDamping (), 6);
         values.mAngularDamping = ValueAdjuster.Number2Precision (shape.GetAngularDamping (), 6);
         values.mAllowSleeping = shape.IsAllowSleeping ();
         values.mFixRotation = shape.IsFixRotation ();
      }
      
      public function ShowEntitySettingsDialog ():void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         //...
         
         var values:Object = new Object ();
         
         values.mPosX = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_PositionX (entity.GetPositionX ()), 12);
         values.mPosY = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_PositionY (entity.GetPositionY ()), 12);
         values.mAngle = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_RotationRadians (entity.GetRotation ()) * Define.kRadians2Degrees, 6);
         values.mScale = ValueAdjuster.Number2Precision (entity.GetScale (), 6);
         values.mIsFlipped = entity.IsFlipped ();
         
         values.mIsVisible = entity.IsVisible ();
         values.mAlpha = entity.GetAlpha ();
         values.mIsEnabled = entity.IsEnabled ();
         
         if (entity is EntityLogic)
         {
            if (entity is EntityEventHandler)
            {
               var event_handler:EntityEventHandler = entity as EntityEventHandler;
               event_handler.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeLibManager = mScene.GetCodeLibManager ();
               values.mCodeSnippetName = event_handler.GetCodeSnippetName ();
               values.mEventId = event_handler.GetEventId ();
               values.mCodeSnippet  = event_handler.GetCodeSnippet ().Clone (mScene, true, null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mScene.GetCoordinateSystem ());
               
               if (entity is EntityEventHandler_Timer)
               {
                  var timer_event_handler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
                  
                  values.mRunningInterval = timer_event_handler.GetRunningInterval ();
                  values.mOnlyRunOnce = timer_event_handler.IsOnlyRunOnce ();
                  
                  if (entity is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timer_event_handler_withPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = entity as EntityEventHandler_TimerWithPrePostHandling;
                     
                     values.mPreCodeSnippet  = timer_event_handler_withPrePostHandling.GetPreCodeSnippet  ().Clone (mScene, true, null);
                     values.mPostCodeSnippet = timer_event_handler_withPrePostHandling.GetPostCodeSnippet ().Clone (mScene, true, null);
                     
                     EditorContext.OpenSettingsDialog (LogicTimerEventHandlerWithPrePostHandlingEditDialog, ConfirmSettingEntityProperties, values);
                  }
                  else
                  {
                     EditorContext.OpenSettingsDialog (LogicTimerEventHandlerEditDialog, ConfirmSettingEntityProperties, values);
                  }
               }
               else if (entity is EntityEventHandler_Keyboard)
               {
                  var keyboard_event_handler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
                  
                  values.mKeyCodes = keyboard_event_handler.GetKeyCodes ();
                  
                  EditorContext.OpenSettingsDialog (LogicKeyboardEventHandlerEditDialog, ConfirmSettingEntityProperties, values);
               }
               else if (entity is EntityEventHandler_MouseGesture)
               {
                  var gesture_event_handler:EntityEventHandler_MouseGesture = entity as EntityEventHandler_MouseGesture;
                  
                  values.mGestureIDs = gesture_event_handler.GetGestureIDs ();
                  
                  EditorContext.OpenSettingsDialog (LogicGestureEventHandlerEditDialog, ConfirmSettingEntityProperties, values);
               }
               else if (entity is EntityEventHandler_Mouse)
               {
                  EditorContext.OpenSettingsDialog (LogicMouseEventHandlerEditDialog, ConfirmSettingEntityProperties, values);
               }
               else if (entity is EntityEventHandler_Contact)
               {
                  EditorContext.OpenSettingsDialog (LogicShapeContactEventHandlerEditDialog, ConfirmSettingEntityProperties, values);
               }
               else if (entity is EntityEventHandler_JointReachLimit)
               {
                  EditorContext.OpenSettingsDialog (LogicJointReachLimitEventHandlerEditDialog, ConfirmSettingEntityProperties, values);
               }
               else if (entity is EntityEventHandler_GameLostOrGotFocus)
               {
                  EditorContext.OpenSettingsDialog (LogicGameLostOrGotFocusEventHandlerEditDialog, ConfirmSettingEntityProperties, values);
               }
               //else if (entity is EntityEventHandler_ModuleLoopToEnd)
               else
               {
                  EditorContext.OpenSettingsDialog (LogicEventHandlerEditDialog, ConfirmSettingEntityProperties, values);
               }
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               condition.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeLibManager = mScene.GetCodeLibManager ();
               values.mCodeSnippetName = condition.GetCodeSnippetName ();
               values.mCodeSnippet  = condition.GetCodeSnippet ().Clone (mScene, true, null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mScene.GetCoordinateSystem ());
               
               EditorContext.OpenSettingsDialog (LogicConditionEditDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               action.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeLibManager = mScene.GetCodeLibManager ();
               values.mCodeSnippetName = action.GetCodeSnippetName ();
               values.mCodeSnippet  = action.GetCodeSnippet ().Clone (mScene, true, null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mScene.GetCoordinateSystem ());
               
               EditorContext.OpenSettingsDialog (LogicActionEditDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityInputEntityScriptFilter)
            {
               var entityFilter:EntityInputEntityScriptFilter = entity as EntityInputEntityScriptFilter;
               
               values.mCodeLibManager = mScene.GetCodeLibManager ();
               values.mCodeSnippetName = entityFilter.GetCodeSnippetName ();
               values.mCodeSnippet  = entityFilter.GetCodeSnippet ().Clone (mScene, true, null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mScene.GetCoordinateSystem ());
               
               EditorContext.OpenSettingsDialog (LogicEntityFilterEditDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityInputEntityPairScriptFilter)
            {
               var pairFilter:EntityInputEntityPairScriptFilter = entity as EntityInputEntityPairScriptFilter;
               
               values.mCodeLibManager = mScene.GetCodeLibManager ();
               values.mCodeSnippetName = pairFilter.GetCodeSnippetName ();
               values.mCodeSnippet  = pairFilter.GetCodeSnippet ().Clone (mScene, true, null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mScene.GetCoordinateSystem ());
               
               EditorContext.OpenSettingsDialog (LogicEntityPairFilterEditDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityConditionDoor)
            {
               EditorContext.OpenSettingsDialog (LogicConditionDoorEditDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityTask)
            {
               EditorContext.OpenSettingsDialog (LogicTaskEditDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityInputEntityAssigner)
            {
               EditorContext.OpenSettingsDialog (LogicEntityAssignerEditDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityInputEntityPairAssigner)
            {
               EditorContext.OpenSettingsDialog (LogicEntityPairAssignerEditDialog, ConfirmSettingEntityProperties, values);
            }
         }
         else if (entity is EntityVectorShape)
         {
            var vectorShape:EntityVectorShape = entity as EntityVectorShape;
            
            values.mDrawBorder = vectorShape.IsDrawBorder ();
            values.mDrawBackground = vectorShape.IsDrawBackground ();
            values.mBorderColor = vectorShape.GetBorderColor ();
            values.mBorderThickness = vectorShape.GetBorderThickness ();
            values.mBackgroundColor = vectorShape.GetFilledColor ();
            values.mTransparency = vectorShape.GetTransparency ();
            values.mBorderTransparency = vectorShape.GetBorderTransparency ();
            
            values.mBodyTextureModule = vectorShape.GetBodyTextureModule ();
            
            values.mAiType = vectorShape.GetAiType ();
            
            if (vectorShape.IsBasicVectorShapeEntity ())
            {
               RetrieveShapePhysicsProperties (vectorShape, values);
               
               //values.mVisibleEditable = true; //vectorShape.GetFilledColor () == Define.ColorStaticObject;
               //values.mStaticEditable = true; //vectorShape.GetFilledColor () == Define.ColorBreakableObject
               //                             || vectorShape.GetFilledColor () == Define.ColorBombObject
               //                      ;
               if (entity is EntityVectorShapeCircle)
               {
                  //values.mRadius = (entity as EntityVectorShapeCircle).GetRadius();
                  values.mRadius = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_Length ((entity as EntityVectorShapeCircle).GetRadius()), 6);
                  
                  values.mAppearanceType = (entity as EntityVectorShapeCircle).GetAppearanceType();
                  values.mAppearanceTypeListSelectedIndex = (entity as EntityVectorShapeCircle).GetAppearanceType();
                  
                  if (Define.IsBombShape (values.mAiType))
                     EditorContext.OpenSettingsDialog (ShapeCircleBombSettingDialog, ConfirmSettingEntityProperties, values);
                  else
                     EditorContext.OpenSettingsDialog (ShapeCircleSettingDialog, ConfirmSettingEntityProperties, values);
               }
               else if (entity is EntityVectorShapeRectangle)
               {
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mScene.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mScene.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfHeight ()), 6);
                  //values.mIsRoundCorners = (vectorShape as EntityVectorShapeRectangle).IsRoundCorners ();
                  values.mIsRoundJoint = (vectorShape as EntityVectorShapeRectangle).IsRoundJoint ();
                  
                  values.mIsRoundCorner = (vectorShape as EntityVectorShapeRectangle).IsRoundCorner ();
                  values.mCornerEclipseWidth = (vectorShape as EntityVectorShapeRectangle).GetCornerEclipseWidth ();
                  values.mCornerEclipseHeight = (vectorShape as EntityVectorShapeRectangle).GetCornerEclipseHeight ();
                  
                  if (Define.IsBombShape (values.mAiType))
                     EditorContext.OpenSettingsDialog (ShapeRectangleBombSettingDialog, ConfirmSettingEntityProperties, values);
                  else
                     EditorContext.OpenSettingsDialog (ShapeRectangleSettingDialog, ConfirmSettingEntityProperties, values);
               }
               else if (entity is EntityVectorShapePolygon)
               {
                  EditorContext.OpenSettingsDialog (ShapePolygonSettingDialog, ConfirmSettingEntityProperties, values);
               }
               else if (entity is EntityVectorShapePolyline)
               {
                  values.mCurveThickness = (vectorShape as EntityVectorShapePolyline).GetCurveThickness ();
                  values.mIsRoundEnds = (vectorShape as EntityVectorShapePolyline).IsRoundEnds ();
                  values.mIsClosed = (vectorShape as EntityVectorShapePolyline).IsClosed ();
                  
                  EditorContext.OpenSettingsDialog (ShapePolylineSettingDialog, ConfirmSettingEntityProperties, values);
               }
            }
            else // no physics entity
            {
               if (entity is EntityVectorShapeText)
               {
                  values.mText = (vectorShape as EntityVectorShapeText).GetText ();
                  
                  values.mTextColor = (vectorShape as EntityVectorShapeText).GetTextColor ();
                  values.mFontSize = (vectorShape as EntityVectorShapeText).GetFontSize ();
                  values.mIsBold = (vectorShape as EntityVectorShapeText).IsBold ();
                  values.mIsItalic = (vectorShape as EntityVectorShapeText).IsItalic ();
                  
                  values.mIsUnderlined = (vectorShape as EntityVectorShapeText).IsUnderlined ();
                  values.mTextAlign = (vectorShape as EntityVectorShapeText).GetTextAlign ();
                  
                  values.mWordWrap = (vectorShape as EntityVectorShapeText).IsWordWrap ();
                  values.mEditable = (vectorShape as EntityVectorShapeText).IsEditable ();
                  values.mSelectable = (vectorShape as EntityVectorShapeText).IsSelectable ();
                  values.mWillRotate = ! (vectorShape as EntityVectorShapeText).IsDontAllowCreatedAsBitmap ();
                  values.mTextFormat = (vectorShape as EntityVectorShapeText).GetTextFormat ();
                  values.mAdaptiveBackgroundSize = (vectorShape as EntityVectorShapeText).IsAdaptiveBackgroundSize ();
                  values.mClipText = (vectorShape as EntityVectorShapeText).IsClipText ();
                  
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mScene.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mScene.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfHeight ()), 6);
                  
                  if (entity is EntityVectorShapeTextButton)
                  {
                     values.mUsingHandCursor = (vectorShape as EntityVectorShapeTextButton).UsingHandCursor ();
                     
                     var moveOverShape:EntityVectorShape = (vectorShape as EntityVectorShapeTextButton).GetMouseOverShape ();
                     values.mMouseOverValues = new Object ();
                     values.mMouseOverValues.mDrawBorder = moveOverShape.IsDrawBorder ();
                     values.mMouseOverValues.mDrawBackground = moveOverShape.IsDrawBackground ();
                     values.mMouseOverValues.mBorderColor = moveOverShape.GetBorderColor ();
                     values.mMouseOverValues.mBorderThickness = moveOverShape.GetBorderThickness ();
                     values.mMouseOverValues.mBackgroundColor = moveOverShape.GetFilledColor ();
                     values.mMouseOverValues.mTransparency = moveOverShape.GetTransparency ();
                     values.mMouseOverValues.mBorderTransparency = moveOverShape.GetBorderTransparency ();
                     
                     EditorContext.OpenSettingsDialog (ShapeTextButtonSettingDialog, ConfirmSettingEntityProperties, values);
                  }
                  else
                  {
                     EditorContext.OpenSettingsDialog (ShapeTextSettingDialog, ConfirmSettingEntityProperties, values);
                  }
               }
               else if (entity is EntityVectorShapeGravityController)
               {
                  values.mRadius = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_Length ((entity as EntityVectorShapeCircle).GetRadius()), 6);
                  
                  // removed from v1.05
                  /////values.mIsInteractive = (vectorShape as EntityVectorShapeGravityController).IsInteractive ();
                  values.mInteractiveZones = (vectorShape as EntityVectorShapeGravityController).GetInteractiveZones ();
                  
                  values.mInteractiveConditions = (vectorShape as EntityVectorShapeGravityController).mInteractiveConditions;
                  
                  values.mMaximalGravityAcceleration = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude ((vectorShape as EntityVectorShapeGravityController).GetMaximalGravityAcceleration ()), 6);
                  
                  values.mInitialGravityAcceleration = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude ((vectorShape as EntityVectorShapeGravityController).GetInitialGravityAcceleration ()), 6);
                  values.mInitialGravityAngle = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_RotationDegrees ((vectorShape as EntityVectorShapeGravityController).GetInitialGravityAngle ()), 6);
                  
                  EditorContext.OpenSettingsDialog (ShapeGravityControllerSettingDialog, ConfirmSettingEntityProperties, values);
               }
            }
         }
         else if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
            if (entity is EntityShapeImageModule)
            {
               RetrieveShapePhysicsProperties (shape, values);
               
               values.mModule = (entity as EntityShapeImageModule).GetAssetImageModule ();
               
               EditorContext.OpenSettingsDialog (ShapeImageModuleSettingDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityShapeImageModuleButton)
            {
               RetrieveShapePhysicsProperties (shape, values);
               
               values.mModuleUp = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseUp ();
               values.mModuleOver = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseOver ();
               values.mModuleDown = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseDown ();
               
               EditorContext.OpenSettingsDialog (ShapeImageModuleButtonSettingDialog, ConfirmSettingEntityProperties, values);
            }
         }
         else if (entity is SubEntityJointAnchor)
         {
            var jointAnchor:SubEntityJointAnchor = entity as SubEntityJointAnchor;
            var joint:EntityJoint = entity.GetMainAsset () as EntityJoint;
            
            var jointValues:Object = new Object ();
            values.mJointValues = jointValues;
            
            jointValues.mCollideConnected = joint.mCollideConnected;
            
            jointValues.mPosX = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_PositionX (joint.GetPositionX ()), 12);
            jointValues.mPosY = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_PositionY (joint.GetPositionY ()), 12);
            jointValues.mAngle = ValueAdjuster.Number2Precision (joint.GetRotation () * Define.kRadians2Degrees, 6);
            
            jointValues.mIsVisible = joint.IsVisible ();
            jointValues.mAlpha = joint.GetAlpha ();
            jointValues.mIsEnabled = joint.IsEnabled ();
            
            //>>from v1.02
            jointValues.mShapeListDataProvider = mScene.GetEntitySelectListDataProviderByFilter (Filters.IsPhysicsShapeEntity, true, "[Auto Select]");
            jointValues.mShapeList1SelectedIndex = Scene.EntityIndex2SelectListSelectedIndex (joint.GetConnectedShape1Index (), jointValues.mShapeListDataProvider);
            jointValues.mShapeList2SelectedIndex = Scene.EntityIndex2SelectListSelectedIndex (joint.GetConnectedShape2Index (), jointValues.mShapeListDataProvider);
            jointValues.mAnchorIndex = jointAnchor.GetAnchorIndex (); // hinge will modify it below
            //<<
            
            //from v1.08
            jointValues.mIsBreakable = joint.IsBreakable ();
            //<<
            
            if (entity is SubEntityHingeAnchor)
            {
               jointValues.mAnchorIndex = -1; // to make both shape select lists selectable
               
               var hinge:EntityJointHinge = joint as EntityJointHinge;
               var lowerAngle:Number = mScene.GetCoordinateSystem ().D2P_RotationDegrees (hinge.GetLowerLimit ());
               var upperAngle:Number = mScene.GetCoordinateSystem ().D2P_RotationDegrees (hinge.GetUpperLimit ());
               if (lowerAngle > upperAngle)
               {
                  var tempAngle:Number = lowerAngle;
                  lowerAngle = upperAngle;
                  upperAngle = tempAngle;
               }
               
               jointValues.mEnableLimit = hinge.IsLimitsEnabled ();
               jointValues.mLowerAngle = ValueAdjuster.Number2Precision (lowerAngle, 6);
               jointValues.mUpperAngle = ValueAdjuster.Number2Precision (upperAngle, 6);
               jointValues.mEnableMotor = hinge.mEnableMotor;
               jointValues.mMotorSpeed = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_RotationDegrees (hinge.mMotorSpeed), 6);
               jointValues.mBackAndForth = hinge.mBackAndForth;
               
               //>>from v1.04
               jointValues.mMaxMotorTorque = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_Torque (hinge.GetMaxMotorTorque ()), 6);
               //<<
               
               EditorContext.OpenSettingsDialog (JointHingeSettingDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is SubEntitySliderAnchor)
            {
               var slider:EntityJointSlider = joint as EntityJointSlider;
               
               jointValues.mEnableLimit = slider.IsLimitsEnabled ();
               jointValues.mLowerTranslation = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_Length (slider.GetLowerLimit ()), 6);
               jointValues.mUpperTranslation = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_Length (slider.GetUpperLimit ()), 6);
               jointValues.mEnableMotor = slider.mEnableMotor;
               jointValues.mMotorSpeed = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (slider.mMotorSpeed), 6);
               jointValues.mBackAndForth = slider.mBackAndForth;
               
               //>>from v1.04
               jointValues.mMaxMotorForce = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_ForceMagnitude (slider.GetMaxMotorForce ()), 6);
               //<<
               
               EditorContext.OpenSettingsDialog (JointSliderSettingDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is SubEntitySpringAnchor)
            {
               var spring:EntityJointSpring = joint as EntityJointSpring;
               
               jointValues.mStaticLengthRatio = ValueAdjuster.Number2Precision (spring.GetStaticLengthRatio (), 6);
               jointValues.mSpringType = spring.GetSpringType ();
               jointValues.mDampingRatio = ValueAdjuster.Number2Precision (spring.mDampingRatio, 6);
               
               //from v1.08
               jointValues.mFrequencyDeterminedManner = spring.GetFrequencyDeterminedManner ();
               jointValues.mFrequency = ValueAdjuster.Number2Precision (spring.GetFrequency (), 6);
               jointValues.mSpringConstant = ValueAdjuster.Number2Precision (spring.GetSpringConstant () * mScene.GetCoordinateSystem ().D2P_Length (1.0) / mScene.GetCoordinateSystem ().D2P_ForceMagnitude (1.0), 6);
               jointValues.mBreakExtendedLength = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_Length (spring.GetBreakExtendedLength ()), 6);
               //<<
               
               EditorContext.OpenSettingsDialog (JointSpringSettingDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = joint as EntityJointDistance;
               
               //from v1.08
               jointValues.mBreakDeltaLength = ValueAdjuster.Number2Precision (mScene.GetCoordinateSystem ().D2P_Length (distance.GetBreakDeltaLength ()), 6);
               //<<
               
               EditorContext.OpenSettingsDialog (JointDistanceSettingDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is SubEntityWeldAnchor)
            {
               jointValues.mAnchorIndex = -1; // to make both shape select lists selectable
               
               var weld:EntityJointWeld = joint as EntityJointWeld;
               
               EditorContext.OpenSettingsDialog (JointWeldSettingDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
               
               EditorContext.OpenSettingsDialog (JointDummySettingDialog, ConfirmSettingEntityProperties, values);
            }
         }
         else if (entity is EntityUtility)
         {
            var utility:EntityUtility = entity as EntityUtility;
            
            if (entity is EntityUtilityCamera)
            {
               var camera:EntityUtilityCamera = utility as EntityUtilityCamera;
               
               //from v1.08
               values.mFollowedTarget = camera.GetFollowedTarget ();
               values.mFollowingStyle = camera.GetFollowingStyle ();
               //<<
               
               EditorContext.OpenSettingsDialog (UtilityCameraSettingDialog, ConfirmSettingEntityProperties, values);
            }
            else if (entity is EntityUtilityPowerSource)
            {
               var powerSource:EntityUtilityPowerSource = entity as EntityUtilityPowerSource;
               
               values.mEventId = powerSource.GetKeyboardEventId ();
               values.mKeyCodes = powerSource.GetKeyCodes ();
               values.mPowerSourceType = powerSource.GetPowerSourceType ();
               values.mPowerMagnitude = powerSource.GetPowerMagnitude ();
               
               switch (powerSource.GetPowerSourceType ())
               {
                  case Define.PowerSource_Torque:
                     values.mPowerMagnitude = mScene.GetCoordinateSystem ().D2P_Torque (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Torque";
                     break;
                  case Define.PowerSource_LinearImpusle:
                     values.mPowerMagnitude = mScene.GetCoordinateSystem ().D2P_ImpulseMagnitude (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Linear Impulse";
                     break;
                  case Define.PowerSource_AngularImpulse:
                     values.mPowerMagnitude = mScene.GetCoordinateSystem ().D2P_AngularImpulse (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Impulse";
                     break;
                  case Define.PowerSource_AngularAcceleration:
                     values.mPowerMagnitude = mScene.GetCoordinateSystem ().D2P_AngularAcceleration (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Acceleration";
                     break;
                  case Define.PowerSource_AngularVelocity:
                     values.mPowerMagnitude = mScene.GetCoordinateSystem ().D2P_AngularVelocity (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Velocity";
                     break;
                  //case Define.PowerSource_LinearAcceleration:
                  //   values.mPowerMagnitude = mScene.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (values.mPowerMagnitude);
                  //   values.mPowerLabel = "Step Linear Acceleration";
                  //   break;
                  //case Define.PowerSource_LinearVelocity:
                  //   values.mPowerMagnitude = mScene.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (values.mPowerMagnitude);
                  //   values.mPowerLabel = "Step Linear Velocity";
                  //   break;
                  case Define.PowerSource_Force:
                  default:
                     values.mPowerMagnitude = mScene.GetCoordinateSystem ().D2P_ForceMagnitude (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Force";
                     break;
               }
               values.mPowerMagnitude = ValueAdjuster.Number2Precision (values.mPowerMagnitude, 6);
               
               EditorContext.OpenSettingsDialog (UtilityPowerSourceSettingDialog, ConfirmSettingEntityProperties, values);
            }
         }
      }
      
      private function UpdateShapePhysicsProperties (shape:EntityShape, params:Object):void
      {        
         shape.SetCollisionCategoryIndex (params.mCollisionCategoryIndex);
         
         shape.SetPhysicsEnabled (params.mIsPhysicsEnabled);
         shape.SetAsSensor (params.mIsSensor);
         shape.SetStatic (params.mIsStatic);
         shape.SetAsBullet (params.mIsBullet);
         shape.SetHollow (params.mIsHollow);
         shape.SetBuildBorder (params.mBuildBorder);
         shape.SetDensity (params.mDensity);
         shape.SetFriction (params.mFriction);
         shape.SetRestitution (params.mRestitution);
         
         if (params.mLinearVelocityMagnitude < 0)
         {
            params.mLinearVelocityMagnitude = -params.mLinearVelocityMagnitude;
            params.mLinearVelocityAngle = 360.0 - params.mLinearVelocityAngle;
         }
         shape.SetLinearVelocityMagnitude (mScene.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mLinearVelocityMagnitude));
         shape.SetLinearVelocityAngle (mScene.GetCoordinateSystem ().P2D_RotationDegrees (params.mLinearVelocityAngle));
         shape.SetAngularVelocity (mScene.GetCoordinateSystem ().P2D_AngularVelocity (params.mAngularVelocity));
         shape.SetLinearDamping (params. mLinearDamping);
         shape.SetAngularDamping (params.mAngularDamping);
         shape.SetAllowSleeping (params.mAllowSleeping);
         shape.SetFixRotation (params.mFixRotation);
      }
      
      private function ConfirmSettingEntityProperties (params:Object):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         if (selectedEntities == null || selectedEntities.length != 1)
            return;
         
         var entity:Entity = selectedEntities [0] as Entity;
         
         var newPosX:Number = mScene.GetCoordinateSystem ().P2D_PositionX (params.mPosX);
         var newPosY:Number = mScene.GetCoordinateSystem ().P2D_PositionY (params.mPosY);
         if (! mScene.IsInfiniteSceneSize ())
         {
            //todo: seems this is not essential
            newPosX = MathUtil.GetClipValue (newPosX, mScene.GetWorldLeft () - Define.WorldFieldMargin, mScene.GetWorldRight () + Define.WorldFieldMargin);
            newPosY = MathUtil.GetClipValue (newPosY, mScene.GetWorldTop () - Define.WorldFieldMargin, mScene.GetWorldBottom () + Define.WorldFieldMargin);
         }
         
         entity.SetPosition (newPosX, newPosY);
         entity.SetRotation (mScene.GetCoordinateSystem ().P2D_RotationRadians (params.mAngle * Define.kDegrees2Radians));
         entity.SetScale (params.mScale);
         entity.SetFlipped (params.mIsFlipped);
         entity.SetVisible (params.mIsVisible);
         entity.SetAlpha (params.mAlpha);
         entity.SetEnabled (params.mIsEnabled);
         
         if (entity is EntityLogic)
         {
            var logic:EntityLogic = entity as EntityLogic;
            
            var code_snippet:CodeSnippet;
            
            if (entity is EntityEventHandler)
            {
               var event_handler:EntityEventHandler = entity as EntityEventHandler;
               
               code_snippet = event_handler.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mScene.GetCoordinateSystem ());
               
               if (entity is EntityEventHandler_Timer)
               {
                  var timer_event_handler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
                  
                  timer_event_handler.SetRunningInterval (params.mRunningInterval);
                  timer_event_handler.SetOnlyRunOnce (params.mOnlyRunOnce);
                  
                  if (entity is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timer_event_handler_withPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = entity as EntityEventHandler_TimerWithPrePostHandling;
                     
                     var pre_code_snippet:CodeSnippet = timer_event_handler_withPrePostHandling.GetPreCodeSnippet ();
                     pre_code_snippet.AssignFunctionCallings (params.mReturnPreFunctionCallings);
                     pre_code_snippet.PhysicsValues2DisplayValues (mScene.GetCoordinateSystem ());
                     
                     var post_code_snippet:CodeSnippet = timer_event_handler_withPrePostHandling.GetPostCodeSnippet ();
                     post_code_snippet.AssignFunctionCallings (params.mReturnPostFunctionCallings);
                     post_code_snippet.PhysicsValues2DisplayValues (mScene.GetCoordinateSystem ());
                  }
               }
               else if (entity is EntityEventHandler_Keyboard)
               {
                  var keyboard_event_handler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
                  
                  //keyboard_event_handler.ChangeKeyboardEventId (params.mEventId);
                  keyboard_event_handler.SetKeyCodes (params.mKeyCodes);
               }
               else if (entity is EntityEventHandler_MouseGesture)
               {
                  var gesture_event_handler:EntityEventHandler_MouseGesture = entity as EntityEventHandler_MouseGesture;
                  
                  gesture_event_handler.SetGestureIDs (params.mGestureIDs);
               }
               else if (entity is EntityEventHandler_Mouse)
               {
                  var mouse_event_handler:EntityEventHandler_Mouse = entity as EntityEventHandler_Mouse;
                  
                  //mouse_event_handler.ChangeMouseEventId (params.mEventId);
               }
               else if (entity is EntityEventHandler_Contact)
               {
                  var contact_event_handler:EntityEventHandler_Contact = entity as EntityEventHandler_Contact;
                  
                  //contact_event_handler.ChangeContactEventId (params.mEventId);
               }
               else if (entity is EntityEventHandler_JointReachLimit)
               {
                   var jointReachLimit_event_handler:EntityEventHandler_JointReachLimit = entity as EntityEventHandler_JointReachLimit;
               }
               else if (entity is EntityEventHandler_GameLostOrGotFocus)
               {
                   var gameLostOrGotFocus_event_handler:EntityEventHandler_GameLostOrGotFocus = entity as EntityEventHandler_GameLostOrGotFocus;
               }
               else if (entity is EntityEventHandler_ModuleLoopToEnd)
               {
                  //
               }
               
               if (params.mEventId != event_handler.GetEventId ())
               {
                  event_handler.ChangeToIsomorphicEventId (params.mEventId);
               }
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               
               condition.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = condition.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mScene.GetCoordinateSystem ());
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               
               action.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = action.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mScene.GetCoordinateSystem ());
            }
            else if (entity is EntityInputEntityScriptFilter)
            {
               var entityFilter:EntityInputEntityScriptFilter = entity as EntityInputEntityScriptFilter;
               
               entityFilter.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = entityFilter.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mScene.GetCoordinateSystem ());
            }
            else if (entity is EntityInputEntityPairScriptFilter)
            {
               var pairFilter:EntityInputEntityPairScriptFilter = entity as EntityInputEntityPairScriptFilter;
               
               pairFilter.SetCodeSnippetName (params.mCodeSnippetName);
               
               code_snippet = pairFilter.GetCodeSnippet ();
               code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
               code_snippet.PhysicsValues2DisplayValues (mScene.GetCoordinateSystem ());
            }
            else if (entity is EntityConditionDoor)
            {
            }
            else if (entity is EntityTask)
            {
            }
            else if (entity is EntityInputEntityAssigner)
            {
            }
            else if (entity is EntityInputEntityPairAssigner)
            {
            }
            
            logic.UpdateAppearance ();
            logic.UpdateSelectionProxy ();
         }
         else if (entity is EntityVectorShape)
         {
            var vectorShape:EntityVectorShape = entity as EntityVectorShape;
            
            vectorShape.SetDrawBorder (params.mDrawBorder);
            vectorShape.SetTransparency (params.mTransparency);
            vectorShape.SetBorderColor (params.mBorderColor);
            vectorShape.SetBorderThickness (params.mBorderThickness);
            vectorShape.SetDrawBackground (params.mDrawBackground);
            vectorShape.SetFilledColor (params.mBackgroundColor);
            vectorShape.SetBorderTransparency (params.mBorderTransparency);
            
            vectorShape.SetBodyTextureModule (params.mBodyTextureModule);
            
            vectorShape.SetAiType (params.mAiType);

            if (vectorShape.IsBasicVectorShapeEntity ())
            {
               UpdateShapePhysicsProperties (vectorShape, params);
               
               if (entity is EntityVectorShapeCircle)
               {
                  (vectorShape as EntityVectorShapeCircle).SetRadius (mScene.GetCoordinateSystem ().P2D_Length (params.mRadius));
                  (vectorShape as EntityVectorShapeCircle).SetAppearanceType (params.mAppearanceType);
               }
               else if (entity is EntityVectorShapeRectangle)
               {
                  (vectorShape as EntityVectorShapeRectangle).SetHalfWidth (0.5 * mScene.GetCoordinateSystem ().P2D_Length (params.mWidth));
                  (vectorShape as EntityVectorShapeRectangle).SetHalfHeight (0.5 * mScene.GetCoordinateSystem ().P2D_Length (params.mHeight));
                  //(vectorShape as EntityVectorShapeRectangle).SetRoundCorners (params.mIsRoundCorners);
                  (vectorShape as EntityVectorShapeRectangle).SetRoundJoint (params.mIsRoundJoint);
                  
                  (vectorShape as EntityVectorShapeRectangle).SetRoundCorner (params.mIsRoundCorner);
                  (vectorShape as EntityVectorShapeRectangle).SetCornerEclipseWidth (params.mCornerEclipseWidth);
                  (vectorShape as EntityVectorShapeRectangle).SetCornerEclipseHeight (params.mCornerEclipseHeight);
               }
               else if (entity is EntityVectorShapePolygon)
               {
               }
               else if (entity is EntityVectorShapePolyline)
               {
                  (vectorShape as EntityVectorShapePolyline).SetCurveThickness (params.mCurveThickness);
                  (vectorShape as EntityVectorShapePolyline).SetRoundEnds (params.mIsRoundEnds);
                  (vectorShape as EntityVectorShapePolyline).SetClosed (params.mIsClosed);
               }
            }
            else // no physics entity
            {
               if (entity is EntityVectorShapeText)
               {
                  if (entity is EntityVectorShapeTextButton)
                  {
                     (vectorShape as EntityVectorShapeTextButton).SetUsingHandCursor (params.mUsingHandCursor);
                     
                     var moveOverShape:EntityVectorShape = (vectorShape as EntityVectorShapeTextButton).GetMouseOverShape ();
                     moveOverShape.SetDrawBorder (params.mMouseOverValues.mDrawBorder);
                     moveOverShape.SetTransparency (params.mMouseOverValues.mTransparency);
                     moveOverShape.SetDrawBorder (params.mMouseOverValues.mDrawBorder);
                     moveOverShape.SetBorderColor (params.mMouseOverValues.mBorderColor);
                     moveOverShape.SetBorderThickness (params.mMouseOverValues.mBorderThickness);
                     moveOverShape.SetDrawBackground (params.mMouseOverValues.mDrawBackground);
                     moveOverShape.SetFilledColor (params.mMouseOverValues.mBackgroundColor);
                     moveOverShape.SetBorderTransparency (params.mMouseOverValues.mBorderTransparency);
                   }
                  else
                  {
                  }
                  
                  (vectorShape as EntityVectorShapeText).SetWordWrap (params.mWordWrap);
                  (vectorShape as EntityVectorShapeText).SetEditable (params.mEditable);
                  (vectorShape as EntityVectorShapeText).SetSelectable (params.mSelectable);
                  (vectorShape as EntityVectorShapeText).SetDontAllowCreatedAsBitmap (! params.mWillRotate);
                  (vectorShape as EntityVectorShapeText).SetTextFormat (params.mTextFormat);
                  (vectorShape as EntityVectorShapeText).SetAdaptiveBackgroundSize (params.mAdaptiveBackgroundSize);
                  (vectorShape as EntityVectorShapeText).SetClipText (params.mClipText);
                  
                  (vectorShape as EntityVectorShapeText).SetUnderlined (params.mIsUnderlined);
                  (vectorShape as EntityVectorShapeText).SetTextAlign (params.mTextAlign);
                  
                  (vectorShape as EntityVectorShapeText).SetText (params.mText);
                  (vectorShape as EntityVectorShapeText).SetTextColor (params.mTextColor);
                  (vectorShape as EntityVectorShapeText).SetFontSize (params.mFontSize);
                  (vectorShape as EntityVectorShapeText).SetBold (params.mIsBold);
                  (vectorShape as EntityVectorShapeText).SetItalic (params.mIsItalic);
                  
                  (vectorShape as EntityVectorShapeRectangle).SetHalfWidth (0.5 * mScene.GetCoordinateSystem ().P2D_Length (params.mWidth));
                  (vectorShape as EntityVectorShapeRectangle).SetHalfHeight (0.5 * mScene.GetCoordinateSystem ().P2D_Length (params.mHeight));
               }
               else if (entity is EntityVectorShapeGravityController)
               {
                  (vectorShape as EntityVectorShapeCircle).SetRadius (mScene.GetCoordinateSystem ().P2D_Length (params.mRadius));
                  
                  //(vectorShape as EntityVectorShapeGravityController).SetInteractive (params.mIsInteractive);
                  (vectorShape as EntityVectorShapeGravityController).SetInteractiveZones (params.mInteractiveZones);
                  
                  (vectorShape as EntityVectorShapeGravityController).mInteractiveConditions = params.mInteractiveConditions;
                  
                  if (params.mInitialGravityAcceleration < 0)
                  {
                     params.mInitialGravityAcceleration = -params.mInitialGravityAcceleration;
                     params.mInitialGravityAngle = 360.0 - params.mInitialGravityAngle;
                  }
                  
                  (vectorShape as EntityVectorShapeGravityController).SetMaximalGravityAcceleration (mScene.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mMaximalGravityAcceleration));
                  (vectorShape as EntityVectorShapeGravityController).SetInitialGravityAcceleration (mScene.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mInitialGravityAcceleration));
                  (vectorShape as EntityVectorShapeGravityController).SetInitialGravityAngle (mScene.GetCoordinateSystem ().P2D_RotationDegrees (params.mInitialGravityAngle));
               }
            }
            
            vectorShape.UpdateAppearance ();
            vectorShape.UpdateSelectionProxy ();
         }
         else if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            
            if (entity is EntityShapeImageModule)
            {
               var moduleShape:EntityShapeImageModule = entity as EntityShapeImageModule;
               
               UpdateShapePhysicsProperties (moduleShape, params);
               
               moduleShape.SetAssetImageModule (params.mModule);
               
               moduleShape.UpdateAppearance ();
               moduleShape.UpdateSelectionProxy ();
            }
            else if (entity is EntityShapeImageModuleButton)
            {
               var moduleShapeButton:EntityShapeImageModuleButton = entity as EntityShapeImageModuleButton;
               
               UpdateShapePhysicsProperties (moduleShapeButton, params);
               
               moduleShapeButton.SetAssetImageModuleForMouseUp (params.mModuleUp);
               moduleShapeButton.SetAssetImageModuleForMouseOver (params.mModuleOver);
               moduleShapeButton.SetAssetImageModuleForMouseDown (params.mModuleDown);
               
               moduleShapeButton.UpdateAppearance ();
               moduleShapeButton.UpdateSelectionProxy ();
            }
         }
         else if (entity is SubEntityJointAnchor)
         {
            var jointAnchor:SubEntityJointAnchor = entity as SubEntityJointAnchor;
            var joint:EntityJoint = jointAnchor.GetMainAsset () as EntityJoint;
            
            var jointParams:Object = params.mJointValues;
            
            joint.mCollideConnected = jointParams.mCollideConnected;
            
            newPosX = mScene.GetCoordinateSystem ().P2D_PositionX (jointParams.mPosX);
            newPosY = mScene.GetCoordinateSystem ().P2D_PositionY (jointParams.mPosY);
            if (! mScene.IsInfiniteSceneSize ())
            {
               newPosX = MathUtil.GetClipValue (newPosX, mScene.GetWorldLeft (), mScene.GetWorldRight ());
               newPosY = MathUtil.GetClipValue (newPosY, mScene.GetWorldTop (), mScene.GetWorldBottom ());
            }
            joint.SetPosition (newPosX, newPosY);
            joint.SetRotation (mScene.GetCoordinateSystem ().P2D_RotationRadians (jointParams.mAngle * Define.kDegrees2Radians));
            joint.SetVisible (jointParams.mIsVisible);
            joint.SetAlpha (jointParams.mAlpha);
            joint.SetEnabled (jointParams.mIsEnabled);
            
            //>> from v1.02
            joint.SetConnectedShape1Index (jointParams.mConntectedShape1Index);
            joint.SetConnectedShape2Index (jointParams.mConntectedShape2Index);
            //<<
            
            //from v1.08
            joint.SetBreakable (jointParams.mIsBreakable);
            //<<
            
            if (entity is SubEntityHingeAnchor)
            {
               var hinge:EntityJointHinge = joint as EntityJointHinge;
               
               hinge.SetLimitsEnabled (jointParams.mEnableLimit);
               hinge.SetLimits (mScene.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mLowerAngle), mScene.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mUpperAngle));
               hinge.mEnableMotor = jointParams.mEnableMotor;
               hinge.mMotorSpeed = mScene.GetCoordinateSystem ().P2D_RotationDegrees (jointParams.mMotorSpeed);
               hinge.mBackAndForth = jointParams.mBackAndForth;
               
               //>>from v1.04
               hinge.SetMaxMotorTorque (mScene.GetCoordinateSystem ().P2D_Torque (jointParams.mMaxMotorTorque));
               //<<
               
               // 
               hinge.GetAnchor ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntitySliderAnchor)
            {
               var slider:EntityJointSlider = joint as EntityJointSlider;
               
               slider.SetLimitsEnabled (jointParams.mEnableLimit);
               slider.SetLimits (mScene.GetCoordinateSystem ().P2D_Length (jointParams.mLowerTranslation), mScene.GetCoordinateSystem ().P2D_Length (jointParams.mUpperTranslation));
               slider.mEnableMotor = jointParams.mEnableMotor;
               slider.mMotorSpeed = mScene.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (jointParams.mMotorSpeed);
               slider.mBackAndForth = jointParams.mBackAndForth;
               
               //>>from v1.04
               slider.SetMaxMotorForce (mScene.GetCoordinateSystem ().P2D_ForceMagnitude (jointParams.mMaxMotorForce));
               //<<
               
               // 
               slider.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               slider.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntitySpringAnchor)
            {
               var spring:EntityJointSpring = joint as EntityJointSpring;
               
               spring.SetStaticLengthRatio (jointParams.mStaticLengthRatio);
               spring.SetSpringType (jointParams.mSpringType);
               spring.mDampingRatio = jointParams.mDampingRatio;
               
               //from v1.08
               spring.SetFrequencyDeterminedManner (jointParams.mFrequencyDeterminedManner);
               spring.SetFrequency (jointParams.mFrequency);
               spring.SetSpringConstant (jointParams.mSpringConstant * mScene.GetCoordinateSystem ().P2D_Length (1.0) / mScene.GetCoordinateSystem ().P2D_ForceMagnitude (1.0));
               spring.SetBreakExtendedLength (mScene.GetCoordinateSystem ().P2D_Length (jointParams.mBreakExtendedLength));
               //<<
               
               // 
               spring.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               spring.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = joint as EntityJointDistance;
               
               //from v1.08
               distance.SetBreakDeltaLength (mScene.GetCoordinateSystem ().P2D_Length (jointParams.mBreakDeltaLength));
               //<<
               
               // 
               distance.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               distance.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityWeldAnchor)
            {
               var weld:EntityJointWeld = joint as EntityJointWeld;
               
               // 
               weld.GetAnchor ().SetVisible (jointParams.mIsVisible);
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
               
               // 
               dummy.GetAnchor1 ().SetVisible (jointParams.mIsVisible);
               dummy.GetAnchor2 ().SetVisible (jointParams.mIsVisible);
            }
            
            jointAnchor.GetMainAsset ().UpdateAppearance ();
            jointAnchor.UpdateSelectionProxy ();
         }
         else if (entity is EntityUtility)
         {
            var utility:EntityUtility = entity as EntityUtility;
            
            if (entity is EntityUtilityCamera)
            {
               var camera:EntityUtilityCamera = utility as EntityUtilityCamera;
               
               //from v1.08
               camera.SetFollowedTarget (params.mFollowedTarget);
               camera.SetFollowingStyle (params.mFollowingStyle);
               //<<
            }
            else if (entity is EntityUtilityPowerSource)
            {
               var powerSource:EntityUtilityPowerSource = entity as EntityUtilityPowerSource;
               
               powerSource.SetKeyboardEventId (params.mEventId);
               powerSource.SetKeyCodes (params.mKeyCodes);
               
               switch (powerSource.GetPowerSourceType ())
               {
                  case Define.PowerSource_Torque:
                     params.mPowerMagnitude = mScene.GetCoordinateSystem ().P2D_Torque (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_LinearImpusle:
                     params.mPowerMagnitude = mScene.GetCoordinateSystem ().P2D_ImpulseMagnitude (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularImpulse:
                     params.mPowerMagnitude = mScene.GetCoordinateSystem ().P2D_AngularImpulse (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularAcceleration:
                     params.mPowerMagnitude = mScene.GetCoordinateSystem ().P2D_AngularAcceleration (params.mPowerMagnitude);
                     break;
                  case Define.PowerSource_AngularVelocity:
                     params.mPowerMagnitude = mScene.GetCoordinateSystem ().P2D_AngularVelocity (params.mPowerMagnitude);
                     break;
                  //case Define.PowerSource_LinearAcceleration:
                  //   params.mPowerMagnitude = mScene.GetCoordinateSystem ().P2D_LinearAccelerationMagnitude (params.mPowerMagnitude);
                  //   break;
                  //case Define.PowerSource_LinearVelocity:
                  //   params.mPowerMagnitude = mScene.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mPowerMagnitude);
                  //   break;
                  case Define.PowerSource_Force:
                  default:
                     params.mPowerMagnitude = mScene.GetCoordinateSystem ().P2D_ForceMagnitude (params.mPowerMagnitude);
                     break;
               }
               powerSource.SetPowerMagnitude (params.mPowerMagnitude);
            }
            
            utility.UpdateAppearance ();
            utility.UpdateSelectionProxy ();
         }
         
         if (entity != null)
         {
            entity.UpdateControlPoints (true);
            
            CreateUndoPoint ("The properties of entity [" + entity.GetTypeName ().toLowerCase () + "] are changed");
         }
      }
      
      public function ShowBatchModifyEntityCommonPropertiesDialog ():void
      {
         EditorContext.OpenSettingsDialog (BatchEntityCommonPropertyModifyDialog, OnBatchModifyEntityCommonProperties, null);
      }
      
      public function ShowBatchModifyShapePhysicsPropertiesDialog ():void
      {
         EditorContext.OpenSettingsDialog (BatchShapePhysicsPropertiesModifyDialog, OnBatchModifyShapePhysicsProperties, {mScene: mScene});
      }
      
      public function ShowBatchModifyShapeAppearancePropertiesDialog ():void
      {
         EditorContext.OpenSettingsDialog (BatchShapeAppearancePropertiesModifyDialog, OnBatchModifyShapeAppearanceProperties, null);
      }
      
      public function ShowBatchModifyShapeCirclePropertiesDialog ():void
      {
         EditorContext.OpenSettingsDialog (BatchShapeCirclePropertiesModifyDialog, OnBatchModifyShapeCircleProperties, null);
      }
      
      public function ShowBatchModifyShapeRectanglePropertiesDialog ():void
      {
         EditorContext.OpenSettingsDialog (BatchShapeRectanglePropertiesModifyDialog, OnBatchModifyShapeRectangleProperties, null);
      }
      
      public function ShowBatchModifyShapePolylinePropertiesDialog ():void
      {
         EditorContext.OpenSettingsDialog (BatchShapePolylinePropertiesModifyDialog, OnBatchModifyShapePolylineProperties, null);
      }
      
      public function ShowBatchModifyJointCollideConnectedsDialog ():void
      {
         EditorContext.OpenSettingsDialog (BatchJointCollideConnectedsModifyDialog, OnBatchModifyJointCollideConnectedsProperty, null);
      }
      
      private function OnBatchModifyEntityCommonProperties (params:Object):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         var entity:Entity;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            entity = selectedEntities [i];
            
            if (entity != null)
            {
               if (params.mToModifyAngle)
                  entity.SetRotation (mScene.GetCoordinateSystem ().P2D_RotationRadians (params.mAngle * Define.kDegrees2Radians));
               if (params.mToModifyAlpha)
                  entity.SetAlpha (params.mAlpha);
               if (params.mToModifyVisible)
                  entity.SetVisible (params.mIsVisible);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify common proeprties for " + selectedEntities.length + " entities");
      }
      
      public function OnBatchModifyShapeAppearanceProperties (params:Object):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         
         var numShapes:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            var shape:EntityVectorShape = selectedEntities [i] as EntityVectorShape;
            
            if (shape != null)
            {
               ++ numShapes;
               
               if (shape.IsBasicVectorShapeEntity ())
               {
                  if (params.mToModifyAiType)
                     shape.SetAiType (params.mAiType);
               }
               
               if (params.mToModifyDrawBackground)
                  shape.SetDrawBackground (params.mDrawBackground);
               if (params.mToModifyTransparency)
                  shape.SetTransparency (params.mTransparency);
               if (params.mToModifyBackgroundColor)
                  shape.SetFilledColor (params.mBackgroundColor);
               if (params.mToModifyBodyTexture)
                  shape.SetBodyTextureModule (params.mBodyTextureModule);   
               if (params.mToModifyDrawBorder)
                  shape.SetDrawBorder (params.mDrawBorder);
               if (params.mToModifyBorderColor)
                  shape.SetBorderColor (params.mBorderColor);
               if (params.mToModifyBorderThickness)
                  shape.SetBorderThickness (params.mBorderThickness);
               if (params.mToModifyBorderTransparency)
                  shape.SetBorderTransparency (params.mBorderTransparency);
               
               shape.UpdateAppearance ();
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify appearances proeprties for " + numShapes + " shapes");
      }
      
      public function OnBatchModifyShapePhysicsProperties (params:Object):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         
         var numShapes:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            //var shape:EntityVectorShape = selectedEntities [i] as EntityVectorShape;
            var shape:EntityShape = selectedEntities [i] as EntityShape;
            
            if (shape != null)
            {
               ++ numShapes;
               
               // flags
               if (params.mToModifyEnablePhysics)
                  shape.SetPhysicsEnabled (params.mIsPhysicsEnabled);
               if (params.mToModifyStatic)
                  shape.SetStatic (params.mIsStatic);
               if (params.mToModifyBullet)
                  shape.SetAsBullet (params.mIsBullet);
               if (params.mToModifySensor)
                  shape.SetAsSensor (params.mIsSensor);
               if (params.mToModifyHollow)
                  shape.SetHollow (params.mIsHollow);
               if (params.mToModifyBuildBorder)
                  shape.SetBuildBorder (params.mBuildBorder);
               if (params.mToModifAllowSleeping)
                  shape.SetAllowSleeping (params.mAllowSleeping);
               if (params.mToModifyFixRotation)
                  shape.SetFixRotation (params.mFixRotation);
               
               // ccat
               if (params.mToModifyCCat)
                  shape.SetCollisionCategoryIndex (params.mCollisionCategoryIndex);
               
               // velocity
               if (params.mToModifyLinearVelocityMagnitude)
                  shape.SetLinearVelocityMagnitude (mScene.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (params.mLinearVelocityMagnitude));
               if (params.mToModifyLinearVelocityAngle)
                  shape.SetLinearVelocityAngle (mScene.GetCoordinateSystem ().P2D_RotationDegrees (params.mLinearVelocityAngle));
               if (params.mToModifyAngularVelocity)
                  shape.SetAngularVelocity (mScene.GetCoordinateSystem ().P2D_AngularVelocity (params.mAngularVelocity));
               
               // fixture
               if (params.mToModifyDensity)
                  shape.SetDensity (params.mDensity);
               if (params.mToModifyFriction)
                  shape.SetFriction (params.mFriction);
               if (params.mToModifyRestitution)
                  shape.SetRestitution (params.mRestitution);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify physics proeprties for " + numShapes + " shapes");
      }
      
      public function OnBatchModifyShapeCircleProperties (params:Object):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         var circle:EntityVectorShapeCircle;
         
         var numCircles:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            circle = selectedEntities [i] as EntityVectorShapeCircle;
            
            if (circle != null)
            {
               ++ numCircles;
               
               if (params.mToModifyAppearanceType)
                  circle.SetAppearanceType (params.mAppearanceType);
               if (params.mToModifyRadius)
                  circle.SetRadius (mScene.GetCoordinateSystem ().P2D_Length (params.mRadius));
               
               circle.UpdateAppearance ();
               circle.UpdateSelectionProxy ();
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify proeprties for " + numCircles + " circles");
      }
      
      public function OnBatchModifyShapeRectangleProperties (params:Object):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         var rect:EntityVectorShapeRectangle;
         
         var numRectangles:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            rect = selectedEntities [i] as EntityVectorShapeRectangle;
            
            if (rect != null)
            {
               ++ numRectangles;
            
               //if (params.mToModifyRoundCorners)
               //   rect.SetRoundCorners (params.mIsRoundCorners);
               if (params.mToModifyRoundJoint)
                  rect.SetRoundJoint (params.mIsRoundJoint);
               if (params.mToModifyWidth)
                  rect.SetHalfWidth (0.5 * mScene.GetCoordinateSystem ().P2D_Length (params.mWidth));
               if (params.mToModifyHeight)
                  rect.SetHalfHeight (0.5 * mScene.GetCoordinateSystem ().P2D_Length (params.mHeight));
            
               rect.UpdateAppearance ();
               rect.UpdateSelectionProxy ();
               
               rect.UpdateControlPoints (true);
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify proeprties for " + numRectangles + " rectangles");
      }
      
      public function OnBatchModifyShapePolylineProperties (params:Object):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         var polyline:EntityVectorShapePolyline;
         
         var numPolylines:int = 0;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            polyline = selectedEntities [i] as EntityVectorShapePolyline;
            
            if (polyline != null)
            {
               ++  numPolylines;
            
               if (params.mToModifyCurveThickness)
                  polyline.SetCurveThickness (params.mCurveThickness);
               if (params.mToModifyRoundEnds)
                  polyline.SetRoundEnds (params.mIsRoundEnds);
               if (params.mToModifyClosed)
                  polyline.SetClosed (params.mIsClosed);
            
               polyline.UpdateAppearance ();
               polyline.UpdateSelectionProxy ();
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify proeprties for " +  numPolylines + " polylines");
      }
      
      public function OnBatchModifyJointCollideConnectedsProperty (params:Object):void
      {
         var selectedEntities:Array = mScene.GetSelectedAssets ();
         var joint:EntityJoint;
         var anchor:SubEntityJointAnchor;
         
         for (var i:int = 0; i < selectedEntities.length; ++ i)
         {
            anchor = selectedEntities [i] as SubEntityJointAnchor;
            
            if (anchor != null)
            {
               joint = anchor.GetMainAsset () as EntityJoint;
               
               if (joint != null)
               {
                  joint.mCollideConnected = params.mCollideConnected;
               }
            }
         }
         
         if (selectedEntities.length > 0)
            CreateUndoPoint ("Modify collid-connected proeprty for " + selectedEntities.length + " joints");
      }
      
//============================================================================
//   
//============================================================================
      
      public function AlignTextureCenterWithShapeCenter ():void
      {
         var entities:Array = mScene.GetSelectedAssets ();
         var entity:Entity;
         var i:int;
         var count:int = 0;
         for (i = 0; i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            if (entity is EntityVectorShapeArea)
            {
               if ((entity as EntityVectorShapeArea).AlignTextureCenterWithShapeCenter ())
               {
                  ++ count;
               }
            }
         }
         
         if (count > 0)
         {
            CreateUndoPoint ("Align texture");
         }
      }
      
      public function AlignCenterSelectedEntities ():void
      {
         // try to find the largest circle and set its position as target position, 
         // if no circle found, set the first joint anchor as target position,
         // 
         
         var entities:Array = mScene.GetSelectedAssets ();
         var entity:Entity;
         var i:int;
         var centerX:Number;
         var centerY:Number;
         var maxArea:Number = 0;
         var area:Number;
         var numShapes:int = 0;
         var circleRadius:Number;
         var numAnchors:int = 0;
         for (i = 0; i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            if (entity is EntityVectorShapeCircle)
            {
               ++ numShapes;
               circleRadius = (entity as EntityVectorShapeCircle).GetRadius ();
               area = Math.PI * circleRadius * circleRadius;
               if ( area > maxArea )
               {
                  maxArea = area;
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
            }
            else if (entity is EntityVectorShapeRectangle)
            {
               ++ numShapes;
               area = 4 * (entity as EntityVectorShapeRectangle).GetHalfWidth () * (entity as EntityVectorShapeRectangle).GetHalfHeight ();
               if ( area > maxArea )
               {
                  maxArea = area;
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
            }
            else if (entity is SubEntityJointAnchor)
            {
               if (numShapes == 0 && numAnchors == 0)
               {
                  centerX = entity.GetPositionX ();
                  centerY = entity.GetPositionY ();
               }
               
               ++ numAnchors;
            }
         }
         
         if (numShapes + numAnchors > 1)
         {
            for (i = 0; i < entities.length; ++ i)
            {
               entity = entities [i] as Entity;
               if (entity is EntityVectorShapeCircle || entity is EntityVectorShapeRectangle || entity is SubEntityJointAnchor)
               {
                  entity.Move (centerX - entity.GetPositionX (), centerY - entity.GetPositionY ());
                  entity.OnTransformIntentDone ();
               }
            }
            
            CreateUndoPoint ("Coincide entity centers");
            
            OnAssetSelectionsChanged ();
         }
      }
      
      public function RoundPositionForSelectedEntities ():void
      {
         var entities:Array = mScene.GetSelectedAssets ();
         var entity:Entity;
         var i:int;
         var posX:Number;
         var posY:Number;
         for (i = 0; i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            posX = Math.round (entity.GetPositionX ());
            posY = Math.round (entity.GetPositionY ());
            entity.SetPosition (posX, posY);
            entity.OnTransformIntentDone ();
         }
         
         if (entities.length > 0)
         {
            CreateUndoPoint ("Round entity positons");
            
            OnAssetSelectionsChanged ();
         }
      }
       
      public function ConvertOldRegisterVariablesToGlobalVariables ():void
      {
         try
         {
            EditorContext.GetEditorApp ().GetWorld ().ConvertRegisterVariablesToGlobalVariables ();
            
            // ...
            CreateUndoPoint ("Register variables are converted.");
         }
         catch (error:Error)
         {
            if (Capabilities.isDebugger)
               throw error;
            
            PushFloatingMessage (new EffectMessagePopup ("Convert register variables failed", EffectMessagePopup.kBgColor_Error, 0x000000, 0.5 * GetPanelWidth ()))
         }
      }
      
//============================================================================
//   entity links
//============================================================================
      
      override public function CreateOrBreakAssetLink (startLinkable:Linkable, mStartManagerX:Number, mStartManagerY:Number, endManagerX:Number, endManagerY:Number):void
      {
         if (CreateOrBreakAssetLink_Default (startLinkable, mStartManagerX, mStartManagerY, endManagerX, endManagerY))
         {
            CreateUndoPoint ("Created a link");
         }
      }
   
   }
}
