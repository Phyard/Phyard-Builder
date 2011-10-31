
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
         var pureModule:AssetImagePureModule = division.GetImagePureModulePeer ();
         
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
         if (left < 0)
            left = 0;
         if (right < 0)
            right = 0;
         if (top < 0)
            top = 0;
         if (bottom < 0)
            bottom = 0;
         
         var temp:Number;
         if (left > right)
         {
            temp = left;
            left = right;
            right = temp;
         }
         if (top > bottom)
         {
            temp = top;
            top = bottom;
            bottom = temp;
         }
         
         if (selectIt) // editing stage, not loading stage
         {
            if (Math.round (left) == Math.round (right)|| Math.abs (top) == Math.round (bottom))
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

