package common.trigger
{
   public class FunctionDeclaration
   {
      public static const Index_ValueType:int = 0;
      public static const Index_DevaultValue:int = 1;
      
   //
      
      private var mId:int;
      
      private var mInputParamDefines:Array;
      private var mOutputParamDefines:Array;
      
      public function FunctionDeclaration (id:int, inputParamDefines:Array, outputParamDefines:Array = null)
      {
         mId = id;
         
         mInputParamDefines = inputParamDefines;
         mOutputParamDefines = outputParamDefines;
      }
      
      public function GetID ():int
      {
         return mId;
      }
      
      public function GetNumInputs ():int
      {
         if (mInputParamDefines == null)
            return 0;
         
         return mInputParamDefines.length;
      }
      
      public function GetInputParamDefaultValue (inputId:int):Object
      {
         if (mInputParamDefines == null)
            return undefined;
         
         if (inputId < 0 || inputId >= mInputParamDefines.length)
            return undefined;
         
         return mInputParamDefines [inputId][Index_DevaultValue];
      }
      
      public function GetInputParamValueType (inputId:int):int
      {
         if (mInputParamDefines == null)
            return mInputParamDefines.ValueType_Void;
         
         if (inputId < 0 || inputId >= mInputParamDefines.length)
            return ValueTypeDefine.ValueType_Void;
         
         return mInputParamDefines [inputId][Index_ValueType] & ValueTypeDefine.NumberTypeMask_Basic;
      }
      
      public function GetInputNumberTypeDetail (inputId:int):int
      {
         if (mInputParamDefines == null)
            return ValueTypeDefine.NumberTypeDetail_Double;
         
         if (inputId < 0 || inputId >= mInputParamDefines.length)
            return ValueTypeDefine.NumberTypeDetail_Double;
         
         return  mInputParamDefines [inputId][Index_ValueType] & ValueTypeDefine.NumberTypeMask_Detail;
      }
      
      public function GetInputNumberTypeUsage (inputId:int):int
      {
         if (mInputParamDefines == null)
            return ValueTypeDefine.NumberTypeUsage_General;
         
         if (inputId < 0 || inputId >= mInputParamDefines.length)
            return ValueTypeDefine.NumberTypeUsage_General;
         
         return mInputParamDefines [inputId][Index_ValueType] & ValueTypeDefine.NumberTypeMask_Usage;
      }
      
      public function GetNumOutputs ():int
      {
         if (mOutputParamDefines == null)
            return 0;
         
         return mOutputParamDefines.length;
      }
      
      public function GetOutputParamValueType (returnId:int):int
      {
         if (mOutputParamDefines == null)
            return ValueTypeDefine.ValueType_Void;
         
         if (returnId < 0 || returnId >= mOutputParamDefines.length)
            return ValueTypeDefine.ValueType_Void;
         
         return mOutputParamDefines [returnId][Index_ValueType] & ValueTypeDefine.NumberTypeMask_Basic;
      }
      
//=====================================================================
//
//=====================================================================
      
   }
}