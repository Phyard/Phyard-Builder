package player.trigger
{
   import common.trigger.define.ValueSourceDefine_Direct;
   
   public class FunctionDefinition
   {
      protected var mNumInputParams:int;
      protected var mDefaultInputValueSourceDefines:Array; // currently, all are direct sources
      
      protected var mNumOutputParams:int;
      protected var mOutputParamValueTypes:Array;
      
      public function FunctionDefinition (inputValueSourceDefines:Array, outputParamValueTypes:Array):void
      {
         mNumInputParams = inputValueSourceDefines == null ? 0 : inputValueSourceDefines.length;
         mDefaultInputValueSourceDefines = inputValueSourceDefines == null ? [] : inputValueSourceDefines;
         
         mNumOutputParams = outputParamValueTypes == null ? 0 : outputParamValueTypes.length;
         mOutputParamValueTypes = outputParamValueTypes;
      }
      
      public function GetNumInputParameters ():int
      {
         return mNumInputParams;
      }
      
      public function GetDefaultInputValueSourceDefine (paramId:int):ValueSourceDefine_Direct
      {
         return (mDefaultInputValueSourceDefines [paramId] as ValueSourceDefine_Direct).Clone () as ValueSourceDefine_Direct;
      }
      
      public function GetNumOutputParameters ():int
      {
         return mNumOutputParams;
      }
      
      public function GetOutputParamValueType (paramdId:int):int
      {
         return mOutputParamValueTypes [paramdId] as int;
      }
      
      public function DoCall (inputValueSources:Parameter, returnValueTarget:Parameter):void
      {
         // throw new Error ("to override");
      }
   }
}