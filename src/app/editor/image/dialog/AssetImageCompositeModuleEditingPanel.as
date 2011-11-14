
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
   
   import editor.asset.AssetManagerPanel;
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   import editor.asset.IntentDrag;
   import editor.asset.IntentTaps;
   
   import editor.image.AssetImageModule;
   import editor.image.AssetImageCompositeModule;
   import editor.image.AssetImageModuleInstance;
   import editor.image.AssetImageModuleInstanceManager;
   import editor.image.AssetImageShapeModule;
   import editor.image.AssetImageNullModule;
   
   import editor.display.sprite.CoordinateSprite;
   
   import editor.runtime.Runtime;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
   import common.shape.*;
   import common.Define;
   import common.Version;
   
   public class AssetImageCompositeModuleEditingPanel extends AssetManagerPanel
   {
      protected var mCoordinateSprite:CoordinateSprite = new CoordinateSprite ();
      protected var mAssetImageModuleInstanceManager:AssetImageModuleInstanceManager;
      
      public function AssetImageCompositeModuleEditingPanel ()
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
            
            MoveManager (0.5 * mParentWidth - mAssetImageModuleInstanceManager.x, 0.5 * mParentHeight - mAssetImageModuleInstanceManager.y);
         }
      }
      
      protected var mAssetImageModuleInstanceListingPanelPeer:AssetImageModuleInstanceListingPanel;
      public function SetAssetImageModuleInstanceListingPanelPeer (assetImageModuleInstanceListingPanel:AssetImageModuleInstanceListingPanel):void
      {
         mAssetImageModuleInstanceListingPanelPeer = assetImageModuleInstanceListingPanel;
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
         
         if (mAssetImageModuleInstanceManager != null && mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ().IsSequenced ())
         {
            mAssetImageModuleInstanceManager.UpdateModuleInstancesAlpha ();
         }
         
         if (! passively)
         {
            if (mAssetImageModuleInstanceListingPanelPeer != null)
            {
               mAssetImageModuleInstanceListingPanelPeer.GetAssetImageModuleInstanceManagerForListing ().GetAssetImageCompositeModule ().SynchronizeManagerSelectionsFromEdittingToListing ();
               
               mAssetImageModuleInstanceListingPanelPeer.OnAssetSelectionsChanged (true);
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
         
         // this one will call RearrangeAssetPositions
         if (mAssetImageModuleInstanceListingPanelPeer != null)
         {
            mAssetImageModuleInstanceListingPanelPeer.GetAssetImageModuleInstanceManagerForListing ().DeleteSelectedAssets ();
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

         if (mAssetImageModuleInstanceListingPanelPeer != null && mAssetImageModuleInstanceListingPanelPeer.GetAssetImageModuleInstanceManagerForListing () != null)
         {
            mAssetImageModuleInstanceListingPanelPeer.GetAssetImageModuleInstanceManagerForListing ().RearrangeAssetPositions (true);
         }
      }
      
      protected function OnPutCreateMouleInstacne (moduleInstance:AssetImageModuleInstance, done:Boolean):void
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
         
         OnCreatingShapeMouleInstacne (points, done);
      }
      
      protected function OnTapsCreatingShapeMouleInstacne (points:Array, currentX:Number, currentY:Number, isHoldMouse:Boolean):void
      {
         points.push (new Point (currentX, currentY));
         
         OnCreatingShapeMouleInstacne (points, false);
      }
      
      protected function OnCreatingShapeMouleInstacne (points:Array, done:Boolean):void
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
                                 mAssetImageModuleInstanceManager.CreateImageModuleInstance (AssetImageModule.mCurrentAssetImageModule, true), 
                                 OnPutCreateMouleInstacne, OnCreatingCancelled));
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
               SetCurrentIntent (new IntentTaps (this, OnCreatingShapeMouleInstacne, OnTapsCreatingShapeMouleInstacne, OnCreatingCancelled));
               break;
            case mButtonCreateShapePolylineInstance:
               mAssetImageModuleInstanceManager.CreateImageShapePolylineModuleInstance (true);
               SetCurrentIntent (new IntentTaps (this, OnCreatingShapeMouleInstacne, OnTapsCreatingShapeMouleInstacne, OnCreatingCancelled));
               break;
            case mButtonCreateShapeTextInstance:
               SetCurrentIntent (new IntentPutAsset (
                                 mAssetImageModuleInstanceManager.CreateImageShapeTextModuleInstance (true),
                                 OnPutCreateMouleInstacne, OnCreatingCancelled));
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
            if (imageModule is AssetImageNullModule)
            {
               mFormOtherPropertySettings.visible = false;
            }
            else
            { 
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
                  }
               }
               else // module ref
               {
                  mFormOtherPropertySettings.addChild (mButtonPickModule.parent);
               }
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
            
            mFormOtherPropertySettings.enabled = true;
            /*
            var imageModule:AssetImageModule = moudleInstance.GetAssetImageModule ();
            if (imageModule is AssetImageNullModule)
            {
            }
            else
            { 
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
                  }
               }
               else // module ref
               {
                  mFormOtherPropertySettings.addChild (mButtonPickModule.parent);
               }
            }
            */
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
      
      public function SychronizeCurrentModuleInstacnePropertiesFromUI ():void
      {
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();
         
         if (mAssetImageModuleInstanceManager.GetNumSelectedAssets () == 1)
         {
            var moduleInstance:AssetImageModuleInstance = mAssetImageModuleInstanceManager.GetSelectedAssets ()[0] as AssetImageModuleInstance;
            
            var duration:int;
            
            var offsetX:Number;
            var offsetY:Number;
            var scaleValue:Number;
            var angleDegrees:Number;
            var alphaValue:Number;
            
            try {
               offsetX = parseFloat (mTextInputPosX.text);
            } catch (err:Error) {
               offsetX = NaN;
            }
            if (isNaN (offsetX))
            {
               offsetX = 0.0;
            }
            
            try {
               offsetY = parseFloat (mTextInputPosY.text);
            } catch (err:Error) {
               offsetY = NaN;
            }
            if (isNaN (offsetY))
            {
               offsetY = 0.0;
            }
            
            try {
               scaleValue = parseFloat (mTextInputScale.text);
            } catch (err:Error) {
               scaleValue = NaN;
            }
            if (isNaN (scaleValue))
            {
               scaleValue = 0.0;
            }
            
            try {
               angleDegrees = parseFloat (mTextInputAngle.text);
            } catch (err:Error) {
               angleDegrees = NaN;
            }
            if (isNaN (angleDegrees))
            {
               angleDegrees = 0.0;
            }
            
            try {
               alphaValue = parseFloat (mTextInputAlpha.text);
            } catch (err:Error) {
               alphaValue = NaN;
            }
            if (isNaN (angleDegrees))
            {
               alphaValue = 1.0;
            }
            
            moduleInstance.SetTransformParameters (offsetX, offsetY, scaleValue, mCheckBoxFlipped.selected, angleDegrees);
            moduleInstance.SetDuration (mNumericStepperDuration.value);
            moduleInstance.SetAlpha (alphaValue);
            moduleInstance.SetVisible (mCheckBoxVisible.selected);
            
            moduleInstance.UpdateAppearance ();
            moduleInstance.UpdateSelectionProxy ();
            
            compositeModule.NotifyModifiedForReferers ();
            //UpdateInterface (); // NotifyModifiedForReferers will call this
         }
      }
      
   }
}
