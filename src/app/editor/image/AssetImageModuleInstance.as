
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
   
   public class AssetImageModuleInstance extends Asset
   {  
      protected var mAssetImageModuleInstanceManager:AssetImageModuleInstanceManager;
      
      protected var mAssetImageModule:AssetImageModule = null;
      private var mReferPair:ReferPair = null;
      
      public function AssetImageModuleInstance (assetImageModuleInstanceManager:AssetImageModuleInstanceManager, assetImageModule:AssetImageModule)
      {
         super (assetImageModuleInstanceManager);
         
         mAssetImageModuleInstanceManager = assetImageModuleInstanceManager;
         
         SetAssetImageModule (assetImageModule);
      }
      
      public function GetAssetImageModuleInstanceManager ():AssetImageModuleInstanceManager
      {
         return mAssetImageModuleInstanceManager;
      }
      
      public function GetAssetImageModule ():AssetImageModule
      {
         return mAssetImageModule;
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
      
      override public function OnReferingModified (refering:EditorObject, info:Object = null):void
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

      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var moduleSize:Number = 50;
         var halfModuleSize:Number = 0.5 * moduleSize;
                                       
         if (mAssetImageModule == null)
         {
            GraphicsUtil.ClearAndDrawRect (this, - halfModuleSize, - halfModuleSize, moduleSize, moduleSize,
                                          0x0000FF, -1, true, IsSelected () ? 0xC0C0FF : 0xD0FFD0, false);
         }
         else
         {
            var moduleSprite:DisplayObject = mAssetImageModule.CreateModuleSprite ();
            addChild (moduleSprite);
            
            if (IsSelected ())
            {
               var rectangle:Rectangle = mAssetImageModule.GetModuleBoundingRectangle ();

               var shape:Shape = new Shape ();
               shape.alpha = 0.67;
               GraphicsUtil.DrawRect (shape, rectangle.left, rectangle.top, rectangle.width, rectangle.height,
                                          0x0000FF, -1, true, 0xC0C0FF, false);
               addChild (shape);
            }
         } 
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         if (mAssetImageModule == null)
         {
            var moduleSize:Number = 50;
            var halfModuleSize:Number = 0.5 * moduleSize;
            (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (0, GetPositionX (), GetPositionY (), halfModuleSize, halfModuleSize);
         }
         else
         {
            var rectangle:Rectangle = mAssetImageModule.GetModuleBoundingRectangle ();
            
            //todo: tranlate the rect
            (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (0, GetPositionX () + rectangle.left + 0.5 * rectangle.width, GetPositionY () + rectangle.top + 0.5 * rectangle.height, 0.5 * rectangle.width, 0.5 * rectangle.height);
         } 
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemChangeIntoTimeCompositeModule:ContextMenuItem = new ContextMenuItem("Change Into Time Composite Module", true);
         var menuItemChangeIntoSpaceCompositeModule:ContextMenuItem = new ContextMenuItem("Change Into Space Composite Module");
         
         menuItemChangeIntoTimeCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeIntoTimeCompositeModule);
         menuItemChangeIntoSpaceCompositeModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeIntoSpaceCompositeModule);

         customMenuItemsStack.push (menuItemChangeIntoTimeCompositeModule);
         customMenuItemsStack.push (menuItemChangeIntoSpaceCompositeModule);
         
         mAssetImageModuleInstanceManager.BuildContextMenuInternal (customMenuItemsStack);
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_ChangeIntoTimeCompositeModule (event:ContextMenuEvent):void
      {
      }
      
      private function OnContextMenuEvent_ChangeIntoSpaceCompositeModule (event:ContextMenuEvent):void
      {
      }
      
  }
}