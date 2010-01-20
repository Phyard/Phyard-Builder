package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.FunctionTypeDefine;
   
   public class FunctionDeclaration
   {
      protected var mId:int;
      protected var mName:String;
      
      private var mDescription:String = null;
      
      protected var mInputParamDefinitions:Array; // input variable defines
      protected var mOutputParamDefinitions:Array; // returns
      
      public function FunctionDeclaration (id:int, name:String, inputDefinitions:Array = null, description:String = null, returnDefinitions:Array = null) //returnValueType:int=0) //ValueTypeDefine.ValueType_Void)
      {
         mId = id;
         mName = name;
         mDescription = description;
         mInputParamDefinitions = inputDefinitions;
         
         mOutputParamDefinitions = returnDefinitions;
      }
      
      public function GetID ():int
      {
         return mId;
      }
      
      public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_Unknown;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function GetNumOutputs ():int
      {
         if (mOutputParamDefinitions == null)
            return 0;
         
         return mOutputParamDefinitions.length;
      }
      
      public function GetOuputParamDefinitionAt (returnId:int):VariableDefinition
      {
         if (mOutputParamDefinitions == null)
            return null;
         
         if (returnId < 0 || returnId >= mOutputParamDefinitions.length)
            return null;
         
         return mOutputParamDefinitions [returnId];
      }
      
      public function GetOutputParamValueType (returnId:int):int
      {
         var vd:VariableDefinition = GetOuputParamDefinitionAt (returnId);
         
         if (vd == null)
            return ValueTypeDefine.ValueType_Void;
         
         return vd.GetValueType ();
      }
      
      public function GetNumInputs ():int
      {
         if (mInputParamDefinitions == null)
            return 0;
         
         return mInputParamDefinitions.length;
      }
      
      public function GetInputParamDefinitionAt (inputId:int):VariableDefinition
      {
         if (mInputParamDefinitions == null)
            return null;
         
         if (inputId < 0 || inputId >= mInputParamDefinitions.length)
            return null;
         
         return mInputParamDefinitions [inputId];
      }
      
      public function GetInputParamValueType (inputId:int):int
      {
         var vd:VariableDefinition = GetInputParamDefinitionAt (inputId);
         
         if (vd == null)
            return ValueTypeDefine.ValueType_Void;
         
         return vd.GetValueType ();
      }
      
      public function HasInputsWithValueTypeOf (valueType:int):Boolean
      {
         if (mInputParamDefinitions == null)
            return false;
         
         for (var i:int = 0; i < mInputParamDefinitions.length; ++ i)
         {
            if (GetInputParamValueType (i) == valueType)
               return true;
         }
         
         return false;
      }
      
      public function HasInputsSatisfy (variableDefinition:VariableDefinition):Boolean
      {
         if (mInputParamDefinitions != null)
         {
            for (var i:int = 0; i < mInputParamDefinitions.length; ++ i)
            {
               if (GetInputParamDefinitionAt (i).IsCompatibleWith (variableDefinition))
                  return true;
            }
         }
         
         return false;
      }
      
      public function GetInputVariableIndexesSatisfy (variableDefinition:VariableDefinition):Array
      {
         var indexes:Array = new Array ();
         
         if (mInputParamDefinitions != null)
         {
            for (var i:int = 0; i < mInputParamDefinitions.length; ++ i)
            {
               if (GetInputParamDefinitionAt (i).IsCompatibleWith (variableDefinition))
                  indexes.push (i);
            }
         }
         
         return indexes;
      }
      
      public function HasInputsSatisfyBy (variableDefinition:VariableDefinition):Boolean
      {
         if (mInputParamDefinitions != null)
         {
            for (var i:int = 0; i < mInputParamDefinitions.length; ++ i)
            {
               if (variableDefinition.IsCompatibleWith (GetInputParamDefinitionAt (i)))
                  return true;
            }
         }
         
         return false;
      }
      
      public function GetInputVariableIndexesSatisfy (variableDefinition:VariableDefinition):Array
      {
         var indexes:Array = new Array ();
         
         if (mInputParamDefinitions != null)
         {
            for (var i:int = 0; i < mInputParamDefinitions.length; ++ i)
            {
               if (variableDefinition.IsCompatibleWith (GetInputParamDefinitionAt (i)))
                  indexes.push (i);
            }
         }
         
         return indexes;
      }
      
      public function HasOutputsSatisfiedBy (variableDefinition:VariableDefinition):Boolean
      {
         if (mOutputParamDefinitions != null)
         {
            for (var i:int = 0; i < mOutputParamDefinitions.length; ++ i)
            {
               if (variableDefinition.IsCompatibleWith (GetOuputParamDefinitionAt (i)))
                  return true;
            }
         }
         
         return false;
      }
      
      public function GetOutputVariableIndexesSatisfiedBy (variableDefinition:VariableDefinition):Array
      {
         var indexes:Array = new Array ();
         
         if (mOutputParamDefinitions != null)
         {
            for (var i:int = 0; i < mOutputParamDefinitions.length; ++ i)
            {
               if (variableDefinition.IsCompatibleWith (GetOuputParamDefinitionAt (i)))
                  indexes.push (i);
            }
         }
         
         return indexes;
      }
      
//=================================================================
//
//=================================================================
      
      public function GetInputNumberTypeDetail (inputId:int):int
      {
         return ValueTypeDefine.NumberTypeDetail_Double;
      }
      
      public function GetInputNumberTypeUsage (inputId:int):int
      {
         return ValueTypeDefine.NumberTypeUsage_General;
      }
      
//=================================================================
//
//=================================================================
      
      protected function CheckConsistent (coreDelcaration:common.trigger.FunctionDeclaration):Boolean
      {
         if (coreDelcaration == null)
            return false;
         
         if ( mId != coreDelcaration.GetID ())
            return false;
         
         var num_inputs:int = coreDelcaration.GetNumInputs ();
         
         if (mInputParamDefinitions == null && num_inputs != 0)
            return false;
         
         if (mInputParamDefinitions != null && num_inputs == 0)
            return false;
         
         var i:int;
         
         if (mInputParamDefinitions != null && num_inputs != 0)
         {
            if (mInputParamDefinitions.length != num_inputs)
               return false;
            
            for (i = 0; i < num_inputs; ++ i)
            {
               if (GetInputParamValueType (i) != coreDelcaration.GetInputParamValueType (i))
                  return false;
            }
         }
         
         var num_outputs:int = coreDelcaration.GetNumOutputs ();
         
         if (mOutputParamDefinitions == null && num_outputs != 0)
            return false;
         
         if (mOutputParamDefinitions != null && num_outputs == 0)
            return false;
         
         if (mOutputParamDefinitions != null && num_outputs != 0)
         {
            if (mOutputParamDefinitions.length != num_outputs)
               return false;
            
            for (i = 0; i < num_outputs; ++ i)
            {
               if (GetOutputParamValueType (i) != coreDelcaration.GetOutputParamValueType (i))
                  return false;
            }
         }
         
         return true;
      }
      
   }
}
