package player.trigger.entity
{
   import flash.utils.Dictionary;
   
   import player.world.World;
   import player.entity.Entity;
   
   import player.trigger.ValueSource;
   import player.trigger.ValueSource_Direct;
   
   import player.trigger.data.ListElement_InputEntityAssigner;
   
   import common.trigger.ValueDefine;
   
   import common.Define;
   
   public class EntityInputEntityLimiter extends EntityLogic
   {
      protected var mIsPairLimiter:Boolean;
      
      // 
      public function EntityInputEntityLimiter (world:World, isPairLimiter:Boolean)
      {
         super (world);
         
         mIsPairLimiter = isPairLimiter;
      }
      
   }
}
