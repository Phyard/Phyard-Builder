
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
   import editor.trigger.VariableSpace;
   
   import editor.display.dialog.VariablesEditDialog;
   
   import editor.EditorContext;
   
   public class TriggerEngine
   {
      // register variables
      private var mRegisterVariableSpace_Boolean          :VariableSpaceRegister;
      private var mRegisterVariableSpace_String           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Number           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Entity           :VariableSpaceRegister;
      private var mRegisterVariableSpace_CollisionCategory:VariableSpaceRegister;
      private var mRegisterVariableSpace_Module           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Sound           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Array            :VariableSpaceRegister;
      
      // custom session variables
      private var mSessionVariableSpace:VariableSpaceSession;
      
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
         
         PlayerFunctionDefinesForEditing.sCustomMenuGroup.Clear ();
         
         // register variable spaces
         
         mRegisterVariableSpace_Boolean           = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Boolean);
         mRegisterVariableSpace_String            = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_String);
         mRegisterVariableSpace_Number            = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Number);
         mRegisterVariableSpace_Entity            = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Entity);
         mRegisterVariableSpace_CollisionCategory = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_CollisionCategory);
         mRegisterVariableSpace_Module            = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Module);
         mRegisterVariableSpace_Sound            = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Sound);
         mRegisterVariableSpace_Array             = new VariableSpaceRegister (this, ValueTypeDefine.ValueType_Array);
         
         // custom session variable space
         
         mSessionVariableSpace = new VariableSpaceSession (this);
         
         // custom global variable space
         
         mGlobalVariableSpace = new VariableSpaceGlobal (this);
         
         // custom entity property space
         
         mEntityVariableSpace = new VariableSpaceEntity (this);
         
         // ...
         
         HideSessionVariablesEditDialog ();
         mSessionVariablesEditDialog = null;
         
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
      
      public function UpdateCustomFunctionMenu ():void
      {
         PlayerFunctionDefinesForEditing.UpdateCustomMenu ();
      }
      
      public static function GetEventDeclarationById (event_id:int):FunctionDeclaration_EventHandler
      {
         return PlayerEventDefinesForEditing.GetEventDeclarationById (event_id);
      }
      
      public static function GetPlayerCoreFunctionDeclarationById (func_id:int):FunctionDeclaration_Core
      {
         return PlayerFunctionDefinesForEditing.GetCoreFunctionDeclarationById (func_id);
      }
      
      public static function GetCoreApiFunctionsMenuBarDataProvider_Shorter ():XML
      {
         return PlayerFunctionDefinesForEditing.sMenuBarDataProvider_Shorter;
      }
      
      public static function GetCoreApiFunctionsMenuBarDataProvider_Longer ():XML
      {
         return PlayerFunctionDefinesForEditing.sMenuBarDataProvider_Longer;
      }
      
   //========================================================================================================
   // some special function declarations
   //========================================================================================================
      
      public static function GetVoidFunctionDeclaration ():FunctionDeclaration_PreDefined
      {
         return PlayerFunctionDefinesForEditing.GetPreDefinedFunctionDeclarationById (CoreFunctionIds.ID_Void);
      }
      
      public static function GetBoolFunctionDeclaration ():FunctionDeclaration_PreDefined
      {
         return PlayerFunctionDefinesForEditing.GetPreDefinedFunctionDeclarationById (CoreFunctionIds.ID_Bool);
      }
      
      public static function GetEntityFilterFunctionDeclaration ():FunctionDeclaration_PreDefined
      {
         return PlayerFunctionDefinesForEditing.GetPreDefinedFunctionDeclarationById (CoreFunctionIds.ID_EntityFilter);
      }
      
      public static function GetEntityPairFilterFunctionDeclaration ():FunctionDeclaration_PreDefined
      {
         return PlayerFunctionDefinesForEditing.GetPreDefinedFunctionDeclarationById (CoreFunctionIds.ID_EntityPairFilter);
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
            case ValueTypeDefine.ValueType_Module:
               return mRegisterVariableSpace_Module;
            case ValueTypeDefine.ValueType_Sound:
               return mRegisterVariableSpace_Sound;
            case ValueTypeDefine.ValueType_Array:
               return mRegisterVariableSpace_Array;
            default:
               return null;
         }
      }
      
   //========================================================================================================
   // session variable edit dialog
   //========================================================================================================
      
      private static var mSessionVariablesEditDialog:VariablesEditDialog = null;
      private static var mSessionVariablesEditDialogVisible:Boolean = false;
      
      public function ShowSessionVariablesEditDialog (parent:DisplayObject):void
      {
         var toCreate:Boolean = (mSessionVariablesEditDialog == null);
         if (toCreate)
         {
            mSessionVariablesEditDialog = new VariablesEditDialog ();
            mSessionVariablesEditDialog.SetTitle ("Session Variables Editing");
            mSessionVariablesEditDialog.SetCloseFunc (HideSessionVariablesEditDialog);
            //mSessionVariablesEditDialog.visible = false; // useless, when change to true first ime, show-event will not triggered
         }
         
         mSessionVariablesEditDialog.SetVariableSpace (mSessionVariableSpace);
         
         if (! mSessionVariablesEditDialogVisible)
         {
            PopUpManager.addPopUp (mSessionVariablesEditDialog, parent, true);
            mSessionVariablesEditDialogVisible = true;
            mSessionVariablesEditDialog.visible = true;
         }
         
         if (toCreate)
         {
            PopUpManager.centerPopUp (mSessionVariablesEditDialog);
         }
         
         PopUpManager.bringToFront (mSessionVariablesEditDialog);
      }
      
      public function HideSessionVariablesEditDialog ():void
      {
         if (mSessionVariablesEditDialog != null && mSessionVariablesEditDialogVisible)
         {
            mSessionVariablesEditDialog.visible = false;
            
            PopUpManager.removePopUp (mSessionVariablesEditDialog);
            
            if (EditorContext.mSessionVariablesEditingDialogClosedCallBack != null)
            {
               EditorContext.mSessionVariablesEditingDialogClosedCallBack ();
            }
         }
         
         mSessionVariablesEditDialogVisible = false;
      }
      
      public function GetSessionVariableSpace ():VariableSpaceSession
      {
         return mSessionVariableSpace;
      }
      
      public function NotifySessionVariableSpaceModified ():void
      {
         if (mSessionVariablesEditDialog != null)
         {
            mSessionVariablesEditDialog.NotifyVariableSpaceModified ();
         }
      }
      
   //========================================================================================================
   // global variable edit dialog
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
            //mGlobalVariablesEditDialog.visible = false; // useless, when change to true first ime, show-event will not triggered
         }
         
         mGlobalVariablesEditDialog.SetVariableSpace (mGlobalVariableSpace);
         
         if (! mGlobalVariablesEditDialogVisible)
         {
            PopUpManager.addPopUp (mGlobalVariablesEditDialog, parent, true);
            mGlobalVariablesEditDialogVisible = true;
            mGlobalVariablesEditDialog.visible = true;
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
            mGlobalVariablesEditDialog.visible = false;
            
            PopUpManager.removePopUp (mGlobalVariablesEditDialog);
            
            if (EditorContext.mGlobalVariablesEditingDialogClosedCallBack != null)
            {
               EditorContext.mGlobalVariablesEditingDialogClosedCallBack ();
            }
         }
         
         mGlobalVariablesEditDialogVisible = false;
      }
      
      public function GetGlobalVariableSpace ():VariableSpaceGlobal
      {
         return mGlobalVariableSpace;
      }
      
      public function NotifyGlobalVariableSpaceModified ():void
      {
         if (mGlobalVariablesEditDialog != null)
         {
            mGlobalVariablesEditDialog.NotifyVariableSpaceModified ();
         }
      }
      
   //========================================================================================================
   // entity variable edit dialog
   //========================================================================================================
      
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
            //mEntityVariablesEditDialog.visible = false; // useless, when change to true first ime, show-event will not triggered
         }
         
         mEntityVariablesEditDialog.SetVariableSpace (mEntityVariableSpace);
         
         if (! mEntityVariablesEditDialogVisible)
         {
            PopUpManager.addPopUp (mEntityVariablesEditDialog, parent, true);
            mEntityVariablesEditDialogVisible = true;
            mEntityVariablesEditDialog.visible = true;
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
            mEntityVariablesEditDialog.visible = false;
            
            PopUpManager.removePopUp (mEntityVariablesEditDialog);
            
            if (EditorContext.mEntityVariablesEditingDialogClosedCallBack != null)
            {
               EditorContext.mEntityVariablesEditingDialogClosedCallBack ();
            }
         }
         
         mEntityVariablesEditDialogVisible = false;
      }
      
      public function GetEntityVariableSpace ():VariableSpaceEntity
      {
         return mEntityVariableSpace;
      }
      
      public function NotifyEntityVariableSpaceModified ():void
      {
         if (mEntityVariablesEditDialog != null)
         {
            mEntityVariablesEditDialog.NotifyVariableSpaceModified ();
         }
      }
      
   //========================================================================================================
   // local variable edit dialog
   //========================================================================================================
      
      private static var mLocalVariablesEditDialog:VariablesEditDialog = null;
      private static var mLocalVariablesEditDialogVisible:Boolean = false;
      
      public function ShowLocalVariablesEditDialog (parent:DisplayObject, variableSpace:VariableSpace):void
      {
         var toCreate:Boolean = (mLocalVariablesEditDialog == null);
         if (toCreate)
         {
            mLocalVariablesEditDialog = new VariablesEditDialog ();
            mLocalVariablesEditDialog.SetTitle ("Local Variables Editing");
            mLocalVariablesEditDialog.SetCloseFunc (HideLocalVariablesEditDialog);
            //mLocalVariablesEditDialog.visible = false; // useless, when change to true first ime, show-event will not triggered
            
            mLocalVariablesEditDialog.SetOptions ({mSupportEditingInitialValues: false});
         }
         
         mLocalVariablesEditDialog.SetVariableSpace (variableSpace);
         
         if (! mLocalVariablesEditDialogVisible)
         {
            PopUpManager.addPopUp (mLocalVariablesEditDialog, parent, true);
            mLocalVariablesEditDialogVisible = true;
            mLocalVariablesEditDialog.visible = true;
         }
         
         if (toCreate)
         {
            PopUpManager.centerPopUp (mLocalVariablesEditDialog);
         }
         
         PopUpManager.bringToFront (mLocalVariablesEditDialog);
      }
      
      public function HideLocalVariablesEditDialog ():void
      {
         if (mLocalVariablesEditDialog != null && mLocalVariablesEditDialogVisible)
         {
            mLocalVariablesEditDialog.visible = false;
            
            PopUpManager.removePopUp (mLocalVariablesEditDialog);
            
            if (EditorContext.mLocalVariablesEditingDialogClosedCallBack != null)
            {
               EditorContext.mLocalVariablesEditingDialogClosedCallBack ();
            }
         }
         
         mLocalVariablesEditDialogVisible = false;
      }
      
      public function NotifyLocalVariableSpaceInvalid ():void
      {
         if (mLocalVariablesEditDialog != null)
         {
            mLocalVariablesEditDialog.SetVariableSpace (null);
            mLocalVariablesEditDialog.NotifyVariableSpaceModified ();
         }
      }
      
   //========================================================================================================
   // local variable edit dialog
   //========================================================================================================
      
      private static var mInputVariablesEditDialog:VariablesEditDialog = null;
      private static var mInputVariablesEditDialogVisible:Boolean = false;
      
      public function ShowInputVariablesEditDialog (parent:DisplayObject, variableSpace:VariableSpace):void
      {
         var toCreate:Boolean = (mInputVariablesEditDialog == null);
         if (toCreate)
         {
            mInputVariablesEditDialog = new VariablesEditDialog ();
            mInputVariablesEditDialog.SetTitle ("Input Variables Editing");
            mInputVariablesEditDialog.SetCloseFunc (HideInputVariablesEditDialog);
            //mInputVariablesEditDialog.visible = false; // useless, when change to true first ime, show-event will not triggered
         }
         
         mInputVariablesEditDialog.SetVariableSpace (variableSpace);
         
         if (! mInputVariablesEditDialogVisible)
         {
            PopUpManager.addPopUp (mInputVariablesEditDialog, parent, true);
            mInputVariablesEditDialogVisible = true;
            mInputVariablesEditDialog.visible = true;
         }
         
         if (toCreate)
         {
            PopUpManager.centerPopUp (mInputVariablesEditDialog);
         }
         
         PopUpManager.bringToFront (mInputVariablesEditDialog);
      }
      
      public function HideInputVariablesEditDialog ():void
      {
         if (mInputVariablesEditDialog != null && mInputVariablesEditDialogVisible)
         {
            mInputVariablesEditDialog.visible = false;
            
            PopUpManager.removePopUp (mInputVariablesEditDialog);
            
            if (EditorContext.mInputVariablesEditingDialogClosedCallBack != null)
            {
               EditorContext.mInputVariablesEditingDialogClosedCallBack ();
            }
         }
         
         mInputVariablesEditDialogVisible = false;
      }
      
      public function NotifyInputVariableSpaceInvalid ():void
      {
         if (mInputVariablesEditDialog != null)
         {
            mInputVariablesEditDialog.SetVariableSpace (null);
            mInputVariablesEditDialog.NotifyVariableSpaceModified ();
         }
      }
      
   //========================================================================================================
   // local variable edit dialog
   //========================================================================================================
      
      private static var mOutputVariablesEditDialog:VariablesEditDialog = null;
      private static var mOutputVariablesEditDialogVisible:Boolean = false;
      
      public function ShowOutputVariablesEditDialog (parent:DisplayObject, variableSpace:VariableSpace):void
      {
         var toCreate:Boolean = (mOutputVariablesEditDialog == null);
         if (toCreate)
         {
            mOutputVariablesEditDialog = new VariablesEditDialog ();
            mOutputVariablesEditDialog.SetTitle ("Output Variables Editing");
            mOutputVariablesEditDialog.SetCloseFunc (HideOutputVariablesEditDialog);
            //mOutputVariablesEditDialog.visible = false; // useless, when change to true first ime, show-event will not triggered
            
            mOutputVariablesEditDialog.SetOptions ({mSupportEditingInitialValues: false});
         }
         
         mOutputVariablesEditDialog.SetVariableSpace (variableSpace);
         
         if (! mOutputVariablesEditDialogVisible)
         {
            PopUpManager.addPopUp (mOutputVariablesEditDialog, parent, true);
            mOutputVariablesEditDialogVisible = true;
            mOutputVariablesEditDialog.visible = true;
         }
         
         if (toCreate)
         {
            PopUpManager.centerPopUp (mOutputVariablesEditDialog);
         }
         
         PopUpManager.bringToFront (mOutputVariablesEditDialog);
      }
      
      public function HideOutputVariablesEditDialog ():void
      {
         if (mOutputVariablesEditDialog != null && mOutputVariablesEditDialogVisible)
         {
            mOutputVariablesEditDialog.visible = false;
            
            PopUpManager.removePopUp (mOutputVariablesEditDialog);
            
            if (EditorContext.mOutputVariablesEditingDialogClosedCallBack != null)
            {
               EditorContext.mOutputVariablesEditingDialogClosedCallBack ();
            }
         }
         
         mOutputVariablesEditDialogVisible = false;
      }
      
      public function NotifyOutputVariableSpaceInvalid ():void
      {
         if (mOutputVariablesEditDialog != null)
         {
            mOutputVariablesEditDialog.SetVariableSpace (null);
            mOutputVariablesEditDialog.NotifyVariableSpaceModified ();
         }
      }
   }
}
