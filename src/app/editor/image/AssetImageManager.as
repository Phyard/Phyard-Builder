
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageManager extends AssetManager 
   {
      public function AssetImageManager ()
      {
         super ();
      }
      
      public function CreateImage (insertBeforeSelectedThenSelectNew:Boolean):AssetImage
      {
         var image:AssetImage = new AssetImage (this);
         addChild (image);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (image);
         
         return image;
      }
      
   }
}

