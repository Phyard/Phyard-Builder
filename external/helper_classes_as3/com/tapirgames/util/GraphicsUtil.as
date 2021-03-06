package com.tapirgames.util {
   
   import flash.display.Shape;
   import flash.display.Graphics;
   import flash.display.BitmapData;
   import flash.display.LineScaleMode;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   public class GraphicsUtil 
   {      
      public static function DeepClonePointArray (points:Array):Array
      {
         if (points == null)
            return null;
         
         var numPoints:int = points.length;
         var newPointArray:Array = new Array (numPoints);
         var point:Point;
         for (var i:int = 0; i < numPoints; ++ i)
         {
            point = points [i] as Point;
            newPointArray [i] = new Point (point.x, point.y);
         }
         
         return newPointArray;
      }
      
      public static function GetInvertColor (color:uint):uint
      {
         var r:int = (color >> 16) & 0xFF;
         var g:int = (color >>  8) & 0xFF;
         var b:int = (color >>  0) & 0xFF;
         
         return (color & 0xFF000000) | ((255 - r) << 16) | ((255 - g) << 8) | ((255 - b));
      }
      
      public static function GetColorLightnessDiff (color1:uint, color2:uint):Number
      {
         return Math.abs (GetColorLightness (color1) - GetColorLightness (color2));
      }
      
      public static function GetColorLightness (color:uint):Number
      {
         var r:Number = (color >> 16) & 0xFF;
         var g:Number = (color >>  8) & 0xFF;
         var b:Number = (color >>  0) & 0xFF;
         
         return GetColorRgbLightness (r, g, b);
      }
      
      public static function GetColorRgbLightness (r:uint, g:uint, b:uint):Number
      {
         return (0.30 * r + 0.59 * g + 0.11 * b) / 256.0;
      }
      
      // return black or white
      public static function GetInvertColor_b (color:uint):uint
      {
         /*
         var r:int = (color >> 16) & 0xFF;
         var g:int = (color >>  8) & 0xFF;
         var b:int = (color >>  0) & 0xFF;
         
         if (r + g + b > 100 * 3)
            return (color & 0xFF000000) | 0x0;
         else
            return (color & 0xFF000000) | 0xFFFFFF;
         */
         
         if (GetColorLightness (color) > 0.5)
            return (color & 0xFF000000) | 0x0;
         else
            return (color & 0xFF000000) | 0xFFFFFF;
      }
      
      public static function BlendColor (color1:uint, color2:uint, weigth1:Number):uint
      {
         var r1:int = (color1 >> 16) & 0xFF;
         var g1:int = (color1 >>  8) & 0xFF;
         var b1:int = (color1 >>  0) & 0xFF;
         
         var r2:int = (color2 >> 16) & 0xFF;
         var g2:int = (color2 >>  8) & 0xFF;
         var b2:int = (color2 >>  0) & 0xFF;
         
         var weigth2:Number = 1.0 - weigth1;
         
         var r:int = weigth1 * r1 + weigth2 * r2; if (r < 0) r = 0; if (r > 255) r = 255;
         var g:int = weigth1 * g1 + weigth2 * g2; if (g < 0) g = 0; if (g > 255) g = 255;
         var b:int = weigth1 * b1 + weigth2 * b2; if (b < 0) b = 0; if (b > 255) b = 255;
         
         return (r << 16) | (g << 8) | (b);
      }
      
      public static function Clear (shape:Object):void
      {
         shape.graphics.clear ();
      }
      
      // roundCorners is only useful when drawing border
      public static function ClearAndDrawRect (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFFF, roundJoints:Boolean = false, roundCorners:Boolean = false, cornerEslipseWidth:Number = 0.0, cornerEslipseHeight:Number = 0.0, fillTexture:BitmapData = null, fillTextureMatrix:Matrix = null):void
      {
         shape.graphics.clear ();
         if (filled)
         {
            if (fillTexture == null)
               shape.graphics.beginFill(fillColor);
            else
               shape.graphics.beginBitmapFill (fillTexture, fillTextureMatrix);
         }
         if (borderSize >= 0)
            shape.graphics.lineStyle(borderSize, borderColor, 1.0, true, LineScaleMode.NORMAL, roundJoints ? CapsStyle.ROUND: CapsStyle.SQUARE, roundJoints ? JointStyle.ROUND : JointStyle.MITER, 255);
         else
            shape.graphics.lineStyle ();
         if (roundCorners)
            shape.graphics.drawRoundRect(x, y, w, h, cornerEslipseWidth, cornerEslipseHeight);
         else
            shape.graphics.drawRect(x, y, w, h);
         if (filled)
            shape.graphics.endFill();
         if (borderSize >= 0)
            shape.graphics.lineStyle ();
      }
      
      // roundCorners is only useful when drawing border
      public static function DrawRect (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFFF, roundJoints:Boolean = false, roundCorners:Boolean = false, cornerEslipseWidth:Number = 0.0, cornerEslipseHeight:Number = 0.0, fillTexture:BitmapData = null, fillTextureMatrix:Matrix = null):void
      {
         if (filled)
         {
            if (fillTexture == null)
               shape.graphics.beginFill(fillColor);
            else
               shape.graphics.beginBitmapFill (fillTexture, fillTextureMatrix);
         }
         if (borderSize >= 0)
            shape.graphics.lineStyle(borderSize, borderColor, 1.0, true, LineScaleMode.NORMAL, roundJoints ? CapsStyle.ROUND: CapsStyle.SQUARE, roundJoints ? JointStyle.ROUND : JointStyle.MITER, 255);
         else
            shape.graphics.lineStyle ();
         if (roundCorners)
            shape.graphics.drawRoundRect(x, y, w, h, cornerEslipseWidth, cornerEslipseHeight);
         else
            shape.graphics.drawRect(x, y, w, h);
         if (filled)
            shape.graphics.endFill();
         if (borderSize >= 0)
            shape.graphics.lineStyle ();
      }
      
      //public static function DrawRoundRect (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFFF):void
      //{
      //   if (filled) shape.graphics.beginFill(fillColor);
      //   
      //   if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor, 1.0, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER, 255);
      //   shape.graphics.drawRect(x, y, w, h);
      //   if (filled) shape.graphics.endFill();
      //}
      
      //public static function ClearAndDrawEclipse (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      //{
      //   shape.graphics.clear ();
      //   if (filled) shape.graphics.beginFill(fillColor);
      //   if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor);
      //   shape.graphics.drawEclipse(x, y, w, h);
      //   if (filled) shape.graphics.endFill();
      //}
      
      //public static function DrawEclipse (shape:Object, x:Number, y:Number, w:Number, h:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF):void
      //{
      //   if (filled) shape.graphics.beginFill(fillColor);
      //   if (borderSize >= 0) shape.graphics.lineStyle(borderSize, borderColor);
      //   shape.graphics.drawEclipse(x, y, w, h);
      //   if (filled) shape.graphics.endFill();
      //}
      
      public static function ClearAndDrawCircle (shape:Object, x:Number, y:Number, radius:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF, fillTexture:BitmapData = null, fillTextureMatrix:Matrix = null):void
      {
         shape.graphics.clear ();
         if (filled)
         {
            if (fillTexture == null)
               shape.graphics.beginFill(fillColor);
            else
               shape.graphics.beginBitmapFill (fillTexture, fillTextureMatrix);
         }
         if (borderSize >= 0)
            shape.graphics.lineStyle(borderSize, borderColor);
         else
            shape.graphics.lineStyle ();
         shape.graphics.drawCircle(x, y, radius);
         if (filled)
            shape.graphics.endFill();
         if (borderSize >= 0)
            shape.graphics.lineStyle ();
      }
      
      public static function DrawCircle (shape:Object, x:Number, y:Number, radius:Number, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF, fillTexture:BitmapData = null, fillTextureMatrix:Matrix = null):void
      {
         if (filled)
         {
            if (fillTexture == null)
               shape.graphics.beginFill(fillColor);
            else
               shape.graphics.beginBitmapFill (fillTexture, fillTextureMatrix);
         }
         if (borderSize >= 0)
            shape.graphics.lineStyle(borderSize, borderColor);
         else
            shape.graphics.lineStyle ();
         shape.graphics.drawCircle(x, y, radius);
         if (filled)
            shape.graphics.endFill();
         if (borderSize >= 0)
            shape.graphics.lineStyle ();
      }
      
      public static function ClearAndDrawLine (shape:Object, x1:Number, y1:Number, x2:Number, y2:Number, color:uint = 0x0, thickness:Number = 1):void
      {
         shape.graphics.clear ();
         shape.graphics.lineStyle(thickness, color);
         shape.graphics.moveTo(x1, y1);
         shape.graphics.lineTo(x2, y2);
         shape.graphics.lineStyle();
      }
      
      public static function DrawLine (shape:Object, x1:Number, y1:Number, x2:Number, y2:Number, color:uint = 0x0, thickness:Number = 1):void
      {
         //trace ("x1 = " + x1 + ", y1 = " + y1 + ", x2= " + x2 + ", y2 = " + y2 + ", thickness = " + thickness);
         
         shape.graphics.lineStyle(thickness, color);
         shape.graphics.moveTo(x1, y1);
         shape.graphics.lineTo(x2, y2);
         shape.graphics.lineStyle();
      }
      
      public static function ClearAndDrawPolyline (shape:Object, points:Array, color:uint = 0x0, thickness:Number = 1, roundEnds:Boolean = true, closed:Boolean = false):void
      {
         shape.graphics.clear ();
         
         DrawPolyline (shape, points, color, thickness, roundEnds, closed);
      }
      
      public static function DrawPolyline (shape:Object, points:Array, color:uint = 0x0, thickness:Number = 1, roundEnds:Boolean = true, closed:Boolean = false):void
      {
         if (points == null)
            return;
         
         var vertexCount:uint = points.length;
         if (vertexCount < 2)
            return;
         
         if (roundEnds)
            shape.graphics.lineStyle(thickness, color, 1.0, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
         else
            shape.graphics.lineStyle(thickness, color, 1.0, false, LineScaleMode.NORMAL, CapsStyle.NONE);
         
         var p1:Point;
         var p2:Point;
         
         p1 = points [0];
         p2 = points [1];
         shape.graphics.moveTo(p1.x, p1.y);
         shape.graphics.lineTo(p2.x, p2.y);
         
         if (vertexCount > 2)
         {
            var i:int = 2;
            if (vertexCount > 3)
            {
               if (! roundEnds)
               {
                  shape.graphics.lineStyle(thickness, color, 1.0, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
               }
               
               var secondLast:int = vertexCount - 2;
               
               for (; i <= secondLast; ++ i)
               {
                  p2 = points [i];
                  shape.graphics.lineTo(p2.x, p2.y);
               }
               
               if (! roundEnds)
               {
                  shape.graphics.lineStyle(thickness, color, 1.0, false, LineScaleMode.NORMAL, CapsStyle.NONE);
               }
            }
            
            p2 = points [i];
            shape.graphics.lineTo(p2.x, p2.y);
            
            if (closed)
            {
               p2 = points [0];
               shape.graphics.lineTo(p2.x, p2.y);
            }
         }
         
         shape.graphics.lineStyle();
      }
      
      public static function ClearAndDrawPolygon (shape:Object, points:Array, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFF, fillTexture:BitmapData = null, fillTextureMatrix:Matrix = null):void
      {
         shape.graphics.clear ();
         
         DrawPolygon (shape, points, borderColor, borderSize, filled, fillColor, fillTexture, fillTextureMatrix);
      }
      
      public static function DrawPolygon (shape:Object, points:Array, borderColor:uint = 0x0, borderSize:Number = 1, filled:Boolean = false, fillColor:uint = 0xFFFFFF, fillTexture:BitmapData = null, fillTextureMatrix:Matrix = null):void
      {
         if (points == null)
            return;
         
         var vertexCount:uint = points.length;
         if (vertexCount <= 2)
            return;
         
         if (filled)
         {
            if (fillTexture == null)
               shape.graphics.beginFill(fillColor);
            else
               shape.graphics.beginBitmapFill (fillTexture, fillTextureMatrix);
         }
         if (borderSize >= 0) 
            shape.graphics.lineStyle(borderSize, borderColor);
         else
            shape.graphics.lineStyle ();
         shape.graphics.moveTo( points [0].x, points [0].y );
         for (var i:uint = 1; i < vertexCount; ++ i)
            shape.graphics.lineTo (points[i].x, points[i].y);
         shape.graphics.lineTo( points [0].x, points [0].y );
         if (borderSize >= 0) 
            shape.graphics.lineStyle();
         if (filled) shape.graphics.endFill();
      }
      
   }
}
