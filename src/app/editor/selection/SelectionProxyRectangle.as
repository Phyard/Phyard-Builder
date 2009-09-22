
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   
   public class SelectionProxyRectangle extends SelectionProxy 
   {
      public function SelectionProxyRectangle (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      public function RebuildRectangle (rotation:Number, centerX:Number, centerY:Number, halfWidth:Number, halfHeight:Number):void
      {
         Rebuild (rotation, centerX, centerY);
         
         var p1:Point = new Point (- halfWidth, - halfHeight);
         var p2:Point = new Point (+ halfWidth, - halfHeight);
         var p3:Point = new Point (+ halfWidth, + halfHeight);
         var p4:Point = new Point (- halfWidth, + halfHeight);
         
         CreateConvexPolygonZone ([p1, p2, p3, p4]);
      }
      
   }
}
