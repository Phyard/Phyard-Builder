package common.trigger
{
   public class FunctionDeclaration
   {
      private var mId:int;
      private var mInputValueTypes:Array;
      private var mReturnValueTypes:Array;
      
      public function FunctionDeclaration (id:int, inputValueTypes:Array, returnValueTypes:Array = null)
      {
         mId = id;
         mInputValueTypes = inputValueTypes;
         mReturnValueTypes = returnValueTypes;
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
      
      public function GetInputValueType (inputId:int):int
      {
         if (mInputValueTypes == null)
            return ValueTypeDefine.ValueType_Void;
         
         if (inputId < 0 || inputId >= mInputValueTypes.length)
            return ValueTypeDefine.ValueType_Void;
         
         return mInputValueTypes [inputId] & ValueTypeDefine.NumberTypeMask_Basic;
      }
      
      public function GetInputNumberTypeDetail (inputId:int):int
      {
         var valueType:int = GetInputValueType (inputId);
         if (valueType != ValueTypeDefine.ValueType_Number)
            return ValueTypeDefine.NumberTypeDetail_Double;
         
         return valueType & ValueTypeDefine.NumberTypeMask_Detail;
      }
      
      public function GetInputNumberTypeUsage (inputId:int):int
      {
         var valueType:int = GetInputValueType (inputId);
         if (valueType != ValueTypeDefine.ValueType_Number)
            return ValueTypeDefine.NumberTypeUsage_General;
         
         return valueType & ValueTypeDefine.NumberTypeMask_Usage;
      }
      
      public function GetNumOutputs ():int
      {
         if (mReturnValueTypes == null)
            return 0;
         
         return mReturnValueTypes.length;
      }
      
      public function GetOutputValueType (returnId:int):int
      {
         if (mReturnValueTypes == null)
            return ValueTypeDefine.ValueType_Void;
         
         if (returnId < 0 || returnId >= mReturnValueTypes.length)
            return ValueTypeDefine.ValueType_Void;
         
         return mReturnValueTypes [returnId] & ValueTypeDefine.NumberTypeMask_Basic;
      }
      
//=====================================================================
//
//=====================================================================
      
   }
}