package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   
   import editor.world.World;
   import editor.entity.WorldEntity;
   
   import editor.runtime.Runtime;
   
   import common.trigger.ValueTypeDefine;
   
   public class VariableDefinitionEntity extends VariableDefinition
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mFilterFunction:Function = null;
      protected var mNullValueEnabled:Boolean = true;
      protected var mMultiValuesEnabled:Boolean = false;
      
      public function VariableDefinitionEntity (name:String, description:String = null, filterFunc:Function = null, nullValueEnabled:Boolean = true, multiValuesEnabled:Boolean = false)
      {
         super (name, ValueTypeDefine.ValueType_Entity, description);
         
         mFilterFunction = filterFunc;
         mNullValueEnabled = nullValueEnabled;
         mMultiValuesEnabled = multiValuesEnabled;
      }
      
//==============================================================================
// to override
//==============================================================================
      
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
      
      override public function CreateControlForDirectValueSource (valueSourceDirect:ValueSource_Direct):UIComponent
      {
         var world:World = Runtime.GetCurrentWorld ();
         var entity_list:Array = world.GetEntitySelectListDataProviderByFilter (mFilterFunction);
         
         var entity:WorldEntity = valueSourceDirect.GetValueObject () as WorldEntity;
         var sel_index:int = -1;
         var entity_index:int = -1;
         if (entity != null)
            entity_index = entity.GetCreationOrderId ();
         sel_index = World.EntityIndex2SelectListSelectedIndex (entity_index, entity_list);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = entity_list;
         combo_box.selectedIndex = sel_index;
         
         //trace ("sel_index = " + sel_index);
         
         return combo_box;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent):void
      {
         if (control is ComboBox)
         {
            var combo_box:ComboBox = control as ComboBox;
            
            if (combo_box.selectedItem == null)
               valueSourceDirect.SetValueObject (null);
            else
            {
               var world:World = Runtime.GetCurrentWorld ();
               var entity_index:int = combo_box.selectedItem.mEntityIndex;
               if (entity_index < 0)
                  valueSourceDirect.SetValueObject (null);
               else
                  valueSourceDirect.SetValueObject (world.GetEntityByCreationId (entity_index));
            }
         }
      }
   }
}

