package player.trigger
{
   import common.trigger.define.ValueSourceDefine_Direct;
   
   public class FunctionDefinition
   {
      protected var mNumInputParams:int;
      //protected var mDefaultInputValueSourceDefines:Array; // before v2.05 // currently, all are direct sources
      protected var mInputVariableSpace:VariableSpace; // since v2.05
      
      protected var mNumOutputParams:int;
      //protected var mOutputParamValueTypes:Array;
      protected var mOutputVariableSpace:VariableSpace; // since v2.05
      
      //public function FunctionDefinition (inputValueSourceDefines:Array, outputParamValueTypes:Array):void
      public function FunctionDefinition (inputVariableSpace:VariableSpace, outputVariableSpace:VariableSpace):void
      {
         //mNumInputParams = inputValueSourceDefines == null ? 0 : inputValueSourceDefines.length;
         //mDefaultInputValueSourceDefines = inputValueSourceDefines == null ? [] : inputValueSourceDefines;
         
         //mNumOutputParams = outputParamValueTypes == null ? 0 : outputParamValueTypes.length;
         //mOutputParamValueTypes = outputParamValueTypes;
         
         mInputVariableSpace = inputVariableSpace; // should not be null
         mNumInputParams = mInputVariableSpace == null ? 0 : mInputVariableSpace.GetNumVariables ();
         
         mOutputVariableSpace = outputVariableSpace; // should not be null
         mNumOutputParams = mOutputVariableSpace == null ? 0 : mOutputVariableSpace.GetNumVariables ();
      }
      
      public function GetNumInputParameters ():int
      {
         return mNumInputParams;
      }
      
      //public function GetDefaultInputValueSourceDefine (paramId:int):ValueSourceDefine_Direct
      //{
      //   return (mDefaultInputValueSourceDefines [paramId] as ValueSourceDefine_Direct).Clone () as ValueSourceDefine_Direct;
      //}
      public function GetInputParameter (paramId:int):VariableInstance
      {
         return mInputVariableSpace.GetVariableAt (paramId);
      }
      
      public function GetNumOutputParameters ():int
      {
         return mNumOutputParams;
      }
      
      //public function GetOutputParameter (paramdId:int):int
      //{
      //   return mOutputParamValueTypes [paramdId] as int;
      //}
      public function GetOutputParameter (paramId:int):VariableInstance
      {
         return mOutputVariableSpace.GetVariableAt (paramId);
      }
      
      public function DoCall (inputValueSources:Parameter, returnValueTarget:Parameter):void
      {
         // throw new Error ("to override");
      }
   }
}