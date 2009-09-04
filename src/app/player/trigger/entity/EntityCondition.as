package player.trigger.entity
{
   import player.world.World;
   
   import common.trigger.ValueDefine;
   
   public class EntityCondition extends EntityLogic
   {
      protected var mEvaluatedValue:int = ValueDefine.BoolValue_False;
      
      public function EntityCondition (world:World)
      {
         super (world);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
      }
      
      public function Evaluate ():void
      {
      }
      
      public function GetEvaluatedValue ():int
      {
         return mEvaluatedValue;
      }
   }
}