
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
      
      protected var mAssetImageModule:AssetImageModule = null;
      
      protected var mAssetImageModuleInstanceForEditingPeer:AssetImageModuleInstance;
      
      public function AssetImageModuleInstanceForListing (assetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing, assetImageModule:AssetImageModule)
      {
         super (assetImageModuleInstanceManagerForListing);
         
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage); // added in super class
         
         mAssetImageModuleInstanceManagerForListing = assetImageModuleInstanceManagerForListing;
         
         SetAssetImageModule (assetImageModule);
      }
      
      public function GetAssetImageModuleInstanceManagerForListing ():AssetImageModuleInstanceManagerForListing
      {
         return mAssetImageModuleInstanceManagerForListing;
      }
      
      public function GetAssetImageModule ():AssetImageModule
      {
         return mAssetImageModule;
      }
      
      public function GetModuleInstaneForEditingPeer ():AssetImageModuleInstance
      {
         return mAssetImageModuleInstanceForEditingPeer;
      }
      
      public function SetModuleInstaneForEditingPeer (moduleInstacne:AssetImageModuleInstance):void
      {
         mAssetImageModuleInstanceForEditingPeer = moduleInstacne;
      }
      
      public function SetAssetImageModule (assetImageModule:AssetImageModule):void
      {
         if (mReferPair != null)
         {
            mReferPair.Break ();
            mAssetImageModule = null;
         }
         
         if (assetImageModule != null)
         {
            mAssetImageModule = assetImageModule;
            mReferPair = ReferObject (mAssetImageModule);
         }
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
      
      override public function OnReferingModified (referPair:ReferPair, info:Object = null):void
      {
         if (referPair == mReferPair)
         {
            UpdateAppearance ();
         }
      }

      override public function OnReferingDestroyed (referPair:ReferPair):void
      {
         if (referPair == mReferPair)
         {
            mAssetImageModuleInstanceManagerForListing.DestroyAsset (this);
            mReferPair = null;
            mAssetImageModule = null;
         }
      }
      
//=============================================================
//   
//=============================================================
      
      override public function BuildImageModuleSprite ():DisplayObject
      {
         if (mAssetImageModule == null)
            return null;
         
         return mAssetImageModule.BuildImageModuleSprite ();
      }
      
      // this function is useless for this class
      override public function GetImageModuleBoundingRectangle ():Rectangle
      {
         return null;
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         mAssetImageModuleManager.BuildContextMenuInternal (customMenuItemsStack);
      }

  }
}