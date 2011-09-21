
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
      
      override public function GetAssetSpriteSize ():Number
      {
         return 76;
      }

      override public function GetAssetSpriteGap ():Number
      {
         return 10;
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
      
      override public function DestroyAsset (asset:Asset):void
      {
         var moduleInstanceForListing:AssetImageModuleInstanceForListing = asset as AssetImageModuleInstanceForListing;
         var moduleInstance:AssetImageModuleInstance = moduleInstanceForListing.GetModuleInstaneForEditingPeer ();
         
         super.DestroyAsset (asset); // the module instance for listing
         
         if (! moduleInstance.IsDestroyed ())
         {
            moduleInstance.GetAssetImageModuleInstanceManager ().DestroyAsset (moduleInstance);
         }
      }

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
         
         RearrangeAssetPositions (true);
         
         return moduleInstane;
      }
   }
}
