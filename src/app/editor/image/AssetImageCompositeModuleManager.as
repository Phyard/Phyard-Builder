
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageCompositeModuleManager extends AssetImageModuleManager //AssetManager 
   {
      public function CreateImageCompositeModule (insertBeforeSelectedThenSelectNew:Boolean):AssetImageCompositeModule
      {
         var module:AssetImageCompositeModule = new AssetImageCompositeModule (this);
         module.UpdateAppearance ();
         module.UpdateSelectionProxy ();
         addChild (module);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (module);
         
         return module;
      }
      
   }
}

