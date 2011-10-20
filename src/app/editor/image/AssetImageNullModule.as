
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.geom.Rectangle;
   import flash.geom.Point;
   
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
   
   import editor.image.vector.VectorShape;
   import editor.image.vector.VectorShapeRectangle;
   import editor.image.vector.VectorShapeCircle;
   import editor.image.vector.VectorShapePolygon;
   import editor.image.vector.VectorShapePolyline;
   import editor.image.vector.VectorShapeText;
   
   import common.Transform2D;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageNullModule extends AssetImageModule
   {
      public function AssetImageNullModule ()
      {
         super (null); // no manager
         
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage); // added in super class
      }
      
//=============================================================
//   
//=============================================================

      override public function BuildImageModuleAppearance (container:Sprite, transform:Transform2D = null):void
      {
         var moduleSize:Number = 50;
         var halfModuleSize:Number = 0.5 * moduleSize;
         
         var rectShape:Shape = new Shape ();
         GraphicsUtil.DrawRect (rectShape, - halfModuleSize, - halfModuleSize, moduleSize, moduleSize,
                                       0x0000FF, -1, true, 0xD0FFD0, false);
         
         if (transform != null)
            transform.TransformUntransformedDisplayObject (rectShape);
         
         container.addChild (rectShape);
      }
      
      override public function BuildImageModulePhysicsAppearance (container:Sprite, transform:Transform2D = null):void
      {
      }
      
      override public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         var moduleSize:Number = 50;
         var halfModuleSize:Number = 0.5 * moduleSize;
         
         selectionProxy.AddRectangleShapeHalfWH (halfModuleSize, halfModuleSize, transform);
      }
      
  }
}
