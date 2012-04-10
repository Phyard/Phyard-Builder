package editor.image.dialog {
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
   
   import mx.containers.ViewStack;
   import mx.containers.Form;
   import mx.containers.HBox;
   import mx.controls.Button;
   import mx.controls.NumericStepper;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.ColorPicker;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.MathUtil;
   
   import editor.asset.Asset;
   import editor.asset.AssetManagerPanel;
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   import editor.asset.IntentDrag;
   import editor.asset.IntentTaps;
   
   import editor.image.AssetImageModule;
   import editor.image.AssetImageBitmapModule;
   import editor.image.AssetImageCompositeModule;
   import editor.image.AssetImageModuleInstance;
   import editor.image.AssetImageModuleInstanceManager;
   import editor.image.AssetImageShapeModule;
   import editor.image.AssetImageNullModule;
   
   import editor.display.sprite.CoordinateSprite;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
   import editor.EditorContext;
   
   import common.shape.*;
   import common.Define;
   import common.Version;
   
   public class AssetImageCompositeModuleEditPanel extends AssetManagerPanel
   {
      protected var mCoordinateSprite:CoordinateSprite = new CoordinateSprite ();
      protected var mAssetImageModuleInstanceManager:AssetImageModuleInstanceManager;
      
      public function AssetImageCompositeModuleEditPanel ()
      {
         mBackgroundLayer.addChild (mCoordinateSprite);
      }
      
      public function GetAssetImageModuleInstanceManager ():AssetImageModuleInstanceManager
      {
         return mAssetImageModuleInstanceManager;
      }
      
      public function SetAssetImageModuleInstanceManager (amim:AssetImageModuleInstanceManager):void
      {
         super.SetAssetManager (amim);
         
         mAssetImageModuleInstanceManager = amim;
         
         if (mAssetImageModuleInstanceManager != null)
         {
            mAssetImageModuleInstanceManager.mCallback_OnChangedForPanel = UpdateInterface;
            
            UpdateInterface ();
            
            AdjustPosition ();
         }
      }
      
      protected var mAssetImageModuleInstanceListPanelPeer:AssetImageModuleInstanceListPanel;
      public function SetAssetImageModuleInstanceListPanelPeer (assetImageModuleInstanceListingPanel:AssetImageModuleInstanceListPanel):void
      {
         mAssetImageModuleInstanceListPanelPeer = assetImageModuleInstanceListingPanel;
      }
      
//=====================================================================
//
//=====================================================================
      
      override protected function OnResize (event:Event):void 
      {
         super.OnResize (event);
            //mParentWidth  = parent.width;
            //mParentHeight = parent.height;
            //UpdateBackgroundAndContentMaskSprites ();
         
         if (mAssetImageModuleInstanceManager != null)
         {
            AdjustPosition ();
         }
      }
      
      //private var mOldParentWidth:Number = 0;
      //private var mOldParentHeight:Number = 0; 
      
      private function AdjustPosition ():void
      {
         MoveManager (0.5 * mParentWidth - mAssetImageModuleInstanceManager.x, 0.5 * mParentHeight - mAssetImageModuleInstanceManager.y);
         //MoveManager (0.5 * (mParentWidth - mOldParentWidth) - mAssetImageModuleInstanceManager.x, 0.5 * (mParentHeight - mOldParentHeight) - mAssetImageModuleInstanceManager.y);
         //
         //mOldParentWidth = mParentWidth;
         //mOldParentHeight = mParentHeight;
      }
      
//=====================================================================
//
//=====================================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mAssetImageModuleInstanceManager != null)
         {
            mCoordinateSprite.UpdateAppearance (mParentWidth, mParentHeight, mAssetImageModuleInstanceManager.x, mAssetImageModuleInstanceManager.y, mAssetImageModuleInstanceManager.scaleX);
         }
      }
      
      override public function OnAssetSelectionsChanged (passively:Boolean = false):void
      {
         UpdatePropertySettingComponents ();
         
         if (! passively)
         {
            if (mAssetImageModuleInstanceListPanelPeer != null)
            {
               mAssetImageModuleInstanceListPanelPeer.GetAssetImageModuleInstanceManagerForListing ().GetAssetImageCompositeModule ().SynchronizeManagerSelectionsFromEdittingToListing ();
               
               mAssetImageModuleInstanceListPanelPeer.OnAssetSelectionsChanged (true);
            }
         }
         
         super.OnAssetSelectionsChanged ();
      }

//====================================================================================
//   
//====================================================================================
      
      public function DeleteModuleInstances ():void
      {
         //if (mAssetImageModuleInstanceManager == null)
         //   return;
         //
         //mAssetImageModuleInstanceManager.DeleteSelectedAssets ();
         
         // this one will call UpdateLayout
         if (mAssetImageModuleInstanceListPanelPeer != null)
         {
            mAssetImageModuleInstanceListPanelPeer.GetAssetImageModuleInstanceManagerForListing ().DeleteSelectedAssets ();
         }
      }
      
      public function MoveModuleInstanceUp ():void
      {
         if (mAssetImageModuleInstanceManager == null)
            return;
         
         mAssetImageModuleInstanceManager.MoveUpDownTheOnlySelectedModuleInstance (true);
      }
      
      public function MoveModuleInstanceDown ():void
      {
         if (mAssetImageModuleInstanceManager == null)
            return;
         
         mAssetImageModuleInstanceManager.MoveUpDownTheOnlySelectedModuleInstance (false);
      }
      
//====================================================================================
//   
//====================================================================================
      
      public var mButtonCreateGeneralModuleInstance:Button;
      public var mButtonCreateShapeBoxInstance:Button;
      public var mButtonCreateShapeCircleInstance:Button;
      public var mButtonCreateShapePolygonInstance:Button;
      public var mButtonCreateShapePolylineInstance:Button;
      public var mButtonCreateShapeTextInstance:Button;
      
      private var mCurrentSelectedCreateButton:Button = null;
      
      protected function OnCreatingFinished (moduleInstance:AssetImageModuleInstance):void
      {
         if (mCurrentSelectedCreateButton != null)
            mCurrentSelectedCreateButton.selected = false;
         
         mCurrentSelectedCreateButton = null;
         
         OnAssetSelectionsChanged (false);
         
         //mAssetImageModuleInstanceManager.NotifyModifiedForReferers ();
         moduleInstance.NotifyModifiedForReferers ();
      }
      
      protected function OnCreatingCancelled (moduleInstance:AssetImageModuleInstance = null):void
      {
         DeleteSelectedAssets ();
         OnAssetSelectionsChanged ();
                  
         if (mCurrentSelectedCreateButton != null)
            mCurrentSelectedCreateButton.selected = false;
         
         mCurrentSelectedCreateButton = null;

         if (mAssetImageModuleInstanceListPanelPeer != null && mAssetImageModuleInstanceListPanelPeer.GetAssetImageModuleInstanceManagerForListing () != null)
         {
            mAssetImageModuleInstanceListPanelPeer.GetAssetImageModuleInstanceManagerForListing ().UpdateLayout (true);
         }
      }
      
      protected function OnPutingCreating (moduleInstance:AssetImageModuleInstance, done:Boolean):void
      {
         if (done)
         {
            OnCreatingFinished (moduleInstance);
         }
      }
      
      protected function OnDragCreatingShapeMouleInstacne (startX:Number, startY:Number, endX:Number, endY:Number, done:Boolean):void
      {
         var points:Array = new Array (2);
         points [0] = new Point (startX, startY);
         points [1] = new Point (endX, endY);
         
         OnCreatingShapeMoudleInstacne (points, done);
      }
      
      protected function OnTapsCreatingShapeMouleInstacne (points:Array, currentX:Number, currentY:Number, isHoldMouse:Boolean):void
      {
         points.push (new Point (currentX, currentY));
         
         OnCreatingShapeMoudleInstacne (points, false);
      }
      
      protected function OnCreatingShapeMoudleInstacne (points:Array, done:Boolean):void
      {
         var selectedModuleInstacnes:Array = mAssetImageModuleInstanceManager.GetSelectedAssets ();
         if (selectedModuleInstacnes == null || selectedModuleInstacnes.length != 1)
         {
            OnCreatingCancelled ();
            return;
         }
         
         var moduleInstance:AssetImageModuleInstance = selectedModuleInstacnes [0] as AssetImageModuleInstance;
         var imageModule:AssetImageModule = moduleInstance.GetAssetImageModule ();
         if (imageModule == null)
         {
            OnCreatingCancelled (moduleInstance);
            return;
         }
         
         var shapeModule:AssetImageShapeModule = imageModule as AssetImageShapeModule;
         if (shapeModule == null)
         {
            OnCreatingCancelled (moduleInstance);
            return;
         }
         
         var pos:Point = shapeModule.OnCreating (points);
         if (pos != null)
            moduleInstance.SetPosition (pos.x, pos.y);
         
         moduleInstance.UpdateAppearance ();
         
         if (done)
         {
            if (shapeModule.IsValid ())
            {
               moduleInstance.UpdateSelectionProxy ();
               
               OnCreatingFinished (moduleInstance);
            }
            else
            {
               OnCreatingCancelled (moduleInstance);
            }
         }
      }
      
      public function OnClickCreateButton (event:MouseEvent):void
      {
         if (! event.target is Button)
            return;
         
         SetCurrentIntent (null);
         
         // cancel old
         if (mCurrentSelectedCreateButton == event.target)
         {
            mCurrentSelectedCreateButton = null;
            return;
         }
         
         mCurrentSelectedCreateButton = event.target as Button;
         
         switch (mCurrentSelectedCreateButton)
         {
            case mButtonCreateGeneralModuleInstance:
               SetCurrentIntent (new IntentPutAsset (
                                 mAssetImageModuleInstanceManager.CreateImageModuleInstance (EditorContext.GetSingleton ().mCurrentAssetImageModule, true), 
                                 OnPutingCreating, OnCreatingCancelled));
               break;
            case mButtonCreateShapeBoxInstance:
               mAssetImageModuleInstanceManager.CreateImageShapeRectangleModuleInstance (true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingShapeMouleInstacne, OnCreatingCancelled));
               break;
            case mButtonCreateShapeCircleInstance:
               mAssetImageModuleInstanceManager.CreateImageShapeCircleModuleInstance (true);
               SetCurrentIntent (new IntentDrag (OnDragCreatingShapeMouleInstacne, OnCreatingCancelled));
               break;
            case mButtonCreateShapePolygonInstance:
               mAssetImageModuleInstanceManager.CreateImageShapePolygonModuleInstance (true);
               SetCurrentIntent (new IntentTaps (this, OnCreatingShapeMoudleInstacne, OnTapsCreatingShapeMouleInstacne, OnCreatingCancelled));
               break;
            case mButtonCreateShapePolylineInstance:
               mAssetImageModuleInstanceManager.CreateImageShapePolylineModuleInstance (true);
               SetCurrentIntent (new IntentTaps (this, OnCreatingShapeMoudleInstacne, OnTapsCreatingShapeMouleInstacne, OnCreatingCancelled));
               break;
            case mButtonCreateShapeTextInstance:
               SetCurrentIntent (new IntentPutAsset (
                                 mAssetImageModuleInstanceManager.CreateImageShapeTextModuleInstance (true),
                                 OnPutingCreating, OnCreatingCancelled));
               break;
            default:
            {
               break;
            }
         }
         
         if (GetCurrentIntent () != null)
         {
            UpdatePropertySettingComponents ();
            
            //OnAssetSelectionsChanged (false); // some problems
            mFormBasicPropertySettings.enabled = false;
            mFormOtherPropertySettings.enabled = false;
         }
      }
      
//====================================================================================
//   
//====================================================================================
      
      protected var mIsPlaying:Boolean = false;
      
      public function Play ():void
      {
         mIsPlaying = true;
      }
      
      public function Pause ():void
      {
         mIsPlaying = false;
      }
      
//====================================================================================
//   
//====================================================================================
      
      public var mFormBasicPropertySettings:Form;
      public var mTextInputPosX:TextInput;
      public var mTextInputPosY:TextInput;
      public var mTextInputScale:TextInput;
      public var mCheckBoxFlipped:CheckBox;
      public var mTextInputAngle:TextInput;
      public var mTextInputAlpha:TextInput;
      public var mCheckBoxVisible:CheckBox;
      public var mNumericStepperDuration:NumericStepper;
      
      public var mFormOtherPropertySettings:Form;
      public var mFormItemBlockTitle:HBox;
      
      public var mButtonPickModule:Button;
      
      public var mCheckBoxBuildBody:CheckBox;
      public var mCheckBoxShowBody:CheckBox;
      public var mNumericStepperBodyOpacity:NumericStepper;
      public var mColorPickerBodyColor:ColorPicker;
      public var mButtonPickTextureModule:Button;
      
      public var mCheckBoxBuildBorder:CheckBox;
      public var mCheckBoxShowBorder:CheckBox;
      public var mNumericStepperBorderOpacity:NumericStepper;
      public var mColorPickerBorderColor:ColorPicker;
      public var mTextInputBorderThickness:TextInput;
      
      public var mTextInputPathThickness:TextInput;
      public var mCheckBoxPathClosed:CheckBox;
      public var mCheckBoxPathRoundEnds:CheckBox;
      
      public var mTextInputCircleRadius:TextInput;
      
      public var mCheckBoxRectRoundCorners:CheckBox;
      public var mTextInputRectWidth:TextInput;
      public var mTextInputRectHeight:TextInput;
      
      public var mButtonMoveUpModuleInstance:Button;
      public var mButtonMoveDownModuleInstance:Button;
      public var mButtonDeleteModuleInstances:Button;
      
      
      private function UpdatePropertySettingComponents ():void
      {         
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();

         if (! compositeModule.IsSequenced ())
         {
            if (mNumericStepperDuration.parent.parent != null) // == mFormBasicPropertySettings
               mNumericStepperDuration.parent.parent.removeChild (mNumericStepperDuration.parent);
         }
         else
         {
            if (mNumericStepperDuration.parent.parent == null)
               mFormBasicPropertySettings.addChild (mNumericStepperDuration.parent);
         }
         
         var numSelecteds:int = mAssetImageModuleInstanceManager.GetNumSelectedAssets ();
         
         if (numSelecteds == 1)
         {
            var moudleInstance:AssetImageModuleInstance = mAssetImageModuleInstanceManager.GetSelectedAssets ()[0] as AssetImageModuleInstance;
            
            var imageModule:AssetImageModule = moudleInstance.GetAssetImageModule ();

            mFormOtherPropertySettings.visible = true;
            while (mFormOtherPropertySettings.numChildren > 0)
               mFormOtherPropertySettings.removeChildAt (0);
            
            mFormOtherPropertySettings.addChild (mFormItemBlockTitle);
            
            if (imageModule is AssetImageShapeModule)
            {  
               var shapeImageModule:AssetImageShapeModule = imageModule as AssetImageShapeModule;
               var vectorShape:VectorShape = shapeImageModule.GetVectorShape () as VectorShape;
               
               mFormOtherPropertySettings.addChild (mCheckBoxBuildBody.parent);
               mFormOtherPropertySettings.addChild (mCheckBoxShowBody.parent);
               mFormOtherPropertySettings.addChild (mNumericStepperBodyOpacity.parent);
               mFormOtherPropertySettings.addChild (mColorPickerBodyColor.parent);
               
               if (vectorShape is VectorShapePath)
               {
                  var pathVectorShape:VectorShapePath = vectorShape as VectorShapePath;
                  
                  mFormOtherPropertySettings.addChild (mTextInputPathThickness.parent);
                  mFormOtherPropertySettings.addChild (mCheckBoxPathClosed.parent);
                  mFormOtherPropertySettings.addChild (mCheckBoxPathRoundEnds.parent);
                  
                  if (vectorShape is VectorShapePolyline)
                  {
                     var polylineShape:VectorShapePolyline = pathVectorShape as VectorShapePolyline;
                  }
               }
               else if (vectorShape is VectorShapeArea)
               {
                  mFormOtherPropertySettings.addChild (mButtonPickTextureModule.parent);
                  
                  var areaVectorShape:VectorShapeArea = vectorShape as VectorShapeArea;
               
                  mFormOtherPropertySettings.addChild (mCheckBoxBuildBorder.parent);
                  mFormOtherPropertySettings.addChild (mCheckBoxShowBorder.parent);
                  mFormOtherPropertySettings.addChild (mNumericStepperBorderOpacity.parent);
                  mFormOtherPropertySettings.addChild (mColorPickerBorderColor.parent);
                  mFormOtherPropertySettings.addChild (mTextInputBorderThickness.parent);
                  
                  if (vectorShape is VectorShapeCircle)
                  {
                     var circleShape:VectorShapeCircle = areaVectorShape as VectorShapeCircle;
                     
                     mFormOtherPropertySettings.addChild (mTextInputCircleRadius.parent);
                  }
                  else if (vectorShape is VectorShapePolygon)
                  {
                     var polygonShape:VectorShapePolygon = areaVectorShape as VectorShapePolygon;
                  }
                  else if (vectorShape is VectorShapeRectangle)
                  {
                     var rectangleShape:VectorShapeRectangle = areaVectorShape as VectorShapeRectangle;
                     
                     mFormOtherPropertySettings.addChild (mCheckBoxRectRoundCorners.parent);
                     mFormOtherPropertySettings.addChild (mTextInputRectWidth.parent);
                     mFormOtherPropertySettings.addChild (mTextInputRectHeight.parent);
                  }
                  
                  // texture
                  
               }
            }
            else // module ref, or AssetImageNullModule
            {
               mFormOtherPropertySettings.addChild (mButtonPickModule.parent);
            }
         }
      }
      
      override public function UpdateInterface ():void
      {
         if (mAssetImageModuleInstanceManager == null)
            return;
         
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();
         
         var numSelecteds:int = mAssetImageModuleInstanceManager.GetNumSelectedAssets ();
         
         mButtonDeleteModuleInstances.enabled = numSelecteds > 0;
         if (numSelecteds == 1)
         {
            var moudleInstance:AssetImageModuleInstance = mAssetImageModuleInstanceManager.GetTheFirstSelectedAsset () as AssetImageModuleInstance;
            
            mButtonMoveUpModuleInstance.enabled = moudleInstance.GetAppearanceLayerId () > 0;
            mButtonMoveDownModuleInstance.enabled = moudleInstance.GetAppearanceLayerId () < mAssetImageModuleInstanceManager.GetNumAssets () - 1;
            
            mFormBasicPropertySettings.enabled = true;
            
            mNumericStepperDuration.enabled = true; mNumericStepperDuration.value = moudleInstance.GetDuration ();
            
            mTextInputPosX.enabled   = true; mTextInputPosX.text   = "" + moudleInstance.GetPositionX ();
            mTextInputPosY.enabled   = true; mTextInputPosY.text   = "" + moudleInstance.GetPositionY ();
            mTextInputScale.enabled  = true; mTextInputScale.text  = "" + moudleInstance.GetScale ();
            mCheckBoxFlipped.enabled = true; mCheckBoxFlipped.selected = moudleInstance.IsFlipped ();
            mTextInputAngle.enabled  = true; mTextInputAngle.text  = "" + moudleInstance.GetRotation () * 180.0 / Math.PI;
            mTextInputAlpha.enabled = true; mTextInputAlpha.text = "" + moudleInstance.GetAlpha ();
            mCheckBoxVisible.enabled = true; mCheckBoxVisible.selected = moudleInstance.IsVisible ();
            
            var imageModule:AssetImageModule = moudleInstance.GetAssetImageModule ();
            var shapeBodyTexutureModule:AssetImageBitmapModule = moudleInstance.GetBodyTextureModule ();

            mFormOtherPropertySettings.enabled = true;
            
            if (imageModule is AssetImageShapeModule)
            {  
               var shapeImageModule:AssetImageShapeModule = imageModule as AssetImageShapeModule;
               var vectorShape:VectorShape = shapeImageModule.GetVectorShape () as VectorShape;
               
               mCheckBoxBuildBody.selected = vectorShape.IsBuildBackground ();
               mCheckBoxShowBody.selected = vectorShape.IsDrawBackground ();
               mNumericStepperBodyOpacity.value = vectorShape.GetBodyOpacity100 ();
               mColorPickerBodyColor.selectedColor = vectorShape.GetBodyColor ();
               
               if (vectorShape is VectorShapePath)
               {
                  var pathVectorShape:VectorShapePath = vectorShape as VectorShapePath;
                  
                  mTextInputPathThickness.text = "" + pathVectorShape.GetPathThickness ();
                  mCheckBoxPathClosed.selected = pathVectorShape.IsClosed ();
                  mCheckBoxPathRoundEnds.selected = pathVectorShape.IsRoundEnds ();
                  
                  if (vectorShape is VectorShapePolyline)
                  {
                     var polylineShape:VectorShapePolyline = pathVectorShape as VectorShapePolyline;
                  }
               }
               else if (vectorShape is VectorShapeArea)
               {
                  mButtonPickTextureModule.label = shapeBodyTexutureModule == null ? "Null" : shapeBodyTexutureModule.ToCodeString ();
                  
                  var areaVectorShape:VectorShapeArea = vectorShape as VectorShapeArea;
                  
                  mCheckBoxBuildBorder.selected = areaVectorShape.IsBuildBorder ();
                  mCheckBoxShowBorder.selected = areaVectorShape.IsDrawBorder ();
                  mNumericStepperBorderOpacity.value = areaVectorShape.GetBorderOpacity100 ();
                  mColorPickerBorderColor.selectedColor = areaVectorShape.GetBorderColor ();
                  mTextInputBorderThickness.text = "" + areaVectorShape.GetBorderThickness ();
                  
                  if (vectorShape is VectorShapeCircle)
                  {
                     var circleShape:VectorShapeCircle = areaVectorShape as VectorShapeCircle;
                     
                     mTextInputCircleRadius.text = "" + circleShape.GetRadius ();
                  }
                  else if (vectorShape is VectorShapePolygon)
                  {
                     var polygonShape:VectorShapePolygon = areaVectorShape as VectorShapePolygon;
                  }
                  else if (vectorShape is VectorShapeRectangle)
                  {
                     var rectangleShape:VectorShapeRectangle = areaVectorShape as VectorShapeRectangle;
                     
                     mCheckBoxRectRoundCorners.selected = rectangleShape.IsRoundCorners ();
                     mTextInputRectWidth.text = "" + (2.0 * rectangleShape.GetHalfWidth ());
                     mTextInputRectHeight.text = "" + (2.0 * rectangleShape.GetHalfHeight ());
                  }
               }
            }
            else // other module ref or AssetImageNullModule
            {
               mButtonPickModule.label = imageModule.ToCodeString ();
            }
         }
         else
         {  
            mButtonMoveUpModuleInstance.enabled = false;
            mButtonMoveDownModuleInstance.enabled = false;
            
            mFormBasicPropertySettings.enabled = false;

            mNumericStepperDuration.value = 0;
            mTextInputPosX.text   = "";
            mTextInputPosY.text   = "";
            mTextInputScale.text  = "";
            mCheckBoxFlipped.selected = false;
            mTextInputAngle.text  = "";
            mTextInputAlpha.text = "";
            mCheckBoxVisible.selected = false;
            
            mFormOtherPropertySettings.enabled = false;
         }
      }
      
      public function SychronizeCompositeModulePropertiesFromUI ():void
      {
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();
         
         //if (compositeModule.IsSequenced ())
         //{
            //compositeModule.SetLooped (mCheckBoxLoop.selected);
            //mAssetImageModuleInstanceManager.SetShowAllSequences (mCheckBoxShowAllSequences.selected);
         //}
      }
      
      public function ChangeModuleForCurrentModuleInstacne (asset:Asset):void
      {
         var module:AssetImageModule = asset as AssetImageModule;
         
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();
         
         if (mAssetImageModuleInstanceManager.GetNumSelectedAssets () == 1)
         {
            var moduleInstance:AssetImageModuleInstance = mAssetImageModuleInstanceManager.GetSelectedAssets ()[0] as AssetImageModuleInstance;
            
            moduleInstance.RebuildFromModule (module);
         }
      }
      
      public function ChangeTextureModuleForCurrentShapeModuleInstacne (asset:Asset):void
      {
         var bitmapModule:AssetImageBitmapModule = asset as AssetImageBitmapModule;
         
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();
         
         if (mAssetImageModuleInstanceManager.GetNumSelectedAssets () == 1)
         {
            var moduleInstance:AssetImageModuleInstance = mAssetImageModuleInstanceManager.GetSelectedAssets ()[0] as AssetImageModuleInstance;
            if (moduleInstance.SetBodyTextureModule (bitmapModule))
            {
               moduleInstance.UpdateAppearance ();
               
               moduleInstance.NotifyModifiedForReferers ();
               
               UpdateInterface ();
            }
         }
      }
      
      public function SychronizeCurrentModuleInstacnePropertiesFromUI ():void
      {
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();
         
         if (mAssetImageModuleInstanceManager.GetNumSelectedAssets () == 1)
         {
            var moduleInstance:AssetImageModuleInstance = mAssetImageModuleInstanceManager.GetSelectedAssets ()[0] as AssetImageModuleInstance;
            
            var duration:int;
            
            var offsetX:Number = MathUtil.ParseNumber (mTextInputPosX.text, 0.0);
            var offsetY:Number = MathUtil.ParseNumber (mTextInputPosY.text, 0.0);
            var scaleValue:Number = MathUtil.ParseNumber (mTextInputScale.text, 1.0, - Number.MAX_VALUE, Number.MAX_VALUE);
            var angleDegrees:Number = MathUtil.ParseNumber (mTextInputAngle.text, 0.0);
            var alphaValue:Number = MathUtil.ParseNumber (mTextInputAlpha.text, 1.0, 0.0, 1.0);
            
            moduleInstance.SetTransformParameters (offsetX, offsetY, scaleValue, mCheckBoxFlipped.selected, angleDegrees);
            moduleInstance.SetDuration (mNumericStepperDuration.value);
            moduleInstance.SetAlpha (alphaValue);
            moduleInstance.SetVisible (mCheckBoxVisible.selected);
            
            // ...
            
            var imageModule:AssetImageModule = moduleInstance.GetAssetImageModule ();

            if (imageModule is AssetImageShapeModule)
            {  
               var shapeImageModule:AssetImageShapeModule = imageModule as AssetImageShapeModule;
               var vectorShape:VectorShape = shapeImageModule.GetVectorShape () as VectorShape;
               
               vectorShape.SetBuildBackground (mCheckBoxBuildBody.selected);
               vectorShape.SetDrawBackground (mCheckBoxShowBody.selected);
               vectorShape.SetBodyOpacity100 (mNumericStepperBodyOpacity.value);
               vectorShape.SetBodyColor (mColorPickerBodyColor.selectedColor);
               
               if (vectorShape is VectorShapePath)
               {
                  var pathVectorShape:VectorShapePath = vectorShape as VectorShapePath;
                  
                  pathVectorShape.SetPathThickness (MathUtil.ParseNumber (mTextInputPathThickness.text, 1.0, 0.0, Number.MAX_VALUE));
                  pathVectorShape.SetClosed (mCheckBoxPathClosed.selected);
                  pathVectorShape.SetRoundEnds (mCheckBoxPathRoundEnds.selected);
                  
                  if (vectorShape is VectorShapePolyline)
                  {
                     var polylineShape:VectorShapePolyline = pathVectorShape as VectorShapePolyline;
                  }
               }
               else if (vectorShape is VectorShapeArea)
               {
                  var areaVectorShape:VectorShapeArea = vectorShape as VectorShapeArea;
                  
                  areaVectorShape.SetBuildBorder (mCheckBoxBuildBorder.selected);
                  areaVectorShape.SetDrawBorder (mCheckBoxShowBorder.selected);
                  areaVectorShape.SetBorderOpacity100 (mNumericStepperBorderOpacity.value);
                  areaVectorShape.SetBorderColor (mColorPickerBorderColor.selectedColor);
                  areaVectorShape.SetBorderThickness (MathUtil.ParseNumber (mTextInputBorderThickness.text, 1.0, 0.0, Number.MAX_VALUE));
                  
                  if (vectorShape is VectorShapeCircle)
                  {
                     var circleShape:VectorShapeCircle = areaVectorShape as VectorShapeCircle;
                     
                     circleShape.SetRadius (MathUtil.ParseNumber (mTextInputCircleRadius.text, 1.0, Define.kFloatEpsilon, Number.MAX_VALUE));
                  }
                  else if (vectorShape is VectorShapePolygon)
                  {
                     var polygonShape:VectorShapePolygon = areaVectorShape as VectorShapePolygon;
                  }
                  else if (vectorShape is VectorShapeRectangle)
                  {
                     var rectangleShape:VectorShapeRectangle = areaVectorShape as VectorShapeRectangle;
                     
                     rectangleShape.SetRoundCorners (mCheckBoxRectRoundCorners.selected);
                     rectangleShape.SetHalfWidth (0.5 * MathUtil.ParseNumber (mTextInputRectWidth.text, 1.0, Define.kFloatEpsilon, Number.MAX_VALUE));
                     rectangleShape.SetHalfHeight (0.5 * MathUtil.ParseNumber (mTextInputRectHeight.text, 1.0, Define.kFloatEpsilon, Number.MAX_VALUE));
                  }
               }
            }
            else // module ref, or AssetImageNullModule
            {
            }
            
            moduleInstance.UpdateAppearance ();
            moduleInstance.UpdateSelectionProxy ();
            moduleInstance.UpdateControlPoints ();
            
            moduleInstance.NotifyModifiedForReferers ();
            UpdateInterface ();
         }
      }
      
   }
}
