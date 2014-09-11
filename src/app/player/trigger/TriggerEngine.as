package player.trigger
{
   import flash.utils.getTimer;
   
   import common.trigger.FunctionCoreBasicDefine;
   import common.trigger.CoreFunctionIds;
   import common.trigger.CoreEventIds;
   import common.trigger.CoreFunctionDeclarations;
   import common.trigger.CoreEventDeclarations;
   import common.trigger.IdPool;
   
   public class TriggerEngine
   {
   
//=============================================================================
// calling context
//=============================================================================
      
   // variable spaces
      
      public static var sCallingLevel:int;
      public static var sStepStartTime:Number;
      
   // ...
      
      public static function Reset ():void
      {
         sCallingLevel = 0;
         sStepStartTime = getTimer ();
      }
      
//=============================================================================
// const data structures
//=============================================================================
      
      // move put into Global.Initialize
      //private static var sConstDataInited:Boolean = false;
      //
      //public static function InitializeConstData ():void
      //{
      //   if (sConstDataInited)
      //      return;
      //   
      //   CoreFunctionDeclarations.Initialize ();
      //   CoreEventDeclarations.Initialize ();
      //   
      //   // CoreFunctionDefinitions.Initialize (); // moved
      //   
      //   sConstDataInited = true;
      //}
      
      public static function GetCoreFunctionDefinition (functionId:int):FunctionDefinition_Core
      {
         if (functionId < 0 || functionId >= IdPool.NumPlayerFunctions)
            return null;
         
         return CoreFunctionDefinitions.sCoreFunctionDefinitions [functionId];
      }
      
      public static function GetVoidFunctionDeclaration ():FunctionCoreBasicDefine
      {
         return CoreFunctionDeclarations.sCoreFunctionDeclarations [CoreFunctionIds.ID_Void];
      }
      
      public static function GetBoolFunctionDeclaration ():FunctionCoreBasicDefine
      {
         return CoreFunctionDeclarations.sCoreFunctionDeclarations [CoreFunctionIds.ID_Bool];
      }
      
      public static function GetEntityFilterFunctionDeclaration ():FunctionCoreBasicDefine
      {
         return CoreFunctionDeclarations.sCoreFunctionDeclarations [CoreFunctionIds.ID_EntityFilter];
      }
      
      public static function GetEntityPairFilterFunctionDeclaration ():FunctionCoreBasicDefine
      {
         return CoreFunctionDeclarations.sCoreFunctionDeclarations [CoreFunctionIds.ID_EntityPairFilter];
      }
      
//=============================================================================
// cached Parameter instances
//=============================================================================
      
      // this cache implementation may not better than direct new ()
      
      public static var mFreeDirectParameterListHead:Parameter_DirectConstant = null;
      
      public static function ApplyNewDirectParameter_Source (classDefinition:ClassDefinition, initialValue:Object, nextParameter:Parameter):Parameter_DirectConstant
      {
         var returnParameter:Parameter_DirectConstant = mFreeDirectParameterListHead;
         
         if (returnParameter == null)
         {
            returnParameter = new Parameter_DirectConstant (classDefinition, initialValue, nextParameter);
         }
         else
         {
            mFreeDirectParameterListHead = returnParameter.mNextParameter as Parameter_DirectConstant;
            returnParameter.GetVariableInstance ().SetRealClassDefinition (classDefinition);
            returnParameter.mValueObject = initialValue;
            returnParameter.mNextParameter = nextParameter;
         }
         
         return returnParameter;
      }
      
      public static function ReleaseDirectParameter_Source (parameter:Parameter_DirectConstant):void
      {
         parameter.GetVariableInstance ().SetRealClassDefinition (null);
         parameter.mValueObject = null;
         parameter.mNextParameter = mFreeDirectParameterListHead;
         mFreeDirectParameterListHead = parameter;
      }
      
   }
}