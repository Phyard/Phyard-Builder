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
      
      public function VariableDefinitionNumber (name:String, description:String = null, defaultValue:Number = 0, minValue:Number = Number.NEGATIVE_INFINITY,  maxValue:Number = Number.POSITIVE_INFINITY)
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
      
      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return Number (valueObject);
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
         var text_input:TextInput = new TextInput ()
         
         text_input.text = (parseFloat ((Number (valueSourceDirect.GetValueObject ())).toFixed (12))).toString ();
         
         return text_input;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent):void
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

