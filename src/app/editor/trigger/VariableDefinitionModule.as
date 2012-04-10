package editor.trigger {

   import mx.core.UIComponent;
   import mx.controls.Label;

   import editor.display.control.ModulePickButton;

   import editor.image.AssetImageModule;

   import common.trigger.ValueTypeDefine;

   import common.Define;

   public class VariableDefinitionModule extends VariableDefinition
   {
   //========================================================================================================
   //
   //========================================================================================================

      public function VariableDefinitionModule (name:String, description:String = null, options:Object = null)
      {
         super (ValueTypeDefine.ValueType_Module, name, description, options);

         if (options != null)
         {
         }
      }

//==============================================================================
// clone
//==============================================================================

      override public function Clone ():VariableDefinition
      {
         var moduleVariableDefinition:VariableDefinitionModule = new VariableDefinitionModule (mName, mDescription);

         return moduleVariableDefinition;
      }

//==============================================================================
// to override
//==============================================================================

      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return ValidateValueObject_Module (valueObject);
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
         if (isForPureCustomFunction)
         {
            var label:Label = new Label ();
            label.text = "Null";

            return label;
         }
         else
         {
            var imageModule:AssetImageModule = valueSourceDirect.GetValueObject () as AssetImageModule;
            
            var button:ModulePickButton = new ModulePickButton (imageModule);

            return button;
         }
      }

      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent, triggerEngine:TriggerEngine):ValueSource
      {
         if (control is ModulePickButton)
         {
            valueSourceDirect.SetValueObject ((control as ModulePickButton).GetPickedModule ());
         }
         else
         {
            valueSourceDirect.SetValueObject (null);
         }

         // throw new Error ("?");

         return null;
      }
   }
}

