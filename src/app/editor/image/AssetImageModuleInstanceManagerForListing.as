
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageModuleInstanceManagerForListing extends AssetImageModuleManager
   {
      protected var mAssetImageCompositeModule:AssetImageCompositeModule;
      
      public function AssetImageModuleInstanceManagerForListing (assetImageCompositeModule:AssetImageCompositeModule):void
      {
         mAssetImageCompositeModule = assetImageCompositeModule;
      }
      
      public function GetAssetImageCompositeModule ():AssetImageCompositeModule
      {
         return mAssetImageCompositeModule;
      }
      
//==========================================================      
// 
//==========================================================      
      
      override public function GetModuleIconSize ():Number
      {
         return 66;
      }
      
//==========================================================      
// 
//==========================================================      

      public function CreateImageModuleInstanceForListing (module:AssetImageModule, selectIt:Boolean = false, atIndex:int = -1):AssetImageModuleInstanceForListing
      {
         var moduleInstane:AssetImageModuleInstanceForListing = new AssetImageModuleInstanceForListing (this, module);
         
         if (atIndex < 0 || atIndex > GetNumAssets ())
            addChild (moduleInstane);
         else
            addChildAt (moduleInstane, atIndex);
         
         moduleInstane.UpdateAppearance ();
         moduleInstane.UpdateSelectionProxy ();
         
         
         if (selectIt)
            SetSelectedAsset (moduleInstane);
         
         UpdateLayout (true);
         
         return moduleInstane;
      }
      
//==========================================================      
// 
//========================================================== 
      
      // for loading
      public function DestroyAllModuleInstances (passively:Boolean = false):void
      {
         DestroyAllAssets ();
         
         if (! passively)
         {
            mAssetImageCompositeModule.GetModuleInstanceManager ().DestroyAllModuleInstances (true);
         }
      }
      
      override public function DeleteSelectedAssets (passively:Boolean = false):Boolean
      {
         if (super.DeleteSelectedAssets ())
         {
            if (! passively)
            {
               mAssetImageCompositeModule.GetModuleInstanceManager ().DeleteSelectedAssets (true);
            }
            
            UpdateLayout (true);
            
            return true;
         }
         
         return false;
      }
      
      override public function MoveSelectedAssetsToIndex (aCurrentIndex:int):void
      {
         super.MoveSelectedAssetsToIndex (aCurrentIndex);
         
         NotifyPeerAppearanceOrdersChanged ();
      }
      
      private function NotifyPeerAppearanceOrdersChanged ():void
      {  
         mAssetImageCompositeModule.SynchronizePartAppearanceOrdersFromListingToEditing ();
         mAssetImageCompositeModule.GetModuleInstanceManager ().UpdateLayout (true);
         mAssetImageCompositeModule.GetModuleInstanceManager ().NotifyModifiedForReferers ();
         mAssetImageCompositeModule.GetModuleInstanceManager ().NotifyChangedForPanel ();
      }
      
      public function MoveUpDownTheOnlySelectedModuleInstance (moveUp:Boolean):void
      {  
         var selectedMoudleInstances:Array = GetSelectedAssets ();
         if (selectedMoudleInstances.length != 1)
            return;
         
         var moudleInstance:AssetImageModuleInstanceForListing = selectedMoudleInstances [0] as AssetImageModuleInstanceForListing;
         var oldIndex:int = moudleInstance.GetAppearanceLayerId ();
         var newIndex:int;
         if (moveUp)
         {
            if (oldIndex <= 0)
               return;
            
            newIndex = oldIndex - 1;
         }
         else
         {
            if (oldIndex >= GetNumAssets () - 1)
               return;
            
            newIndex = oldIndex + 2;
         }
         
         MoveSelectedAssetsToIndex (newIndex);
         UpdateLayout (true);
         
         NotifyPeerAppearanceOrdersChanged ();
         
         //AdjustAssetAppearanceOrder (moudleInstance, newIndex);
         //moudleInstance.GetModuleInstaneForListingPeer ().GetAssetImageModuleInstanceManagerForListing ().AdjustAssetAppearanceOrder (moudleInstance.GetModuleInstaneForListingPeer (), newIndex);
         //
         //moudleInstance.GetModuleInstaneForListingPeer ().GetAssetImageModuleInstanceManagerForListing ().UpdateLayout (true);
         //
         //NotifyChangedForPanel ();
      }
      
      // originally put in AssetImageModuleInstanceManager
      //public function MoveUpDownTheOnlySelectedModuleInstance (moveUp:Boolean):void
      //{  
      //   var selectedMoudleInstances:Array = GetSelectedAssets ();
      //   if (selectedMoudleInstances.length != 1)
      //      return;
      //   
      //   var moudleInstance:AssetImageModuleInstance = selectedMoudleInstances [0] as AssetImageModuleInstance;
      //   var oldIndex:int = moudleInstance.GetAppearanceLayerId ();
      //   var newIndex:int;
      //   if (moveUp)
      //   {
      //      if (oldIndex <= 0)
      //         return;
      //      
      //      newIndex = oldIndex - 1;
      //   }
      //   else
      //   {
      //      if (oldIndex >= GetNumAssets () - 1)
      //         return;
      //      
      //      newIndex = oldIndex + 1;
      //   }
      //   
      //   AdjustAssetAppearanceOrder (moudleInstance, newIndex);
      //   moudleInstance.GetModuleInstaneForListingPeer ().GetAssetImageModuleInstanceManagerForListing ().AdjustAssetAppearanceOrder (moudleInstance.GetModuleInstaneForListingPeer (), newIndex);
      //   
      //   moudleInstance.GetModuleInstaneForListingPeer ().GetAssetImageModuleInstanceManagerForListing ().UpdateLayout (true);
      //   
      //   NotifyChangedForPanel ();
      //}
   }
}
