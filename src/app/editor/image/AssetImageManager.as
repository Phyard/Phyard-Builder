
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageManager extends AssetImageModuleManager //AssetManager 
   {  
      public function CreateImage (insertBeforeSelectedThenSelectNew:Boolean):AssetImage
      {
         var image:AssetImage = new AssetImage (this);
         image.UpdateAppearance ();
         image.UpdateSelectionProxy ();
         addChild (image);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (image);
         
         RearrangeAssetPositions (true);
         
         return image;
      }
      
      
   }
}

