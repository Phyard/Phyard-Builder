
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   import Box2D.Collision.Shapes.b2Polygon;
   
   public class SelectionProxyPolygon extends SelectionProxy 
   {
      public function SelectionProxyPolygon (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      public function RebuildRectangle (rotation:Number, centerX:Number, centerY:Number, halfWidth:Number, halfHeight:Number):void
      {
         var p1:Point = new Point (- halfWidth, - halfHeight);
         var p2:Point = new Point (+ halfWidth, - halfHeight);
         var p3:Point = new Point (+ halfWidth, + halfHeight);
         var p4:Point = new Point (- halfWidth, + halfHeight);
         
         RebuildConvexPolygon (rotation, centerX, centerY, [p1, p2, p3, p4]);
      }
      
      public function RebuildConvexPolygon (rotation:Number, centerX:Number, centerY:Number, localPoints:Array):void
      {
      //
         var vertexCount:uint = localPoints.length;
         if (vertexCount > b2Settings.b2_maxPolygonVertices)
            vertexCount = b2Settings.b2_maxPolygonVertices;
         
      //
         Rebuild_b2Body (rotation, centerX, centerY);
         
      //
         var polygonDef:b2PolygonDef = new b2PolygonDef ();
         polygonDef.vertexCount = vertexCount;
         polygonDef.filter.groupIndex = IsSelectable () ? 0 : -1;
         for (var i:int = 0; i < vertexCount; ++ i)
         {
            polygonDef.vertices [i].Set (localPoints [i].x, localPoints [i].y);
         }
         
         _b2Body.CreateShape (polygonDef);
      }
      
      public function RebuildConcavePolygon (rotation:Number, centerX:Number, centerY:Number, localPoints:Array):void
      {
         var vertexCount:uint = localPoints.length;
         
         if (vertexCount < 3)
            return;
         
         Rebuild_b2Body (rotation, centerX, centerY);
         
         var xPositions:Array = new Array (vertexCount);
         var yPositions:Array = new Array (vertexCount);
         
         var i:int;
         
         for (i = 0; i < localPoints.length; ++ i) 
         {
            xPositions[i] = localPoints[i].x;
            yPositions[i] = localPoints[i].y;
         }
         
         // Create the initial poly
         var polygon:b2Polygon = new b2Polygon(xPositions, yPositions, vertexCount);
         
         var decomposedPolygons:Array = new Array ();
         var numDecomposedPolygons:int = b2Polygon.DecomposeConvex(polygon, decomposedPolygons, vertexCount - 2);
         
         for (i = 0; i < numDecomposedPolygons; ++ i) 
         {
            var polygonDef:b2PolygonDef = new b2PolygonDef();
            
            polygonDef.filter.groupIndex = IsSelectable () ? 0 : -1;
            
            decomposedPolygons[i].AddTo(polygonDef);
            
            _b2Body.CreateShape (polygonDef);
         }
      }
      
      
      
   }
}
