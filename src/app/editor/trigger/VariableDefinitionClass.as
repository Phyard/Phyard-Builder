package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   
   import editor.world.World;
   import editor.world.CoreClasses;
   import editor.entity.Scene;
   import editor.entity.Entity;
   import editor.entity.Scene;
   import editor.codelib.CodeLibManager;
   
   import editor.EditorContext;
   
   import common.trigger.CoreClassIds;
   
   import common.Define;
   
   public class VariableDefinitionClass extends VariableDefinition_Core
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableDefinitionClass (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_Class), name, description, null);
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         return new VariableDefinitionClass (mName, mDescription, mOptions);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct (CoreClasses.sVoidClass);
      }
      
      override public function CreateControlForDirectValueSource (scene:Scene, valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         var type_list:Array = CodeLibManager.GetTypesDataProviderForParameter (scene.GetCodeLibManager (), true, false);
         
         var sel_index:int = CodeLibManager.GetSelectIndexForParameter (type_list, valueSourceDirect.GetValueObject () as ClassDefinition);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = type_list;
         combo_box.labelField = "label";
         combo_box.selectedIndex = sel_index;
         
         //trace ("sel_index = " + sel_index);
         
         return combo_box;
      }
      
      override public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         if (control is ComboBox)
         {
            var combo_box:ComboBox = control as ComboBox;
            
            valueSourceDirect.SetValueObject (scene.GetCodeLibManager ().GetClassDefinitionForParameterFromSelectItem (combo_box.selectedItem));
         }
         
         return null;
      }
   }
}

