
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageModuleInstanceManagerForListing extends AssetImageModuleManager
   {
      
      protected var mAssetImageModuleInstanceManager:AssetImageModuleInstanceManager;
      
      public function SetAssetImageModuleInstanceManager (assetImageModuleInstanceManager:AssetImageModuleInstanceManager):void
      {
         mAssetImageModuleInstanceManager = assetImageModuleInstanceManager;
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

      public function CreateImageModuleInstanceForListing (module:AssetImageModule, selectIt:Boolean = false):AssetImageModuleInstanceForListing
      {
         var moduleInstane:AssetImageModuleInstanceForListing = new AssetImageModuleInstanceForListing (this, module);
         moduleInstane.UpdateAppearance ();
         moduleInstane.UpdateSelectionProxy ();
         addChild (moduleInstane);
         
         if (selectIt)
            SetSelectedAsset (moduleInstane);
         
         RearrangeAssetPositions (true);
         
         return moduleInstane;
      }
   }
}
