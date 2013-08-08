package editor.trigger {
   
   import mx.core.UIComponent;
   //import mx.controls.ComboBox;
   import mx.containers.HBox;
   import mx.controls.RadioButtonGroup;
   import mx.controls.RadioButton;
   
   import editor.world.World;
   
   import editor.entity.Scene;
   
   import common.trigger.CoreClassIds;
   
   public class VariableDefinitionBoolean extends VariableDefinition_Core
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mDefaultValue:Boolean = false;
      
      public function VariableDefinitionBoolean (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_Boolean), name, description, options);
         
         if (options != null)
         {
            if (options.mDefaultValue != undefined)
               mDefaultValue = Boolean (options.mDefaultValue);
         }
      }
      
      override public function SetDefaultValue (valueObject:Object):void
      {
         mDefaultValue = Boolean (valueObject);
      }
      
      public function GetDefaultValue ():Boolean
      {
         return mDefaultValue;
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         var booleanVariableDefinition:VariableDefinitionBoolean = new VariableDefinitionBoolean (mName, mDescription);
         booleanVariableDefinition.SetDefaultValue (mDefaultValue);
         
         return booleanVariableDefinition;
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
      
      override public function CreateControlForDirectValueSource (scene:Scene, valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
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
      
      override public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         if (control is HBox)
         {
            var box:HBox = control as HBox;
            
            var button_true:RadioButton = box.getChildAt (0) as RadioButton;
            
            valueSourceDirect.SetValueObject (button_true.selected);
         }
         
         return null;
      }
      
      
      
   }
}

