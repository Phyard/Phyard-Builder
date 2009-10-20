
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
      
      
      override public function RebuildRectangle (rotation:Number, centerX:Number, centerY:Number, halfWidth:Number, halfHeight:Number):void
      {
         super.RebuildRectangle (rotation, centerX, centerY, halfWidth, halfHeight);
         
         //_b2Body.m_fixtureList.m_density = 1.0;
         //_b2Body.SetMassFromShapes();
      }
   }
}
