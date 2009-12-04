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
      
      public function Evaluate ():void
      {
         // to override
      }
      
      private var mLastEvaluateStep:int = -1;
      
      final public function GetEvaluatedValue ():int
      {
         // most evaluate once at each simulateion step
         var worldSimulateStep:int = mWorld.GetSimulatedStep ();
         if (mLastEvaluateStep < worldSimulateStep)
         {
            mLastEvaluateStep = worldSimulateStep;
            
            Evaluate ();
         }
         
         return mEvaluatedValue;
      }
   }
}