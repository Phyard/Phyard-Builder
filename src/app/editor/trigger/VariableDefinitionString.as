package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.TextInput;
   
   import common.trigger.ValueTypeDefine;
   
   public class VariableDefinitionString extends VariableDefinition
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mMaxLength:int = 0;
      
      public function VariableDefinitionString (name:String, description:String = null, typeClassPrototype:Object = null, options:Object = null)
      {
         super (ValueTypeDefine.ValueType_String, name, description, typeClassPrototype);
         
         if (options != null)
         {
            if (options.mMaxLength != undefined)
               mMaxLength = int (options.mMaxLength);
         }
      }
      
      protected function ValidateValue (text:String):String
      {
         if (text == null)
            return null;
         
         if (mMaxLength > 0 && text.length > mMaxLength)
            return text.substr (0, mMaxLength);
         
         return text;
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultTypeClassPrototype ():Object
      {
         return String.prototype;
      }
      
      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return String (valueObject);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct ("");
      }
      
      override public function CreateControlForDirectValueSource (valueSourceDirect:ValueSource_Direct):UIComponent
      {
         var text_input:TextInput = new TextInput ()
         
         text_input.text = String (valueSourceDirect.GetValueObject ());
         
         return text_input;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent):void
      {
         if (control is TextInput)
         {
            var text_input:TextInput = control as TextInput;
            
            var text:String = String (text_input.text);
            text = ValidateValue (text);
            
            valueSourceDirect.SetValueObject (text);
         }
      }
   }
}

