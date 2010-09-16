
package player.trigger
{
   
   public class VariableSpace
   {
      protected var mFirstVariableInstance:VariableInstance = null;
      
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
      
      public function GetValuesFromParameters (inputParamList:Parameter):void
      {
         var vi:VariableInstance = mFirstVariableInstance;
         
         while (vi != null) // && inputParamList != null) // the missed value sources should be appended at init process.
         {
            vi.SetValueObject (inputParamList.EvaluateValueObject ());
            vi = vi.mNextVariableInstanceInSpace;
            inputParamList = inputParamList.mNextParameter;
         }
      }
      
      public function SetValuesToParameters (outputParamList:Parameter):void
      {
         var vi:VariableInstance = mFirstVariableInstance;
         
         while (vi != null) // && outputParamList != null) // the missed value targets should be appended at init process.
         {
            outputParamList.AssignValueObject (vi.GetValueObject ());
            vi = vi.mNextVariableInstanceInSpace;
            outputParamList = outputParamList.mNextParameter;
         }
      }
      
      public function FillVariableReferenceList (viRefList:VariableReference):void
      {
         var vi:VariableInstance = mFirstVariableInstance;
         
         while (vi != null)
         {
            viRefList.mVariableInstance = vi;
            vi = vi.mNextVariableInstanceInSpace;
            viRefList = viRefList.mNextVariableReference;
         }
      }
   }
}

