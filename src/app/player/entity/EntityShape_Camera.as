
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
      
//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         mWorld.MoveCameraCenterTo_PhysicsPoint (mPositionX, mPositionY);
         mWorld.FollowCameraWithEntity (this, false, false);
      }
      
   }
   
}
