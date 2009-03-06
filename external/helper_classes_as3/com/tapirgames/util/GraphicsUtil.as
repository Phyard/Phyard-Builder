package com.tapirgames.util {
   
   import flash.display.Shape;
   import flash.display.Graphics;
   
   import flash.geom.Point;
   
   
   import com.tapirgames.suit2d.loader.Sprite2dFile;
   import com.tapirgames.suit2d.display.Tiled2dBackgroundInstance;
   import com.tapirgames.suit2d.display.Sprite2dModelInstance;
   
   public class GraphicsUtil 
   {
      /*
      public static function CreateTiled2dBackgroundInstance (appearanceDefine:Object, appearanceValue:Object):Tiled2dBackgroundInstance
      {
         var sprite2dFile:Sprite2dFile = Engine.GetDataAsset (appearanceDefine.mFilePath) as Sprite2dFile;
         return new Tiled2dBackgroundInstance (sprite2dFile, appearanceValue as int);
      }
      
      public static function CreateSprite2dModelInstance (appearanceDefine:Object, appearanceValue:Object):Sprite2dModelInstance
      {
         var sprite2dFile:Sprite2dFile = Engine.GetDataAsset (appearanceDefine.mFilePath) as Sprite2dFile;
         var model:Sprite2dModelInstance = new Sprite2dModelInstance (sprite2dFile, appearanceDefine.mModelID as int);
         
         model.SetAnimationID (appearanceValue as int);
         
         return model;
      }
      */
      
      public static function GetInvertColor (color:uint):uint
      {
         var r:uint = (color >> 16) & 0xFF;
         var g:uint = (color >>  8) & 0xFF;
         var b:uint = (color >>  0) & 0xFF;
         
         return (color & 0xFF000000) | ((255 - r) << 16) | ((255 - g) << 8) | ((255 - b));
      }
      
      public static function GetInvertColor_b (color:uint):uint
      {
         var r:uint = (color >> 16) & 0xFF;
         var g:uint = (color >>  8) & 0xFF;
         var b:uint = (color >>  0) & 0xFF;
         
         if (r + g + b > 100 * 3)
            return (color & 0xFF000000) | 0x0;
         else
            return (color & 0xFF000000) | 0xFFFFFF;
      }
      
      public static function CreateRectShape (x:Number, y:Number, w:Number, h:Number, borderColor:uint, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):Shape
      {
         var rect:Shape = new Shape();
         if (filled) rect.graphics.beginFill(fillColor);
         rect.graphics.lineStyle(borderSize, borderColor);
         rect.graphics.drawRect(x, y, w, h);
         if (filled) rect.graphics.endFill();
         
         return rect;
      }
      
      public static function CreateEllipseShape (x:Number, y:Number, w:Number, h:Number, borderColor:uint, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):Shape
      {
         var rect:Shape = new Shape();
         if (filled) rect.graphics.beginFill(fillColor);
         rect.graphics.lineStyle(borderSize, borderColor);
         rect.graphics.drawEllipse(x, y, w, h);
         if (filled) rect.graphics.endFill();
         
         return rect;
      }
      
      public static function Clear (shape:Object):void
      {
         shape.graphics.clear ();
      }
      
      public static function ClearAndDrawRect (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         shape.graphics.clear ();
         if (filled) shape.graphics.beginFill(fillColor);
         shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawRect(x, y, w, h);
         if (filled) shape.graphics.endFill();
      }
      
      public static function DrawRect (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         if (filled) shape.graphics.beginFill(fillColor);
         shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawRect(x, y, w, h);
         if (filled) shape.graphics.endFill();
      }
      
      public static function ClearAndDrawEllipse (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         shape.graphics.clear ();
         if (filled) shape.graphics.beginFill(fillColor);
         shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawEllipse(x, y, w, h);
         if (filled) shape.graphics.endFill();
      }
      
      public static function DrawEllipse (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         if (filled) shape.graphics.beginFill(fillColor);
         shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawEllipse(x, y, w, h);
         if (filled) shape.graphics.endFill();
      }
      
      public static function ClearAndDrawCircle (shape:Object, x:Number, y:Number, radius:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         shape.graphics.clear ();
         if (filled) shape.graphics.beginFill(fillColor);
         shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawCircle(x, y, radius);
         if (filled) shape.graphics.endFill();
      }
      
      public static function DrawCircle (shape:Object, x:Number, y:Number, radius:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         if (filled) shape.graphics.beginFill(fillColor);
         shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.drawCircle(x, y, radius);
         if (filled) shape.graphics.endFill();
      }
      
      public static function ClearAndDrawLine (shape:Object, x1:Number, y1:Number, x2:Number, y2:Number, color:uint = 0x0, thickness:Number = 1):void
      {
         shape.graphics.clear ();
         shape.graphics.lineStyle(thickness, color);
         shape.graphics.moveTo(x1, y1);
         shape.graphics.lineTo(x2, y2);
      }
      
      public static function DrawLine (shape:Object, x1:Number, y1:Number, x2:Number, y2:Number, color:uint = 0x0, thickness:Number = 1):void
      {
         //trace ("x1 = " + x1 + ", y1 = " + y1 + ", x2= " + x2 + ", y2 = " + y2 + ", thickness = " + thickness);
         
         shape.graphics.lineStyle(thickness, color);
         shape.graphics.moveTo(x1, y1);
         shape.graphics.lineTo(x2, y2);
      }
      
      public static function ClearAndDrawPolygon (shape:Object, points:Array, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         shape.graphics.clear ();
         
         if (points == null)
            return;
         
         var vertexCount:uint = points.length;
         if (vertexCount <= 2)
            return;
         
         if (filled) shape.graphics.beginFill(fillColor);
         shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.moveTo( points [0].x, points [0].y );
         for (var i:uint = 0; i < vertexCount; ++ i)
            shape.graphics.lineTo (points[i].x, points[i].y);
         shape.graphics.lineTo( points [0].x, points [0].y );
         if (filled) shape.graphics.endFill();
      }
      
      public static function DrawPolygon (shape:Object, points:Array, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      {
         if (points == null)
            return;
         
         var vertexCount:uint = points.length;
         if (vertexCount <= 2)
            return;
         
         if (filled) shape.graphics.beginFill(fillColor);
         shape.graphics.lineStyle(borderSize, borderColor);
         shape.graphics.moveTo( points [0].x, points [0].y );
         for (var i:uint = 0; i < vertexCount; ++ i)
            shape.graphics.lineTo (points[i].x, points[i].y);
         shape.graphics.lineTo( points [0].x, points [0].y );
         if (filled) shape.graphics.endFill();
      }
      
   }
}