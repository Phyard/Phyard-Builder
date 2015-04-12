
package player.trigger
{
   import flash.utils.Dictionary;
   
   public class VariableSpace
   {
      private var mFirstVariableInstance:VariableInstance = null; // the link list is for input and output parameter spaces
      
      private var mVariableInstances:Array = null;
      
      private var mVariableKeyMappings:Dictionary = null;
      
      public function VariableSpace (numVariables:int)
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
      
      // the cloned space doesn't hold detailed VariableInstance.
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

            viSource.CloneForVariableInstance (viTarget);
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
         
         
         var vi:VariableInstance; //VariableInstance;
         if (numVariables > oldNumVariables) // need append
         {
            mVariableInstances.length = numVariables; // for c/java, more need to do
            
            var lastVi:VariableInstance;
            var fromIndex:int;
            if (oldNumVariables == 0)
            {
               mFirstVariableInstance = new VariableInstance ();
               mVariableInstances [0] = mFirstVariableInstance;
               lastVi = mFirstVariableInstance;
               fromIndex = 1;
            }
            else
            {
               lastVi = mVariableInstances [oldNumVariables - 1] as VariableInstance;
               fromIndex = oldNumVariables;
            }
            
            for (var i:int = fromIndex; i < numVariables; ++ i)
            {
               vi = new VariableInstance ();
               mVariableInstances [i] = vi;
               //(mVariableInstances [i-1] as VariableInstance).mNextVariableInstanceInSpace = vi;
               lastVi.mNextVariableInstanceInSpace = vi;
               lastVi = vi;
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
      
      //public function GetVariableIndex (vi:VariableInstance):int
      //{
      //   return mVariableInstances == null ? -1 : mVariableInstances.indexOf (vi);
      //}
      
      public function GetVariableByIndex (index:int):VariableInstance
      {
         if (index < 0 || mVariableInstances == null || index >= mVariableInstances.length)
            return VariableInstanceConstant.kVoidVariableInstance; // null;
         
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
            return VariableInstanceConstant.kVoidVariableInstance; // null;
         
         var vi:VariableInstance = mVariableKeyMappings [key] as VariableInstance;
         return vi != null ? vi : VariableInstanceConstant.kVoidVariableInstance;
      }
      
      public function GetValuesFromParameters (inputParamList:Parameter):void
      {
         var vi:VariableInstance = mFirstVariableInstance;
         
         // same length. "vi != null" == "inputParamList != null"
         while (vi != null) // && inputParamList != null) // the missed value sources should be appended at init process.
         {
            // before v2.05
            //vi.SetValueObject (inputParamList.EvaluateValueObject ());
            // since v2.05
            CoreClassesHub.AssignValue (inputParamList.GetVariableInstance (), vi);
            
            vi = vi.mNextVariableInstanceInSpace;
            inputParamList = inputParamList.mNextParameter;
         }
      }
      
      public function SetValuesToParameters (outputParamList:Parameter):void
      {
         var vi:VariableInstance = mFirstVariableInstance;
         
         // same length. "vi != null" == "outputParamList != null"
         while (vi != null) // && outputParamList != null) // the missed value targets should be appended at init process.
         {
            // before v2.05
            //outputParamList.AssignValueObject (vi.GetValueObject ());
            // since v2.05
            CoreClassesHub.AssignValue (vi, outputParamList.GetVariableInstance ());
            
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

