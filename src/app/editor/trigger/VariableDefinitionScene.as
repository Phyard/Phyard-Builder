package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   
   import editor.world.World;
   import editor.entity.Scene;
   import editor.entity.Entity;
   import editor.entity.Scene;
   
   import editor.EditorContext;
   
   import common.trigger.CoreClassIds;
   
   import common.Define;
   
   public class VariableDefinitionScene extends VariableDefinition_Core
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      protected var mDefaultValue:Scene = null;
      
      public function VariableDefinitionScene (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_Scene), name, description, null);
         
         if (options != null)
         {
            if (options.mDefaultValue != undefined)
               mDefaultValue = options.mDefaultValue as Scene;
         }
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         var sceneVariableDefinition:VariableDefinitionScene = new VariableDefinitionScene (mName, mDescription);
         
         sceneVariableDefinition.mDefaultValue = mDefaultValue;
         
         return sceneVariableDefinition;
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return ValidateValueObject_Scene (valueObject);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct (mDefaultValue);
      }
      
      override public function CreateControlForDirectValueSource (scene:Scene, valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         var scene_list:Array = scene.GetWorld ().GetSceneSelectListDataProvider ();
         
         var scene:Scene = valueSourceDirect.GetValueObject () as Scene;
         var scene_index:int = scene == null ? -1 : scene.GetSceneIndex ();
         
         var sel_index:int = World.SceneIndex2SelectListSelectedIndex (scene_index, scene_list);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = scene_list;
         combo_box.selectedIndex = sel_index;
         
         //trace ("sel_index = " + sel_index);
         
         return combo_box;
      }
      
      override public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         if (control is ComboBox)
         {
            var combo_box:ComboBox = control as ComboBox;
            
            if (combo_box.selectedItem == null)
               valueSourceDirect.SetValueObject (null);
            else
            {
               var scene_index:int = combo_box.selectedItem.mSceneIndex;
               if (scene_index < 0)
               {
                  valueSourceDirect.SetValueObject (null);
               }
               else
               {
                  valueSourceDirect.SetValueObject (scene.GetWorld ().GetSceneByIndex (scene_index));
               }
            }
         }
         
         return null;
      }
   }
}

