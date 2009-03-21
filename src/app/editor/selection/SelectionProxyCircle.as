
package editor.selection {
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class SelectionProxyCircle extends SelectionProxy  
   {
      public function SelectionProxyCircle (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      public function RebuildCircle (rotation:Number, centerX:Number, centerY:Number, radius:Number):void
      {
         Rebuild (rotation, centerX, centerY);
         
         CreateCircleZone (0, 0, radius);
      }
   }
}
