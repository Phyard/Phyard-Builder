
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImagePureModuleManager extends AssetImageModuleManager 
   {
      public function CreateImagePureModule (imageDivision:AssetImageDivision, insertBeforeSelectedThenSelectNew:Boolean):AssetImagePureModule
      {
         var module:AssetImagePureModule = new AssetImagePureModule (this, imageDivision);
         module.UpdateAppearance ();
         module.UpdateSelectionProxy ();
         addChild (module);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (module);
         
         return module;
      }
      
   }
}

