
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.geom.Rectangle;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
         
   import flash.net.FileReference;
   import flash.net.FileFilter;
   import flash.events.IOErrorEvent;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.LocalImageLoader;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
   import common.Define;
   
   public class AssetImageModuleInstanceForListing extends AssetImageModule
   {  
      protected var mAssetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing;
      
      protected var mAssetImageModule:AssetImageModule;
      
      public function AssetImageModuleInstanceForListing (assetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing, assetImageModule:AssetImageModule)
      {
         super (assetImageModuleInstanceManagerForListing);
         
         mAssetImageModuleInstanceManagerForListing = assetImageModuleInstanceManagerForListing;
         
         mAssetImageModule = assetImageModule;
         mReferPair = ReferObject (mAssetImageModule);
      }
      
      public function GetAssetImageModuleInstanceManagerForListing ():AssetImageModuleInstanceManagerForListing
      {
         return mAssetImageModuleInstanceManagerForListing;
      }
      
      public function GetAssetImageModule ():AssetImageModule
      {
         return mAssetImageModule;
      }
      
      override public function ToCodeString ():String
      {
         return mAssetImageModule == null ? "" : mAssetImageModule.ToCodeString ();
      }
      
      override public function GetTypeName ():String
      {
         return mAssetImageModule == null ? "" : mAssetImageModule.GetTypeName ();
      }
      
//=============================================================
//   
//=============================================================
      
      private var mReferPair:ReferPair;
      
      override public function OnReferingModified (refering:EditorObject, info:Object = null):void
      {
         if (refering == mAssetImageModule)
         {
            UpdateAppearance ();
         }
      }

      override public function OnReferingDestroyed (refering:EditorObject):void
      {
         if (refering == mAssetImageModule)
         {
            mAssetImageModuleInstanceManagerForListing.DestroyAsset (this);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      override public function CreateModuleSprite ():DisplayObject
      {
         if (mAssetImageModule == null)
            return null;
         
         return mAssetImageModule.CreateModuleSprite ();
      }
      
      override public function GetModuleBoundingRectangle ():Rectangle
      {
         if (mAssetImageModule == null)
            return null;
         
         return mAssetImageModule.GetModuleBoundingRectangle ();
      }

  }
}