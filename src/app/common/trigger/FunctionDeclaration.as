package common.trigger
{
   public class FunctionDeclaration
   {
      public var mId:int;
      public var mInputValueTypes:Array;
      //public var mReturnValueType:int = ValueTypeDefine.ValueType_Void;
      public var mReturnValueTypes:Array;
      public var mCanBeCalledInConditionList:Boolean = false;
      
      public function FunctionDeclaration (id:int, inputValueTypes:Array, returnValueTypes:Array = null, canBeCalledInConditionList:Boolean = false) //returnValueType:int=0) //ValueTypeDefine.ValueType_Void)
      {
         mId = id;
         mInputValueTypes = inputValueTypes;
         //mReturnValueType = returnValueType;
         mReturnValueTypes = returnValueTypes;
         
         mCanBeCalledInConditionList = canBeCalledInConditionList;
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
         
         return mInputValueTypes [inputId];
      }
      
      public function GetNumReturns ():int
      {
         if (mReturnValueTypes == null)
            return 0;
         
         return mReturnValueTypes.length;
      }
      
      public function GetReturnValueType (returnId:int):int
      {
         if (mReturnValueTypes == null)
            return ValueTypeDefine.ValueType_Void;
         
         if (returnId < 0 || returnId >= mReturnValueTypes.length)
            return ValueTypeDefine.ValueType_Void;
         
         return mReturnValueTypes [returnId];
      }
      
      public function GetReturnValueTypes ():Array
      {
         return mReturnValueTypes;
      }
      
//=====================================================================
//
//=====================================================================
      
   }
}