package player.trigger
{
   import flash.utils.getTimer;
   
   import common.trigger.FunctionDeclaration;
   import common.trigger.CoreFunctionIds;
   import common.trigger.CoreEventIds;
   import common.trigger.CoreFunctionDeclarations;
   import common.trigger.CoreEventDeclarations;
   import common.trigger.ValueTypeDefine;
   
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
         
         CoreFunctionDefinitions.Initialize ();
         
         sConstDataInited = true;
      }
      
      public static function GetCoreFunctionDefinition (functionId:int):FunctionDefinition_Core
      {
         if (functionId < 0 || functionId >= CoreFunctionIds.NumPlayerFunctions)
            return null;
         
         return CoreFunctionDefinitions.sCoreFunctionDefinitions [functionId];
      }
      
      public static function GetVoidFunctionDeclaration ():FunctionDeclaration
      {
         return CoreFunctionDefinitions.sCoreFunctionDefinitions [CoreFunctionIds.ID_Void];
      }
      
      public static function GetBoolFunctionDeclaration ():FunctionDeclaration
      {
         return CoreFunctionDefinitions.sCoreFunctionDefinitions [CoreFunctionIds.ID_Bool];
      }
   }
}