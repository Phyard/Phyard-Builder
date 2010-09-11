package common.trigger
{
   public class FunctionDeclaration
   {
      private var mId:int;
      
      private var mInputValueTypes:Array;
      private var mReturnValueTypes:Array;
      private var mLocalValueTypes:Array;
      
      public function FunctionDeclaration (id:int, inputValueTypes:Array, returnValueTypes:Array = null, localValueTypes:Array = null)
      {
         mId = id;
         mInputValueTypes = inputValueTypes;
         mReturnValueTypes = returnValueTypes;
         mLocalValueTypes = localValueTypes;
      }
      
      public function GetID ():int
      {
         return mId;
      }
      
      public function GetNumInputs ():int
      {
         if (mInputValueTypes == null)
            return 0;
         
         return mInputValueTypes.length;
      }
      
      public function GetInputParamValueType (inputId:int):int
      {
         if (mInputValueTypes == null)
            return ValueTypeDefine.ValueType_Void;
         
         if (inputId < 0 || inputId >= mInputValueTypes.length)
            return ValueTypeDefine.ValueType_Void;
         
         return mInputValueTypes [inputId] & ValueTypeDefine.NumberTypeMask_Basic;
      }
      
      public function GetInputNumberTypeDetail (inputId:int):int
      {
         if (mInputValueTypes == null)
            return ValueTypeDefine.NumberTypeDetail_Double;
         
         if (inputId < 0 || inputId >= mInputValueTypes.length)
            return ValueTypeDefine.NumberTypeDetail_Double;
         
         return  mInputValueTypes [inputId] & ValueTypeDefine.NumberTypeMask_Detail;
      }
      
      public function GetInputNumberTypeUsage (inputId:int):int
      {
         if (mInputValueTypes == null)
            return ValueTypeDefine.NumberTypeUsage_General;
         
         if (inputId < 0 || inputId >= mInputValueTypes.length)
            return ValueTypeDefine.NumberTypeUsage_General;
         
         return mInputValueTypes [inputId] & ValueTypeDefine.NumberTypeMask_Usage;
      }
      
      public function GetNumOutputs ():int
      {
         if (mReturnValueTypes == null)
            return 0;
         
         return mReturnValueTypes.length;
      }
      
      public function GetOutputParamValueType (returnId:int):int
      {
         if (mReturnValueTypes == null)
            return ValueTypeDefine.ValueType_Void;
         
         if (returnId < 0 || returnId >= mReturnValueTypes.length)
            return ValueTypeDefine.ValueType_Void;
         
         return mReturnValueTypes [returnId] & ValueTypeDefine.NumberTypeMask_Basic;
      }
      
      public function GetNumLocalVariables ():int
      {
         if (mLocalValueTypes == null)
            return 0;
         
         return mLocalValueTypes.length;
      }
      
      public function GetLocalVariableValueType (variableId:int):int
      {
         if (mLocalValueTypes == null)
            return ValueTypeDefine.ValueType_Void;
         
         if (variableId < 0 || variableId >= mLocalValueTypes.length)
            return ValueTypeDefine.ValueType_Void;
         
         return mLocalValueTypes [variableId] & ValueTypeDefine.NumberTypeMask_Basic;
      }
      
//=====================================================================
//
//=====================================================================
      
   }
}