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
      
      private static var sConstDataInited:Boolean = false;
      
      public static function InitializeConstData ():void
      {
         if (sConstDataInited)
            return;
         
         CoreFunctionDeclarations.Initialize ();
         CoreEventDeclarations.Initialize ();
         
         // CoreFunctionDefinitions.Initialize (); // moved
         
         sConstDataInited = true;
      }
      
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
      
      public static var mFreeDirectParameterListHead:Parameter_DirectSource = null;
      
      public static function ApplyNewDirectParameter (initialValue:Object, nextParameter:Parameter):Parameter_DirectSource
      {
         var returnParameter:Parameter_DirectSource = mFreeDirectParameterListHead;
         
         if (returnParameter != null)
         {
            mFreeDirectParameterListHead = returnParameter.mNextParameter as Parameter_DirectSource;
            returnParameter.mValueObject = initialValue; // a little faster than calling AssignValueObject
         }
         else
         {
            returnParameter = new Parameter_DirectSource (initialValue);
         }
         
         returnParameter.mNextParameter = nextParameter;
         
         return returnParameter;
      }
      
      //public static function ReleaseDirectParameter_Target (parameter:Parameter_DirectTarget):Object
      //{
      //   var returnValue:Object = parameter.mValueObject;
      //   
      //   parameter.mValueObject = null; // a little faster than calling AssignValueObject
      //   parameter.mNextParameter = mFreeDirectParameterListHead;
      //   mFreeDirectParameterListHead = parameter;
      //   
      //   return returnValue;
      //}
      
      public static function ReleaseDirectParameter_Source (parameter:Parameter_DirectSource):void
      {
         parameter.mValueObject = null; // a little faster than calling AssignValueObject
         parameter.mNextParameter = mFreeDirectParameterListHead;
         mFreeDirectParameterListHead = parameter;
      }
      
   }
}