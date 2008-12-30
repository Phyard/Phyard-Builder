
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Common.b2Settings;
   import Box2D.Common.Math.b2Vec2;
   
   
   public class PhysicsProxyShapePolygon extends PhysicsProxyShape
   {
      public function PhysicsProxyShapePolygon (phyEngine:PhysicsEngine, proxyBody:PhysicsProxyBody, worldPhysicsPoints:Array, params:Object = null):void
      {
         super (phyEngine, proxyBody);
         
         var polygonDef:b2PolygonDef = new b2PolygonDef ();
         polygonDef.vertexCount = worldPhysicsPoints.length;
         if (polygonDef.vertexCount > b2Settings.b2_maxPolygonVertices)
            polygonDef.vertexCount = b2Settings.b2_maxPolygonVertices;
         
         for (var vertexId:int = 0; vertexId < polygonDef.vertexCount; ++ vertexId)
         {
            var point:Point = worldPhysicsPoints [vertexId] as Point;
            var vertex:b2Vec2 = new b2Vec2 (point.x, point.y);
            polygonDef.vertices [vertexId].SetV ( mPhysicsProxyBody._b2Body.GetLocalVector (vertex) );
         }
         
         if (params != null)
         {
            polygonDef.density = params.mDensity;
            polygonDef.friction = params.mFriction;
            polygonDef.restitution = params.mRestitution;
         }
         else
         {
            polygonDef.density = 1.0;
            polygonDef.friction = 0.1;
            polygonDef.restitution = 0.2;
         }
         
         //polygonDef.filter.groupIndex = 
         
         _b2Shape = mPhysicsProxyBody._b2Body.CreateShape (polygonDef);
         
         _b2Shape.SetUserData (this);
      }
      
   }
}
