package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.TextInput;
   
   import common.trigger.ValueTypeDefine;
   
   public class VariableDefinitionNumber extends VariableDefinition
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mDefaultValue:Number = 0.0;
      protected var mMinValue:Number = - Number.MAX_VALUE;
      protected var mMaxValue:Number = Number.MAX_VALUE;
      
      protected var mIsColorValue:Boolean = false;
      
      public function VariableDefinitionNumber (name:String, description:String = null, typeClassPrototype:Object = null, options:Object = null)
      {
         super (ValueTypeDefine.ValueType_Number, name, description, typeClassPrototype);
         
         if (options != null)
         {
            if (options.mMinValue != undefined)
               mMinValue = Number (options.mMinValue);
            if (options.mMaxValue != undefined)
               mMaxValue = Number (options.mMaxValue);
            if (options.mDefaultValue != undefined)
               mDefaultValue = Number (options.mDefaultValue);
            if (options.mIsColorValue != undefined)
               mIsColorValue = Boolean (options.mIsColorValue);
            
            if (mMinValue > mMaxValue)
            {
               var tempValue:Number = mMaxValue;
               mMaxValue = mMinValue;
               mMinValue = tempValue;
            }
         }
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
      
      override public function GetDefaultTypeClassPrototype ():Object
      {
         return Number.prototype;
      }
      
      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         var num:Number = Number (valueObject);;
         if (isNaN (num))
            num = 0.0;
         
         if (num < mMinValue)
            num = mMinValue;
         if (num > mMaxValue)
            num = mMaxValue;
         
         return num;
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
         
         if (mIsColorValue)
         {
            var text:String = (int (valueSourceDirect.GetValueObject ()) & 0xFFFFFF).toString (16);
            while (text.length < 6)
               text = "0" + text;
            
            text_input.text = "0x" + text.toUpperCase ();
         }
         else
            text_input.text = (parseFloat ((Number (valueSourceDirect.GetValueObject ())).toFixed (12))).toString ();
         
         return text_input;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent):void
      {
         if (control is TextInput)
         {
            var text_input:TextInput = control as TextInput;
            var text:String = text_input.text;
            var value:Number;
            
            if (text.length > 2 && text.substr (0, 2).toLowerCase() == "0x")
               value = parseInt (text.substr (2), 16);
            else
               value = parseFloat (text);
            
            value = ValidateValue (value);
            
            valueSourceDirect.SetValueObject (value);
         }
      }
   }
}

