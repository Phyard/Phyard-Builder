package editor.trigger {
   
   import mx.core.UIComponent;
   //import mx.controls.ComboBox;
   import mx.containers.HBox;
   import mx.controls.RadioButtonGroup;
   import mx.controls.RadioButton;
   
   import common.trigger.ValueTypeDefine;
   
   public class VariableDefinitionBoolean extends VariableDefinition
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mDefaultValue:Boolean = false;
      
      public function VariableDefinitionBoolean (name:String, description:String = null, defalutValue:Boolean = false)
      {
         super (name, ValueTypeDefine.ValueType_Boolean, description);
         
         mDefaultValue = defalutValue;
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return Boolean (valueObject);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct (mDefaultValue);
      }
      
      override public function CreateControlForDirectValueSource (valueSourceDirect:ValueSource_Direct):UIComponent
      {
         var box:HBox = new HBox ();
         
         var ratio_group:RadioButtonGroup = new RadioButtonGroup ();
         
         var button_true:RadioButton = new RadioButton ();
         button_true.label = "true";
         button_true.group = ratio_group;
         
         var button_false:RadioButton = new RadioButton ();
         button_false.label = "false";
         button_false.group = ratio_group;
         
         box.addChild (button_true);
         box.addChild (button_false);
         
         var bValue:Boolean = Boolean (valueSourceDirect.GetValueObject ());
         button_true.selected  = bValue;
         button_false.selected = ! bValue;
         
         return box;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent):void
      {
         if (control is HBox)
         {
            var box:HBox = control as HBox;
            
            var button_true:RadioButton = box.getChildAt (0) as RadioButton;
            
            valueSourceDirect.SetValueObject (button_true.selected);
         }
      }
      
      
      
   }
}
