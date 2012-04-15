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
      
      public function SetMoveSceneMode (moveSveneMode:Boolean):void
      {
      }
      
      public function SetCookieSelectMode (cookieSelectMode:Boolean):void
      {
      }
      
      public function SetShowAllEntityLinks (showLinks:Boolean):void
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
      
      // entity settings
      
      public function ShowEntitySettingsDialog ():void
      {
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
      
      // clone / delete
      
      public function CloneSelectedEntities ():void
      {
      }
      
      public function DeleteSelectedEntities ():void
      {
      }
      
      // move to top/bottom 
      
      public function MoveSelectedEntitiesToTop ():void
      {
      }
      
      public function MoveSelectedEntitiesToBottom ():void
      {
      }
      
      // brothers
      
      public function MakeBrothersForSelectedEntities ():void
      {
      }
      
      public function BreakApartBrothersForSelectedEntities ():void
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
