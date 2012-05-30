package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.Scene;
   
   import editor.EditorContext;
   
   import common.trigger.ValueTypeDefine;
   
   import common.Define;
   
   public class VariableDefinitionEntity extends VariableDefinition
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      internal var mValidClasses:Array = null;
      internal var mExceptClasses:Array = null;
      internal var mNullValueEnabled:Boolean = true;
      internal var mMultiValuesEnabled:Boolean = false;
      internal var mGroundSelectable:Boolean = false;
      
      public function VariableDefinitionEntity (name:String, description:String = null, options:Object = null)
      {
         super (ValueTypeDefine.ValueType_Entity, name, description, options);
         
         if (options != null)
         {
            if (options.mValidClasses != undefined)
               mValidClasses = options.mValidClasses;
            if (options.mExceptClasses != undefined)
               mExceptClasses = options.mExceptClasses;
            if (options.mNullValueEnabled != undefined)
               mNullValueEnabled = Boolean (options.mNullValueEnabled);
            if (options.mMultiValuesEnabled != undefined)
               mMultiValuesEnabled = Boolean (options.mMultiValuesEnabled);
            if (options.mGroundSelectable != undefined)
               mGroundSelectable = Boolean (options.mGroundSelectable);
         }
      }
      
      private static const sDefaultValidClasses:Array = [Entity];
      
      public function GetValidClasses ():Array
      {
         return mValidClasses == null ? sDefaultValidClasses : mValidClasses;
      }
      
      public function GetExceptClasses ():Array
      {
         return mExceptClasses;
      }
      
      public function DoesSatisfyAnyPrototypesIn (classes:Array):Boolean
      {
         if (classes == null)
            return false;
         
         var validClasses:Array = GetValidClasses ();
         
         if (validClasses == null)
            return false;
         
         var validClass:Object;
         var inputClass:Object;
         
         for (var i:int = 0; i < validClasses.length; ++ i)
         {
            validClass = validClasses [i];
            for (var j:int = 0; j < classes.length; ++ j)
            {
               inputClass = classes [j];
               if (inputClass.prototype == validClass.prototype || inputClass.prototype.isPrototypeOf (validClass.prototype))
                  return true;
            }
         }
         
         return false;
      }
      
      public function IsValidEntity (entity:Entity):Boolean
      {
         if (entity == null)
            return false;
         
         var i:int;
         var exceptClass:Object;
         
         var exceptClasses:Array = GetExceptClasses ();
         if (exceptClasses != null)
         {
            for (i = 0; i < exceptClasses.length; ++ i)
            {
               exceptClass = exceptClasses [i];
               
               if (exceptClass.prototype.isPrototypeOf (entity))
                  return false;
            }
         }
         
         var validClass:Object;
         
         var validClasses:Array = GetValidClasses ();
         for (i = 0; i < validClasses.length; ++ i)
         {
            validClass = validClasses [i];
            
            if (validClass.prototype.isPrototypeOf (entity))
               return true;
         }
         
         return false;
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         var entityVariableDefinition:VariableDefinitionEntity = new VariableDefinitionEntity (mName, mDescription);
         entityVariableDefinition.mValidClasses = mValidClasses;
         entityVariableDefinition.mExceptClasses = mExceptClasses;
         entityVariableDefinition.mNullValueEnabled = mNullValueEnabled;
         entityVariableDefinition.mMultiValuesEnabled = mMultiValuesEnabled;
         entityVariableDefinition.mGroundSelectable = mGroundSelectable;
         
         return entityVariableDefinition;
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function IsCompatibleWith (variableDefinition:VariableDefinition):Boolean
      {
         if (super.IsCompatibleWith (variableDefinition))
         {
            // variableDefinition must be a VariableDefinitionEntity
            
            if ( DoesSatisfyAnyPrototypesIn ( (variableDefinition as VariableDefinitionEntity).GetExceptClasses () ) )
               return false;
            
            return DoesSatisfyAnyPrototypesIn ( (variableDefinition as VariableDefinitionEntity).GetValidClasses () );
         }
         
         return false;
      }
      
      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return ValidateValueObject_Entity (valueObject);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct (null);
      }
      
      override public function CreateControlForDirectValueSource (valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         var world:World = EditorContext.GetEditorApp ().GetWorld ();
         var entity_list:Array = world.GetEntityContainer ().GetEntitySelectListDataProviderByFilter (IsValidEntity, mGroundSelectable, null, isForPureCustomFunction);
         
         var entity:Entity = valueSourceDirect.GetValueObject () as Entity;
         var sel_index:int = -1;
         var entity_index:int = Define.EntityId_None;
         
         if (entity == null)
         {
            if (valueSourceDirect.GetValueObject () is World)
            {
               entity_index = Define.EntityId_Ground;
            }
         }
         else
         {
            entity_index = entity.GetCreationOrderId ();
         }
         
         sel_index = Scene.EntityIndex2SelectListSelectedIndex (entity_index, entity_list);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = entity_list;
         combo_box.selectedIndex = sel_index;
         
         //trace ("sel_index = " + sel_index);
         
         return combo_box;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         if (control is ComboBox)
         {
            var combo_box:ComboBox = control as ComboBox;
            
            if (combo_box.selectedItem == null)
               valueSourceDirect.SetValueObject (null);
            else
            {
               var world:World = EditorContext.GetEditorApp ().GetWorld ();
               var entity_index:int = combo_box.selectedItem.mEntityIndex;
               if (entity_index < 0)
               {
                  if (entity_index == Define.EntityId_Ground)
                     valueSourceDirect.SetValueObject (EditorContext.GetEditorApp ().GetWorld ());
                  else // if (entity_index == Define.EntityId_None)
                     valueSourceDirect.SetValueObject (null);
               }
               else
               {
                  valueSourceDirect.SetValueObject (world.GetEntityContainer ().GetAssetByCreationId (entity_index));
               }
            }
         }
         
         return null;
      }
   }
}

