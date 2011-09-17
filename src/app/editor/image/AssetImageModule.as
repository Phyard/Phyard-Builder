
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
   import editor.asset.AssetManager;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageModule extends Asset
   {
      public static var mCurrentAssetImageModule:AssetImageModule = null;
   
   //=========
   
      protected var mAssetImageModuleManager:AssetImageModuleManager;
      
      public function AssetImageModule (assetImageModuleManager:AssetImageModuleManager)
      {
         super (assetImageModuleManager);
         
         mAssetImageModuleManager = assetImageModuleManager;
      }
      
      public function GetAssetImageModuleManager ():AssetImageModuleManager
      {
         return mAssetImageModuleManager;
      }
      
//=============================================================
//   
//=============================================================
      
      public function CreateModuleSprite ():DisplayObject
      {
         return null; // to override
      }
      
      public function GetModuleBoundingRectangle ():Rectangle
      {
         return null; // to override
      }
      
//=============================================================
//   
//=============================================================

      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var moduleSize:Number = mAssetImageModuleManager.GetAssetSpriteSize ();
         var halfModuleSize:Number = 0.5 * moduleSize;
         GraphicsUtil.ClearAndDrawRect (this, - halfModuleSize, - halfModuleSize, moduleSize, moduleSize,
                                       IsSelected () ? 0x0000FF : 0x0, 0, true, IsSelected () ? 0xC0C0FF : 0xFFFFFF, false);
                                       
         var iconSize:Number = mAssetImageModuleManager.GetModuleIconSize ();
         var halfIconSize:Number = 0.5 * iconSize;

         var moduleSprite:DisplayObject = CreateModuleSprite ();
         
         if (moduleSprite == null)
         {
            GraphicsUtil.DrawLine (this, - halfModuleSize, - halfModuleSize, halfModuleSize, halfModuleSize);
            GraphicsUtil.DrawLine (this, halfModuleSize, - halfModuleSize,  - halfModuleSize, halfModuleSize);
         }
         else
         {
            addChild (moduleSprite);

            var spriteBounds:Rectangle = moduleSprite.getBounds (this);
            if (spriteBounds.width != 0 || spriteBounds.height != 0)
            {
               var spriteSize:Number = moduleSprite.width > moduleSprite.height ? moduleSprite.width : moduleSprite.height;
               moduleSprite.scaleX = moduleSprite.scaleY = spriteSize <= iconSize ? 1.0 : Number (iconSize) / Number (spriteSize);
               moduleSprite.x = - moduleSprite.scaleX  * (spriteBounds.left + 0.5 * spriteBounds.width);
               moduleSprite.y = - moduleSprite.scaleY  * (spriteBounds.top + 0.5 * spriteBounds.height);
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
         
         var moduleSize:Number = mAssetImageModuleManager.GetAssetSpriteSize ();
         var halfModuleSize:Number = 0.5 * moduleSize;
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (0, GetPositionX (), GetPositionY (), halfModuleSize, halfModuleSize);
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemEditModule:ContextMenuItem = new ContextMenuItem("Set As Current Module");
         
         menuItemEditModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_SetAsCurrentModule);
         
         customMenuItemsStack.push (menuItemEditModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
         mAssetImageModuleManager.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_SetAsCurrentModule (event:ContextMenuEvent):void
      {
         mCurrentAssetImageModule = this;
      }
      
  }
}