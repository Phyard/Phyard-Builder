
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.AssetManager; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageDivisionManager extends AssetManager 
   {
      private var mAssetImage:AssetImage;
      
      public function AssetImageDivisionManager (assetImage:AssetImage)
      {
         super ();
         
         mAssetImage = assetImage;
      }
      
      public function GetAssetImage ():AssetImage
      {
         return mAssetImage;
      }
      
      public function CreateImageDivision (left:Number, top:Number, right:Number, bottom:Number, selectIt:Boolean = false):AssetImageDivision
      {
         if (! selectIt) // loading stage
         {
            if (Math.abs (left - right) == 0 || Math.abs (top - bottom) == 0)
               return null;
         }
         
         var imageDivision:AssetImageDivision = new AssetImageDivision (this);
         imageDivision.SetRegion (left, top, right, bottom);
         imageDivision.UpdateSelectionProxy ();
         addChild (imageDivision);
         
         if (selectIt)
            SetSelectedAsset (imageDivision);
         
         return imageDivision;
      }
      
   }
}

