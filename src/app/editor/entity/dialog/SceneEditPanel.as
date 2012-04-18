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
   
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
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
   
   import editor.display.sprite.BackgroundSprite;
   
   import editor.EditorContext;
   
   import common.trigger.CoreEventIds;
   
   import common.Define;
   import common.Version;
   
   public class SceneEditPanel extends AssetManagerPanel
   {  
      private var mSceneBackground:BackgroundSprite = new BackgroundSprite ();
      private var mScene:Scene = null;
      
      public function SceneEditPanel ()
      {
         mBackgroundLayer.addChild (mSceneBackground);
      }
      
//============================================================================
//   
//============================================================================
      
      public function SetScene (scene:Scene):void
      {
         mScene = scene;
         
         super.SetAssetManager (scene);
         
         mSceneBackground.visible = (mScene != null);
         
         MoveSceneCameraToPanelCenter ();
      }
      
      private function MoveSceneCameraToPanelCenter ():void
      {
         if (mScene != null)
         {
            var sceneCameraCenterPanelPoint:Point = ManagerToView (new Point (mScene.GetCameraCenterX (), mScene.GetCameraCenterY ()));
            
            MoveManager (0.5 * mParentWidth - sceneCameraCenterPanelPoint.x, 0.5 * mParentHeight - sceneCameraCenterPanelPoint.y);
         }
      }
      
//============================================================================
//   
//============================================================================
      
      override protected function GetMaxAllowedScale ():Number
      {
         return 16.0;
      }
      
      override protected function GetMinAllowedScale ():Number
      {
         return 1.0 / 16.0;
      }
      
      override protected function OnResize (event:Event):void 
      {
         super.OnResize (event);
         
         MoveSceneCameraToPanelCenter ();
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mScene == null)
         {
            mSceneBackground.visible = false;
         }
         else
         {
            mSceneBackground.visible = true;
             
            var sceneLeft  :Number;
            var sceneTop   :Number;
            var sceneWidth :Number;
            var sceneHeight:Number;
            
            if (mScene.IsInfiniteSceneSize ())
            {
               sceneLeft   = -1000000000; // about halft of - 0x7FFFFFFF;
               sceneTop    = - 1000000000; // about half of - 0x7FFFFFFF;
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
            
            var sceneCameraCenter:Point = ViewToManager (new Point (0.5 * mParentWidth, 0.5 * mParentHeight));
            
            if (sceneCameraCenter.x < sceneLeft)
               sceneCameraCenter.x = sceneLeft;
            if (sceneCameraCenter.x > sceneLeft + sceneWidth)
               sceneCameraCenter.x = sceneLeft + sceneWidth;
            if (sceneCameraCenter.y < sceneTop)
               sceneCameraCenter.y = sceneTop;
            if (sceneCameraCenter.y > sceneTop + sceneHeight)
               sceneCameraCenter.y = sceneTop + sceneHeight;
            
            mScene.SetCameraCenterX (sceneCameraCenter.x);
            mScene.SetCameraCenterY (sceneCameraCenter.y);
            
            mSceneBackground.UpdateAppearance (sceneLeft, sceneTop, sceneWidth, sceneHeight, 
                                               mScene.GetWorldBorderLeftThickness (), mScene.GetWorldBorderTopThickness (), mScene.GetWorldBorderRightThickness (), mScene.GetWorldBorderBottomThickness (),
                                               mScene.GetBackgroundColor (), mScene.GetBorderColor (), mScene.IsBuildBorder (),
                                               sceneCameraCenter.x, sceneCameraCenter.y, mScene.scaleX, mScene.scaleY,
                                               mParentWidth, mParentHeight, mBackgroundGridSize);
         }
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
               mScene.CreateEntityVectorShapeRectangle (params.mAiType, true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingShape, OnCreatingCancelled));
               break;
            case "CircleShape":
               mScene.CreateEntityVectorShapeCircle (params.mAiType, true);
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
            case CoreEventIds.ID_OnPhysicsShapeMouseDown:
            case CoreEventIds.ID_OnPhysicsShapeMouseUp:
            case CoreEventIds.ID_OnEntityMouseClick:
            case CoreEventIds.ID_OnEntityMouseDown:
            case CoreEventIds.ID_OnEntityMouseUp:
            case CoreEventIds.ID_OnEntityMouseMove:
            case CoreEventIds.ID_OnEntityMouseEnter:
            case CoreEventIds.ID_OnEntityMouseOut:
            case CoreEventIds.ID_OnWorldMouseClick:
            case CoreEventIds.ID_OnWorldMouseDown:
            case CoreEventIds.ID_OnWorldMouseUp:
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
//   
//============================================================================
      
      override public function UpdateInterface ():void
      {
         var numSelectedEntities:int = 0;
         var hasUndoPoints:Boolean = false;
         var hasRedoPoints:Boolean = false;
         
         mDialogCallbacks.UpdateInterface (numSelectedEntities, hasUndoPoints, hasRedoPoints);
      }
      
      private var mDialogCallbacks:Object = null; // must be null
      
      public function SetDialogCallbacks (callbacks:Object):void
      {
         mDialogCallbacks = callbacks;
      }
      
      private var mBackgroundGridSize:int = 50;
      
      public function SetBackgroundGridSize (gridSize:Number):void
      {
         mBackgroundGridSize = gridSize;
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
      
      public function ClearAllEntities (resetScene:Boolean, showAlert:Boolean = true):void
      {
      /*
         if (showAlert)
            Alert.show("Do you want to clear all objects?", "Clear All", 3, this, resetScene ? OnCloseClearAllAndResetSceneAlert : OnCloseClearAllAlert, null, Alert.NO);
         else
         {
            if (resetScene)
            {
               EditorContext.GetEditorApp ().SetWorld (new editor.world.World ());
               mViewCenterWorldX = DefaultWorldWidth * 0.5;
               mViewCenterWorldY = DefaultWorldHeight * 0.5;
               mEntityContainerZoomScale = 1.0;
               
               mShowAllEntityLinks = false;
               mShowAllEntityIds = false;
               
               UpdateChildComponents ();
               
               if (NotifyEditingScaleChanged != null)
                  NotifyEditingScaleChanged ();
            }
            else
            {
               mEntityContainer.DestroyAllEntities ();
            }
            
            CreateUndoPoint ("Clear world");
            
            CalSelectedEntitiesCenterPoint ();
            
            //EditorContext.mCollisionCategoryView.UpdateFriendLinkLines ();
            if (CollisionCategoryListDialog.sCollisionCategoryListDialog != null)
            {
               CollisionCategoryListDialog.sCollisionCategoryListDialog.GetCollisionCategoryListPanel ().UpdateAssetLinkLines ();
            }
            ////EditorContext.mFunctionEditingView.UpdateEntityLinkLines ();
            //if (CodeLibListDialog.sCodeLibListDialog != null)
            //{
            //   CodeLibListDialog.sCodeLibListDialog.GetCodeLibListPanel ().UpdateFriendLinkLines ();
            //}
            
            EditorContext.SetRecommandDesignFilename (null);
         }
      */
      }

      public function ShowLevelRulesEditDialog ():void
      {
      }

      public function ShowCoordinateSystemEditDialog ():void
      {
      }

      public function ShowWorldPhysicsEditDialog ():void
      {
      }

      public function ShowWorldAppearanceEditDialog ():void
      {
      }

      public function ShowViewportEditDialog ():void
      {
      }
      
      // find entity
      
      public function SelectEntities (entityIDs:Array):void
      {
      }
      
      // zoom in / out
      
      public function ZoomOut ():void
      {
      }
      
      public function ZoomIn ():void
      {
      }
      
      // clone / delete
      
      public function CloneSelectedEntities ():void
      {
         if (mScene.GetNumSelectedAssets () > 0)
         {
            mScene.CloneSelectedEntities (Define.BodyCloneOffsetX, Define.BodyCloneOffsetY);
            
            OnAssetSelectionsChanged ();
            
            EditorContext.GetEditorApp ().CreateUndoPoint ("Clone");
         }
      }
      
      public function DeleteSelectedEntities ():void
      {
         if (mScene.DeleteSelectedAssets ())
         {
            EditorContext.GetEditorApp ().CreateUndoPoint ("Delete");
         }
      }
      
      // move to top/bottom 
      
      public function MoveSelectedEntitiesToTop ():void
      {
         mScene.MoveSelectedAssetsToTop ();
         
         EditorContext.GetEditorApp ().CreateUndoPoint ("Move entities to the most top layer");
      }
      
      public function MoveSelectedEntitiesToBottom ():void
      {
         mScene.MoveSelectedAssetsToBottom ();
         
         EditorContext.GetEditorApp ().CreateUndoPoint ("Move entities to the most bottom layer");
      }
      
      // brothers
      
      public function MakeBrothersForSelectedEntities ():void
      {
         mScene.MakeBrothers (mScene.GetSelectedAssets ());
         
         EditorContext.GetEditorApp ().CreateUndoPoint ("Make brothers");
      }
      
      public function BreakApartBrothersForSelectedEntities ():void
      {
         mScene.BreakBrothersApart ();
         
         EditorContext.GetEditorApp ().CreateUndoPoint ("Break brothers");
      }
      
      // entity settings
      
      public function ShowEntitySettingsDialog ():void
      {
      /*
         //var selectedEntities:Array = mEntityContainer.GetSelectedAssets ();
         //if (selectedEntities == null || selectedEntities.length != 1)
         //   return;
         if (mMainSelectedEntity == null)
            return;
         
         //var entity:Entity = selectedEntities [0] as Entity;
         var entity:Entity = mMainSelectedEntity;
         
         var values:Object = new Object ();
         
         values.mPosX = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionX (entity.GetPositionX ()), 12);
         values.mPosY = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionY (entity.GetPositionY ()), 12);
         values.mAngle = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_RotationRadians (entity.GetRotation ()) * Define.kRadians2Degrees, 6);
         
         values.mIsVisible = entity.IsVisible ();
         values.mAlpha = entity.GetAlpha ();
         values.mIsEnabled = entity.IsEnabled ();
         
         if (entity is EntityLogic)
         {
            if (entity is EntityEventHandler)
            {
               var event_handler:EntityEventHandler = entity as EntityEventHandler;
               event_handler.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = event_handler.GetCodeSnippetName ();
               values.mEventId = event_handler.GetEventId ();
               values.mCodeSnippet  = event_handler.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               if (entity is EntityEventHandler_Timer)
               {
                  var timer_event_handler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
                  
                  values.mRunningInterval = timer_event_handler.GetRunningInterval ();
                  values.mOnlyRunOnce = timer_event_handler.IsOnlyRunOnce ();
                  
                  if (entity is EntityEventHandler_TimerWithPrePostHandling)
                  {
                     var timer_event_handler_withPrePostHandling:EntityEventHandler_TimerWithPrePostHandling = entity as EntityEventHandler_TimerWithPrePostHandling;
                     
                     values.mPreCodeSnippet  = timer_event_handler_withPrePostHandling.GetPreCodeSnippet  ().Clone (null);
                     values.mPostCodeSnippet = timer_event_handler_withPrePostHandling.GetPostCodeSnippet ().Clone (null);
                     ShowTimerEventHandlerWithPreAndPostHandlingSettingDialog (values, ConfirmSettingEntityProperties);
                  }
                  else
                  {
                     ShowTimerEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
                  }
               }
               else if (entity is EntityEventHandler_Keyboard)
               {
                  var keyboard_event_handler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
                  
                  values.mKeyCodes = keyboard_event_handler.GetKeyCodes ();
                  
                  ShowKeyboardEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_Mouse)
               {
                  ShowMouseEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_Contact)
               {
                  ShowContactEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_JointReachLimit)
               {
                  ShowJointReachLimitEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityEventHandler_GameLostOrGotFocus)
               {
                  ShowGameLostOrGotFocusEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
               //else if (entity is EntityEventHandler_ModuleLoopToEnd)
               else
               {
                  ShowEventHandlerSettingDialog (values, ConfirmSettingEntityProperties);
               }
            }
            else if (entity is EntityBasicCondition)
            {
               var condition:EntityBasicCondition = entity as EntityBasicCondition;
               condition.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = condition.GetCodeSnippetName ();
               values.mCodeSnippet  = condition.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               ShowConditionSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityAction)
            {
               var action:EntityAction = entity as EntityAction;
               action.GetCodeSnippet ().ValidateCallings ();
               
               values.mCodeSnippetName = action.GetCodeSnippetName ();
               values.mCodeSnippet  = action.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               ShowActionSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityScriptFilter)
            {
               var entityFilter:EntityInputEntityScriptFilter = entity as EntityInputEntityScriptFilter;
               
               values.mCodeSnippetName = entityFilter.GetCodeSnippetName ();
               values.mCodeSnippet  = entityFilter.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               ShowEntityFilterSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityPairScriptFilter)
            {
               var pairFilter:EntityInputEntityPairScriptFilter = entity as EntityInputEntityPairScriptFilter;
               
               values.mCodeSnippetName = pairFilter.GetCodeSnippetName ();
               values.mCodeSnippet  = pairFilter.GetCodeSnippet ().Clone (null);
               (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mEntityContainer.GetCoordinateSystem ());
               
               ShowEntityPairFilterSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityConditionDoor)
            {
               ShowConditionDoorSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityTask)
            {
               ShowTaskSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityAssigner)
            {
               ShowEntityAssignerSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityInputEntityPairAssigner)
            {
               ShowEntityPairAssignerSettingDialog (values, ConfirmSettingEntityProperties);
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
                  values.mRadius = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length ((entity as EntityVectorShapeCircle).GetRadius()), 6);
                  
                  values.mAppearanceType = (entity as EntityVectorShapeCircle).GetAppearanceType();
                  values.mAppearanceTypeListSelectedIndex = (entity as EntityVectorShapeCircle).GetAppearanceType();
                  
                  ShowShapeCircleSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityVectorShapeRectangle)
               {
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mEntityContainer.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mEntityContainer.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfHeight ()), 6);
                  values.mIsRoundCorners = (vectorShape as EntityVectorShapeRectangle).IsRoundCorners ();
                  
                  ShowShapeRectangleSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityVectorShapePolygon)
               {
                  ShowShapePolygonSettingDialog (values, ConfirmSettingEntityProperties);
               }
               else if (entity is EntityVectorShapePolyline)
               {
                  values.mCurveThickness = (vectorShape as EntityVectorShapePolyline).GetCurveThickness ();
                  values.mIsRoundEnds = (vectorShape as EntityVectorShapePolyline).IsRoundEnds ();
                  values.mIsClosed = (vectorShape as EntityVectorShapePolyline).IsClosed ();
                  
                  ShowShapePolylineSettingDialog (values, ConfirmSettingEntityProperties);
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
                  values.mAdaptiveBackgroundSize = (vectorShape as EntityVectorShapeText).IsAdaptiveBackgroundSize ();
                  
                  values.mWidth  = ValueAdjuster.Number2Precision (2.0 * mEntityContainer.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfWidth ()), 6);
                  values.mHeight = ValueAdjuster.Number2Precision (2.0 * mEntityContainer.GetCoordinateSystem ().D2P_Length ((vectorShape as EntityVectorShapeRectangle).GetHalfHeight ()), 6);
                  
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
                     
                     ShowShapeTextButtonSettingDialog (values, ConfirmSettingEntityProperties);
                  }
                  else
                  {
                     ShowShapeTextSettingDialog (values, ConfirmSettingEntityProperties);
                  }
               }
               else if (entity is EntityVectorShapeGravityController)
               {
                  values.mRadius = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length ((entity as EntityVectorShapeCircle).GetRadius()), 6);
                  
                  // removed from v1.05
                  /////values.mIsInteractive = (vectorShape as EntityVectorShapeGravityController).IsInteractive ();
                  values.mInteractiveZones = (vectorShape as EntityVectorShapeGravityController).GetInteractiveZones ();
                  
                  values.mInteractiveConditions = (vectorShape as EntityVectorShapeGravityController).mInteractiveConditions;
                  
                  values.mMaximalGravityAcceleration = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude ((vectorShape as EntityVectorShapeGravityController).GetMaximalGravityAcceleration ()), 6);
                  
                  values.mInitialGravityAcceleration = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude ((vectorShape as EntityVectorShapeGravityController).GetInitialGravityAcceleration ()), 6);
                  values.mInitialGravityAngle = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees ((vectorShape as EntityVectorShapeGravityController).GetInitialGravityAngle ()), 6);
                  
                  ShowShapeGravityControllerSettingDialog (values, ConfirmSettingEntityProperties);
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
               
               ShowShapeImageModuleSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is EntityShapeImageModuleButton)
            {
               RetrieveShapePhysicsProperties (shape, values);
               
               values.mModuleUp = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseUp ();
               values.mModuleOver = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseOver ();
               values.mModuleDown = (entity as EntityShapeImageModuleButton).GetAssetImageModuleForMouseDown ();
               
               ShowShapeImageModuleButtonSettingDialog (values, ConfirmSettingEntityProperties);
            }
         }
         else if (entity is SubEntityJointAnchor)
         {
            var jointAnchor:SubEntityJointAnchor = entity as SubEntityJointAnchor;
            var joint:EntityJoint = entity.GetMainAsset () as EntityJoint;
            
            var jointValues:Object = new Object ();
            values.mJointValues = jointValues;
            
            jointValues.mCollideConnected = joint.mCollideConnected;
            
            jointValues.mPosX = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionX (joint.GetPositionX ()), 12);
            jointValues.mPosY = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionY (joint.GetPositionY ()), 12);
            jointValues.mAngle = ValueAdjuster.Number2Precision (joint.GetRotation () * Define.kRadians2Degrees, 6);
            
            jointValues.mIsVisible = joint.IsVisible ();
            jointValues.mAlpha = joint.GetAlpha ();
            jointValues.mIsEnabled = joint.IsEnabled ();
            
            //>>from v1.02
            jointValues.mShapeListDataProvider = mEntityContainer.GetEntitySelectListDataProviderByFilter (Filters.IsPhysicsShapeEntity, true, "[Auto Select]");
            jointValues.mShapeList1SelectedIndex = EntityContainer.EntityIndex2SelectListSelectedIndex (joint.GetConnectedShape1Index (), jointValues.mShapeListDataProvider);
            jointValues.mShapeList2SelectedIndex = EntityContainer.EntityIndex2SelectListSelectedIndex (joint.GetConnectedShape2Index (), jointValues.mShapeListDataProvider);
            jointValues.mAnchorIndex = jointAnchor.GetAnchorIndex (); // hinge will modify it below
            //<<
            
            //from v1.08
            jointValues.mIsBreakable = joint.IsBreakable ();
            //<<
            
            if (entity is SubEntityHingeAnchor)
            {
               jointValues.mAnchorIndex = -1; // to make both shape select lists selectable
               
               var hinge:EntityJointHinge = joint as EntityJointHinge;
               var lowerAngle:Number = mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees (hinge.GetLowerLimit ());
               var upperAngle:Number = mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees (hinge.GetUpperLimit ());
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
               jointValues.mMotorSpeed = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_RotationDegrees (hinge.mMotorSpeed), 6);
               jointValues.mBackAndForth = hinge.mBackAndForth;
               
               //>>from v1.04
               jointValues.mMaxMotorTorque = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Torque (hinge.GetMaxMotorTorque ()), 6);
               //<<
               
               ShowHingeSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntitySliderAnchor)
            {
               var slider:EntityJointSlider = joint as EntityJointSlider;
               
               jointValues.mEnableLimit = slider.IsLimitsEnabled ();
               jointValues.mLowerTranslation = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (slider.GetLowerLimit ()), 6);
               jointValues.mUpperTranslation = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (slider.GetUpperLimit ()), 6);
               jointValues.mEnableMotor = slider.mEnableMotor;
               jointValues.mMotorSpeed = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (slider.mMotorSpeed), 6);
               jointValues.mBackAndForth = slider.mBackAndForth;
               
               //>>from v1.04
               jointValues.mMaxMotorForce = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_ForceMagnitude (slider.GetMaxMotorForce ()), 6);
               //<<
               
               ShowSliderSettingDialog (values, ConfirmSettingEntityProperties);
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
               jointValues.mSpringConstant = ValueAdjuster.Number2Precision (spring.GetSpringConstant () * mEntityContainer.GetCoordinateSystem ().D2P_Length (1.0) / mEntityContainer.GetCoordinateSystem ().D2P_ForceMagnitude (1.0), 6);
               jointValues.mBreakExtendedLength = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (spring.GetBreakExtendedLength ()), 6);
               //<<
               
               ShowSpringSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityDistanceAnchor)
            {
               var distance:EntityJointDistance = joint as EntityJointDistance;
               
               //from v1.08
               jointValues.mBreakDeltaLength = ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (distance.GetBreakDeltaLength ()), 6);
               //<<
               
               ShowDistanceSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityWeldAnchor)
            {
               jointValues.mAnchorIndex = -1; // to make both shape select lists selectable
               
               var weld:EntityJointWeld = joint as EntityJointWeld;
               
               ShowWeldSettingDialog (values, ConfirmSettingEntityProperties);
            }
            else if (entity is SubEntityDummyAnchor)
            {
               var dummy:EntityJointDummy = joint as EntityJointDummy;
               
               ShowDummySettingDialog (values, ConfirmSettingEntityProperties);
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
               
               ShowCameraSettingDialog (values, ConfirmSettingEntityProperties);
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
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_Torque (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Torque";
                     break;
                  case Define.PowerSource_LinearImpusle:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_ImpulseMagnitude (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Linear Impulse";
                     break;
                  case Define.PowerSource_AngularImpulse:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_AngularImpulse (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Impulse";
                     break;
                  case Define.PowerSource_AngularAcceleration:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_AngularAcceleration (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Acceleration";
                     break;
                  case Define.PowerSource_AngularVelocity:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_AngularVelocity (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Angular Velocity";
                     break;
                  //case Define.PowerSource_LinearAcceleration:
                  //   values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_LinearAccelerationMagnitude (values.mPowerMagnitude);
                  //   values.mPowerLabel = "Step Linear Acceleration";
                  //   break;
                  //case Define.PowerSource_LinearVelocity:
                  //   values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (values.mPowerMagnitude);
                  //   values.mPowerLabel = "Step Linear Velocity";
                  //   break;
                  case Define.PowerSource_Force:
                  default:
                     values.mPowerMagnitude = mEntityContainer.GetCoordinateSystem ().D2P_ForceMagnitude (values.mPowerMagnitude);
                     values.mPowerLabel = "Step Force";
                     break;
               }
               values.mPowerMagnitude = ValueAdjuster.Number2Precision (values.mPowerMagnitude, 6);
               
               ShowPowerSourceSettingDialog (values, ConfirmSettingEntityProperties);
            }
         }
         */
      }
      
      public function ShowBatchModifyEntityCommonPropertiesDialog ():void
      {
      }
      
      public function ShowBatchModifyShapePhysicsPropertiesDialog ():void
      {
      }
      
      public function ShowBatchModifyShapeAppearancePropertiesDialog ():void
      {
      }
      
      public function ShowBatchModifyShapeCirclePropertiesDialog ():void
      {
      }
      
      public function ShowBatchModifyShapeRectanglePropertiesDialog ():void
      {
      }
      
      public function ShowBatchModifyShapePolylinePropertiesDialog ():void
      {
      }
      
      public function ShowBatchModifyJointCollideConnectedsDialog ():void
      {
      }
      
//============================================================================
//   entity links
//============================================================================
      
      override public function CreateOrBreakAssetLink (startLinkable:Linkable, mStartManagerX:Number, mStartManagerY:Number, endManagerX:Number, endManagerY:Number):void
      {
         var created:Boolean = false;
         
         // first round
         var entities:Array = mScene.GetAssetsAtPoint (endManagerX, endManagerY);
         var entity:Entity;
         var linkable:Linkable;
         var i:int;
         for (i = 0; !created && i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            if (entity is Linkable)
            {
               linkable = entity as Linkable;
               created = startLinkable.TryToCreateLink (mStartManagerX, mStartManagerY, linkable as Entity, endManagerX, endManagerY);
               if (! created && startLinkable is Entity)
                  created = linkable.TryToCreateLink (endManagerX, endManagerY, startLinkable as Entity, mStartManagerX, mStartManagerY);
            }
         }
         
         // second round, link general entity with a linkable
         
         for (i = 0; i < entities.length; ++ i)
         {
            entity = (entities [i] as Entity).GetMainAsset () as Entity;
            if (! (entity is Linkable) )
            {
               created = startLinkable.TryToCreateLink (mStartManagerX, mStartManagerY, entity, endManagerX, endManagerY);
               if (created)
                  break;
            }
         }
         
         if (created)
         {
            // CreateUndoPoint ("Create link");
            
            RepaintAllAssetLinks ();
         }
      }
      
//============================================================================
//   
//============================================================================
      
      public var ShowFunctionSettingDialog:Function = null;
      
      private function OpenAssetSettingDialog ():void
      {
         if (EditorContext.GetSingleton ().HasSettingDialogOpened ())
            return;
         
         var selectedAssets:Array = mScene.GetSelectedAssets ();
         if (selectedAssets == null || selectedAssets.length != 1)
            return;
         
         var entity:Entity = selectedAssets [0] as Entity;
         
         var values:Object = new Object ();
         
         /*
         if (entity is AssetFunction)
         {
            var aFunction:AssetFunction = asset as AssetFunction;
            
            values.mCodeSnippetName = aFunction.GetCodeSnippetName ();
            values.mCodeSnippet  = aFunction.GetCodeSnippet ().Clone (null);
            (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (EditorContext.GetEditorApp ().GetWorld ().GetEntityContainer ().GetCoordinateSystem ());
            
            ShowFunctionSettingDialog (values, ConfirmSettingAssetProperties);
         }
         */
      }
      
      private function ConfirmSettingAssetProperties (params:Object):void
      {
         var selectedAssets:Array = mScene.GetSelectedAssets ();
         if (selectedAssets == null || selectedAssets.length != 1)
            return;
         
         var entity:Entity = selectedAssets [0] as Entity;
         
         /*
         if (asset is AssetFunction)
         {
            var aFunction:AssetFunction = asset as AssetFunction;
            
            var code_snippet:CodeSnippet = aFunction.GetCodeSnippet ();
            code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
            code_snippet.PhysicsValues2DisplayValues (EditorContext.GetEditorApp ().GetWorld ().GetEntityContainer ().GetCoordinateSystem ());
         }
         */
      }
   
   }
}
