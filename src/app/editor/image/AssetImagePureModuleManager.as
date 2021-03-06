
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.Asset; 
   import editor.asset.AssetManager;
   
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
      
      override public function GetModuleIconSize ():Number
      {
         return 66;
      }
      
//==========================================================      
// 
//========================================================== 
      
      override public function DestroyAsset (asset:Asset):void
      {
         var pureModule:AssetImagePureModule = asset as AssetImagePureModule;
         var division:AssetImageDivision = pureModule.GetImageDivisionPeer ();
         
         super.DestroyAsset (asset); // the pureModule
         
         if (! division.IsDestroyed ())
         {
            division.GetAssetImageDivisionManager ().DestroyAsset (division);
         }
      }

      public function CreateImagePureModule (key:String, imageDivision:AssetImageDivision, insertBeforeSelectedThenSelectNew:Boolean):AssetImagePureModule
      {
         var module:AssetImagePureModule = new AssetImagePureModule (this, imageDivision, ValidateAssetKey (key));
         module.UpdateAppearance ();
         module.UpdateSelectionProxy ();
         addChild (module);
         
         if (insertBeforeSelectedThenSelectNew)
            SetSelectedAsset (module);
         
         UpdateLayout (true);
         
         return module;
      }
        
//=====================================================================
// context menu
//=====================================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {  
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
   }
}

