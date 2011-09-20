
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
   
   import editor.runtime.Runtime;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageCompositeModuleEditingPanel extends AssetManagerPanel
   {
      protected var mAssetImageModuleInstanceManager:AssetImageModuleInstanceManager;
      
      public function AssetImageCompositeModuleEditingPanel ()
      {
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
         }
      }
      
      protected var mAssetImageModuleInstanceListingPanel:AssetImageModuleInstanceListingPanel;
      public function SetAssetImageModuleInstanceListingPanelPeer (assetImageModuleInstanceListingPanel:AssetImageModuleInstanceListingPanel):void
      {
         mAssetImageModuleInstanceListingPanel = assetImageModuleInstanceListingPanel;
      }
      
//=====================================================================
//
//=====================================================================
      
      override public function OnAssetSelectionsChanged (passively:Boolean = false):void
      {  
         super.OnAssetSelectionsChanged ();
         
         if (passively)
            return;
         
         if (mAssetImageModuleInstanceListingPanel != null)
         {
            mAssetImageModuleInstanceListingPanel.GetAssetImageModuleInstanceManagerForListing ().GetAssetImageCompositeModule ().SynchronizeManagerSelectionsFromEdittingToListing ();
            
            mAssetImageModuleInstanceListingPanel.OnAssetSelectionsChanged (true);
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
      }
      
      public function MoveModuleInstanceDown ():void
      {
      }
      
//====================================================================================
//   
//====================================================================================
      
      public function Play ():void
      {
         mAssetImageModuleInstanceManager.SetPlaying (true);
      }
      
      public function Pause ():void
      {
         mAssetImageModuleInstanceManager.SetPlaying (false);
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
      public var mCheckBoxShowAllParts:CheckBox;
      
      override public function UpdateInterface ():void
      {
         if (mAssetImageModuleInstanceManager == null)
            return;
         
         var numSelecteds:int = mAssetImageModuleInstanceManager.GetNumSelectedAssets ();
         
         mButtonDeleteModuleInstances.enabled = numSelecteds > 0;
         if (numSelecteds == 1)
         {
            var moduleinstance:AssetImageModuleInstance = mAssetImageModuleInstanceManager.GetSelectedAssets ()[0] as AssetImageModuleInstance;
            
            mNumericStepperDuration.enabled = true; mNumericStepperDuration.value = moduleinstance.GetDuration ();
            
            mTextInputPosX.enabled   = true; mTextInputPosX.text   = "" + moduleinstance.GetPositionX ();
            mTextInputPosY.enabled   = true; mTextInputPosY.text   = "" + moduleinstance.GetPositionY ();
            mTextInputScale.enabled  = true; mTextInputScale.text  = "" + moduleinstance.GetScale ();
            mCheckBoxFlipped.enabled = true; mCheckBoxFlipped.selected = moduleinstance.IsFlipped ();
            mTextInputAngle.enabled  = true; mTextInputAngle.text  = "" + moduleinstance.GetRotation () * 180.0 / Math.PI;
         }
         else
         {
            mNumericStepperDuration.enabled = false; mNumericStepperDuration.value = 0;
            
            mTextInputPosX.enabled   = false; mTextInputPosX.text   = "";
            mTextInputPosY.enabled   = false; mTextInputPosY.text   = "";
            mTextInputScale.enabled  = false; mTextInputScale.text  = "";
            mCheckBoxFlipped.enabled = false;
            mTextInputAngle.enabled  = false; mTextInputAngle.text  = "";
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
            mCheckBoxShowAllParts.selected = mAssetImageModuleInstanceManager.IsShowAllParts ();
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
            mAssetImageModuleInstanceManager.SetShowAllParts (mCheckBoxShowAllParts.selected);
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
