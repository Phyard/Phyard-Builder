package player.trigger
{
   import flash.utils.getTimer;
   
   import common.trigger.FunctionDeclaration;
   import common.trigger.CoreFunctionIds;
   import common.trigger.CoreEventIds;
   import common.trigger.CoreFunctionDeclarations;
   import common.trigger.CoreEventDeclarations;
   
   public class TriggerEngine
   {
   
//=============================================================================
// calling context
//=============================================================================
      
   // return value 
      
      public static var sLastBoolReturnValue:Boolean = false;
      
   // variable spaces
      
      public static var sCallingLevel:int;
      public static var sStepStartTime:Number;
      
   // ...
      
      public static function Reset ():void
      {
         sCallingLevel = 0;
         sStepStartTime = getTimer ();
         
         sLastBoolReturnValue = false;
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
      
      public static function GetCoreFunctionDeclaration (functionId:int):FunctionDeclaration
      {
         if (functionId < 0 || functionId >= CoreFunctionIds.NumPlayerFunctions)
            return null;
         
         return CoreFunctionDeclarations.sCoreFunctionDeclarations [functionId];
      }
      
      public static function GetCoreEventHandlerDeclarationById (eventId:int):FunctionDeclaration
      {
         if (eventId < 0 || eventId >= CoreEventIds.NumEventTypes)
            return null;
         
         return CoreEventDeclarations.sEventHandlerDeclarations [eventId];
      }
      
      public static function GetVoidFunctionDeclaration ():FunctionDeclaration
      {
         return new FunctionDeclaration (CoreFunctionIds.ID_Void, null)
      }
   }
}