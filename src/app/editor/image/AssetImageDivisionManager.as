
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import editor.runtime.Runtime;
   
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
         
         GetAssetImageSprite (true); // for panel
      }
      
      public function GetAssetImage ():AssetImage
      {
         return mAssetImage;
      }
      
      // for panel using
      private var mImageSprite:Sprite = new Sprite ();
      public function GetAssetImageSprite (rebuild:Boolean = false):Sprite
      {
         if (rebuild)
         {
            while (mImageSprite.numChildren > 0)
               mImageSprite.removeChildAt (0);
            
            var bitmapData:BitmapData = mAssetImage.GetBitmapData ();
            if (bitmapData != null)
            {
               mImageSprite.addChild (new Bitmap (bitmapData));
            }
         }
         
         return mImageSprite;
      }
      
      public function OnAssetImagePixelsChanged ():void
      {
         var numDivisons:int = GetNumAssets ();
         for (var i:int = 0; i < numDivisons; ++ i)
         {
            var division:AssetImageDivision = GetAssetByAppearanceId (i) as AssetImageDivision;
            division.UpdatePixels ();
         }
         
         GetAssetImageSprite (true); // for panel
      }
      
//================================================================
//
//================================================================
      
      override public function SupportScaleRotateFlipTransforms ():Boolean
      {
         return false;
      }
      
//================================================================
//
//================================================================
      
      override public function DestroyAsset (asset:Asset):void
      {
         var division:AssetImageDivision = asset as AssetImageDivision;
         var pureModule:AssetImagePureModule = division.GetImagePureModule ();
         
         super.DestroyAsset (asset); // the division
         
         if (pureModule != null && (! pureModule.IsDestroyed ()))
         {
            var assetImagePureModuleManager:AssetImagePureModuleManager = pureModule.GetAssetImagePureModuleManager ();
            assetImagePureModuleManager.DestroyAsset (pureModule);
            assetImagePureModuleManager.RearrangeAssetPositions (true);
         }
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
         imageDivision.UpdateAppearance ();
         imageDivision.UpdateSelectionProxy ();
         addChild (imageDivision);
         
         if (selectIt)
            SetSelectedAsset (imageDivision);
         
         Runtime.GetCurrentWorld ().GetAssetImagePureModuleManager ().CreateImagePureModule (imageDivision, selectIt);
         
         return imageDivision;
      }
      
   }
}

