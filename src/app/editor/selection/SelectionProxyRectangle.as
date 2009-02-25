
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
   }
}
