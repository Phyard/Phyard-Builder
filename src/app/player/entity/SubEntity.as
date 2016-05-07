package player.entity {
   
   import player.world.World;
   
   public class SubEntity extends Entity
   {
      protected var mMainEntity:Entity;
      
      public function SubEntity (world:World)
      {
         super (world);
      }
      
      public function SetMainEntity (mainEntity:Entity):void
      {
         mMainEntity = mainEntity;
      }
      
      override internal function GetMainEntity ():Entity
      {
         return mMainEntity;
      }
   }
}