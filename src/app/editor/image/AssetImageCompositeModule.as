
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
   
   import editor.image.dialog.AssetImageCompositeModuleEditDialog;
   
   import editor.EditorContext;
   
   import common.DataFormat;
   
   import common.Transform2D;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageCompositeModule extends AssetImageModule
   {
      protected var mAssetImageCompositeModuleManager:AssetImageCompositeModuleManager;
      
      protected var mModuleInstanceManager:AssetImageModuleInstanceManager; // for internal module parts editing
      protected var mModuleInstanceManagerForListing:AssetImageModuleInstanceManagerForListing; // for internal module parts listing
      
      public function AssetImageCompositeModule (assetImageCompositeModuleManager:AssetImageCompositeModuleManager, sequenced:Boolean, key:String)
      {
         super (assetImageCompositeModuleManager, key);
         
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
      
      override public function GetImageModuleType ():int
      {  
         return IsSequenced () ? AssetImageModule.ImageModuleType_SequencedModule : AssetImageModule.ImageModuleType_AssembledModule;
      }
      
      public function GetModuleInstanceManager ():AssetImageModuleInstanceManager
      {
         return mModuleInstanceManager;
      }
      
      public function GetModuleInstanceManagerForListing ():AssetImageModuleInstanceManagerForListing
      {
         return mModuleInstanceManagerForListing;
      }
      
      public function GetNumModuleInstances ():int
      {
         return mModuleInstanceManager.GetNumAssets ();
      }
      
      public function GetModuleInstanceAt (appearanceId:int):AssetImageModuleInstance
      {
         return mModuleInstanceManager.GetAssetByAppearanceId (appearanceId) as AssetImageModuleInstance;
      }
      
      override public function ToCodeString ():String
      {
         return (IsSequenced () ? "Sequenced#" : "Assembled#") + GetAppearanceLayerId ();
      }
      
      override public function GetTypeName ():String
      {
         return IsSequenced () ? "Sequenced Module" : "Assembled Module";
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
         mModuleInstanceManager.Destroy ();
         mModuleInstanceManagerForListing.Destroy ();
         
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

      public function CanRefImageModule (module:AssetImageModule):Boolean
      {
         if (module == null)
            return true;
         
         if ((module is AssetImageCompositeModule) && (module as AssetImageCompositeModule).IsSequenced ())
         {
            return false;
         }
         
         if (module == this || module.ContainsDescendant (this))
         {
            return false;
         }
         
         return true;
      }
      
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
      
      // false for assembled
      public function IsSequenced ():Boolean
      {
         return mIsSequenced;
      }

      public function SetSequenced (sequenced:Boolean):void
      {
         mIsSequenced = sequenced;
      }
      
      public function GetNumFrames ():Number
      {
         return IsSequenced () ? mModuleInstanceManager.GetNumAssets () : 1;
      }
      
      protected var mSettingFlags:int = 0; 
         // only low 16 bits are used.
         // now, only for sequenced modules
      
      public function GetSettingFlags ():int
      {
         return mSettingFlags & 0xFFFF;
      }
      
      public function SetSettingFlags (flags:int):void
      {
         mSettingFlags = flags & 0xFFFF;
      }
      
      //public function IsLooped ():Boolean
      //{
      //   return mIsLooped; SequencedModule_StopAtLastFrame
      //}
      //
      //public function SetLooped (looped:Boolean):void
      //{
      //   mIsLooped = looped;
      //}
      
      public function IsConstantPhysicsGeom ():Boolean
      {
         return (mSettingFlags & Define.SequencedModule_ConstantPhysicsGeomForAllFrames) == Define.SequencedModule_ConstantPhysicsGeomForAllFrames;
      }
      
      public function SetConstantPhysicsGeom (constant:Boolean):void
      {
         if (constant)
            mSettingFlags |= Define.SequencedModule_ConstantPhysicsGeomForAllFrames;
         else
            mSettingFlags &= (~Define.SequencedModule_ConstantPhysicsGeomForAllFrames);
      }
      
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
      
      public function SynchronizePartAppearanceOrdersFromListingToEditing ():void
      {
         while (mModuleInstanceManager.numChildren > 0)
            mModuleInstanceManager.removeChildAt (0);
         
         var count:int = mModuleInstanceManagerForListing.numChildren;
         for (var i:int = 0; i < count; ++ i)
         {
            var peer:AssetImageModuleInstanceForListing = mModuleInstanceManagerForListing.getChildAt (i) as AssetImageModuleInstanceForListing;
            mModuleInstanceManager.addChild (peer.GetModuleInstaneForEditingPeer ());
         }
      }

//=============================================================
//   context menu
//=============================================================
      
      public function SetEditable (editable:Boolean):void
      {
         mMenuItemEditModule.enabled = editable;
         mMenuItemCloneModule.enabled = editable;
      }
      
      protected var mMenuItemEditModule:ContextMenuItem = new ContextMenuItem("Edit ...");
      protected var mMenuItemCloneModule:ContextMenuItem = new ContextMenuItem("Clone");
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         mMenuItemEditModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_EditModule);
         mMenuItemCloneModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CloneModule);
         
         customMenuItemsStack.push (mMenuItemEditModule);
         customMenuItemsStack.push (mMenuItemCloneModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_EditModule (event:ContextMenuEvent):void
      {
         AssetImageCompositeModuleEditDialog.ShowAssetImageCompositeModuleEditDialog (this);
      }
      
      private function OnContextMenuEvent_CloneModule (event:ContextMenuEvent):void
      {
         try
         {
            var newMoudle:AssetImageCompositeModule = GetAssetImageCompositeModuleManager ().CreateImageCompositeModule (null, true, false);
            newMoudle.SetSettingFlags (GetSettingFlags ());
            
            var modulePartDefines:Array = DataFormat.ModuleInstances2Define (EditorContext.GetEditorApp ().GetWorld (), GetModuleInstanceManager (), GetAssetImageCompositeModuleManager ().IsSequencedModuleManager ());
            
            var numImageModules:int = EditorContext.GetEditorApp ().GetWorld ().GetNumImageModules ();
            var imageModuleRefIndex_CorrectionTable:Array = new Array (numImageModules);
            for (var i:int = 0; i < numImageModules; ++ i)
               imageModuleRefIndex_CorrectionTable [i] = i;
            
            DataFormat.ModuleInstanceDefinesToModuleInstances (modulePartDefines, imageModuleRefIndex_CorrectionTable, EditorContext.GetEditorApp ().GetWorld (), newMoudle.GetModuleInstanceManager (), newMoudle.GetAssetImageCompositeModuleManager ().IsSequencedModuleManager ());
            
            GetAssetImageCompositeModuleManager ().MoveSelectedAssetsToIndex (GetAssetImageCompositeModuleManager ().getChildIndex (this) + 1);
            
            newMoudle.UpdateTimeModified ();
            newMoudle.UpdateAppearance ();
            
            GetAssetImageCompositeModuleManager ().UpdateLayout (true);
         }
         catch (error:Error)
         {
            trace (error.getStackTrace ());
         }
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