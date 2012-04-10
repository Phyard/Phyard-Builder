package editor.trigger {

   import mx.core.UIComponent;
   import mx.controls.Label;

   import editor.display.control.SoundPickButton;

   import editor.sound.AssetSound;

   import common.trigger.ValueTypeDefine;

   import common.Define;

   public class VariableDefinitionSound extends VariableDefinition
   {
   //========================================================================================================
   //
   //========================================================================================================

      public function VariableDefinitionSound (name:String, description:String = null, options:Object = null)
      {
         super (ValueTypeDefine.ValueType_Sound, name, description, options);

         if (options != null)
         {
         }
      }

//==============================================================================
// clone
//==============================================================================

      override public function Clone ():VariableDefinition
      {
         var soundVariableDefinition:VariableDefinitionSound = new VariableDefinitionSound (mName, mDescription);

         return soundVariableDefinition;
      }

//==============================================================================
// to override
//==============================================================================

      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return ValidateValueObject_Sound (valueObject);
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
            var sound:AssetSound = valueSourceDirect.GetValueObject () as AssetSound;
            
            var button:SoundPickButton = new SoundPickButton (sound);

            return button;
         }
      }

      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent, triggerEngine:TriggerEngine):ValueSource
      {
         if (control is SoundPickButton)
         {
            valueSourceDirect.SetValueObject ((control as SoundPickButton).GetPickedSound ());
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

