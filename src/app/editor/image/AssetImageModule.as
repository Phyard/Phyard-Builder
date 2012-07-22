
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
   import editor.asset.AssetManager;
   
   import editor.EditorContext;

   import common.Transform2D;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageModule extends Asset
   {
      public static const ImageModuleType_Unknown:int = -1;
      public static const ImageModuleType_WholeImage:int = 0;
      public static const ImageModuleType_PureModule:int = 1;
      public static const ImageModuleType_AssembledModule:int = 2;
      public static const ImageModuleType_SequencedModule:int = 3;
      
//=============================================================
//   
//=============================================================
   
      protected var mAssetImageModuleManager:AssetImageModuleManager;
      
      public function AssetImageModule (assetImageModuleManager:AssetImageModuleManager, key:String = null)
      {
         super (assetImageModuleManager, key);
         
         mAssetImageModuleManager = assetImageModuleManager;
         
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
      }
      
      public function GetAssetImageModuleManager ():AssetImageModuleManager
      {
         return mAssetImageModuleManager;
      }
      
      public function GetImageModuleType ():int
      {  
         return AssetImageModule.ImageModuleType_Unknown;
      }
      
      override public function Destroy ():void
      {
         super.Destroy ();
         
         if (EditorContext.GetSingleton ().mCurrentAssetImageModule == this)
         {
            EditorContext.GetSingleton ().mCurrentAssetImageModule = null;
         }
      }
      
//=============================================================
//   
//=============================================================
      
      public function OnMouseDown (event:MouseEvent):void
      {
         EditorContext.GetSingleton ().mCurrentAssetImageModule = this;
      }
      
//=============================================================
//   for module instance callings
//=============================================================
      
      public function ContainsDescendant (module:AssetImageModule):Boolean
      {
         return false;
      }
      
      public function BuildImageModuleAppearance (container:Sprite, transform:Transform2D = null):void
      {
         // to override
      }
      
      public function BuildImageModulePhysicsAppearance (container:Sprite, transform:Transform2D = null):void
      {
         // to override
      }
      
      public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         // to override
      }
      
//=============================================================
//   
//=============================================================

      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var moduleWidth:Number = mAssetImageModuleManager.GetAssetSpriteWidth ();
         var moduleHeight:Number = mAssetImageModuleManager.GetAssetSpriteHeight ();
         var halfMoudleWidth:Number = 0.5 * moduleWidth;
         var halfMoudleHeight:Number = 0.5 * moduleHeight;
         GraphicsUtil.ClearAndDrawRect (this, - halfMoudleWidth, - halfMoudleHeight, moduleWidth, moduleHeight,
                                       IsSelected () ? 0x0000FF : 0x0, 0, true, IsSelected () ? 0xC0C0FF : 0xFFFFFF, false);
                                       
         var iconSize:Number = mAssetImageModuleManager.GetModuleIconSize ();
         var halfIconWidth:Number = 0.5 * iconSize;
         var halfIconHeight:Number = 0.5 * iconSize;

         var moduleSprite:Sprite = new Sprite ();
         BuildImageModuleAppearance (moduleSprite);
         
         if (moduleSprite.numChildren == 0)
         {
            GraphicsUtil.DrawLine (this, - halfMoudleWidth, - halfMoudleHeight, halfMoudleWidth, halfMoudleHeight);
            GraphicsUtil.DrawLine (this, halfMoudleWidth, - halfMoudleHeight,  - halfMoudleWidth, halfMoudleHeight);
         }
         else
         {
            addChild (moduleSprite);

            var spriteBounds:Rectangle = moduleSprite.getBounds (this);
            if (spriteBounds.width != 0 || spriteBounds.height != 0)
            {
               var spriteSize:Number = moduleSprite.width > moduleSprite.height ? moduleSprite.width : moduleSprite.height;
               moduleSprite.scaleX = spriteSize <= iconSize ? 1.0 : Number (iconSize) / Number (spriteSize);
               moduleSprite.scaleY = spriteSize <= iconSize ? 1.0 : Number (iconSize) / Number (spriteSize);
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
         
         var moduleWidth:Number = mAssetImageModuleManager.GetAssetSpriteWidth ();
         var moduleHeight:Number = mAssetImageModuleManager.GetAssetSpriteHeight ();
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (GetPositionX (), GetPositionY (), 0.5 * moduleWidth, 0.5 * moduleHeight);
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemEditModule:ContextMenuItem = new ContextMenuItem("Set As Current Module", true);
         
         menuItemEditModule.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_SetAsCurrentModule);
         
         customMenuItemsStack.push (menuItemEditModule);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
         mAssetImageModuleManager.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_SetAsCurrentModule (event:ContextMenuEvent):void
      {
         EditorContext.GetSingleton ().mCurrentAssetImageModule = this;
      }
      
  }
}