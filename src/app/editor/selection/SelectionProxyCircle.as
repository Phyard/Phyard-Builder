
package editor.selection {
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   
   public class SelectionProxyCircle extends SelectionProxy  
   {
      public function SelectionProxyCircle (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      public function RebuildCircle (centerX:Number, centerY:Number, radius:Number, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         Rebuild (centerX, centerY, rotation);
         
         CreateCircleZone (0, 0, radius * scale);
      }
   }
}
