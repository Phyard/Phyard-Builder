
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   public class _SelectionProxyRectangleForRegionSelection extends SelectionProxyRectangle 
   {
      public function _SelectionProxyRectangleForRegionSelection (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      
      override public function RebuildRectangle (centerX:Number, centerY:Number, halfWidth:Number, halfHeight:Number, rotation:Number = 0.0, flipped:Boolean = false, scale:Number = 1.0):void
      {
         super.RebuildRectangle (centerX, centerY, halfWidth, halfHeight, rotation);
         
         _b2Body.m_fixtureList.SetDensity (1.0);
         _b2Body.ResetMassData ();
      }
   }
}
