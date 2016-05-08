
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   import Box2D.Collision.Shapes.b2Polygon;
   
   // todo: remove this class
   public class SelectionProxyPolygon extends SelectionProxy 
   {
      public function SelectionProxyPolygon (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      // moved into SelectionProxy
      //public function RebuildConvexPolygon (centerX:Number, centerY:Number, localPoints:Array, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      //{
      //   Rebuild (centerX, centerY, rotation);
      //   
      //   CreateConvexPolygonZone (localPoints);
      //}
      //
      //public function RebuildConcavePolygon (centerX:Number, centerY:Number, localPoints:Array, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      //{
      //   Rebuild (centerX, centerY, rotation);
      //   
      //   CreateConcavePolygonZone (localPoints);
      //}
      
      
      
   }
}
