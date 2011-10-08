
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
   
   public class AssetImageShapeModule extends AssetImageModule
   {
      protected var mVectorShape:VectorShape;
      protected var mIsValid:Boolean;
      
      public function AssetImageShapeModule (vectorShape:VectorShape)
      {
         super (null); // no manager
         
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage); // added in super class
         
         mVectorShape = vectorShape;
         mIsValid = false;
      }
      
      public function IsValid ():Boolean
      {
         return mVectorShape == null ? false : mVectorShape.IsValid ();
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
      
      override public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D):void
      {
         var moduleSize:Number = 50;
         var halfModuleSize:Number = 0.5 * moduleSize;
         
         selectionProxy.AddRectangleShapeHalfWH (halfModuleSize, halfModuleSize, transform);
      }
      
//=============================================================
//   
//=============================================================

      /*
      todo:
      1. BuildImageModuleSprite ->BuildImageModuleSprite (contianer, accumulatedTransform)
      2. GetImageModuleBoundingRectangle -> BuildImageModulePhysics (proxyBody, accumulatedTransform);
         - proxyBody 中加入mScale,mFlipped, mRotation, (cancelled, not good)
      3. Transform.as
         - scale
         - flipped
         - rotation 
      */
       
//=============================================================
//   
//=============================================================
      
      // return position
      public function OnCreating (points:Array):void
      {
         var centerPoint:Point = OnCreatingShape (mVectorShape, points);
         SetPosition (centerPoint.x, centerPoint.y);
      }
      
//=============================================================
//   
//=============================================================
      
      // for circle and rectangle, points contains 2 drag box vertexes
      // for polyline and polygon, points contains all vertexes
      public static function OnCreatingShape (vectorShape:VectorShape, points:Array):Point
      {
         if (points != null)
         {
            var point1:Point;
            var point2:Point;
            var posX:Number;
            var posY:Number;
            
            if (vectorShape is VectorShapeRectangle)
            {
               if (points.length == 2)
               {
                  point1 = points [0] as Point;
                  point2 = points [1] as Point;
                  posX = 0.5 * (point2.x + point1.x);
                  posY = 0.5 * (point2.y + point1.y);
                  var halfWidth:Number  = 0.5 * Math.abs (point2.x - point1.x);
                  var halfHeight:Number = 0.5 * Math.abs (point2.y - point1.y);
                  
                  var rectange:VectorShapeRectangle = vectorShape as VectorShapeRectangle;
                  rectange.SetHalfWidth (halfWidth);
                  rectange.SetHalfHeight (halfWidth);
                  
                  vectorShape.SetValid (true);
                  return new Point (posX, posY);
               }
            }
            else if (vectorShape is VectorShapeCircle)
            {
               if (points.length == 2)
               {
                  point1 = points [0] as Point;
                  point2 = points [1] as Point;
                  posX = point1.x;
                  posY = point1.y;
                  var dx:Number = point2.x - point1.x;
                  var dy:Number = point2.y - point1.y;
                  var radius:Number = Math.sqrt (dx * dx + dy * dy);
                  
                  var circle:VectorShapeCircle = vectorShape as VectorShapeCircle;
                  circle.SetRadius (radius);
                  
                  vectorShape.SetValid (true);
                  return new Point (posX, posY);
               }
            }
            else if (vectorShape is VectorShapePolygon)
            {
            }
            else if (vectorShape is VectorShapePolyline)
            {
            }
            else if (vectorShape is VectorShapeText)
            {
            }
         }
         
         vectorShape.SetValid (false);
         return null;
      }
      
  }
}