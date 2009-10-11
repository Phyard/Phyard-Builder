
package player.entity {
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyJoint;
   
   public class EntityContainerChild extends Entity
   {
      //protected var mShapeContainer:ShapeContainer;
      
      public function EntityContainerChild (world:World, shapeContainer:ShapeContainer)
      {
         super (world);
         
         //mShapeContainer = shapeContainer;
         
         shapeContainer.addChild (this);
      }
      
      public function GetParentContainer ():ShapeContainer
      {
         return parent as ShapeContainer;
      }
      
   }
   
}
