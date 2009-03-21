
package player.physics {
   
   public class PhysicsProxyShapePolygon extends PhysicsProxyShape
   {
      public function PhysicsProxyShapePolygon (phyEngine:PhysicsEngine, proxyBody:PhysicsProxyBody, worldPhysicsPoints:Array, params:Object = null):void
      {
         super (phyEngine, proxyBody);
         
         AddPolygonShape (worldPhysicsPoints, params);
      }
      
   }
}
