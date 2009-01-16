
package player.entity {
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyJoint;
   
   public class EntityJoint extends Entity
   {
      
      
      public function EntityJoint (world:World)
      {
         super (world);
      }
      
      // used internally
      public function GetRecommendedChildIndex ():int
      {
         if (mPhysicsProxy == null)
            return -1;
         
         var body1:PhysicsProxyBody = (mPhysicsProxy as PhysicsProxyJoint).GetBody1 () as PhysicsProxyBody;
         var body2:PhysicsProxyBody = (mPhysicsProxy as PhysicsProxyJoint).GetBody2 () as PhysicsProxyBody;
         var container1:ShapeContainer = body1 == null ? null : body1.GetUserData () as ShapeContainer;
         var container2:ShapeContainer = body2 == null ? null : body2.GetUserData () as ShapeContainer;
         
         var index1:int = -1;
         var index2:int = -1;
         
         if (container1 != null && mWorld.contains (container1))
           index1 = mWorld.getChildIndex (container1);
         if (container2 != null && mWorld.contains (container2))
           index2 = mWorld.getChildIndex (container2);
         
         return index1 > index2 ? index1 : index2;
      }
      
   }
   
}
