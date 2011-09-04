
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
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageDivision extends Asset
   {  
      protected var mAssetImageDivisionManager:AssetImageDivisionManager;
      
      protected var mLeft:int;
      protected var mTop:int;
      protected var mRight:int;
      protected var mBottom:int;
      
      public function AssetImageDivision (assetImageDivisionManager:AssetImageDivisionManager)
      {
         super (assetImageDivisionManager);
         
         mAssetImageDivisionManager = assetImageDivisionManager;
         
         alpha = 0.5;
         
         //BuildContextMenu ();
      }
      
      public function GetAssetImageDivisionManager ():AssetImageDivisionManager
      {
         return mAssetImageDivisionManager;
      }
      
      override public function ToCodeString ():String
      {
         return "Module#" + mCreationOrderId;
      }
      
      override public function GetTypeName ():String
      {
         return "Module";
      }
      
//=============================================================
//   
//=============================================================
      
      override public function SetPosition (posX:Number, posY:Number):void
      {
         var dx:int = int (posX);
         var dy:int = int (posY);
         mLeft += dx;
         mRight += dx;
         mTop += dy;
         mBottom += dy;
         
         UpdateAppearance ();
      }
      
      public function SetRegion (left:Number, top:Number, right:Number, bottom:Number):void
      {
         if (left >= right)
         {
            mLeft = left;
            mRight = right;
         }
         else
         {
            mRight = right;
            mLeft = left;
         }
         
         if (top <= bottom)
         {
            mTop = top;
            mBottom = bottom;
         }
         else
         {
            mTop = bottom;
            mBottom = top;
         }
         
         UpdateAppearance ();
         
         //if ()
      }

//=============================================================
//   
//=============================================================
      
      override public function UpdateAppearance ():void
      {
         GraphicsUtil.ClearAndDrawRect (this, mLeft, mTop, mRight - mLeft, mBottom - mTop,
                                       0x00FF00, 0, true, IsSelected () ? 0xC0C0FF : 0xC0FFC0, false);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         var centerX:Number = 0.5 * (mLeft + mRight);
         var centerY:Number = 0.5 * (mTop + mBottom); 
         var halfW:Number = 0.5 * (mRight - mLeft);
         var halfH:Number = 0.5 * (mBottom - mTop); 
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (0, centerX, centerY, halfW, halfH);
      }
      
//=============================================================
//   
//=============================================================
      /*
      private var mContextMenu:ContextMenu;
      private var mMenuItemDelete:ContextMenuItem;
      
      final private function BuildContextMenu ():void
      {
         mContextMenu = new ContextMenu ();
         mContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = mContextMenu.builtInItems;
         defaultItems.print = true;
         contextMenu = mContextMenu;
         
         mMenuItemDelete = new ContextMenuItem("Delete ...");
         
         mMenuItemDelete.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);

         mContextMenu.customItems.push (mMenuItemDelete);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         switch (event.target)
         {
            case mMenuItemDelete:
               mAssetImageDivisionManager.DestroyAsset (this);
               break;
            default:
               break;
         }
      }
      */
      
  }
}