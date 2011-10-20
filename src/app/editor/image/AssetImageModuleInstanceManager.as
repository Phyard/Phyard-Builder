
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
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import editor.image.vector.VectorShapeForEditing;
   import editor.image.vector.VectorShapeRectangleForEditing;
   import editor.image.vector.VectorShapeCircleForEditing;
   import editor.image.vector.VectorShapePolygonForEditing;
   import editor.image.vector.VectorShapePolylineForEditing;
   import editor.image.vector.VectorShapeTextForEditing;
   
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
      
      override public function DestroyAsset (asset:Asset):void
      {
         var moduleInstance:AssetImageModuleInstance = asset as AssetImageModuleInstance;
         var moduleInstanceForListing:AssetImageModuleInstanceForListing = moduleInstance.GetModuleInstaneForListingPeer ();
         
         super.DestroyAsset (asset); // the module instance
         
         if (! moduleInstanceForListing.IsDestroyed ())
         {
            moduleInstanceForListing.GetAssetImageModuleInstanceManagerForListing ().DestroyAsset (moduleInstanceForListing);
         }
      }

      public function CreateImageModuleInstance (module:AssetImageModule, selectIt:Boolean = false, atIndex:int = -1):AssetImageModuleInstance
      {
         if (module == null)
            module= new AssetImageNullModule ();
         
         //var finalModule:AssetImageModule = module == null ? null : module.GetFinalImageModule ();
         var finalModule:AssetImageModule = module;
         
         if (finalModule == mAssetImageCompositeModule || finalModule.ContainsDescendant (mAssetImageCompositeModule))
         {
            return null;
         }
            
         var moduleInstane:AssetImageModuleInstance = new AssetImageModuleInstance (this, finalModule);

         if (selectIt) // in editing, not loading
         {
            moduleInstane.SetPosition (mouseX, mouseY);
            SetSelectedAsset (moduleInstane);
         }
         
         if (atIndex < 0 || atIndex > GetNumAssets ())
            addChild (moduleInstane);
         else
            addChildAt (moduleInstane, atIndex);
         
         // impossible now.
         // todo: AssetImageModuleInstanceForListing should not extend from AssetImageModule
         //
         //if (module is AssetImageModuleInstanceForListing)
         //{
         //   var fromModuleInstance:AssetImageModuleInstance = (module as AssetImageModuleInstanceForListing).GetModuleInstaneForEditingPeer ();
         //   moduleInstane.SetAlpha (fromModuleInstance.GetAlpha ());
         //   moduleInstane.SetScale (fromModuleInstance.GetScale ());
         //   moduleInstane.SetFlipped (fromModuleInstance.IsFlipped ());
         //   moduleInstane.SetRotation (fromModuleInstance.GetRotation ());
         //   //moduleInstane.SetPosition (fromModuleInstance.GetPositionX (), fromModuleInstance.GetPositionY ());
         //}
         
         moduleInstane.UpdateAppearance ();
         moduleInstane.UpdateSelectionProxy ();
         
         // create icon in list
         
         //if (mAssetImageModuleInstanceManagerForListing != null)
         //{
            var moduleInstaneForListing:AssetImageModuleInstanceForListing = mAssetImageCompositeModule.GetModuleInstanceManagerForListing ().CreateImageModuleInstanceForListing (finalModule, selectIt, atIndex);
            moduleInstaneForListing.SetModuleInstaneForEditingPeer (moduleInstane);
            moduleInstane.SetModuleInstaneForListingPeer (moduleInstaneForListing);
         //}

         return moduleInstane;
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
      
      protected function NotifyChangedForPanel ():void
      {
         if (mCallback_OnChangedForPanel != null)
         {
            mCallback_OnChangedForPanel ();
         }
      }
      
      public function UpdateModuleInstancesAlpha ():void
      {
         var moduleInstance:AssetImageModuleInstance;
         var count:int = GetNumAssets ();
         for (var i:int = 0; i < count; ++ i)
         {
            moduleInstance = GetAssetByAppearanceId (i) as AssetImageModuleInstance;
            if (mAssetImageCompositeModule.IsSequenced ())
            {
               if (moduleInstance.IsSelected () || mShowAllSequences)
                  moduleInstance.alpha = 1.0;
               else
                  moduleInstance.alpha = 0.66;
            }
            else
            {
               moduleInstance.alpha = 1.0;
            }
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
         
         moudleInstance.GetModuleInstaneForListingPeer ().GetAssetImageModuleInstanceManagerForListing ().RearrangeAssetPositions (true);
         
         NotifyChangedForPanel ();
      }
      
//=============================================================
//   context menu
//=============================================================

      public function OnContextMenuEvent_CreateImageModuleInstanceAtIndex (index:int):void
      {
         CreateImageModuleInstance (AssetImageModule.mCurrentAssetImageModule, true, index);
         UpdateModuleInstancesAlpha ();
         
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
      //   CreateImageModuleInstance (AssetImageModule.mCurrentAssetImageModule, true);
      //   UpdateModuleInstancesAlpha ();
      //   
      //   NotifyChangedForPanel ();
      //}
   }
}
