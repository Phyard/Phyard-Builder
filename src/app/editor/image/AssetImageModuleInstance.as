
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
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
   
   public class AssetImageModuleInstance extends Asset
   {  
      protected var mAssetImageModuleInstanceManager:AssetImageModuleInstanceManager;
      
      protected var mAssetImageModule:AssetImageModule;
      
      public function AssetImageModuleInstance (assetImageModuleInstanceManager:AssetImageModuleInstanceManager, assetImageModule:AssetImageModule)
      {
         super (assetImageModuleInstanceManager);
         
         mAssetImageModuleInstanceManager = assetImageModuleInstanceManager;
         
         mAssetImageModule = assetImageModule;
         mReferPair = ReferObject (mAssetImageModule);
      }
      
      public function GetAssetImageModuleInstanceManager ():AssetImageModuleInstanceManager
      {
         return mAssetImageModuleInstanceManager;
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
      
      override public function OnReferingModified (refering:EditorObject):void
      {
         if (refering == mAssetImageModule)
         {
            UpdateAppearance ();
            UpdateSelectionProxy ();
         }
      }

      override public function OnReferingDestroyed (refering:EditorObject):void
      {
         if (refering == mAssetImageModule)
         {
            mAssetImageModuleInstanceManager.DestroyAsset (this);
         }
      }
      
//=============================================================
//   
//=============================================================

      /*
      override public function UpdateAppearance ():void
      {
         var moduleSize:Number = mAssetImageModuleInstanceManager.GetModuleSize ();
         var halfModuleSize:Number = 0.5 * moduleSize;
         GraphicsUtil.ClearAndDrawRect (this, - halfModuleSize, - halfModuleSize, moduleSize, moduleSize,
                                       IsSelected () ? 0x0000FF : 0x00FF00, 0, true, IsSelected () ? 0xC0C0FF : 0xC0FFC0, false);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         var moduleSize:Number = mAssetImageModuleInstanceManager.GetModuleSize ();
         var halfModuleSize:Number = 0.5 * moduleSize;
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (0, GetPosX (), GetPosY (), halfModuleSize, halfModuleSize);
      }
      */
      
  }
}