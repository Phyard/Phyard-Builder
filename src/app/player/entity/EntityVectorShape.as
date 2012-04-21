package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityVectorShape extends EntityShape
   {
      public function EntityVectorShape (world:World)
      {
         super (world);
      }      
   }
}
