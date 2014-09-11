package editor.image.vector
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.geom.Point;

   import com.tapirgames.util.GraphicsUtil;

   import editor.selection.SelectionProxy;

   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   import editor.asset.ControlPointModifyResult;
   
   import editor.image.AssetImageBitmapModule;

   import common.shape.VectorShapePolygon;
   import common.shape.VectorShapePolyline;

   import common.Transform2D;

   public class VectorShapePolylineForEditing extends VectorShapePolyline implements VectorShapeForEditing
   {
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

         SetValid (numPoints >= 2);

         return new Point (centerX, centerY);
      }

      public function CreateSprite (isSelected:Boolean = false, inPreview:Boolean = false):DisplayObject
      {
         var bgColor:uint = GetBodyColor ();
         var curveThickness:Number = GetPathThickness ();

         var polylineSprite:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawPolyline (polylineSprite, GraphicsUtil.DeepClonePointArray (mLocalVertexPoints), isSelected ? 0x0000FF : bgColor, curveThickness, IsRoundEnds (), IsClosed ());

         polylineSprite.alpha = inPreview ? 1.0 : 0.39 + GetBodyAlpha () * 0.40;
         
         return polylineSprite;
      }

      public function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         var vertexPoints:Array = GraphicsUtil.DeepClonePointArray (mLocalVertexPoints);
         var numVertexes:int = vertexPoints.length;

         var thickness:Number = GetPathThickness ();

         // to make selectiing easier
         if (thickness * visualScale < 5)
            thickness = 5 / visualScale;

         var halfThickness:Number = thickness * 0.5;

         var offsetTransform:Transform2D = new Transform2D ();
         var finalTransform:Transform2D = new Transform2D ();

         var i:int;
         var point1:Point;
         var point2:Point;

         if (IsClosed () && numVertexes > 2)
         {
            if (IsClosed () && numVertexes > 2)
            {
               point1 = vertexPoints [numVertexes - 1];
               i = -1;
            }
            else
            {
               point1 = vertexPoints [0];
               i = 0;
            }

            while (++ i < numVertexes)
            {
               point2 = vertexPoints [i];
               selectionProxy.AddLineSegmentShape (point1.x, point1.y, point2.x, point2.y, thickness, transform);
               offsetTransform.mOffsetX = point2.x;
               offsetTransform.mOffsetY = point2.y;
               selectionProxy.AddCircleShape (halfThickness, Transform2D.CombineTransforms (transform, offsetTransform, finalTransform));

               point1 = point2;
            }
         }
         else
         {
            point1 = vertexPoints [0];

            if (IsRoundEnds () && halfThickness > 2 && numVertexes > 0)
            {
               offsetTransform.mOffsetX = point1.x;
               offsetTransform.mOffsetY = point1.y;
               selectionProxy.AddCircleShape (halfThickness, Transform2D.CombineTransforms (transform, offsetTransform, finalTransform));
            }

            for (i = 1; i < numVertexes; ++ i)
            {
               point2 = vertexPoints [i];
               selectionProxy.AddLineSegmentShape (point1.x, point1.y, point2.x, point2.y, thickness, transform);
               if (halfThickness > 2 && i < (numVertexes - 1))
               {
                  offsetTransform.mOffsetX = point2.x;
                  offsetTransform.mOffsetY = point2.y;
                  selectionProxy.AddCircleShape (halfThickness, Transform2D.CombineTransforms (transform, offsetTransform, finalTransform));
               }

               point1 = point2;
            }

            if (IsRoundEnds () && halfThickness > 2 && numVertexes > 1)
            {
               offsetTransform.mOffsetX = point2.x;
               offsetTransform.mOffsetY = point2.y;
               selectionProxy.AddCircleShape (halfThickness, Transform2D.CombineTransforms (transform, offsetTransform, finalTransform));
            }
         }
      }

      public function CreateControlPointsForAsset (asset:Asset):Array
      {
         return VectorShapePolygonForEditing.CreatePolyControlPointsForAsset (mLocalVertexPoints, asset);
      }

      public function GetSecondarySelectedControlPointId (primaryControlPointIndex:int):int
      {
         if (mLocalVertexPoints == null || mLocalVertexPoints.length == 0 || primaryControlPointIndex <= 0 || primaryControlPointIndex >= mLocalVertexPoints.length)
            return -1;

         return (primaryControlPointIndex - 1) % mLocalVertexPoints.length;
      }

      public function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):ControlPointModifyResult
      {
         return VectorShapePolygonForEditing.OnMovePolyControlPoint (mLocalVertexPoints, controlPoints, movedControlPointIndex, dx, dy);;
      }

      public function DeleteControlPoint (controlPoints:Array, toDeleteControlPointIndex:int):ControlPointModifyResult
      {
         return VectorShapePolygonForEditing.OnDeletePolyControlPoint (controlPoints, mLocalVertexPoints, toDeleteControlPointIndex, 2);
      }

      public function InsertControlPointBefore (controlPoints:Array, insertBeforeControlPointIndex:int):ControlPointModifyResult
      {
         if ((! IsClosed ()) && insertBeforeControlPointIndex == 0)
            return null;

         return VectorShapePolygonForEditing.OnInsertPloyControlPointBefore (controlPoints, mLocalVertexPoints, insertBeforeControlPointIndex);
      }
      
   }
}
