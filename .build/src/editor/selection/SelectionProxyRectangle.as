
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class SelectionProxyRectangle extends SelectionProxyPolygon 
   {
      public function SelectionProxyRectangle (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      
      public function RebuildRectangle (rotation:Number, centerX:Number, centerY:Number, halfWidth:Number, halfHeight:Number):void
      {
         trace ("centerX = " + centerX + ", centerY = " + centerY);
         trace ("halfWidth = " + halfWidth + ", halfHeight = " + halfHeight);
         
         var p1:Point = new Point (centerX - halfWidth, centerY - halfHeight);
         var p2:Point = new Point (centerX + halfWidth, centerY - halfHeight);
         var p3:Point = new Point (centerX + halfWidth, centerY + halfHeight);
         var p4:Point = new Point (centerX - halfWidth, centerY + halfHeight);
         
         RebuildPolygon (rotation, [p1, p2, p3, p4]);
      }
   }
}
