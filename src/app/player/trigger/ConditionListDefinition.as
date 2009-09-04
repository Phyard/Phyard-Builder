package player.trigger
{
   import common.trigger.ValueTypeDefine;
   
   public class ConditionListDefinition
   {
      protected var mFirstBoolFunctionCalling:FunctionCalling = null;
      
      protected var mIsAnd:Boolean = true;
      protected var mIsNot:Boolean = true;
      
      public function ConditionListDefinition (firstCalling:FunctionCalling, isAnd:Boolean, isNot:Boolean)
      {
         mFirstBoolFunctionCalling = firstCalling;
         
         mIsAnd = isAnd;
         mIsNot = isNot;
      }
      
      public function Evaluate ():Boolean
      {
         var calling:FunctionCalling = mFirstBoolFunctionCalling;
         
         if (mIsAnd)
         {
            while (calling != null)
            {
               calling.Call ();
               
               if (calling.mIsConditionCalling && TriggerEngine.sLastBoolReturnValue != calling.mTargetBoolValue)
                  return false;
               
               calling = calling.mNextFunctionCalling;
            }
            
            return true;
         }
         else
         {
            while (calling != null)
            {
               calling.Call ();
               
               if (calling.mIsConditionCalling && TriggerEngine.sLastBoolReturnValue == calling.mTargetBoolValue)
                  return true;
               
               calling = calling.mNextFunctionCalling;
            }
            
            return false;
         }
      }
   }
}