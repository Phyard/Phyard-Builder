
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import editor.core.EditorObject;
   import editor.core.ReferPair;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import editor.image.vector.VectorShapeForEditing;
   import editor.image.vector.VectorShapeRectangleForEditing;
   import editor.image.vector.VectorShapeCircleForEditing;
   import editor.image.vector.VectorShapePolygonForEditing;
   import editor.image.vector.VectorShapePolylineForEditing;
   import editor.image.vector.VectorShapeTextForEditing;
   
   import editor.EditorContext;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageModuleInstanceManager extends AssetManager
   {
      protected var mAssetImageCompositeModule:AssetImageCompositeModule;
      
      public function AssetImageModuleInstanceManager (assetImageCompositeModule:AssetImageCompositeModule):void
      {
         mAssetImageCompositeModule = assetImageCompositeModule;
      }
      
      public function GetAssetImageCompositeModule ():AssetImageCompositeModule
      {
         return mAssetImageCompositeModule;
      }
      
//=============================================================
//   
//=============================================================
      
      override public function SupportSelectingEntitiesWithMouse ():Boolean
      {
         return ! mAssetImageCompositeModule.IsSequenced ();
      }
      
//=============================================================
//   
//=============================================================
      
      // for loading
      public function DestroyAllModuleInstances (passively:Boolean = false):void
      {
         DestroyAllAssets ();
         
         if (! passively)
         {
            mAssetImageCompositeModule.GetModuleInstanceManagerForListing ().DestroyAllModuleInstances (true);
         }
      }
      
      override public function DeleteSelectedAssets (passively:Boolean = false):Boolean
      {
         if (super.DeleteSelectedAssets ())
         {
            if (! passively)
            {
               mAssetImageCompositeModule.GetModuleInstanceManagerForListing ().DeleteSelectedAssets (true);
            }
            
            return true;
         }
         
         return false;
      }

      public function CreateImageModuleInstance (module:AssetImageModule, selectIt:Boolean = false, atIndex:int = -1):AssetImageModuleInstance
      {
         var finalModule:AssetImageModule;
         
         if (module == null)
         {
            module = new AssetImageNullModule ();
            finalModule = module;
         }
         else
         {
            //var finalModule:AssetImageModule = module == null ? null : module.GetFinalImageModule ();
            finalModule = module;
            
            if (mAssetImageCompositeModule.CanRefImageModule (finalModule))
            {
               finalModule = module;
            }
            else
            {
               module = new AssetImageNullModule ();
               finalModule = module;
            }
         }
         
         var moduleInstance:AssetImageModuleInstance = new AssetImageModuleInstance (this, finalModule);
         var moduleInstanceForListing:AssetImageModuleInstanceForListing = mAssetImageCompositeModule.GetModuleInstanceManagerForListing ().CreateImageModuleInstanceForListing (finalModule, selectIt, atIndex);
         moduleInstanceForListing.SetModuleInstaneForEditingPeer (moduleInstance);
         moduleInstance.SetModuleInstaneForListingPeer (moduleInstanceForListing);

         if (selectIt) // in editing, not loading
         {
            moduleInstance.SetPosition (mouseX, mouseY);
            SetSelectedAsset (moduleInstance);
         }
         
         if (atIndex < 0 || atIndex > GetNumAssets ())
            addChild (moduleInstance);
         else
            addChildAt (moduleInstance, atIndex);
         
         if (selectIt) // in editing, not loading. DeatFormat will do this. But it is best to do this when all images are loaded.
         {
            moduleInstance.UpdateAppearance ();
            moduleInstance.UpdateSelectionProxy ();
         }
         
         return moduleInstance;
      }
      
      public function CreateImageShapeRectangleModuleInstance (selectIt:Boolean = false, atIndex:int = -1):AssetImageModuleInstance
      {
         return CreateImageModuleInstance (new AssetImageShapeModule (new VectorShapeRectangleForEditing ()), selectIt, atIndex);
      }
      
      public function CreateImageShapeCircleModuleInstance (selectIt:Boolean = false, atIndex:int = -1):AssetImageModuleInstance
      {
         return CreateImageModuleInstance (new AssetImageShapeModule (new VectorShapeCircleForEditing ()), selectIt, atIndex);
      }
      
      public function CreateImageShapePolygonModuleInstance (selectIt:Boolean = false, atIndex:int = -1):AssetImageModuleInstance
      {
         return CreateImageModuleInstance (new AssetImageShapeModule (new VectorShapePolygonForEditing ()), selectIt, atIndex);
      }
      
      public function CreateImageShapePolylineModuleInstance (selectIt:Boolean = false, atIndex:int = -1):AssetImageModuleInstance
      {
         return CreateImageModuleInstance (new AssetImageShapeModule (new VectorShapePolylineForEditing ()), selectIt, atIndex);
      }
      
      public function CreateImageShapeTextModuleInstance (selectIt:Boolean = false, atIndex:int = -1):AssetImageModuleInstance
      {
         return CreateImageModuleInstance (new AssetImageShapeModule (new VectorShapeTextForEditing ()), selectIt, atIndex);
      }
      
//=============================================================
//   
//=============================================================
      
      override public function NotifyModifiedForReferers (info:Object = null):void
      {
         mAssetImageCompositeModule.UpdateTimeModified (); // maybe not a good idea to put it here
         
         mAssetImageCompositeModule.UpdateAppearance ();
         mAssetImageCompositeModule.NotifyModifiedForReferers ();
        
         super.NotifyModifiedForReferers (info);
      }
      
//=============================================================
//   
//=============================================================
      
      // will not saved in file
      protected var mShowAllSequences:Boolean = false;
      
      public function IsShowAllSequences ():Boolean
      {
         return mShowAllSequences;
      }
      
      public function SetShowAllSequences (showAllSequences:Boolean):void
      {
         mShowAllSequences = showAllSequences;
      }
      
//=============================================================
//   
//=============================================================
      
      public var mCallback_OnChangedForPanel:Function = null;
      
      internal function NotifyChangedForPanel ():void
      {
         if (mCallback_OnChangedForPanel != null)
         {
            mCallback_OnChangedForPanel ();
         }
      }
      
      private function UpdateSelectedModuleInstanceAppearances ():void
      {
         var moduleInstances:Array = GetSelectedAssets ();
         var moduleInstance:AssetImageModuleInstance;
         var count:int = moduleInstances.length;
         for (var i:int = 0; i < count; ++ i)
         {
            moduleInstance = moduleInstances [i] as AssetImageModuleInstance;
            moduleInstance.UpdateAppearance ();
         }
      }
      
      public function MoveUpDownTheOnlySelectedModuleInstance (moveUp:Boolean):void
      {  
         var selectedMoudleInstances:Array = GetSelectedAssets ();
         if (selectedMoudleInstances.length != 1)
            return;
         
         var moudleInstance:AssetImageModuleInstance = selectedMoudleInstances [0] as AssetImageModuleInstance;
         var oldIndex:int = moudleInstance.GetAppearanceLayerId ();
         var newIndex:int;
         if (moveUp)
         {
            if (oldIndex <= 0)
               return;
            
            newIndex = oldIndex - 1;
         }
         else
         {
            if (oldIndex >= GetNumAssets () - 1)
               return;
            
            newIndex = oldIndex + 1;
         }
         
         AdjustAssetAppearanceOrder (moudleInstance, newIndex);
         moudleInstance.GetModuleInstaneForListingPeer ().GetAssetImageModuleInstanceManagerForListing ().AdjustAssetAppearanceOrder (moudleInstance.GetModuleInstaneForListingPeer (), newIndex);
         
         moudleInstance.GetModuleInstaneForListingPeer ().GetAssetImageModuleInstanceManagerForListing ().UpdateLayout (true);
         
         NotifyChangedForPanel ();
      }
      
//=============================================================
//   context menu
//=============================================================

      public function OnContextMenuEvent_CreateImageModuleInstanceAtIndex (index:int):void
      {
         CreateImageModuleInstance (EditorContext.GetSingleton ().mCurrentAssetImageModule, true, index);
         
         NotifyChangedForPanel ();
      }
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         //var menuItemCreateModuleInstance:ContextMenuItem = new ContextMenuItem("Append New Model Instance From Current Module", true);
         //
         //menuItemCreateModuleInstance.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateImageModuleInstance);
         //
         //customMenuItemsStack.push (menuItemCreateModuleInstance);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      //private function OnContextMenuEvent_CreateImageModuleInstance (event:ContextMenuEvent):void
      //{
      //   CreateImageModuleInstance (EditorContext.GetSingleton ().mCurrentAssetImageModule, true);
      //   
      //   NotifyChangedForPanel ();
      //}
   }
}
