
package player.physics {
   
   public class PhysicsProxyShapeCircle extends PhysicsProxyShape
   {
      public function PhysicsProxyShapeCircle (phyEngine:PhysicsEngine, proxyBody:PhysicsProxyBody, worldPhysicsX:Number, worldPhysicsY:Number, physicsRadius:Number, params:Object = null):void
      {
         super (phyEngine, proxyBody);
         
         AddCircleShape (worldPhysicsX, worldPhysicsY, physicsRadius, params);
      }
      
      
      
   }
}
