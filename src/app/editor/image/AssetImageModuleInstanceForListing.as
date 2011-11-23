
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
   import flash.events.MouseEvent;
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
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
   import common.Transform2D;
   
   import common.Define;
   
   public class AssetImageModuleInstanceForListing extends AssetImageModule
   {  
      protected var mAssetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing;
      
      protected var mAssetImageModule:AssetImageModule = null;
      
      protected var mAssetImageModuleInstanceForEditingPeer:AssetImageModuleInstance;
      
      public function AssetImageModuleInstanceForListing (assetImageModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing, assetImageModule:AssetImageModule)
      {
         super (assetImageModuleInstanceManagerForListing);
         
         removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown); // added in super class
         
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
         super.OnReferingModified (referPair, info);
         
         if (referPair == mReferPair)
         {
            UpdateAppearance ();
         }
      }

      override public function OnReferingDestroyed (referPair:ReferPair):void
      {
         super.OnReferingDestroyed (referPair);
         
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

      override public function BuildImageModuleAppearance (container:Sprite, transform:Transform2D = null):void
      {
         if (mAssetImageModule == null)
            return;
         
         return mAssetImageModule.BuildImageModuleAppearance (container, transform);
      }
      
      // this function is useless for this class
      override public function BuildImageModulePhysicsAppearance (container:Sprite, transform:Transform2D = null):void
      {
      }
      
      // this function is useless for this class
      override public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
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