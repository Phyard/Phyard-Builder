package player.entity {
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_WorldBorder extends EntityShapeRectangle
   {
      public function EntityShape_WorldBorder (world:World)
      {
         super (world);
         
         SetPhysicsEnabled (true);
         SetStatic (true);
         SetAsBullet (true);
         SetDrawBorder (false);
         SetBuildBorder (false);
         
         mWorld.RemoveChildFromEntityLayer (mAppearanceObjectsContainer); // added in EntityShape class
         mWorld.AddChildToBorderLayer (mAppearanceObjectsContainer);
      }
   }
}
