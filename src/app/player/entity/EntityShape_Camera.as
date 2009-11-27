
package player.entity {
   
   import flash.geom.Point;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_Camera extends EntityShape
   {
      public function EntityShape_Camera (world:World)
      {
         super (world);
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         mWorld.SetTargetCameraCenter (mPositionX, mPositionY);
      }
      
   }
   
}
