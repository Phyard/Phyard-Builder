package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.Label;
   
   import editor.world.World;
   import editor.entity.WorldEntity;
   import editor.entity.Entity;
   
   import editor.runtime.Runtime;
   
   import common.trigger.ValueTypeDefine;
   
   import common.Define;
   
   public class VariableDefinitionArray extends VariableDefinition
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mNullValueEnabled:Boolean = true;
      
      public function VariableDefinitionArray (name:String, description:String = null, options:Object = null)
      {
         super (ValueTypeDefine.ValueType_Array, name, description, options);
         
         if (options != null)
         {
            if (options.mNullValueEnabled != undefined)
               mNullValueEnabled = Boolean (options.mNullValueEnabled);
         }
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
      
      override public function CreateControlForDirectValueSource (valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         var label:Label = new Label ();
         label.text = "null"; // currently, direct array value is not supported
         
         return label;
      }
      
      override public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent, triggerEngine:TriggerEngine):ValueSource
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

