package common.trigger
{
   public class FunctionDeclaration
   {
      public var mId:int;
      public var mInputValueTypes:Array;
      public var mReturnValueTypes:Array;
      
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