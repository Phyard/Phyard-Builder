package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   
   import editor.world.World;
   import editor.world.CoreClasses;
   import editor.entity.Scene;
   import editor.entity.Entity;
   import editor.entity.Scene;
   
   import editor.EditorContext;
   
   import common.trigger.CoreClassIds;
   
   import common.Define;
   
   public class VariableDefinitionClass extends VariableDefinition_Core
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      public function VariableDefinitionClass (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_Class), name, description, null);
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         return new VariableDefinitionClass (mName, mDescription, mOptions);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct (CoreClasses.sVoidClass);
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
         return null;
      }
   }
}

