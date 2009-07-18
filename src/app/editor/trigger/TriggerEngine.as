
/*
//static defines
- registerFunction (funcDefine, packagerName, parentPackagerName = null)
- registerVariable ()
- registerEvent ()

core
core.system
core.world
core.entity
core.entity.shape
core,entity.shape.rect

extend.field.


//instances
 
*/

package editor.trigger {
   
   public class TriggerEngine
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function TriggerEngine ()
      {
         InitStaticData ();
         
      }
      
      private static var mStaticDataInited:Boolean = false;
      private static function InitStaticData ():void
      {
         if (mStaticDataInited)
            return;
         
         mStaticDataInited = true;
         
         PlayerFunctionDefinesForEditing.Initialize ();
         PlayerEventDefinesForEditing.Initialize ();
         
      }
      
   //========================================================================================================
   //
   //========================================================================================================
      
      
      public static function GetEventDeclarationById (event_id:int):EventDeclaration
      {
         return PlayerEventDefinesForEditing.GetEventDeclarationById (event_id);
      }
      
      public static function GetPlayerFunctionDeclarationById (func_id:int):FunctionDeclaration
      {
         return PlayerFunctionDefinesForEditing.GetFunctionDeclarationById (func_id);
      }
      
      public static function GetPlayerCommandFunctionsMenuItemXML ():XML
      {
         return PlayerFunctionDefinesForEditing.sCommandFunctionsMenuItemXML;
      }
      
      public static function GetPlayerConditionFunctionsMenuItemXML ():XML
      {
         return PlayerFunctionDefinesForEditing.sConditionFunctionsMenuItemXML;
      }
      
   }
}
