
package editor.selection {
   
   import flash.geom.Point;
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   
   import Box2dEx.Helper.b2eFixtureHelper;
   
   public class _SelectionProxyRectangleForRegionSelection extends SelectionProxyRectangle 
   {
      public function _SelectionProxyRectangleForRegionSelection (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      
      override public function RebuildRectangle (rotation:Number, centerX:Number, centerY:Number, halfWidth:Number, halfHeight:Number):void
      {
         super.RebuildRectangle (rotation, centerX, centerY, halfWidth, halfHeight);
         
         b2eFixtureHelper.SetDensity (_b2Body.m_fixtureList, 1.0);
         _b2Body.ResetMass ();
      }
   }
}
