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
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   import editor.asset.IntentDrag;
   
   import editor.entity.Scene;
   import editor.entity.*;
   
   import editor.EditorContext;
   
   import common.Define;
   import common.Version;
   
   public class SceneEditPanel extends AssetManagerPanel
   {  
      private var mScene:Scene = null;
      
      public function SetScene (scene:Scene):void
      {
         if (mScene != scene)
         {
            mScene = scene;
         }
         
         super.SetAssetManager (scene);
      }
      
//============================================================================
//   
//============================================================================
      
      override public function UpdateInterface ():void
      {
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
            case "hinge":
               SetCurrentIntent (new IntentPutAsset (
                                 mScene.CreateEntityJointHinge (true), 
                                 OnPutCreatingOneAnchorJoint, OnCreatingCancelled));
               break;
            case "weld":
               SetCurrentIntent (new IntentPutAsset (
                                 mScene.CreateEntityJointWeld (true), 
                                 OnPutCreatingOneAnchorJoint, OnCreatingCancelled));
               break;
            case "slider":
               mScene.CreateEntityJointSlider (true)
               SetCurrentIntent (new IntentDrag (OnDragCreatingTwoAnchorsJoint, OnCreatingCancelled));
               break;
            case "distance":
               mScene.CreateEntityJointDistance (true)
               SetCurrentIntent (new IntentDrag (OnDragCreatingTwoAnchorsJoint, OnCreatingCancelled));
               break;
            case "spring":
               mScene.CreateEntityJointSpring (true)
               SetCurrentIntent (new IntentDrag (OnDragCreatingTwoAnchorsJoint, OnCreatingCancelled));
               break;
            case "dummy":
               mScene.CreateEntityJointDummy (true)
               SetCurrentIntent (new IntentDrag (OnDragCreatingTwoAnchorsJoint, OnCreatingCancelled));
               break;
            case "powersource":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityUtilityPowerSource (params.mPowerSourceType, true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "camera":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityUtilityCamera (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "gravity":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityVectorShapeGravityController (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "text":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityVectorShapeText (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "textbutton":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityVectorShapeTextButton (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "imagemodule":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityShapeImageModule (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            case "imagemodulebutton":
               SetCurrentIntent (new IntentPutAsset (mScene.CreateEntityShapeImageModuleButton (true), 
                                 OnPutCreating, OnCreatingCancelled));
               break;
            default:
               return;
         }
         
         mOnEndCreatingEntityCallback = endCreatingCallback;
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
      
      public function OnCreatingCancelled ():void
      {
         TryToCallOnEndCreatingEntityCallback ();
         
         DeleteSelectedAssets ();
         OnAssetSelectionsChanged ();
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
