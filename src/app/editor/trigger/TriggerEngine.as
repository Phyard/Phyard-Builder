
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
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.CoreEventIds;
   import common.trigger.CoreFunctionDeclarations;
   import common.trigger.CoreEventDeclarations;
   
   import common.trigger.ValueTypeDefine;
   
   public class TriggerEngine
   {
      public static var mRegisterVariableSpace_Boolean          :VariableSpaceRegister;
      public static var mRegisterVariableSpace_String           :VariableSpaceRegister;
      public static var mRegisterVariableSpace_Number           :VariableSpaceRegister;
      public static var mRegisterVariableSpace_Entity           :VariableSpaceRegister;
      public static var mRegisterVariableSpace_CollisionCategory:VariableSpaceRegister;
      
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
         
         // APIs
         
         CoreFunctionDeclarations.Initialize ();
         CoreEventDeclarations.Initialize ();
         
         PlayerFunctionDefinesForEditing.Initialize ();
         PlayerEventDefinesForEditing.Initialize ();
         
         // register spaces
         
         mRegisterVariableSpace_Boolean           = new VariableSpaceRegister (ValueTypeDefine.ValueType_Boolean);
         mRegisterVariableSpace_String            = new VariableSpaceRegister (ValueTypeDefine.ValueType_String);
         mRegisterVariableSpace_Number            = new VariableSpaceRegister (ValueTypeDefine.ValueType_Number);
         mRegisterVariableSpace_Entity            = new VariableSpaceRegister (ValueTypeDefine.ValueType_Entity);
         mRegisterVariableSpace_CollisionCategory = new VariableSpaceRegister (ValueTypeDefine.ValueType_CollisionCategory);
         
         // ...
         mStaticDataInited = true;
      }
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public static function GetRegisterVariableSpace (valueType:int):VariableSpaceRegister
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return mRegisterVariableSpace_Boolean;
            case ValueTypeDefine.ValueType_String:
               return mRegisterVariableSpace_String;
            case ValueTypeDefine.ValueType_Number:
               return mRegisterVariableSpace_Number;
            case ValueTypeDefine.ValueType_Entity:
               return mRegisterVariableSpace_Entity;
            case ValueTypeDefine.ValueType_CollisionCategory:
               return mRegisterVariableSpace_CollisionCategory;
            default:
               return null;
         }
      }
      
      public static function GetEventDeclarationById (event_id:int):FunctionDeclaration_EventHandler
      {
         return PlayerEventDefinesForEditing.GetEventDeclarationById (event_id);
      }
      
      public static function GetPlayerFunctionDeclarationById (func_id:int):FunctionDeclaration_Core
      {
         return PlayerFunctionDefinesForEditing.GetFunctionDeclarationById (func_id);
      }
      
      public static function GetCoreApiFunctionsMenuBarDataProvider_Shorter ():XML
      {
         return PlayerFunctionDefinesForEditing.sMenuBarDataProvider_Shorter;
      }
      
      public static function GetCoreApiFunctionsMenuBarDataProvider_Longer ():XML
      {
         return PlayerFunctionDefinesForEditing.sMenuBarDataProvider_Longer;
      }
      
      public static function GetVoidFunctionDeclaration ():FunctionDeclaration_Core
      {
         return PlayerFunctionDefinesForEditing.GetFunctionDeclarationById (CoreFunctionIds.ID_Void);
      }
      
      public static function GetBoolFunctionDeclaration ():FunctionDeclaration_Core
      {
         return PlayerFunctionDefinesForEditing.GetFunctionDeclarationById (CoreFunctionIds.ID_Bool);
      }
      
      public static function GetEntityFilterFunctionDeclaration ():FunctionDeclaration_Core
      {
         return PlayerFunctionDefinesForEditing.GetFunctionDeclarationById (CoreFunctionIds.ID_EntityFilter);
      }
      
      public static function GetEntityPairFilterFunctionDeclaration ():FunctionDeclaration_Core
      {
         return PlayerFunctionDefinesForEditing.GetFunctionDeclarationById (CoreFunctionIds.ID_EntityPairFilter);
      }
   }
}
