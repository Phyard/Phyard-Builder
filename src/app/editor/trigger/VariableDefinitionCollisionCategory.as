package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   
   import editor.world.World;
   import editor.entity.EntityCollisionCategory;
   
   import editor.runtime.Runtime;
   
   import common.trigger.ValueTypeDefine;
   
   import common.Define;
   
   public class VariableDefinitionCollisionCategory extends VariableDefinition
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableDefinitionCollisionCategory (name:String, description:String = null, options:Object = null)
      {
         super (ValueTypeDefine.ValueType_CollisionCategory, name, description);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return ValidateValueObject_CollisiontCategory (valueObject);
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
         var category_list:Array = world.GetCollisionCategoryListDataProvider ();
         
         var category:EntityCollisionCategory = valueSourceDirect.GetValueObject () as EntityCollisionCategory;
         var sel_index:int = -1;
         var category_index:int = -1;
         if (category != null)
            category_index = category.GetAppearanceLayerId ();
         sel_index = World.CollisionCategoryIndex2SelectListSelectedIndex (category_index, category_list);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = category_list;
         combo_box.selectedIndex = sel_index;
         
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
               var category_index:int = combo_box.selectedItem.mCategoryIndex;
               if (category_index < 0)
                  valueSourceDirect.SetValueObject (null);
               else
                  valueSourceDirect.SetValueObject (world.GetCollisionCategoryByIndex (category_index));
            }
         }
      }
   }
}

