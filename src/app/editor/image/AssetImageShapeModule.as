
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
   import editor.asset.AssetManager;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageShapeModule extends AssetImageModule
   {
      public function AssetImageShapeModule ()
      {
         super (null); // no manager
         
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage); // added in super class
      }
      
//=============================================================
//   
//=============================================================
      
      override public function BuildImageModuleSprite ():DisplayObject
      {
         return null; // to override
      }
      
      override public function GetImageModuleBoundingRectangle ():Rectangle
      {
         return null; // to override
      }
      
  }
}