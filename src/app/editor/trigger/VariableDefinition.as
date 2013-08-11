package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   import mx.controls.Label;
   import mx.containers.HBox;
   
   import editor.world.World;
   import editor.entity.Scene;
   import editor.entity.Entity;
   import editor.ccat.CollisionCategory;
   
   import editor.image.AssetImageModule;
   
   import editor.sound.AssetSound;
   
   import editor.EditorContext;
   
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   import common.trigger.ValueSourceTypeDefine;
   
   public class VariableDefinition
   {
      //public static function GetValueTypeName (valueType:int):String
      //{
      //   switch (valueType)
      //   {
      //      case 
      //      default:
      //         return "Unknow Type";
      //   }
      //}
      
      public static function ValidateValueByType (value:Object, valueType:int):Object
      {
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               return Boolean (value);
            case CoreClassIds.ValueType_String:
               return String (value);
            case CoreClassIds.ValueType_Number:
               return Number (value);
            case CoreClassIds.ValueType_Entity:
               return ValidateValueObject_Entity (value);
            case CoreClassIds.ValueType_CollisionCategory:
               return ValidateValueObject_CollisiontCategory (value);
            case CoreClassIds.ValueType_Module:
               return ValidateValueObject_Module (value);
            case CoreClassIds.ValueType_Sound:
               return ValidateValueObject_Sound (value);
            case CoreClassIds.ValueType_Scene:
               return ValidateValueObject_Scene (value);
            case CoreClassIds.ValueType_Array:
               return ValidateValueObject_Array (value);
            default:
               return value;
         }
      }
      
      //public static function GetValueTypeName (valueType:int):String
      //{
      //   switch (valueType)
      //   {
      //      case CoreClassIds.ValueType_Boolean:
      //         return "Bool";
      //      case CoreClassIds.ValueType_String:
      //         return "Text";
      //      case CoreClassIds.ValueType_Number:
      //         return "Number";
      //      case CoreClassIds.ValueType_Entity:
      //         return "Entity";
      //      case CoreClassIds.ValueType_CollisionCategory:
      //         return "CCat";
      //      case CoreClassIds.ValueType_Module:
      //         return "Module";
      //      case CoreClassIds.ValueType_Sound:
      //         return "Sound";
      //      case CoreClassIds.ValueType_Scene:
      //         return "Scene";
      //      case CoreClassIds.ValueType_Array:
      //         return "Array";
      //      default:
      //         return "void";
      //   }
      //}
      
      //public static function GetValueTypeInstanceName (valueType:int):String
      //{
      //   switch (valueType)
      //   {
      //      case CoreClassIds.ValueType_Boolean:
      //         return "aBool";
      //      case CoreClassIds.ValueType_String:
      //         return "aText";
      //      case CoreClassIds.ValueType_Number:
      //         return "aNumber";
      //      case CoreClassIds.ValueType_Entity:
      //         return "anEntity";
      //      case CoreClassIds.ValueType_CollisionCategory:
      //         return "aCCat";
      //      case CoreClassIds.ValueType_Module:
      //         return "aModule";
      //      case CoreClassIds.ValueType_Sound:
      //         return "aSound";
      //      case CoreClassIds.ValueType_Scene:
      //         return "aScene";
      //      case CoreClassIds.ValueType_Array:
      //         return "anArray";
      //      default:
      //         return "void";
      //   }
      //}
      
      //public static function GetDefaultInitialValueByType (valueType:int):Object
      //{
      //   switch (valueType)
      //   {
      //      case CoreClassIds.ValueType_Boolean:
      //         return false;
      //      case CoreClassIds.ValueType_String:
      //         return "";
      //      case CoreClassIds.ValueType_Number:
      //         return 0;
      //      case CoreClassIds.ValueType_Entity:
      //         return null;
      //      case CoreClassIds.ValueType_CollisionCategory:
      //         return null;
      //      case CoreClassIds.ValueType_Module:
      //         return null;
      //      case CoreClassIds.ValueType_Sound:
      //         return null;
      //      case CoreClassIds.ValueType_Scene:
      //         return null;
      //      case CoreClassIds.ValueType_Array:
      //         return null;
      //      default:
      //         return undefined;
      //   }
      //}
      
      public static function CreateCoreVariableDefinition (valueType:int, variableName:String):VariableDefinition
      {
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               return new VariableDefinitionBoolean (variableName);
            case CoreClassIds.ValueType_String:
               return new VariableDefinitionString (variableName);
            case CoreClassIds.ValueType_Number:
               return new VariableDefinitionNumber (variableName);
            case CoreClassIds.ValueType_Entity:
               return new VariableDefinitionEntity (variableName);
            case CoreClassIds.ValueType_CollisionCategory:
               return new VariableDefinitionCollisionCategory (variableName);
            case CoreClassIds.ValueType_Module:
               return new VariableDefinitionModule (variableName);
            case CoreClassIds.ValueType_Sound:
               return new VariableDefinitionSound (variableName);
            case CoreClassIds.ValueType_Scene:
               return new VariableDefinitionScene (variableName);
            case CoreClassIds.ValueType_Array:
               return new VariableDefinitionArray (variableName);
            default:
               throw new Error ("unknown type in CreateCoreVariableDefinition");
         }
      }
      
      public static function ValidateValueObject_Scene (valueObject:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var scene:Scene = valueObject as Scene;
         //if (scene != null && scene.GetWorld () != world)
         if (scene != null && scene.GetSceneIndex () < 0)
            scene = null;
         
         return scene;
      }
      
      public static function ValidateValueObject_Entity (valueObject:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var entity:Entity = valueObject as Entity;
         //if (entity != null && (entity.GetWorld () != world || entity.GetCreationOrderId () < 0))
         if (entity != null && entity.GetCreationOrderId () < 0)
            entity = null;
         
         return entity;
      }
      
      public static function ValidateValueObject_CollisiontCategory (valueObject:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var category:CollisionCategory = valueObject as CollisionCategory;
         if (category != null && category.GetAppearanceLayerId () < 0)
            category = null;
         
         return category;
      }
      
      public static function ValidateValueObject_Module (valueObject:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var module:AssetImageModule = valueObject as AssetImageModule;
         if (module != null && module.GetAppearanceLayerId () < 0)
            module = null;
         
         return module;
      }
      
      public static function ValidateValueObject_Sound (valueObject:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var sound:AssetSound = valueObject as AssetSound;
         if (sound != null && sound.GetAppearanceLayerId () < 0)
            sound = null;
         
         return sound;
      }
      
      public static function ValidateValueObject_Array (valueObject:Object):Object
      {
         return null; // currently
      }
      
   //========================================================================================================
   //
   //========================================================================================================
      
      // the 2 all are moved into sub classes.
      //public var mTypeType:int;
      //public var mValueType:int;
      
      protected var mClass:ClassBase;
      
      public var mName:String;
      public var mDescription:String = null;
      
      //public var mIsReference:Boolean = false;
      
      // options
      
      // cancelled to unref TriggerEngine
      //private var mDefaultSourceType:int = ValueSourceTypeDefine.ValueSource_Direct;
      
      //public function VariableDefinition (/*typeType:int, valueType:int, */name:String, description:String = null/*, options:Object = null*/)
      public function VariableDefinition (aClass:ClassBase, name:String, description:String = null/*, options:Object = null*/)
      {
         //mTypeType = typeType;
         //mValueType = valueType;
         
         mClass = aClass;
         
         mName = name;
         mDescription = description;
         
         //if (options != null)
         //{
         //   //if (options.mDefaultSourceType != undefined)
         //   //   mDefaultSourceType = int (options.mDefaultSourceType);
         //}
      }
      
      public function GetClass ():ClassBase
      {
         return mClass;
      }
      
      public function GetTypeType ():int
      {
         return mClass.GetClassType ();
      }
      
      public function GetValueType ():int
      {
         return mClass.GetID ();
      }
      
      public function GetTypeName ():String
      {
         return mClass.GetName ();
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function SetName (name:String):void
      {
         mName= name;
      }
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function SetDefaultValue (valueObject:Object):void
      {
         // to override
      }
      
      public function IsCompatibleWith (variableDefinition:VariableDefinition):Boolean
      {
         return GetTypeType () == variableDefinition.GetTypeType () && GetValueType () == variableDefinition.GetValueType ();
      }
      
      
//==============================================================================
// clone
//==============================================================================
      
      public function Clone ():VariableDefinition
      {
         throw new Error ("need override");
         
         return null; // to override
      }
      
//==============================================================================
// common used for value target and value source
//==============================================================================
      
      public static function VariableIndex2SelectListSelectedIndex (variableIndex:int, selectListDataProvider:Array):int
      {
         var vi:VariableInstance;
         var index:int;
         for (var i:int = 0; i < selectListDataProvider.length; ++ i)
         {
            vi = selectListDataProvider[i].mVariableInstance as VariableInstance;
            index = vi == null ? -1 : vi.GetIndex ();
            if (variableIndex == index)
               return i;
         }
         
         return -1;
      }
      
//==============================================================================
// for value target 
//==============================================================================
      
      public function GetDefaultValueTarget ():ValueTarget
      {
         return GetDefaultNullValueTarget ();
      }
      
      public function CreateControlForValueTarget (valueTarget:ValueTarget):UIComponent
      {
         return null;
      }
      
      public function RetrieveValueTargetFromControl (valueTarget:ValueTarget, control:UIComponent):void
      {
      }
      
   //==============================================================================
   // null target
   //==============================================================================
      
      public function GetDefaultNullValueTarget ():ValueTarget_Null
      {
         return new ValueTarget_Null ();
      }
      
      public function CreateControlForNullValueTarget (valueTargetNull:ValueTarget_Null):UIComponent
      {
         var label:Label = new Label ();
         label.text = "(void)";
         
         return label;
      }
      
      public function RetrieveNullValueTargetFromControl (valueTargetNull:ValueTarget_Null, control:UIComponent):void
      {
      }
      
   //==============================================================================
   // variable target
   //==============================================================================
      
      public function GetDefaultVariableValueTarget (variableSpace:VariableSpace):ValueTarget_Variable
      {
         return new ValueTarget_Variable (variableSpace.GetNullVariableInstance ());
      }
      
      public function CreateControlForVariableValueTarget (valueTargetVariable:ValueTarget_Variable, validVariableIndexes:Array = null):UIComponent
      {
         var currentVariable:VariableInstance = valueTargetVariable.GetVariableInstance ();
         var variable_space:VariableSpace = currentVariable.GetVariableSpace ();
         
         //var variable_list:Array = variable_space.GetVariableSelectListDataProviderByValueType (GetTypeType (), GetValueType (), validVariableIndexes);
         var variable_list:Array = variable_space.GetVariableSelectListDataProviderByVariableDefinition (this, validVariableIndexes);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = variable_list;
         combo_box.rowCount = 11;
         
         combo_box.selectedIndex = VariableIndex2SelectListSelectedIndex (currentVariable.IsNull () ? -1 : currentVariable.GetIndex (), variable_list);;
         
         return combo_box;
      }
      
      public function RetrieveVariableValueTargetFromControl (valueTargetVariable:ValueTarget_Variable, control:UIComponent):void
      {
         if (control is ComboBox)
         {
            var combo_box:ComboBox = control as ComboBox;
            
            var currentVariable:VariableInstance = valueTargetVariable.GetVariableInstance ();
            var variable_space:VariableSpace = currentVariable.GetVariableSpace ();
            
            var vi:VariableInstance = combo_box.selectedItem == null ? null : combo_box.selectedItem.mVariableInstance;
            if (vi == null || vi.GetIndex () < 0 || vi.GetVariableSpace () != variable_space)
               valueTargetVariable.SetVariableInstance (variable_space.GetNullVariableInstance ());
            else
               valueTargetVariable.SetVariableInstance (vi);
         }
      }
      
   //==============================================================================
   // todo: property target
   //==============================================================================
      
      //public function GetDefaultPropertyValueTarget (entityVariableSpace:VariableSpaceEntityProperties):ValueTarget_Property
      // from v.202, scene common entity property space is added
      public function GetDefaultPropertyValueTarget (entityVariableSpace:VariableSpace):ValueTarget_Property
      {
         BuildPropertyVaribleDefinition ();
         //return new ValueTarget_Property (mEntityVariableDefinition.GetDefaultDirectValueSource (), mPropertyVariableDefinition.GetDefaultVariableValueTarget (EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetEntityVariableSpace ()));
         return new ValueTarget_Property (mEntityVariableDefinition.GetDefaultDirectValueSource (), mPropertyVariableDefinition.GetDefaultVariableValueTarget (entityVariableSpace));
      }
      
      public function CreateControlForPropertyValueTarget (scene:Scene, valueTargetProperty:ValueTarget_Property):UIComponent
      {
         BuildPropertyVaribleDefinition ();
         
         var entityValueSource:ValueSource = valueTargetProperty.GetEntityValueSource ();
         var propertyValueTarget:ValueTarget_Variable = valueTargetProperty.GetPropertyValueTarget ();
         
         var entityValueSourceControl:UIComponent = null;
         if (entityValueSource is ValueSource_Direct)
         {
            entityValueSourceControl = mEntityVariableDefinition.CreateControlForDirectValueSource (scene, entityValueSource as ValueSource_Direct, false);
         }
         else if (entityValueSource is ValueSource_Variable)
         {
            entityValueSourceControl = mEntityVariableDefinition.CreateControlForVariableValueSource (entityValueSource as ValueSource_Variable, null);
         }
         else
         {
            trace ("unknown value source type in CreateControlForPropertyValueSource");
         }
         
         var propertyValueTargetTontrol:UIComponent = mPropertyVariableDefinition.CreateControlForVariableValueTarget (propertyValueTarget, null);
         
         var box:HBox = new HBox ();
         entityValueSourceControl.percentWidth = 50;
         box.addChild (entityValueSourceControl);
         propertyValueTargetTontrol.percentWidth = 50;
         box.addChild (propertyValueTargetTontrol);
         
         return box;
      }
      
      public function RetrievePropertyValueTargetFromControl (scene:Scene, valueTargetProperty:ValueTarget_Property, control:UIComponent):void
      {
   	   if (control is HBox)
   	   {
            BuildPropertyVaribleDefinition ();
            
            var box:HBox = control as HBox;
   	      var entityValueSource:ValueSource = valueTargetProperty.GetEntityValueSource ();
            var propertyValueTarget:ValueTarget_Variable = valueTargetProperty.GetPropertyValueTarget ();
            
         //trace ("entityValueSource = " + entityValueSource + ", propertyValueTarget = " + propertyValueTarget);
            var entityValueSourceControl:UIComponent = box.getChildAt (0) as UIComponent;
            if (entityValueSource is ValueSource_Direct)
            {
               mEntityVariableDefinition.RetrieveDirectValueSourceFromControl (scene, entityValueSource as ValueSource_Direct, entityValueSourceControl/*, EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ()*/);
            }
            else if (entityValueSource is ValueSource_Variable)
            {
               mEntityVariableDefinition.RetrieveVariableValueSourceFromControl (entityValueSource as ValueSource_Variable, entityValueSourceControl);
            }
            else
            {
               trace ("unknown value source type in RetrievePropertyValueTargetFromControl");
            }
            
            var propertyValueTargetControl:UIComponent = box.getChildAt (1) as UIComponent;
            mPropertyVariableDefinition.RetrieveVariableValueTargetFromControl (propertyValueTarget, propertyValueTargetControl);
   	   }
      }
      
//==============================================================================
// for value source
//==============================================================================
   
   public function GetDefaultValueSource (/*triggerEngine:TriggerEngine*/):ValueSource
   {
      //switch (mDefaultSourceType)
      //{
      //   //case ValueSourceTypeDefine.ValueSource_Variable:
      //   //   return GetDefaultVariableValueSource (triggerEngine.GetRegisterVariableSpace (GetValueType ()));
      //   case ValueSourceTypeDefine.ValueSource_Direct:
      //   default:
      //      return GetDefaultDirectValueSource ();
      //}
      
      return GetDefaultDirectValueSource ();
   }
   
   public function CreateControlForValueSource (valueSource:ValueSource):UIComponent
   {
      return null;
   }
   
   public function RetrieveValueSourceFromControl (valueSource:ValueSource, control:ComboBox):void
   {
   }
   
//==============================================================================
// direct source
//==============================================================================
      
      public function ValidateDirectValueSource (valueSourceDirect:ValueSource_Direct):void
      {
         if (valueSourceDirect == null)
            return;
         
         valueSourceDirect.SetValueObject (ValidateDirectValueObject (valueSourceDirect.GetValueObject ()))
      }
      
   //==============================================================================
   // to override
   //==============================================================================
      
      public function ValidateDirectValueObject (valueObject:Object):Object
      {
         return valueObject;
      }
      
   //==============================================================================
   // to override
   //==============================================================================
      
      public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return null;
      }
      
      public function CreateControlForDirectValueSource (scene:Scene, valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         return null;
      }
      
      // return null for not changed
      public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         return null;
      }
   
//==============================================================================
// variable source
//==============================================================================
         
      public function GetDefaultVariableValueSource (variableSpace:VariableSpace):ValueSource_Variable
      {
         return new ValueSource_Variable (variableSpace.GetNullVariableInstance ());
      }
      
      public function CreateControlForVariableValueSource (valueSourceVariable:ValueSource_Variable, validVariableIndexes:Array = null):UIComponent
      {
         var currentVariable:VariableInstance = valueSourceVariable.GetVariableInstance ();
         var variable_space:VariableSpace = currentVariable.GetVariableSpace ();
         
         //var variable_list:Array = variable_space.GetVariableSelectListDataProviderByValueType (GetTypeType (), GetValueType (), validVariableIndexes);
         var variable_list:Array = variable_space.GetVariableSelectListDataProviderByVariableDefinition (this, validVariableIndexes);
         
         var combo_box:ComboBox = new ComboBox ();
         combo_box.dataProvider = variable_list;
         combo_box.selectedIndex = VariableIndex2SelectListSelectedIndex (currentVariable.IsNull () ? -1 : currentVariable.GetIndex (), variable_list);
         combo_box.rowCount = 11;
         
         return combo_box;
      }
      
      public function RetrieveVariableValueSourceFromControl (valueSourceVariable:ValueSource_Variable, control:UIComponent):void
      {
         if (control is ComboBox)
         {
            var combo_box:ComboBox = control as ComboBox;
            
            var currentVariable:VariableInstance = valueSourceVariable.GetVariableInstance ();
            var variable_space:VariableSpace = currentVariable.GetVariableSpace ();
            
            var vi:VariableInstance = combo_box.selectedItem == null ? null : combo_box.selectedItem.mVariableInstance;
            if (vi == null || vi.GetIndex () < 0 || vi.GetVariableSpace () != variable_space)
               valueSourceVariable.SetVariableInstance (variable_space.GetNullVariableInstance ());
            else
               valueSourceVariable.SetVariableInstance (vi);
         }
      }
      
//==============================================================================
// to do: property source
//==============================================================================
      
      private var mEntityVariableDefinition:VariableDefinitionEntity = null;
      private var mPropertyVariableDefinition:VariableDefinition = null;
      
      public function GetVariableDefinitionForEntityParameter ():VariableDefinitionEntity
      {
         return mEntityVariableDefinition;
      }
      
      private function BuildPropertyVaribleDefinition ():void
      {
         if (mEntityVariableDefinition == null)
         {
            mEntityVariableDefinition = new VariableDefinitionEntity ("Property Owner", null, null);
         }
         
         if (mPropertyVariableDefinition == null)
         {
            mPropertyVariableDefinition = CreateCoreVariableDefinition (GetValueType (), World.GetCoreClassById (GetValueType ()).GetName () + " Property");
         }
      }
      
      //public function GetDefaultPropertyValueSource (entityVariableSpace:VariableSpaceEntityProperties):ValueSource_Property
      // from v.202, scene common entity property space is added
      public function GetDefaultPropertyValueSource (entityVariableSpace:VariableSpace):ValueSource_Property
      {
         BuildPropertyVaribleDefinition ();
         //return new ValueSource_Property (mEntityVariableDefinition.GetDefaultDirectValueSource (), mPropertyVariableDefinition.GetDefaultVariableValueSource (EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetEntityVariableSpace ()));
         return new ValueSource_Property (mEntityVariableDefinition.GetDefaultDirectValueSource (), mPropertyVariableDefinition.GetDefaultVariableValueSource (entityVariableSpace));
      }
      
      public function CreateControlForPropertyValueSource (scene:Scene, valueSourceProperty:ValueSource_Property):UIComponent
      {
         BuildPropertyVaribleDefinition ();
         
         var entityValueSource:ValueSource = valueSourceProperty.GetEntityValueSource ();
         var propertyValueSource:ValueSource_Variable = valueSourceProperty.GetPropertyValueSource ();
         
         var entityValueSourceControl:UIComponent = null;
         if (entityValueSource is ValueSource_Direct)
         {
            entityValueSourceControl = mEntityVariableDefinition.CreateControlForDirectValueSource (scene, entityValueSource as ValueSource_Direct, false);
         }
         else if (entityValueSource is ValueSource_Variable)
         {
            entityValueSourceControl = mEntityVariableDefinition.CreateControlForVariableValueSource (entityValueSource as ValueSource_Variable, null);
         }
         else
         {
            trace ("unknown value source type in CreateControlForPropertyValueSource");
         }
         
         var propertyValueSourceControl:UIComponent = mPropertyVariableDefinition.CreateControlForVariableValueSource (propertyValueSource, null);
         
         var box:HBox = new HBox ();
         entityValueSourceControl.percentWidth = 50;
         box.addChild (entityValueSourceControl);
         propertyValueSourceControl.percentWidth = 50;
         box.addChild (propertyValueSourceControl);
         
         return box;
      }
      
      public function RetrievePropertyValueSourceFromControl (scene:Scene, valueSourceProperty:ValueSource_Property, control:UIComponent):void
      {
   	   if (control is HBox)
   	   {
            BuildPropertyVaribleDefinition ();
            
            var box:HBox = control as HBox;
   	      var entityValueSource:ValueSource = valueSourceProperty.GetEntityValueSource ();
   	      var propertyValueSource:ValueSource_Variable = valueSourceProperty.GetPropertyValueSource ();
            
         //trace ("entityValueSource = " + entityValueSource + ", propertyValueSource = " + propertyValueSource);
            var entityValueSourceControl:UIComponent = box.getChildAt (0) as UIComponent;
            if (entityValueSource is ValueSource_Direct)
            {
               mEntityVariableDefinition.RetrieveDirectValueSourceFromControl (scene, entityValueSource as ValueSource_Direct, entityValueSourceControl/*, EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ()*/);
            }
            else if (entityValueSource is ValueSource_Variable)
            {
               mEntityVariableDefinition.RetrieveVariableValueSourceFromControl (entityValueSource as ValueSource_Variable, entityValueSourceControl);
            }
            else
            {
               trace ("unknown value source type in RetrievePropertyValueSourceFromControl");
            }
            
            var propertyValueSourceControl:UIComponent = box.getChildAt (1) as UIComponent;
            mPropertyVariableDefinition.RetrieveVariableValueSourceFromControl (propertyValueSource, propertyValueSourceControl);
   	   }
      }
      
   }
}
