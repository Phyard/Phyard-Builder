
package player.trigger
{
   import flash.utils.Dictionary;
   
   public class VariableSpace
   {
      private var mFirstVariableInstance:VariableInstance = null; // the link list is for input and output parameter spaces
      
      private var mVariableInstances:Array = null;
      
      private var mVariableKeyMappings:Dictionary = null;
      
      public function VariableSpace (numVariables:int = 0)
      {
         SetNumVariables (numVariables);
      }
      
      public function CloneSpace ():VariableSpace
      {
         //var numVariables:int = mVariableInstances.length;
         //
         //var variableSpace:VariableSpace = new VariableSpace (numVariables);
         //for (var i:int = 0; i < numVariables; ++ i)
         //{
         //   (variableSpace.mVariableInstances [i] as VariableInstance).SetValueObject ((mVariableInstances [i] as VariableInstance).GetValueObject ());
         //}
         //
         //return variableSpace;
         
         return AppendMissedVariablesFor (null);
      }
      
      public function AppendMissedVariablesFor (forVariableSpace:VariableSpace):VariableSpace
      {
         var fromIndex:int;
         var endIndex:int = mVariableInstances.length;
         
         if (forVariableSpace == null)
         {
            fromIndex = 0;
            forVariableSpace = new VariableSpace (endIndex);
            if (endIndex == 0)
               return forVariableSpace;
         }
         else
         {
            fromIndex = forVariableSpace.GetNumVariables ();
            if (fromIndex >= endIndex)
               return forVariableSpace;
            
            forVariableSpace.SetNumVariables (endIndex);
         }
         
         for (var i:int = fromIndex; i < endIndex; ++ i)
         {
            var viSource:VariableInstance = (mVariableInstances [i] as VariableInstance);
            var viTarget:VariableInstance = (forVariableSpace.mVariableInstances [i] as VariableInstance);
            
            viSource.CloneFor (viTarget);
         }
         
         return forVariableSpace;
      }
      
      public function GetNumVariables ():int
      {
         return mVariableInstances == null ? 0 : mVariableInstances.length;
      }
      
      public function SetNumVariables (numVariables:int):void
      {  
         if (numVariables < 0)
            numVariables = 0;
         
         var oldNumVariables:int;
         if (mVariableInstances == null)
         {
            oldNumVariables = 0;
            mVariableInstances = new Array (numVariables);
            //mFirstVariableInstance = null;
         }
         else
         {
            oldNumVariables = mVariableInstances.length;
         }         
         
         
         var vi:VariableInstance;
         if (numVariables > oldNumVariables) // need append
         {
            mVariableInstances.length = numVariables; // for c/java, more need to do
            
            if (oldNumVariables == 0)
            {
               mFirstVariableInstance = new VariableInstance ();
               mVariableInstances [0] = mFirstVariableInstance;
            }
            
            for (var i:int = (oldNumVariables == 0 ? 1 : oldNumVariables); i < numVariables; ++ i)
            {
               vi = new VariableInstance ();
               mVariableInstances [i] = vi;
               (mVariableInstances [i-1] as VariableInstance).mNextVariableInstanceInSpace = vi;
            }
         }
         else if (numVariables < oldNumVariables) // need truncate
         {
            vi =  mVariableInstances [numVariables];
            if (numVariables == 0)
            {
               mFirstVariableInstance = null;
            }
            else
            {
               (mVariableInstances [numVariables - 1] as VariableInstance).mNextVariableInstanceInSpace = null;
            }
            
            mVariableInstances.length = numVariables; // for c/java, more need to do
         }
      }
      
      public function GetVariableAt (index:int):VariableInstance
      {
         if (index < 0 || mVariableInstances == null || index >= mVariableInstances.length)
            return null;
         
         return mVariableInstances [index];
      }
      
      public function RegisterKeyValue (key:String, value:VariableInstance):void
      {
         if (mVariableKeyMappings == null)
            mVariableKeyMappings = new Dictionary ();
         
         mVariableKeyMappings [key] = value;
      }
      
      public function GetVariableByKey (key:String):VariableInstance
      {
         if (mVariableKeyMappings == null)
            return null;
         
         return mVariableKeyMappings [key];
      }
      
      public function GetValuesFromParameters (inputParamList:Parameter):void
      {
         var vi:VariableInstance = mFirstVariableInstance;
         
         // "vi != null" == "inputParamList != null"
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
      
      public function ResetVariables ():void
      {
         
      }
   }
}

