package common.trigger
{
   public class FunctionCoreBasicDefine
   {
      private static const Index_ValueType:int = 0;
      private static const Index_DevaultValue:int = 1;
      
   //
      
      private var mId:int;
      
      private var mInputParamDefines:Array;
      private var mOutputParamDefines:Array;
      
      public function FunctionCoreBasicDefine (id:int, inputParamDefines:Array, outputParamDefines:Array = null)
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
            return null;//undefined;
         
         if (inputId < 0 || inputId >= mInputParamDefines.length)
            return null;//undefined;
         
         return mInputParamDefines [inputId][Index_DevaultValue];
      }
      
      public function GetInputParamValueType (inputId:int):int
      {
         if (mInputParamDefines == null)
            return CoreClassIds.ValueType_Void;
         
         if (inputId < 0 || inputId >= mInputParamDefines.length)
            return CoreClassIds.ValueType_Void;
         
         return mInputParamDefines [inputId][Index_ValueType] & CoreClassIds.NumberTypeMask_Basic;
      }
      
      public function GetInputNumberTypeDetail (inputId:int):int
      {
         if (mInputParamDefines == null)
            return CoreClassIds.NumberTypeDetail_Double;
         
         if (inputId < 0 || inputId >= mInputParamDefines.length)
            return CoreClassIds.NumberTypeDetail_Double;
         
         return  mInputParamDefines [inputId][Index_ValueType] & CoreClassIds.NumberTypeMask_Detail;
      }
      
      public function GetInputNumberTypeUsage (inputId:int):int
      {
         if (mInputParamDefines == null)
            return CoreClassIds.NumberTypeUsage_General;
         
         if (inputId < 0 || inputId >= mInputParamDefines.length)
            return CoreClassIds.NumberTypeUsage_General;
         
         return mInputParamDefines [inputId][Index_ValueType] & CoreClassIds.NumberTypeMask_Usage;
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
            return CoreClassIds.ValueType_Void;
         
         if (returnId < 0 || returnId >= mOutputParamDefines.length)
            return CoreClassIds.ValueType_Void;
         
         return mOutputParamDefines [returnId][Index_ValueType] & CoreClassIds.NumberTypeMask_Basic;
      }
      
      public function GetOutputParamDefaultValue (outputId:int):Object
      {
         if (mOutputParamDefines == null)
            return null; //undefined;
         
         if (outputId < 0 || outputId >= mOutputParamDefines.length)
            return null; //undefined;
         
         return mOutputParamDefines [outputId][Index_DevaultValue];
      }
      
//=====================================================================
//
//=====================================================================
      
   }
}