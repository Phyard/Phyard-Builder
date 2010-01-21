package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.TextInput;
   import mx.controls.ComboBox;
   
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
      
      protected var mValueLists:Array = null;
      
      public function VariableDefinitionNumber (name:String, description:String = null, options:Object = null)
      {
         super (ValueTypeDefine.ValueType_Number, name, description);
         
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
            if (options.mValueLists != undefined)
               mValueLists = options.mValueLists as Array;
            
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
         var directValue:Number = Number (valueSourceDirect.GetValueObject ());
         
         if (mValueLists != null)
         {
            var combo_box:ComboBox = new ComboBox ();
            
            combo_box.dataProvider = Lists.GetListWithDataInLabel (mValueLists);
            combo_box.selectedIndex = Lists.SelectedValue2SelectedIndex (mValueLists, directValue);
            
            return combo_box;
         }
         else 
         {
            var text_input:TextInput = new TextInput ();
            
            if (mIsColorValue)
            {
               var text:String = (int (directValue) & 0xFFFFFF).toString (16);
               while (text.length < 6)
                  text = "0" + text;
               
               text_input.text = "0x" + text.toUpperCase ();
            }
            else
            {
               text_input.text = (parseFloat (directValue.toFixed (12))).toString ();
            }
            
            return text_input;
         }
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent):void
      {
         var value:Number = mDefaultValue;
         
         if (mValueLists != null)
         {
            if (control is ComboBox)
            {
               var combo_box:ComboBox = control as ComboBox;
               
               if (combo_box.selectedItem != null)
                  value = combo_box.selectedItem.data;
            }
         }
         else 
         {
            if (control is TextInput)
            {
               var text_input:TextInput = control as TextInput;
               var text:String = text_input.text;
               
               if (text.length > 2 && text.substr (0, 2).toLowerCase() == "0x")
                  value = parseInt (text.substr (2), 16);
               else
                  value = parseFloat (text);
            }
         }
         
         value = ValidateValue (value);
         
         valueSourceDirect.SetValueObject (value);
      }
   }
}

