package editor.image.vector
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.geom.Point;
   import flash.geom.Rectangle;

   import com.tapirgames.util.GraphicsUtil;

   import editor.selection.SelectionProxy;

   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   import editor.asset.ControlPointModifyResult;
   
   import editor.image.AssetImageBitmapModule;

   import common.shape.VectorShapePolygon;

   import common.Transform2D;

   public class VectorShapePolygonForEditing extends VectorShapePolygon implements VectorShapeForEditing
   {
      private var mPhysicsBuildable:Boolean = true;
      private var mMinLocalX:Number = -1.0;
      private var mMaxLocalX:Number = 1.0;
      private var mMinLocalY:Number = -1.0;
      private var mMaxLocalY:Number = 1.0;

      public function UpdateMinMaxXYs ():void
      {
         mMinLocalX = mMinLocalY = -1.0;
         mMaxLocalX = mMaxLocalY = 1.0;

         var numVertexes:int = mLocalVertexPoints.length;
         for (var i:int = 0; i < numVertexes; ++ i)
         {
            var point:Point = mLocalVertexPoints [i] as Point;
            if (mMinLocalX > point.x)
               mMinLocalX = point.x;
            if (mMaxLocalX < point.x)
               mMaxLocalX = point.x;
            if (mMinLocalY > point.y)
               mMinLocalY = point.y;
            if (mMaxLocalY < point.y)
               mMaxLocalY = point.y;
         }
      }
      
      override public function SetLocalVertexPoints (points:Array):void
      {
         super.SetLocalVertexPoints (points);
         
         UpdateMinMaxXYs ();
      }

      public function OnCreating (points:Array):Point
      {
         if (points == null)
         {
            SetValid (false);
            return null;
         }

         mLocalVertexPoints = new Array (); //.splice (0, mLocalPoints.length);

         var centerX:Number = 0.0;
         var centerY:Number = 0.0;

         var numPoints:int = points.length;
         var i:int;
         var point:Point;

         for (i = 0; i < numPoints; ++ i)
         {
            point = points [i] as Point;
            centerX += point.x;
            centerY += point.y;

            mLocalVertexPoints.push (new Point (point.x, point.y));
         }

         if (numPoints > 1)
         {
            centerX /= numPoints;
            centerY /= numPoints;
         }

         for (i = 0; i < numPoints; ++ i)
         {
            point = mLocalVertexPoints [i] as Point;
            point.x -= centerX;
            point.y -= centerY;
         }

         UpdateMinMaxXYs ();

         SetValid (numPoints >= 3);

         return new Point (centerX, centerY);
      }

      public function CreateSprite (isSelected:Boolean = false):DisplayObject
      {
         var filledColor:uint = GetBodyColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();

         if ( ! drawBorder)
         {
            drawBg = true;
            borderThickness = -1;
         }

         var polygonSprite:Shape = new Shape ();

         var vertexPoints:Array = GraphicsUtil.DeepClonePointArray (mLocalVertexPoints);
         var numVertexes:int = vertexPoints.length;

         if (numVertexes <= 1)
         {
            GraphicsUtil.Clear (polygonSprite);
         }
         else if (numVertexes == 2)
         {
            var point1:Point = vertexPoints [0] as Point;
            var point2:Point = vertexPoints [1] as Point;
            GraphicsUtil.ClearAndDrawLine (polygonSprite, point1.x, point1.y, point2.x, point2.y, isSelected ? 0x0000FF : borderColor, borderThickness);
         }
         else if (numVertexes >= 3)
         {
            var bitmapModule:AssetImageBitmapModule = GetBodyTextureModule () as AssetImageBitmapModule;
            var bitmapTransform:Transform2D = GetBodyTextureTransform ();
            
            GraphicsUtil.ClearAndDrawPolygon (polygonSprite, vertexPoints, borderColor, borderThickness, drawBg, filledColor, 
                                              bitmapModule == null ? null : bitmapModule.GetBitmapData (),
                                              bitmapTransform == null ? null : bitmapTransform.ToMatrix ());

            if (isSelected || (! mPhysicsBuildable))
            {
               var contianer:Sprite = new Sprite ();
               contianer.addChild (polygonSprite);

               if (isSelected)
               {
                  var blueShape:Shape = new Shape ();
                  GraphicsUtil.ClearAndDrawPolygon (blueShape, vertexPoints, 0x0000FF, -1, true, 0x0000FF);
                  blueShape.alpha = 0.5;
                  contianer.addChild (blueShape);
               }
               
               if (! mPhysicsBuildable)
               {
                  var rectangle:Rectangle = polygonSprite.getBounds (polygonSprite);
                  
                  var redShape:Shape = new Shape ();
                  GraphicsUtil.ClearAndDrawRect (redShape, rectangle.left, rectangle.top, rectangle.width, rectangle.height, 
                                                 0xFF0000, 3, false, 0xFF00000);
                  redShape.alpha = 0.5;
                  contianer.addChild (redShape);
               }
               
               return contianer;
            }
         }

         return polygonSprite;
      }

      public function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         var vertexPoints:Array = GraphicsUtil.DeepClonePointArray (mLocalVertexPoints);

         selectionProxy.AddConcavePolygonShape (vertexPoints, transform);

         vertexPoints = GraphicsUtil.DeepClonePointArray (mLocalVertexPoints); // !!! for vertexPoints is transformed in last calling

         if (selectionProxy.GetProxyShapesCount () == 0)
         {
            mPhysicsBuildable = false;

            selectionProxy.AddConvexPolygonShape (
                  [new Point (mMinLocalX, mMinLocalY), new Point (mMaxLocalX, mMinLocalY), new Point (mMaxLocalX, mMaxLocalY), new Point (mMinLocalX, mMaxLocalY)],
                  transform);
         }
         else
         {
            mPhysicsBuildable = true;
         }

         var borderThickness:Number = GetBorderThickness ();
         var halfThickness:Number = borderThickness * 0.5;

         if (halfThickness > 2)
         {
            var numVertexes:int = vertexPoints.length;
            var point1:Point;
            var point2:Point;
            var offsetTransform:Transform2D = new Transform2D ();
            var finalTransform:Transform2D = new Transform2D ();

            if (numVertexes > 0)
            {
               point1 = vertexPoints [0] as Point;
               offsetTransform.mOffsetX = point1.x;
               offsetTransform.mOffsetY = point1.y;
               selectionProxy.AddCircleShape (halfThickness, Transform2D.CombineTransforms (transform, offsetTransform, finalTransform));
            }

            for (var i:int = 1; i < numVertexes; ++ i)
            {
               point2 = vertexPoints [i] as Point;
               selectionProxy.AddLineSegmentShape (point1.x, point1.y, point2.x, point2.y, borderThickness, transform);
               offsetTransform.mOffsetX = point2.x;
               offsetTransform.mOffsetY = point2.y;
               selectionProxy.AddCircleShape (halfThickness, Transform2D.CombineTransforms (transform, offsetTransform, finalTransform));
               point1 = point2;
            }

            if (numVertexes > 2)
            {
               point2 = vertexPoints [0] as Point;
               selectionProxy.AddLineSegmentShape (point1.x, point1.y, point2.x, point2.y, borderThickness, transform);
            }
         }
      }

      public static function CreatePolyControlPointsForAsset (localVertexPoints:Array, asset:Asset):Array
      {
         if (localVertexPoints == null || localVertexPoints.length == 0)
            return null;

         var vertexCount:int = localVertexPoints.length;
         var controlPoints:Array = new Array (vertexCount);

         for (var i:int = 0; i < vertexCount; ++ i)
         {
            var vertexPoint:Point = localVertexPoints [i] as Point;

            var cp:ControlPoint = new ControlPoint (asset, i);
            cp.SetPosition (vertexPoint.x, vertexPoint.y);
            cp.Refresh ();

            controlPoints [i] = cp;
         }

         return controlPoints;
      }

      public function CreateControlPointsForAsset (asset:Asset):Array
      {
         return CreatePolyControlPointsForAsset (mLocalVertexPoints, asset);
      }

      public function GetSecondarySelectedControlPointId (primaryControlPointIndex:int):int
      {
         if (mLocalVertexPoints == null || mLocalVertexPoints.length == 0 || primaryControlPointIndex < 0 || primaryControlPointIndex >= mLocalVertexPoints.length)
            return -1;

         var index:int = (primaryControlPointIndex - 1) % mLocalVertexPoints.length;
         if (index < 0)
            index += mLocalVertexPoints.length;

         return index;
      }

      public static function OnMovePolyControlPoint (localVertexPoints:Array, controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):ControlPointModifyResult
      {
         if (localVertexPoints == null || localVertexPoints.length == 0)
            return null;

         var vertexCount:int = localVertexPoints.length;

         if (controlPoints == null || controlPoints.length != vertexCount)
            return null;

         if (movedControlPointIndex < 0 || movedControlPointIndex >= vertexCount)
            return null;

         var assetLocalDisplaymentX:Number = dx / Number (vertexCount);
         var assetLocalDisplaymentY:Number = dy / Number (vertexCount);

         var movedVertexPoint:Point = localVertexPoints [movedControlPointIndex] as Point;
         movedVertexPoint.x += dx;
         movedVertexPoint.y += dy;

         for (var i:int = 0; i < vertexCount; ++ i)
         {
            var vertexPoint:Point = localVertexPoints [i] as Point;
            vertexPoint.x -= assetLocalDisplaymentX;
            vertexPoint.y -= assetLocalDisplaymentY;

            var cp:ControlPoint = controlPoints [i] as ControlPoint;
            cp.SetPosition (vertexPoint.x, vertexPoint.y);
         }

         return new ControlPointModifyResult (false, assetLocalDisplaymentX, assetLocalDisplaymentY, movedControlPointIndex);
      }

      public function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):ControlPointModifyResult
      {
         var r:ControlPointModifyResult = OnMovePolyControlPoint (mLocalVertexPoints, controlPoints, movedControlPointIndex, dx, dy);
         
         UpdateMinMaxXYs ();
         
         return r;
      }

      public static function OnDeletePolyControlPoint (controlPoints:Array, localVertexPoints:Array, toDeleteControlPointIndex:int, minNumPoints:int):ControlPointModifyResult
      {
         if (localVertexPoints == null || localVertexPoints.length == 0)
            return null;

         var vertexCount:int = localVertexPoints.length;

         if (controlPoints == null || controlPoints.length != vertexCount)
            return null;

         if (toDeleteControlPointIndex < 0 || toDeleteControlPointIndex >= vertexCount)
            return null;

         if (vertexCount <= minNumPoints)
            return new ControlPointModifyResult (true);

         var toDeleteControlPoint:Point = localVertexPoints [toDeleteControlPointIndex] as Point;
         localVertexPoints.splice (toDeleteControlPointIndex, 1);
         -- vertexCount;

         var assetLocalDisplaymentX:Number = toDeleteControlPoint.x / Number (vertexCount);
         var assetLocalDisplaymentY:Number = toDeleteControlPoint.y / Number (vertexCount);

         for (var i:int = 0; i < vertexCount; ++ i)
         {
            var vertexPoint:Point = localVertexPoints [i] as Point;
            vertexPoint.x -= assetLocalDisplaymentX;
            vertexPoint.y -= assetLocalDisplaymentY;
         }

         return new ControlPointModifyResult (false, assetLocalDisplaymentX, assetLocalDisplaymentY, -1);
      }

      public function DeleteControlPoint (controlPoints:Array, toDeleteControlPointIndex:int):ControlPointModifyResult
      {
         var r:ControlPointModifyResult = OnDeletePolyControlPoint (controlPoints, mLocalVertexPoints, toDeleteControlPointIndex, 3);
         
         UpdateMinMaxXYs ();
         
         return r;
      }

      public static function OnInsertPloyControlPointBefore (controlPoints:Array, localVertexPoints:Array, insertBeforeControlPointIndex:int):ControlPointModifyResult
      {
         if (localVertexPoints == null || localVertexPoints.length == 0)
            return null;

         var vertexCount:int = localVertexPoints.length;

         if (controlPoints == null || controlPoints.length != vertexCount)
            return null;

         if (insertBeforeControlPointIndex < 0 || insertBeforeControlPointIndex >= vertexCount)
            return null;

         var insertBeforeControlPoint:Point = localVertexPoints [insertBeforeControlPointIndex] as Point;

         var lastPointIndex:int = insertBeforeControlPointIndex == 0 ? vertexCount - 1 : insertBeforeControlPointIndex - 1;
         var lastPoint:Point = localVertexPoints [lastPointIndex] as Point;

         var newPoint:Point = new Point (0.5 * (lastPoint.x + insertBeforeControlPoint.x), 0.5 * (lastPoint.y + insertBeforeControlPoint.y));

         localVertexPoints.splice (insertBeforeControlPointIndex, 0, newPoint);
         ++ vertexCount;

         var assetLocalDisplaymentX:Number = newPoint.x / Number (vertexCount);
         var assetLocalDisplaymentY:Number = newPoint.y / Number (vertexCount);

         for (var i:int = 0; i < vertexCount; ++ i)
         {
            var vertexPoint:Point = localVertexPoints [i] as Point;
            vertexPoint.x -= assetLocalDisplaymentX;
            vertexPoint.y -= assetLocalDisplaymentY;
         }

         return new ControlPointModifyResult (false, assetLocalDisplaymentX, assetLocalDisplaymentY, insertBeforeControlPointIndex + 1);
      }

      public function InsertControlPointBefore (controlPoints:Array, insertBeforeControlPointIndex:int):ControlPointModifyResult
      {
         var r:ControlPointModifyResult = OnInsertPloyControlPointBefore (controlPoints, mLocalVertexPoints, insertBeforeControlPointIndex);
         
         UpdateMinMaxXYs ();
         
         return r;
      }
      
   }
}
