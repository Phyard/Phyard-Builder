
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   // todo: remove this class
   public class SelectionProxyRectangle extends SelectionProxy
   {
      public function SelectionProxyRectangle (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      // moved into SelectionProxy
      /*
      public function RebuildRectangle (centerX:Number, centerY:Number, halfWidth:Number, halfHeight:Number, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (centerX, centerY, flipped ? - rotation : rotation);
         
         halfWidth *= scale;
         halfHeight *= scale;
         
         var p1:Point = new Point (- halfWidth, - halfHeight);
         var p2:Point = new Point (+ halfWidth, - halfHeight);
         var p3:Point = new Point (+ halfWidth, + halfHeight);
         var p4:Point = new Point (- halfWidth, + halfHeight);
         
         CreateConvexPolygonZone ([p1, p2, p3, p4]);
      }
      
      public function RebuildRectangle2 (posX:Number, posY:Number, left:Number, top:Number, width:Number, height:Number, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (posX, posY, flipped ? - rotation : rotation);
         
         width *= scale;
         height *= scale;
         left *= scale;
         top *= scale;
         var right:Number = left + width;
         var bottom:Number = top + height;
         if (flipped)
         {
            var temp:Number = left;
            left = - right;
            right = - temp;
         }
         
         var p1:Point = new Point (left, top);
         var p2:Point = new Point (right, top);
         var p3:Point = new Point (right, bottom);
         var p4:Point = new Point (left, bottom);
         
         CreateConvexPolygonZone ([p1, p2, p3, p4]);
      }
      */
      
   }
}
