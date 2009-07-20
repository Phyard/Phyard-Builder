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
      
      public static function EntityIndex2SelectListSelectedIndex (entityIndex:int, entitySelectListDataProvider:Array):int
      {
         for (var i:int = 0; i < entitySelectListDataProvider.length; ++ i)
         {
            if (entitySelectListDataProvider[i].mEntityIndex == entityIndex)
               return i;
         }
         
         return -1;
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSourceDirect
      {
         return new ValueSourceDirect (null);
      }
      
      override public function ValidateDirectValueSource (valueSourceDirect:ValueSourceDirect):void
      {
         //if (valueSourceDirect == null)
         //   return;
         
         var world:World = Runtime.GetCurrentWorld ();
         
         var entity:WorldEntity = valueSourceDirect.GetValueObject () as WorldEntity;
         if (entity != null && (entity.GetWorld () != world || entity.GetEntityIndex () < 0))
            entity = null;
         
         valueSourceDirect.SetValueObject (entity)
      }
      
      override public function CreateControlForDirectValueSource (valueSourceDirect:ValueSourceDirect):UIComponent
      {
         var world:World = Runtime.GetCurrentWorld ();
         var entity_list:Array = world.GetEntitySelectListDataProviderByFilter (mFilterFunction);
         
         if (mNullValueEnabled)
            entity_list.unshift ({label: "-1: null", mEntityIndex: -1});
         
         var entity:WorldEntity = valueSourceDirect.GetValueObject () as WorldEntity;
         var sel_index:int = -1;
         var entity_index:int = -1;
         if (entity != null)
            entity_index = entity.GetEntityIndex ();
         sel_index = EntityIndex2SelectListSelectedIndex (entity_index, entity_list);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = entity_list;
         combo_box.selectedIndex = sel_index;
         
         //trace ("sel_index = " + sel_index);
         
         return combo_box;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSourceDirect, control:UIComponent):void
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
                  valueSourceDirect.SetValueObject (world.getChildAt (entity_index));
            }
         }
      }
   }
}

