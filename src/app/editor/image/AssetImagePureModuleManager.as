
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.Asset; 
   import editor.asset.AssetManager; 
   
   import editor.runtime.Runtime;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImagePureModuleManager extends AssetImageModuleManager 
   {
      
//==========================================================      
// 
//==========================================================      
      /*
      override public function SetMainSelectedAsset (asset:Asset):void
      {
         super.SetMainSelectedAsset (asset);
         
         if (asset != null)
         {
            var imageDivision:AssetImageDivision = (asset as AssetImagePureModule).GetImageDivision ();
            if (imageDivision != null)
            {
               imageDivision.GetAssetImageDivisionManager ().SetSelectedAsset (imageDivision);
            }
         }
      }
      */
      
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

      public function CreateImagePureModule (imageDivision:AssetImageDivision, insertBeforeSelectedThenSelectNew:Boolean):AssetImagePureModule
      {
         var module:AssetImagePureModule = new AssetImagePureModule (this, imageDivision);
         module.UpdateAppearance ();
         module.UpdateSelectionProxy ();
         addChild (module);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (module);
         
         RearrangeAssetPositions (true);
         
         return module;
      }
      
   }
}

