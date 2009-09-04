package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.data.ListElement_InputEntityAssigner;
   
   import common.trigger.ValueDefine;
   
   public class EntityTask extends EntityCondition
   {
      public static var sNeedToReEvaluated:Boolean = false;
      
      protected var mFirstEntityAssigner:ListElement_InputEntityAssigner = null;
      
      public function EntityTask (world:World)
      {
         super (world);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
      }
      
      public function SetEntityAssigners (assignerEntityIndexes:Array):void
      {
         if (assignerEntityIndexes == null)
            return;
         
         var newElement:ListElement_InputEntityAssigner;
          
         for (var i:int = assignerEntityIndexes.length - 1; i >= 0; -- i)
         {
            newElement = new ListElement_InputEntityAssigner (mWorld.GetEntityByIndexInEditor (assignerEntityIndexes [i]) as EntityInputEntityAssigner);
            newElement.mNextListElement = mFirstEntityAssigner;
            mFirstEntityAssigner = newElement;
         }
      }
      
      override public function Evaluate ():void
      {
         if (sNeedToReEvaluated)
         {
            var num_faileds:int = 0;
            var num_undetermineds:int = 0;
            
            var element:ListElement_InputEntityAssigner = mFirstEntityAssigner;
            var status:int;
            
            while (element != null)
            {
               status = element.mInputEntityAssigner.UpdateEntityTaskStatus ();
               if (status == ValueDefine.TaskStatus_Undetermined)
                  ++ num_undetermineds;
               else if (status == ValueDefine.TaskStatus_Failed)
                  ++ num_faileds;
               
               element = element.mNextListElement;
            }
            
            if (num_faileds > 0)
               mEvaluatedValue = ValueDefine.TaskStatus_Failed;
            else if (num_undetermineds > 0)
               mEvaluatedValue = ValueDefine.TaskStatus_Undetermined;
            else
               mEvaluatedValue = ValueDefine.TaskStatus_Successed;
         }
      }
   }
}