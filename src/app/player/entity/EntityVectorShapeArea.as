package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityVectorShapeArea extends EntityShape
   {
      public function EntityVectorShapeArea (world:World)
      {
         super (world);
      }      
   }
}
