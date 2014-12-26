package player.display
{
   import flash.display.Sprite;
   
   import player.entity.Entity;
   
   public class EntitySprite extends Sprite
   {
      private var mEntity:Entity;
      
      public function EntitySprite (entity:Entity)
      {
         mEntity = entity;
      }
      
      public function GetEntity ():Entity
      {
         return mEntity;
      }
   }
}