package player.trigger
{
   import common.trigger.define.ValueSourceDefine;
   
   public class FunctionDefinition
   {
      protected var mDefaultInputValueSourceDefines:Array;
      
      protected var mNumInputParams:int;
      protected var mNumOutputParams:int;
      
      public function FunctionDefinition (inputValueSourceDefines:Array, numOutputParams:int)
      {
         mNumInputParams = inputValueSourceDefines == null ? 0 : inputValueSourceDefines.length;
         mDefaultInputValueSourceDefines = inputValueSourceDefines == null ? [] : inputValueSourceDefines;
         mNumOutputParams = numOutputParams;
      }
      
      public function GetDefaultInputValueSourceDefine (paramId:int):ValueSourceDefine
      {
         return mDefaultInputValueSourceDefines [paramId] as ValueSourceDefine;
      }
      
      public function GetNumInputParameters ():int
      {
         return mNumInputParams;
      }
      
      public function GetNumOutputParameters ():int
      {
         return mNumOutputParams;
      }
      
      public function DoCall (inputValueSources:Parameter, returnValueTarget:Parameter):void
      {
         throw new Error ("to override");
      }
   }
}