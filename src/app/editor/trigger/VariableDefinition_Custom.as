package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.Label;
   
   import editor.entity.Scene;
   
   import common.trigger.ClassTypeDefine;
   
   import common.Define;
   
   public class VariableDefinition_Custom extends VariableDefinition
   {
      public function VariableDefinition_Custom (customClass:ClassCustom, name:String, description:String = null, options:Object = null)
      {
         //super (ClassTypeDefine.ClassType_Custom, classId, name, description, options);
         
         super (customClass, name, description);
      }
      
      public function GeCustomClass ():ClassCustom
      {
         return mClass as ClassCustom;
      }
      
      public function GetCustomProperties ():VariableSpaceClassInstance
      {
         return GeCustomClass ().GetPropertyDefinitionSpace ();
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         var customVariableDefinition:VariableDefinition_Custom = new VariableDefinition_Custom (GeCustomClass (), mName, mDescription);
         
         return customVariableDefinition;
      }

//==============================================================================
// to override
//==============================================================================
      
      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         //return valueObject as Array;
         return null; // current, direct array value is not supported. 
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct (null);
      }
      
      override public function CreateControlForDirectValueSource (scene:Scene, valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         var label:Label = new Label ();
         label.text = "null"; // currently, direct array value is not supported
         
         return label;
      }
      
      override public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         if (control is Label)
         {
            // ...
         }
         
         // throw new Error ("?");
         
         return null;
      }
   }
}

