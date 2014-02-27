package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.Label;
   
   import editor.world.World;
   
   import editor.entity.Scene;
   
   import common.trigger.CoreClassIds;
   
   import common.Define;
   
   public class VariableDefinitionByteArrayStream extends VariableDefinition_Core
   {
   
   //do: mege all VariableDefinitionXXXes into one. Also for VariableSpaceXXXes.
   
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mNullValueEnabled:Boolean = true;
      
      public function VariableDefinitionByteArrayStream (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_ByteArrayStream), name, description, options);
         
         if (options != null)
         {
            if (options.mNullValueEnabled != undefined)
               mNullValueEnabled = Boolean (options.mNullValueEnabled);
         }
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         return new VariableDefinitionByteArrayStream (mName, mDescription);
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

