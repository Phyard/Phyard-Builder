package player.trigger.entity
{
   import player.world.World;
   import player.entity.Entity;
   
   public class EntityLogic extends Entity
   {
      
      public function EntityLogic (world:World)
      {
         super (world);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
      }
   }
}