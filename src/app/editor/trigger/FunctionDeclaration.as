package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.FunctionTypeDefine;
   
   public class FunctionDeclaration
   {
      protected var mId:int;
      protected var mName:String;
      
      //protected var mReturnValueType:int;
      
      private var mDescription:String = null;
      
      protected var mParamDefinitions:Array; // input variable defines
      protected var mReturnDefinitions:Array; // returns
      
      public function FunctionDeclaration (id:int, name:String, inputDefinitions:Array = null, description:String = null, returnDefinitions:Array = null) //returnValueType:int=0) //ValueTypeDefine.ValueType_Void)
      {
         mId = id;
         mName = name;
         mDescription = description;
         mParamDefinitions = inputDefinitions;
         
         //mReturnValueType = returnValueType;
         mReturnDefinitions = returnDefinitions;
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
      
      //public function GetOutputValueType ():int
      //{
      //   return mReturnValueType;
      //}
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function GetNumOutputs ():int
      {
         if (mReturnDefinitions == null)
            return 0;
         
         return mReturnDefinitions.length;
      }
      
      public function GetReturnDefinitionAt (returnId:int):VariableDefinition
      {
         if (mReturnDefinitions == null)
            return null;
         
         if (returnId < 0 || returnId >= mReturnDefinitions.length)
            return null;
         
         return mReturnDefinitions [returnId];
      }
      
      public function GetOutputValueType (returnId:int):int
      {
         var vd:VariableDefinition = GetReturnDefinitionAt (returnId);
         
         if (vd == null)
            return ValueTypeDefine.ValueType_Void;
         
         return vd.GetValueType ();
      }
      
      public function GetNumInputs ():int
      {
         if (mParamDefinitions == null)
            return 0;
         
         return mParamDefinitions.length;
      }
      
      public function GetParamDefinitionAt (inputId:int):VariableDefinition
      {
         if (mParamDefinitions == null)
            return null;
         
         if (inputId < 0 || inputId >= mParamDefinitions.length)
            return null;
         
         return mParamDefinitions [inputId];
      }
      
      public function GetInputValueType (inputId:int):int
      {
         var vd:VariableDefinition = GetParamDefinitionAt (inputId);
         
         if (vd == null)
            return ValueTypeDefine.ValueType_Void;
         
         return vd.GetValueType ();
      }
      
      public function CanBeCalledInConditionList ():Boolean
      {
         // the implementattion is different for Core function and Event handler
         
         return GetNumOutputs () == 1 && GetOutputValueType (0) == ValueTypeDefine.ValueType_Boolean;
      }
      
      public function HasInputsWithValueTypeOf (valueType:int):Boolean
      {
         if (mParamDefinitions == null)
            return false;
         
         for (var i:int = 0; i < mParamDefinitions.length; ++ i)
         {
            if (GetInputValueType (i) == valueType)
               return true;
         }
         
         return false;
      }
      
      public function HasInputsSatisfy (variableDefinition:VariableDefinition):Boolean
      {
         if (mParamDefinitions == null)
            return false;
         
         for (var i:int = 0; i < mParamDefinitions.length; ++ i)
         {
            if (GetParamDefinitionAt (i).IsCompatibleWith (variableDefinition))
               return true;
         }
         
         return false;
      }
      
      public function GetInputVariableIndexesSatisfy (variableDefinition:VariableDefinition):Array
      {
         var indexes:Array = new Array ();
         
         if (mParamDefinitions != null)
         {
            for (var i:int = 0; i < mParamDefinitions.length; ++ i)
            {
               if (GetParamDefinitionAt (i).IsCompatibleWith (variableDefinition))
                  indexes.push (i);
            }
         }
         
         return indexes;
      }
      
      public function HasOutputsSatisfiedBy (variableDefinition:VariableDefinition):Boolean
      {
         if (mParamDefinitions == null)
            return false;
         
         for (var i:int = 0; i < mParamDefinitions.length; ++ i)
         {
            if (variableDefinition.IsCompatibleWith (GetParamDefinitionAt (i)))
               return true;
         }
         
         return false;
      }
      
      public function GetOutputVariableIndexesSatisfiedBy (variableDefinition:VariableDefinition):Array
      {
         var indexes:Array = new Array ();
         
         if (mParamDefinitions != null)
         {
            for (var i:int = 0; i < mParamDefinitions.length; ++ i)
            {
               if (variableDefinition.IsCompatibleWith (GetParamDefinitionAt (i)))
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
         
         if (mParamDefinitions == null && num_inputs != 0)
            return false;
         
         if (mParamDefinitions != null && num_inputs == 0)
            return false;
         
         var i:int;
         
         if (mParamDefinitions != null && num_inputs != 0)
         {
            if (mParamDefinitions.length != num_inputs)
               return false;
            
            for (i = 0; i < num_inputs; ++ i)
            {
               if (GetInputValueType (i) != coreDelcaration.GetInputValueType (i))
                  return false;
            }
         }
         
         var num_outputs:int = coreDelcaration.GetNumOutputs ();
         
         if (mReturnDefinitions == null && num_outputs != 0)
            return false;
         
         if (mReturnDefinitions != null && num_outputs == 0)
            return false;
         
         if (mReturnDefinitions != null && num_outputs != 0)
         {
            if (mReturnDefinitions.length != num_outputs)
               return false;
            
            for (i = 0; i < num_outputs; ++ i)
            {
               if (GetOutputValueType (i) != coreDelcaration.GetOutputValueType (i))
                  return false;
            }
         }
         
         return true;
      }
      
   }
}
