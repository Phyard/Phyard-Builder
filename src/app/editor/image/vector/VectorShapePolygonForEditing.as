package editor.image.vector
{
   import flash.display.DisplayObject; 
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.selection.SelectionProxy;
   
   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   
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
      
      public function CreateSprite ():DisplayObject
      {
         var filledColor:uint = GetBackgroundColor ();
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
            GraphicsUtil.ClearAndDrawLine (polygonSprite, point1.x, point1.y, point2.x, point2.y, borderColor, borderThickness);
         }
         else if (numVertexes >= 3)
         {
            GraphicsUtil.ClearAndDrawPolygon (polygonSprite, vertexPoints, borderColor, borderThickness, drawBg, filledColor);
         }
         
         return polygonSprite;
      }
      
      public function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         var vertexPoints:Array = GraphicsUtil.DeepClonePointArray (mLocalVertexPoints);
         
         selectionProxy.AddConcavePolygonShape (vertexPoints, transform);
         
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
               selectionProxy.AddCircleShape (halfThickness, Transform2D.CombineTransform2Ds (transform, offsetTransform, offsetTransform));
            }
            
            for (var i:int = 1; i < numVertexes; ++ i)
            {
               point2 = vertexPoints [i] as Point;
               selectionProxy.AddLineSegmentShape (point1.x, point1.y, point2.x, point2.y, borderThickness, transform);
               offsetTransform.mOffsetX = point2.x;
               offsetTransform.mOffsetY = point2.y;
               selectionProxy.AddCircleShape (halfThickness, Transform2D.CombineTransform2Ds (transform, offsetTransform, offsetTransform));
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
            cp.RebuildAppearance ();
            cp.RebuildSelectionProxy ();
            
            controlPoints [i] = cp;
         }
         
         return controlPoints;
      }
      
      public function CreateControlPointsForAsset (asset:Asset):Array
      {
         return CreatePolyControlPointsForAsset (mLocalVertexPoints, asset);
      }
      
      public function GetSecondarySelectedControlPointId (primaryControlPoint:ControlPoint):int
      {
         return -1;
      }
      
      public static function OnMovePolyControlPoint (localVertexPoints:Array, controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):Array
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
                  
         return new Array (assetLocalDisplaymentX, assetLocalDisplaymentY, movedControlPointIndex);
      }
      
      public function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):Array
      {
         return OnMovePolyControlPoint (mLocalVertexPoints, controlPoints, movedControlPointIndex, dx, dy);
      }
      
      public function DeleteControlPoint (controlPoint:ControlPoint):int
      {
         return -1;
      }
      
      public function InsertControlPointBefore (controlPoint:ControlPoint):int
      {
         return -1;
      }
   }
}
