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
      
      //public function GetReturnValueType ():int
      //{
      //   return mReturnValueType;
      //}
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function GetNumReturns ():int
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
      
      public function GetReturnValueType (returnId:int):int
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
         
         return GetNumReturns () == 1 && GetReturnValueType (0) == ValueTypeDefine.ValueType_Boolean;
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
      
      public function HasInputsCompatibleWith (variableDefinition:VariableDefinition):Boolean
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
      
//=================================================================
//
//=================================================================
      
      protected function CheckConsistent (coreDelcaration:common.trigger.FunctionDeclaration):Boolean
      {
         if (coreDelcaration == null)
            return false;
         
         if ( mId != coreDelcaration.mId)
            return false;
         
         if (mParamDefinitions == null && coreDelcaration.mInputValueTypes != null)
            return false;
         
         if (mParamDefinitions != null && coreDelcaration.mInputValueTypes == null)
            return false;
         
         var i:int;
         
         if (mParamDefinitions != null && coreDelcaration.mInputValueTypes != null)
         {
            if (mParamDefinitions.length != coreDelcaration.mInputValueTypes.length)
               return false;
            
            for (i = 0; i < mParamDefinitions.length; ++ i)
            {
               if (GetInputValueType (i) != coreDelcaration.mInputValueTypes [i])
                  return false;
            }
         }
         
         if (mReturnDefinitions == null && coreDelcaration.mReturnValueTypes != null)
            return false;
         
         if (mReturnDefinitions != null && coreDelcaration.mReturnValueTypes == null)
            return false;
         
         if (mReturnDefinitions != null && coreDelcaration.mReturnValueTypes != null)
         {
            if (mReturnDefinitions.length != coreDelcaration.mReturnValueTypes.length)
               return false;
            
            for (i = 0; i < mReturnDefinitions.length; ++ i)
            {
               if (GetReturnValueType (i) != coreDelcaration.mReturnValueTypes [i])
                  return false;
            }
         }
         
         return true;
      }
      
   }
}
