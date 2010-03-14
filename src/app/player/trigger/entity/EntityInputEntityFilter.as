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
   
   public class EntityInputEntityFilter extends EntityInputEntityLimiter
   {
      protected var mEvaluatedValue:int = ValueDefine.BoolValue_False;
      
      public function EntityInputEntityFilter (world:World, isPairFilter:Boolean)
      {
         super (world, isPairFilter);
      }
   }
}
