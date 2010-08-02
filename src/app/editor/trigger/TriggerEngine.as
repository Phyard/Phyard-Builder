
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
   
   import flash.display.DisplayObject;
   
   import mx.managers.PopUpManager;
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.CoreEventIds;
   import common.trigger.CoreFunctionDeclarations;
   import common.trigger.CoreEventDeclarations;
   
   import common.trigger.ValueTypeDefine;
   
   import editor.dialog.VariablesEditDialog;
   
   import editor.runtime.Runtime;
   
   public class TriggerEngine
   {
      // register variables
      private var mRegisterVariableSpace_Boolean          :VariableSpaceRegister;
      private var mRegisterVariableSpace_String           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Number           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Entity           :VariableSpaceRegister;
      private var mRegisterVariableSpace_CollisionCategory:VariableSpaceRegister;
      
      // custom global variables
      private var mGlobalVariableSpace:VariableSpaceGlobal;
      
      // custom entity properties
      private var mEntityVariableSpace:VariableSpaceEntity;
      
      // custom functions
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public function TriggerEngine ()
      {
         InitStaticData ();
         
         // register variable spaces
         
         mRegisterVariableSpace_Boolean           = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Boolean);
         mRegisterVariableSpace_String            = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_String);
         mRegisterVariableSpace_Number            = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Number);
         mRegisterVariableSpace_Entity            = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Entity);
         mRegisterVariableSpace_CollisionCategory = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_CollisionCategory);
         
         // custom global variable space
         
         mGlobalVariableSpace = new VariableSpaceGlobal (this);
         
         // custom entity property space
         
         mEntityVariableSpace = new VariableSpaceEntity (this);
         
         // ...
         
         HideGlobalVariablesEditDialog ();
         mGlobalVariablesEditDialog = null;
         
         HideEntityVariablesEditDialog ();
         mEntityVariablesEditDialog = null;
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
         
         // ...
         mStaticDataInited = true;
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
      
   //========================================================================================================
   // variable spaces
   //========================================================================================================
      
      public function GetRegisterVariableSpace (valueType:int):VariableSpaceRegister
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
      
      public function GetGlobalVariableSpace ():VariableSpaceGlobal
      {
         return mGlobalVariableSpace;
      }
      
      public function GetEntityVariableSpace ():VariableSpaceEntity
      {
         return mEntityVariableSpace;
      }
      
      public function NotifyGlobalVariableSpaceModified ():void
      {
         if (mGlobalVariablesEditDialog != null)
         {
            mGlobalVariablesEditDialog.NotifyVariableSpaceModified ();
         }
      }
      
      public function NotifyEntityVariableSpaceModified ():void
      {
         if (mEntityVariablesEditDialog != null)
         {
            mEntityVariablesEditDialog.NotifyVariableSpaceModified ();
         }
      }
      
   //========================================================================================================
   // variable edit dialogs
   //========================================================================================================
      
      private static var mGlobalVariablesEditDialog:VariablesEditDialog = null;
      private static var mGlobalVariablesEditDialogVisible:Boolean = false;
      
      public function ShowGlobalVariablesEditDialog (parent:DisplayObject):void
      {
         var toCreate:Boolean = (mGlobalVariablesEditDialog == null);
         if (toCreate)
         {
            mGlobalVariablesEditDialog = new VariablesEditDialog ();
            mGlobalVariablesEditDialog.SetTitle ("Global Variables Editing");
            mGlobalVariablesEditDialog.SetCloseFunc (HideGlobalVariablesEditDialog);
            mGlobalVariablesEditDialog.SetVariableSpace (mGlobalVariableSpace);
         }
         
         if (! mGlobalVariablesEditDialogVisible)
         {
            PopUpManager.addPopUp (mGlobalVariablesEditDialog, parent, true);
            mGlobalVariablesEditDialogVisible = true;
         }
         
         if (toCreate)
         {
            PopUpManager.centerPopUp (mGlobalVariablesEditDialog);
         }
         
         PopUpManager.bringToFront (mGlobalVariablesEditDialog);
      }
      
      public function HideGlobalVariablesEditDialog ():void
      {
         if (mGlobalVariablesEditDialog != null && mGlobalVariablesEditDialogVisible)
         {
            PopUpManager.removePopUp (mGlobalVariablesEditDialog);
            
            if (Runtime.mGlobalVariablesEditingDialogClosedCallBack != null)
            {
               Runtime.mGlobalVariablesEditingDialogClosedCallBack ();
            }
         }
         
         mGlobalVariablesEditDialogVisible = false;
      }
      
      private static var mEntityVariablesEditDialog:VariablesEditDialog = null;
      private static var mEntityVariablesEditDialogVisible:Boolean = false;
      
      public function ShowEntityVariablesEditDialog (parent:DisplayObject):void
      {
         var toCreate:Boolean = (mEntityVariablesEditDialog == null);
         if (toCreate)
         {
            mEntityVariablesEditDialog = new VariablesEditDialog ();
            mEntityVariablesEditDialog.SetTitle ("Custom Entity Properties Editing");
            mEntityVariablesEditDialog.SetCloseFunc (HideEntityVariablesEditDialog);
            mEntityVariablesEditDialog.SetVariableSpace (mEntityVariableSpace);
         }
         
         if (! mEntityVariablesEditDialogVisible)
         {
            PopUpManager.addPopUp (mEntityVariablesEditDialog, parent, true);
            mEntityVariablesEditDialogVisible = true;
         }
         
         if (toCreate)
         {
            PopUpManager.centerPopUp (mEntityVariablesEditDialog);
         }
         
         PopUpManager.bringToFront (mEntityVariablesEditDialog);
      }
      
      public function HideEntityVariablesEditDialog ():void
      {
         if (mEntityVariablesEditDialog != null && mEntityVariablesEditDialogVisible)
         {
            PopUpManager.removePopUp (mEntityVariablesEditDialog);
            
            if (Runtime.mEntityVariablesEditingDialogClosedCallBack != null)
            {
               Runtime.mEntityVariablesEditingDialogClosedCallBack ();
            }
         }
         
         mEntityVariablesEditDialogVisible = false;
      }
   }
}
