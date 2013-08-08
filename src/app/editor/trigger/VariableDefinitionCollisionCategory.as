package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   
   import editor.world.World;
   import editor.entity.Scene;
   //import editor.entity.EntityCollisionCategory;
   import editor.ccat.CollisionCategory;
   
   import editor.EditorContext;
   
   import editor.ccat.CollisionCategoryManager;
   
   import common.trigger.CoreClassIds;
   
   import common.Define;
   
   public class VariableDefinitionCollisionCategory extends VariableDefinition_Core
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableDefinitionCollisionCategory (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_CollisionCategory), name, description, options);
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         var ccatVariableDefinition:VariableDefinitionCollisionCategory = new VariableDefinitionCollisionCategory (mName, mDescription);
         
         return ccatVariableDefinition;
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
      
      override public function CreateControlForDirectValueSource (scene:Scene, valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         var category_list:Array = scene.GetCollisionCategoryManager ().GetCollisionCategoryListDataProvider (isForPureCustomFunction);
         
         var category:CollisionCategory = valueSourceDirect.GetValueObject () as CollisionCategory;
         var sel_index:int = -1;
         var category_index:int = -1;
         if (category != null)
            category_index = category.GetAppearanceLayerId ();
         sel_index = CollisionCategoryManager.CollisionCategoryIndex2SelectListSelectedIndex (category_index, category_list);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = category_list;
         combo_box.selectedIndex = sel_index;
         
         return combo_box;
      }
      
      override public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         if (control is ComboBox)
         {
            var combo_box:ComboBox = control as ComboBox;
            
            if (combo_box.selectedItem == null)
               valueSourceDirect.SetValueObject (null);
            else
            {
               var category_index:int = combo_box.selectedItem.mCategoryIndex;
               if (category_index < 0)
                  valueSourceDirect.SetValueObject (null);
               else
                  valueSourceDirect.SetValueObject (scene.GetCollisionCategoryManager ().GetCollisionCategoryByIndex (category_index));
            }
         }
         
         return null;
      }
   }
}

