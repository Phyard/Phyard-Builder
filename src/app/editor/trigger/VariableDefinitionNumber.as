package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.TextInput;
   
   import common.trigger.ValueTypeDefine;
   
   public class VariableDefinitionNumber extends VariableDefinition
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mDefaultValue:Number;
      protected var mMinValue:Number;
      protected var mMaxValue:Number;
      
      public function VariableDefinitionNumber (name:String, description:String = null, defaultValue:Number = 0, minValue:Number = Number.MIN_VALUE,  maxValue:Number = Number.MAX_VALUE)
      {
         super (name, ValueTypeDefine.ValueType_Number, description);
         
         mMinValue = minValue < maxValue ? minValue : maxValue;
         mMaxValue = maxValue > minValue ? maxValue : minValue;
         
         mDefaultValue = ValidateValue (defaultValue);
      }
      
      protected function ValidateValue (value:Number):Number
      {
         if (isNaN (value))
            value = mDefaultValue;
         
         if (value < mMinValue)
            value = mMinValue;
         if (value > mMaxValue)
            value = mMaxValue;
         
         return value;
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSourceDirect
      {
         return new ValueSourceDirect (mDefaultValue);
      }
      
      override public function ValidateDirectValueSource (valueSourceDirect:ValueSourceDirect):void
      {
         //if (valueSourceDirect == null)
         //   return;
         
         var value:Number = Number (valueSourceDirect.GetValueObject ());
         
         value = ValidateValue (value);
         
         valueSourceDirect.SetValueObject (value)
      }
      
      override public function CreateControlForDirectValueSource (valueSourceDirect:ValueSourceDirect):UIComponent
      {
         var text_input:TextInput = new TextInput ()
         
         text_input.text = (parseFloat ((Number (valueSourceDirect.GetValueObject ())).toFixed (12))).toString ();
         
         return text_input;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSourceDirect, control:UIComponent):void
      {
         if (control is TextInput)
         {
            var text_input:TextInput = control as TextInput;
            
            var value:Number = parseFloat (text_input.text);
            value = ValidateValue (value);
            
            valueSourceDirect.SetValueObject (value);
         }
      }
   }
}

