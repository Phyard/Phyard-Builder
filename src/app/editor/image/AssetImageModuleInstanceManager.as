
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageModuleInstanceManager extends AssetManager
   {
      protected var mForListing:Boolean = false;
      
      public function AssetImageModuleInstanceManager (forListing:Boolean)
      {
         mForListing = forListing;
      }
      
      public function IsForListing ():Boolean
      {
         return mForListing;
      }
      
      public function CreateImageModuleInstance (module:AssetImageModule, selectIt:Boolean = false):AssetImageModuleInstance
      {
         var moduleInstane:AssetImageModuleInstance = new AssetImageModuleInstance (this, module);
         moduleInstane.UpdateAppearance ();
         moduleInstane.UpdateSelectionProxy ();
         addChild (moduleInstane);
         
         if (selectIt)
            SetSelectedAsset (moduleInstane);
         
         return moduleInstane;
      }
   }
}
