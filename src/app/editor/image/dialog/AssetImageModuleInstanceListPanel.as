
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
   
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.asset.AssetManagerPanel;
   import editor.asset.Intent;
   import editor.asset.IntentPutAsset;
   
   import editor.asset.AssetManagerArrayLayout; 
   
   import editor.image.AssetImageModuleInstanceManagerForListing;
   import editor.image.AssetImageModuleInstance;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageModuleInstanceListPanel extends AssetManagerPanel 
   {
      protected var mAssetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing;
      
      public function AssetImageModuleInstanceListPanel ()
      {
      }
      
      public function GetAssetImageModuleInstanceManagerForListing ():AssetImageModuleInstanceManagerForListing
      {
         return mAssetImageModuleInstanceManagerForListing;
      }
      
      public function SetAssetImageModuleInstanceManagerForListing (assetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing):void
      {
         super.SetAssetManager (assetImageModuleInstanceManagerForListing);
          
         mAssetImageModuleInstanceManagerForListing = assetImageModuleInstanceManagerForListing;
         
         if (mAssetImageModuleInstanceManagerForListing != null && mAssetImageModuleInstanceManagerForListing.GetLayout () == null)
         {
            mAssetImageModuleInstanceManagerForListing.SetLayout (new AssetManagerArrayLayout (mAssetImageModuleInstanceManagerForListing, mAssetImageModuleInstanceManagerForListing.GetModuleIconSize () + 16));
            mAssetImageModuleInstanceManagerForListing.UpdateLayout (true, true);
         }
      }
      
      protected var mAssetImageCompositeModuleEditPanelPeer:AssetImageCompositeModuleEditPanel;
      public function SetAssetImageCompositeModuleEditPanelPeer (assetImageCompositeModuleEditingPanel:AssetImageCompositeModuleEditPanel):void
      {
         mAssetImageCompositeModuleEditPanelPeer = assetImageCompositeModuleEditingPanel;
      }
      
//=====================================================================
//
//=====================================================================
      
      public function RearrangeModuleInstancePositions ():void
      {
         if (mAssetImageModuleInstanceManagerForListing != null)
         {
            mAssetImageModuleInstanceManagerForListing.UpdateLayout (true);
         }
      }
      
      override public function OnAssetSelectionsChanged (passively:Boolean = false):void
      {  
         super.OnAssetSelectionsChanged ();
         
         if (passively)
            return;
         
         if (mAssetImageCompositeModuleEditPanelPeer != null)
         {
            mAssetImageCompositeModuleEditPanelPeer.GetAssetImageModuleInstanceManager ().GetAssetImageCompositeModule ().SynchronizeManagerSelectionsFromListingToEditing ();
            
            mAssetImageCompositeModuleEditPanelPeer.OnAssetSelectionsChanged (true);
         }
      }
      
//=====================================================================
//
//=====================================================================
      
      public function MoveModuleInstanceUp ():void
      {
         if (mAssetImageModuleInstanceManagerForListing == null)
            return;
         
         mAssetImageModuleInstanceManagerForListing.MoveUpDownTheOnlySelectedModuleInstance (true);
      }
      
      public function MoveModuleInstanceDown ():void
      {
         if (mAssetImageModuleInstanceManagerForListing == null)
            return;
         
         mAssetImageModuleInstanceManagerForListing.MoveUpDownTheOnlySelectedModuleInstance (false);
      }
      
//==========================================================      
// 
//========================================================== 
      
      private var mInPreviewMode:Boolean = false;
      
      private var mSelectedInstancesBeforePreviewing:Array = null;
      private var mIsTransformRingVisibleBeforePreviewing:Boolean = true;
      
      private var mNumFrames:int = 0;
      private var mCurrentFrame:int = 0;
      private var mCurrentFrameDuration:int = 0;
      private var mCurrentFrameStep:int = 0;
      
      public function SetInPreviewMode (preview:Boolean):void
      {
         if (mInPreviewMode == preview)
            return;
         
         mInPreviewMode = preview;
         
         if (mAssetImageModuleInstanceManagerForListing == null)
            return;
         
         if (mInPreviewMode) // start
         {
            mSelectedInstancesBeforePreviewing = mAssetImageModuleInstanceManagerForListing.GetAssetImageCompositeModule ().GetModuleInstanceManager ().GetSelectedAssets ();
            mIsTransformRingVisibleBeforePreviewing = mAssetImageCompositeModuleEditPanelPeer.IsShowScaleRotateFlipHandlers ();
            mAssetImageCompositeModuleEditPanelPeer.SetShowScaleRotateFlipHandlers (false);
            
            mNumFrames = mAssetImageModuleInstanceManagerForListing.GetAssetImageCompositeModule ().GetNumFrames ();

            mCurrentFrame = 0;
            OnPreviewFrameChanged ();
         }
         else // stop
         {
            mAssetImageModuleInstanceManagerForListing.GetAssetImageCompositeModule ().GetModuleInstanceManager ().SetSelectedAssets (mSelectedInstancesBeforePreviewing);
            mAssetImageCompositeModuleEditPanelPeer.SetShowScaleRotateFlipHandlers (mIsTransformRingVisibleBeforePreviewing);
         }
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mAssetImageModuleInstanceManagerForListing == null)
            return;
         
         if (mInPreviewMode)
         {
            if (mCurrentFrameStep >= mCurrentFrameDuration)
            {
               if (++ mCurrentFrame >= mNumFrames)
               {
                  mCurrentFrame = 0;
               }
               
               OnPreviewFrameChanged ();
            }
            else
            {
               ++ mCurrentFrameStep;
            }
         }
      }
      
      private function OnPreviewFrameChanged ():void
      {
         if (mCurrentFrame < 0 || mCurrentFrame >= mNumFrames)
            return;
         
         var moduleInstance:AssetImageModuleInstance = mAssetImageModuleInstanceManagerForListing.GetAssetImageCompositeModule ().GetModuleInstanceManager ().GetAssetByCreationId (mCurrentFrame) as AssetImageModuleInstance;
         mCurrentFrameDuration = moduleInstance.GetDuration ();
         mCurrentFrameStep = 0;
         
         mAssetImageModuleInstanceManagerForListing.GetAssetImageCompositeModule ().GetModuleInstanceManager ().SetSelectedAsset (moduleInstance);
      }
      
   }
}
