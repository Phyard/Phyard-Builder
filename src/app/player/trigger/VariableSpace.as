
package player.trigger
{
   
   public class VariableSpace
   {
      protected var mFirstVariableInstance:VariableInstance;
      
      internal var mVariableInstances:Array;
      
      public function VariableSpace (numVariables:int = 0)
      {
         if (numVariables < 0)
            numVariables = 0;
         
         mVariableInstances = new Array (numVariables);
         mFirstVariableInstance = null;
         
         // the link list is for input and output parameter spaces
         
         if (numVariables > 0)
         {
            mFirstVariableInstance = new VariableInstance ();
            mVariableInstances [0] = mFirstVariableInstance;
            
            for (var i:int = 1; i < numVariables; ++ i)
            {
               mVariableInstances [i] = new VariableInstance ();
               (mVariableInstances [i-1] as VariableInstance).mNextVariableInstanceInSpace = mVariableInstances [i];
            }
         }
      }
      
      public function CloneSpace ():VariableSpace
      {
         var numVariables:int = mVariableInstances.length;
         
         var variableSpace:VariableSpace = new VariableSpace (numVariables);
         for (var i:int = 0; i < numVariables; ++ i)
         {
            (variableSpace.mVariableInstances [i] as VariableInstance).SetValueObject ((mVariableInstances [i] as VariableInstance).GetValueObject ());
         }
         
         return variableSpace;
      }
      
      public function GetVariableAt (index:int):VariableInstance
      {
         if (index < 0 || index >= mVariableInstances.length)
            return null;
         
         return mVariableInstances [index];
      }
      
      public function GetValuesFrom (valueSourceList:ValueSource):void
      {
         var vi:VariableInstance = mFirstVariableInstance;
         
         while (vi != null) // && valueSourceList != null) // the missed value sources should be appended at init process.
         {
            vi.SetValueObject (valueSourceList.EvalateValueObject ());
            vi = vi.mNextVariableInstanceInSpace;
            valueSourceList = valueSourceList.mNextValueSourceInList;
         }
      }
      
      public function SetValuesTo (valueTargetList:ValueTarget):void
      {
         var vi:VariableInstance = mFirstVariableInstance;
         
         while (valueTargetList != null) // the number of value targets should be less than variable instances
         {
            valueTargetList.AssignValueObject (vi.GetValueObject ());
            
            vi = vi.mNextVariableInstanceInSpace;
            valueTargetList = valueTargetList.mNextValueTargetInList;
         }
      }
   }
}

