
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
      //
         Rebuild_b2Body (rotation, centerX, centerY);
         
      //
         var circleDef:b2CircleDef = new b2CircleDef ();
         circleDef.localPosition.Set(0, 0);
         circleDef.radius = radius;
         circleDef.filter.groupIndex = IsSelectable () ? 0 : -1;
         _b2Body.CreateShape (circleDef);
      }
   }
}
