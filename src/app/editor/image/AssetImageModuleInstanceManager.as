
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
      
      public function CreateImageModuleInstance (module:AssetImageModule, selectIt:Boolean = false):AssetImageModuleInstance
      {
         var moduleInstane:AssetImageModuleInstance = new AssetImageModuleInstance (this, module);
         
         if (selectIt) // in editing, not loading
         {
            moduleInstane.SetPosition (mouseX, mouseY);
            SetSelectedAsset (moduleInstane);
         }
         
         moduleInstane.UpdateAppearance ();
         moduleInstane.UpdateSelectionProxy ();
         addChild (moduleInstane);
         
         // create icon in list
         
         //if (mAssetImageModuleInstanceManagerForListing != null)
         //{
            var moduleInstaneForListing:AssetImageModuleInstanceForListing = mAssetImageCompositeModule.GetModuleInstanceManagerForListing ().CreateImageModuleInstanceForListing (module, selectIt);
            moduleInstaneForListing.SetModuleInstaneForEditingPeer (moduleInstane);
            moduleInstane.SetModuleInstaneForListingPeer (moduleInstaneForListing);
         //}

         return moduleInstane;
      }
      
//=============================================================
//   
//=============================================================
      
      override public function Update (escapedTime:Number):void
      {
         super.Update (escapedTime);
         
         if (mAssetImageCompositeModule.IsAnimated ())
         {
            if (mIsPlaying)
            {
               var numParts:int = GetNumAssets ();
               if (mCurrentPartId < 0 || mCurrentPartId >= numParts)
               {
                  mCurrentPartId = 0;
                  mCurrentPartSteps = 0;
               }
               
               var moduleInstance:AssetImageModuleInstance = GetAssetByAppearanceId (mCurrentPartId) as AssetImageModuleInstance;
               
               if (++ mCurrentPartSteps > moduleInstance.GetDuration ())
               {
                  mCurrentPartSteps = 0;
                  
                  if (++ mCurrentPartId >= numParts)
                  {
                     mCurrentPartId = 0;
                  }
               }
            }
         }
         else
         {
         /*
            if (mIsPlaying)
            {
               moduleInstance.Step ();
            }
            else
            {
               moduleInstance.SetStep (0);
            }
         */
         }
         
         UpdateModuleInstancesAlpha ();
      }
      
      private function UpdateModuleInstancesAlpha ():void
      {
         var numParts:int = GetNumAssets ();
         var i:int;
         var moudleInstance:AssetImageModuleInstance;
         
         for (i = 0; i < numParts; ++ i)
         {
            moudleInstance = GetAssetByAppearanceId (i) as AssetImageModuleInstance;
            
            if (mIsPlaying && mAssetImageCompositeModule.IsAnimated ())
            {
               moudleInstance.SetVisibleForEditing (i == mCurrentPartId);
            }
            else
            {
               moudleInstance.SetVisibleForEditing (true);
               if (mAssetImageCompositeModule.IsAnimated () && (! moudleInstance.IsSelected ()))
               {
                  moudleInstance.alpha = 0.33;
               }
            }
         }
      }
      
      // will not saved in file
      protected var mShowAllParts:Boolean = false;
      
      protected var mIsPlaying:Boolean = false;
      protected var mCurrentPartId:int;
      protected var mCurrentPartSteps:int;
      
      public function IsPlaying ():Boolean
      {
         return mIsPlaying;
      }
      
      public function SetPlaying (playing:Boolean):void
      {
         mIsPlaying = playing; 
      }
      
      public function IsShowAllParts ():Boolean
      {
         return mShowAllParts;
      }
      
      public function SetShowAllParts (showAllParts:Boolean):void
      {
         mShowAllParts = showAllParts;
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
      
//=============================================================
//   context menu
//=============================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemCreateModuleInstance:ContextMenuItem = new ContextMenuItem("Append New Model Instance From Current Module", true);
         var menuItemChangeIntoTimeCompositeModule:ContextMenuItem = new ContextMenuItem("Change Into Time Composite Module", true);
         var menuItemChangeIntoSpaceCompositeModule:ContextMenuItem = new ContextMenuItem("Change Into Space Composite Module");
         
         menuItemCreateModuleInstance.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateImageModuleInstance);
         menuItemChangeIntoTimeCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeIntoTimeCompositeModule);
         menuItemChangeIntoSpaceCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeIntoSpaceCompositeModule);

         customMenuItemsStack.push (menuItemCreateModuleInstance);
         customMenuItemsStack.push (menuItemChangeIntoTimeCompositeModule);
         customMenuItemsStack.push (menuItemChangeIntoSpaceCompositeModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_CreateImageModuleInstance (event:ContextMenuEvent):void
      {
         CreateImageModuleInstance (AssetImageModule.mCurrentAssetImageModule, true);
         NotifyChangedForPanel ();
      }
      
      private function OnContextMenuEvent_ChangeIntoTimeCompositeModule (event:ContextMenuEvent):void
      {
         mAssetImageCompositeModule.SetAnimated (true);
         
         // repaint selected assets
         var moduleInstances:Array = GetSelectedAssets ();
         ClearAssetSelections ();
         SetSelectedAssets (moduleInstances);
         
         NotifyChangedForPanel ();
      }
      
      private function OnContextMenuEvent_ChangeIntoSpaceCompositeModule (event:ContextMenuEvent):void
      {
         mAssetImageCompositeModule.SetAnimated (false);
         
         // repaint selected assets
         var moduleInstances:Array = GetSelectedAssets ();
         ClearAssetSelections ();
         SetSelectedAssets (moduleInstances);
         
         NotifyChangedForPanel ();
      }
   }
}
