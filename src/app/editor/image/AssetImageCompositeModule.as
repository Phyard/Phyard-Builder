
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
   import com.tapirgames.util.LocalImageLoader;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   
   import editor.image.dialog.AssetImageCompositeModuleEditDialog;
   
   import common.Transform2D;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageCompositeModule extends AssetImageModule
   {
      protected var mAssetImageCompositeModuleManager:AssetImageCompositeModuleManager;
      
      protected var mModuleInstanceManager:AssetImageModuleInstanceManager; // for internal module parts editing
      protected var mModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing; // for internal module parts listing
      
      public function AssetImageCompositeModule (assetImageCompositeModuleManager:AssetImageCompositeModuleManager, sequenced:Boolean)
      {
         super (assetImageCompositeModuleManager);
         
         mAssetImageCompositeModuleManager = assetImageCompositeModuleManager;
         SetSequenced (sequenced);
         
         mModuleInstanceManager           = new AssetImageModuleInstanceManager (this);
         mModuleInstanceManagerForListing = new AssetImageModuleInstanceManagerForListing (this);
         
         //if (IsSequenced ())
         //{
         //   removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown); // added in super class
         //}
      }
      
      public function GetAssetImageCompositeModuleManager ():AssetImageCompositeModuleManager
      {
         return mAssetImageCompositeModuleManager;
      }
      
      public function GetModuleInstanceManager ():AssetImageModuleInstanceManager
      {
         return mModuleInstanceManager;
      }
      
      public function GetModuleInstanceManagerForListing ():AssetImageModuleInstanceManagerForListing
      {
         return mModuleInstanceManagerForListing;
      }
      
      override public function ToCodeString ():String
      {
         return "Composite Module#" + mCreationOrderId;
      }
      
      override public function GetTypeName ():String
      {
         return "Composite Module";
      }
      
      public function GetNumModules ():int
      {
         return mModuleInstanceManager.GetNumAssets ();
      }
      
//=============================================================
//   
//=============================================================
      
      override public function Destroy ():void
      {
         super.Destroy ();
         
         if (mAssetImageCompositeModuleEditDialog != null)
         {
            mAssetImageCompositeModuleEditDialog.Hide ();
            mAssetImageCompositeModuleEditDialog = null;
         }
      }
      
//=============================================================
//   
//=============================================================
      
      override public function ContainsDescendant (module:AssetImageModule):Boolean
      {
         var numModules:int = mModuleInstanceManager.GetNumAssets ();
         for (var i:int = 0; i < numModules; ++ i)
         {
            var moduleInstance:AssetImageModuleInstance = mModuleInstanceManager.GetAssetByAppearanceId (i) as AssetImageModuleInstance;
            
            var instanceModule:AssetImageModule = moduleInstance.GetAssetImageModule ();
            if (instanceModule == module || instanceModule.ContainsDescendant (module))
            {
               return true;
            }
         }
         
         return false;
      }

      override public function BuildImageModuleAppearance (container:Sprite, transform:Transform2D = null):void
      {
         var numModules:int = mModuleInstanceManager.GetNumAssets ();
         
         if (IsSequenced ())
         {
            if (numModules > 1) numModules = 1;
         }
         
         for (var i:int = 0; i < numModules; ++ i)
         {
            var moduleInstance:AssetImageModuleInstance = mModuleInstanceManager.GetAssetByAppearanceId (i) as AssetImageModuleInstance;
            var finalTransform:Transform2D = new Transform2D (moduleInstance.GetPositionX (), moduleInstance.GetPositionY (), moduleInstance.GetScale (), moduleInstance.IsFlipped (), moduleInstance.GetRotation ());
            if (transform != null)
               finalTransform = Transform2D.CombineTransforms (transform, finalTransform);
            
            moduleInstance.GetAssetImageModule ().BuildImageModuleAppearance (container, finalTransform);
         }
      }
      
      override public function BuildImageModulePhysicsAppearance (container:Sprite, transform:Transform2D = null):void
      {
      }
      
      override public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {  
         var numModules:int = mModuleInstanceManager.GetNumAssets ();

         if (IsSequenced ())
         {
            if (numModules > 1) numModules = 1;
         }
         
         for (var i:int = 0; i < numModules; ++ i)
         {
            var moduleInstance:AssetImageModuleInstance = mModuleInstanceManager.GetAssetByAppearanceId (i) as AssetImageModuleInstance;
            var finalTransform:Transform2D = new Transform2D (moduleInstance.GetPositionX (), moduleInstance.GetPositionY (), moduleInstance.GetScale (), moduleInstance.IsFlipped (), moduleInstance.GetRotation ());
            finalTransform = Transform2D.CombineTransforms (transform, finalTransform);
            
            moduleInstance.GetAssetImageModule ().BuildImageModuleSelectionProxy (selectionProxy, finalTransform, visualScale);
         }
      }
      
//=============================================================
//   
//=============================================================

      protected var mIsSequenced:Boolean = false;
      protected var mIsLooped:Boolean = true; // for sequenced module only
      
      // false for assembled
      public function IsSequenced ():Boolean
      {
         return mIsSequenced;
      }

      public function SetSequenced (sequenced:Boolean):void
      {
         mIsSequenced = sequenced;
      }
      
      public function IsLooped ():Boolean
      {
         return mIsLooped;
      }
      
      public function SetLooped (looped:Boolean):void
      {
         mIsLooped = looped;
      }
      
      public function GetNumFrames ():Number
      {
         return IsSequenced () ? mModuleInstanceManager.GetNumAssets () : 1;
      }
      
//=============================================================
//   
//=============================================================
      
//=============================================================
//   
//=============================================================

      public function SynchronizeManagerSelectionsFromListingToEditing ():void
      {
         var moduleInstanceToSelect:Array = new Array (); 
         
         var selectedAssets:Array = mModuleInstanceManagerForListing.GetSelectedAssets ();
         var count:int = selectedAssets.length;
         for (var i:int = 0; i < count; ++ i)
         {
            var moduleInstanceForListing:AssetImageModuleInstanceForListing = selectedAssets [i] as AssetImageModuleInstanceForListing;
            
            moduleInstanceToSelect.push (moduleInstanceForListing.GetModuleInstaneForEditingPeer ());
         }
         
         mModuleInstanceManager.SetSelectedAssets (moduleInstanceToSelect);
      }

      public function SynchronizeManagerSelectionsFromEdittingToListing ():void
      {
         var moduleInstanceForListingToSelect:Array = new Array (); 
         
         var selectedAssets:Array = mModuleInstanceManager.GetSelectedAssets ();
         var count:int = selectedAssets.length;
         for (var i:int = 0; i < count; ++ i)
         {
            var moduleInstance:AssetImageModuleInstance = selectedAssets [i] as AssetImageModuleInstance;
            
            moduleInstanceForListingToSelect.push (moduleInstance.GetModuleInstaneForListingPeer ());
         }
         
         mModuleInstanceManagerForListing.SetSelectedAssets (moduleInstanceForListingToSelect);
      }

//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemEditModule:ContextMenuItem = new ContextMenuItem("Edit ...");
         
         menuItemEditModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_EditModule);
         
         customMenuItemsStack.push (menuItemEditModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_EditModule (event:ContextMenuEvent):void
      {
         AssetImageCompositeModuleEditDialog.ShowAssetImageCompositeModuleEditDialog (this);
      }
      
//=============================================================
//   
//=============================================================
      
      private var mAssetImageCompositeModuleEditDialog:AssetImageCompositeModuleEditDialog;
      public function SetAssetImageCompositeModuleEditDialog (assetImageCompositeModuleEditDialog:AssetImageCompositeModuleEditDialog):void
      {
         mAssetImageCompositeModuleEditDialog = assetImageCompositeModuleEditDialog;
      }
      
      public function GetAssetImageCompositeModuleEditDialog ():AssetImageCompositeModuleEditDialog
      {
         return mAssetImageCompositeModuleEditDialog;
      }
      
  }
}