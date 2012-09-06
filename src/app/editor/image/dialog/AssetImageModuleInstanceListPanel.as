
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
      
   }
}
