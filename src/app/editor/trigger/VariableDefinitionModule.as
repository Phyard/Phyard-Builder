package editor.trigger {

   import mx.core.UIComponent;
   import mx.controls.Label;
   
   import editor.world.World;
   
   import editor.entity.Scene;

   import editor.display.control.ModulePickButton;

   import editor.image.AssetImageModule;
   import editor.image.AssetImageBitmapModule;

   import common.trigger.CoreClassIds;

   import common.Define;

   public class VariableDefinitionModule extends VariableDefinition_Core
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      internal var mIsTextureValue:Boolean = false;

      public function VariableDefinitionModule (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_Module), name, description, options);

         if (options != null)
         {
            if (options.mIsTextureValue != undefined)
               mIsTextureValue = options.mIsTextureValue;
         }
      }

//==============================================================================
// clone
//==============================================================================

      override public function Clone ():VariableDefinition
      {
         return new VariableDefinitionModule (mName, mDescription, mOptions);
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
         if (isForPureCustomFunction)
         {
            var label:Label = new Label ();
            label.text = "Null";

            return label;
         }
         else
         {
            var imageModule:AssetImageModule = valueSourceDirect.GetValueObject () as AssetImageModule;
            
            var button:ModulePickButton = new ModulePickButton (imageModule);

            return button;
         }
      }

      override public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         if (control is ModulePickButton)
         {
            if (mIsTextureValue)
               valueSourceDirect.SetValueObject ((control as ModulePickButton).GetPickedModule () as AssetImageBitmapModule);
            else
               valueSourceDirect.SetValueObject ((control as ModulePickButton).GetPickedModule ());
         }
         else
         {
            valueSourceDirect.SetValueObject (null);
         }

         // throw new Error ("?");

         return null;
      }
   }
}

