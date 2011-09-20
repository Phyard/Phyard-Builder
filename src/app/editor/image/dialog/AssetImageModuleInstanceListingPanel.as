
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
   
   import editor.image.AssetImageModuleInstanceManagerForListing;
   
   import editor.runtime.Runtime;
   
   import common.Define;
   import common.Version;
   
   public class AssetImageModuleInstanceListingPanel extends AssetManagerPanel 
   {
      protected var mAssetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing;
      
      public function AssetImageModuleInstanceListingPanel ()
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
      }
      
      protected var mAssetImageCompositeModuleEditingPanel:AssetImageCompositeModuleEditingPanel;
      public function SetAssetImageCompositeModuleEditingPanelPeer (assetImageCompositeModuleEditingPanel:AssetImageCompositeModuleEditingPanel):void
      {
         mAssetImageCompositeModuleEditingPanel = assetImageCompositeModuleEditingPanel;
      }
      
//=====================================================================
//
//=====================================================================
      
      override public function OnAssetSelectionsChanged (passively:Boolean = false):void
      {  
         super.OnAssetSelectionsChanged ();
         
         if (passively)
            return;
         
         if (mAssetImageCompositeModuleEditingPanel != null)
         {
            mAssetImageCompositeModuleEditingPanel.GetAssetImageModuleInstanceManager ().GetAssetImageCompositeModule ().SynchronizeManagerSelectionsFromListingToEditing ();
            
            mAssetImageCompositeModuleEditingPanel.OnAssetSelectionsChanged (true);
         }
      } 
      
   }
}
