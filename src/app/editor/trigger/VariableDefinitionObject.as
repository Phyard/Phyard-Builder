package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.Label;
   
   import editor.world.World;
   
   import editor.entity.Scene;
   
   import common.trigger.CoreClassIds;
   import common.trigger.ClassTypeDefine;
   
   import common.Define;
   
   public class VariableDefinitionObject extends VariableDefinition_Core
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableDefinitionObject (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_Object), name, description, options);
      }
      
      public function AllowCoreClasses ():Boolean
      {
         return (mOptions.mAllowCoreClasses == null) || (mOptions.mAllowCoreClasses == true);
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         return new VariableDefinitionObject (mName, mDescription, mOptions);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function IsCompatibleWith (variableDefinition:VariableDefinition):Boolean
      {
         // temp, only custom types can be newed.
         return AllowCoreClasses () || variableDefinition.GetClassType () == ClassTypeDefine.ClassType_Custom;
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

