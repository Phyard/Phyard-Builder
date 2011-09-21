
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
   import mx.containers.HBox;
   import mx.controls.Button;
   import mx.controls.NumericStepper;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.asset.AssetManagerPanel;
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   
   import editor.image.AssetImageCompositeModule;
   import editor.image.AssetImageModuleInstance;
   import editor.image.AssetImageModuleInstanceManager;
   
   import editor.display.sprite.CoordinateSprite;
   
   import editor.runtime.Runtime;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
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
         super.OnAssetSelectionsChanged ();
         
         if (mAssetImageModuleInstanceManager != null && mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ().IsAnimated ())
         {
            mAssetImageModuleInstanceManager.UpdateModuleInstancesAlpha ();
         }
         
         if (passively)
            return;
         
         if (mAssetImageModuleInstanceListingPanelPeer != null)
         {
            mAssetImageModuleInstanceListingPanelPeer.GetAssetImageModuleInstanceManagerForListing ().GetAssetImageCompositeModule ().SynchronizeManagerSelectionsFromEdittingToListing ();
            
            mAssetImageModuleInstanceListingPanelPeer.OnAssetSelectionsChanged (true);
         }
      }

//====================================================================================
//   
//====================================================================================
      
      public function DeleteModuleInstances ():void
      {
         if (mAssetImageModuleInstanceManager == null)
            return;
         
         mAssetImageModuleInstanceManager.DeleteSelectedAssets ();
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
      
      public var mButtonDeleteModuleInstances:Button;
      public var mViewStackPlayStop:ViewStack;
      public var mLabelDuration:Label;
      public var mNumericStepperDuration:NumericStepper;
      public var mTextInputPosX:TextInput;
      public var mTextInputPosY:TextInput;
      public var mTextInputScale:TextInput;
      public var mCheckBoxFlipped:CheckBox;
      public var mTextInputAngle:TextInput;
      
      public var mBoxModuleProperties:HBox;
      public var mLabelModuleInfos:Label;
      public var mCheckBoxLoop:CheckBox;
      public var mCheckBoxShowAllSequences:CheckBox;
      
      public var mButtonMoveUpModuleInstance:Button;
      public var mButtonMoveDownModuleInstance:Button;
      
      override public function UpdateInterface ():void
      {
         if (mAssetImageModuleInstanceManager == null)
            return;
         
         var numSelecteds:int = mAssetImageModuleInstanceManager.GetNumSelectedAssets ();
         
         mButtonDeleteModuleInstances.enabled = numSelecteds > 0;
         if (numSelecteds == 1)
         {
            var moudleInstance:AssetImageModuleInstance = mAssetImageModuleInstanceManager.GetSelectedAssets ()[0] as AssetImageModuleInstance;
            
            mNumericStepperDuration.enabled = true; mNumericStepperDuration.value = moudleInstance.GetDuration ();
            
            mTextInputPosX.enabled   = true; mTextInputPosX.text   = "" + moudleInstance.GetPositionX ();
            mTextInputPosY.enabled   = true; mTextInputPosY.text   = "" + moudleInstance.GetPositionY ();
            mTextInputScale.enabled  = true; mTextInputScale.text  = "" + moudleInstance.GetScale ();
            mCheckBoxFlipped.enabled = true; mCheckBoxFlipped.selected = moudleInstance.IsFlipped ();
            mTextInputAngle.enabled  = true; mTextInputAngle.text  = "" + moudleInstance.GetRotation () * 180.0 / Math.PI;
            
            mButtonMoveUpModuleInstance.enabled = moudleInstance.GetAppearanceLayerId () > 0;
            mButtonMoveDownModuleInstance.enabled = moudleInstance.GetAppearanceLayerId () < mAssetImageModuleInstanceManager.GetNumAssets () - 1;
         }
         else
         {
            mNumericStepperDuration.enabled = false; mNumericStepperDuration.value = 0;
            
            mTextInputPosX.enabled   = false; mTextInputPosX.text   = "";
            mTextInputPosY.enabled   = false; mTextInputPosY.text   = "";
            mTextInputScale.enabled  = false; mTextInputScale.text  = "";
            mCheckBoxFlipped.enabled = false;
            mTextInputAngle.enabled  = false; mTextInputAngle.text  = "";
            
            mButtonMoveUpModuleInstance.enabled = false;
            mButtonMoveDownModuleInstance.enabled = false;
         }
         
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();
         
         if (compositeModule.IsAnimated ())
         {
            mLabelDuration.visible = true;
            mNumericStepperDuration.visible = true;
            
            if (mBoxModuleProperties.parent == null)
            {
               this.parent.parent.addChildAt (mBoxModuleProperties, 0);
            }
            
            mCheckBoxLoop.selected = compositeModule.IsLooped ();
            mCheckBoxShowAllSequences.selected = mAssetImageModuleInstanceManager.IsShowAllSequences ();
         }
         else
         {
            mLabelDuration.visible = false;
            mNumericStepperDuration.visible = false;
            
            if (mBoxModuleProperties.parent != null)
            {
               this.parent.parent.removeChild (mBoxModuleProperties);
            }
         }
         
         if (compositeModule.IsPlayable ())
         {
            mViewStackPlayStop.visible = true;
         }
         else
         {
            mViewStackPlayStop.visible = false;
         }
      }
      
      public function SychronizeCompositeModulePropertiesFromUI ():void
      {
         var compositeModule:AssetImageCompositeModule = mAssetImageModuleInstanceManager.GetAssetImageCompositeModule ();
         
         //if (compositeModule.IsAnimated ())
         //{
            compositeModule.SetLooped (mCheckBoxLoop.selected);
            mAssetImageModuleInstanceManager.SetShowAllSequences (mCheckBoxShowAllSequences.selected);
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
            var scale:Number;
            var angleDegrees:Number;
            
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
               scale = parseFloat (mTextInputScale.text);
            } catch (err:Error) {
               scale = NaN;
            }
            if (isNaN (scale))
            {
               scale = 0.0;
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
            
            moduleInstance.SetTransformParameters (offsetX, offsetY, scale, mCheckBoxFlipped.selected, angleDegrees);
            moduleInstance.SetDuration (mNumericStepperDuration.value);
            
            moduleInstance.UpdateAppearance ();
            moduleInstance.UpdateSelectionProxy ();
            
            compositeModule.NotifyModifiedForReferers ();
            //UpdateInterface (); // NotifyModifiedForReferers will call this
         }
      }
      
   }
}
