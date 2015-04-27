package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.TextInput;
   
   import editor.world.World;
   
   import editor.entity.Scene;
   
   import common.trigger.CoreClassIds;
   
   public class VariableDefinitionString extends VariableDefinition_Core
   {
   
   //========================================================================================================
   //
   //========================================================================================================
      
      //protected var mDefaultValue:String = "";
      //protected var mMaxLength:int = 0;
      
      public function VariableDefinitionString (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_String), name, description, options);
         
         //if (options != null)
         //{
         //   //if (options.mMaxLength != undefined)
         //   //   mMaxLength = int (options.mMaxLength);
         //   if (options.mDefaultValue != undefined)
         //      mDefaultValue = options.mDefaultValue as String;
         //}
      }
      
      //override public function SetDefaultValue (valueObject:Object):void
      //{
      //   mDefaultValue = String (valueObject);
      //}
      
      //public function GetDefaultValue ():String
      //{
      //   return mDefaultValue;
      //}
      
      //protected function ValidateValue (text:String):String
      //{
      //   if (text == null)
      //      return null;
      //   
      //   if (mMaxLength > 0 && text.length > mMaxLength)
      //      return text.substr (0, mMaxLength);
      //   
      //   return text;
      //}
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         return new VariableDefinitionString (mName, mDescription, mOptions);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct (mDefaultValueObject);
      }
      
      override public function CreateControlForDirectValueSource (scene:Scene, valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         var text_input:TextInput = new TextInput ()
         
         text_input.text = String (valueSourceDirect.GetValueObject ());
         
         return text_input;
      }
      
      override public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         var text:String = mDefaultValueObject as String;
         
         if (control is TextInput)
         {
            var text_input:TextInput = control as TextInput;
            
            text = String (text_input.text);
         }

         //text = ValidateValue (text);
         text = ValidateDirectValueObject (text) as String;
         
         valueSourceDirect.SetValueObject (text);
         
         return null;
      }
   }
}

