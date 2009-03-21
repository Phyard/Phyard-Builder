
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
      
      public function RebuildConvexPolygon (rotation:Number, centerX:Number, centerY:Number, localPoints:Array):void
      {
         Rebuild (rotation, centerX, centerY);
         
         CreateConvexPolygonZone (localPoints);
      }
      
      public function RebuildConcavePolygon (rotation:Number, centerX:Number, centerY:Number, localPoints:Array):void
      {
         Rebuild (rotation, centerX, centerY);
         
         CreateConcavePolygonZone (localPoints);
      }
      
      
      
   }
}
