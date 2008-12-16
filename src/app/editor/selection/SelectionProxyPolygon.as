
package editor.selection {
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class SelectionProxyPolygon extends SelectionProxy 
   {
      public function SelectionProxyPolygon (selEngine:SelectionEngine):void
      {
         super (selEngine);
      }
      
      
      public function RebuildPolygon (rotation:Number, points:Array):void
      {
      //
         var vertexCount:uint = points.length;
         if (vertexCount > b2Settings.b2_maxPolygonVertices)
            vertexCount = b2Settings.b2_maxPolygonVertices;
         
         var i:uint;
         var centerX:Number = 0;
         var centerY:Number = 0;
         
         for (i =0; i < vertexCount; ++ i)
         {
            centerX += points [i].x;
            centerY += points [i].y;
         }
         
         if (vertexCount > 0)
         {
            centerX = centerX / vertexCount;
            centerY = centerY / vertexCount;
         }
         
      //
         Rebuild_b2Body (rotation, centerX, centerY);
         
      //
         var polygonDef:b2PolygonDef = new b2PolygonDef ();
         polygonDef.vertexCount = vertexCount;
         for (i =0; i < vertexCount; ++ i)
         {
            polygonDef.vertices [i].Set (points [i].x - centerX, points [i].y - centerY);
         }
         
         _b2Body.CreateShape (polygonDef);
      }
   }
}
