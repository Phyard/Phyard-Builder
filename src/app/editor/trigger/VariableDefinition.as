package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   import mx.controls.Label;
   import mx.containers.HBox;
   
   import editor.world.World;
   import editor.entity.WorldEntity;
   import editor.entity.EntityCollisionCategory;
   
   import editor.runtime.Runtime;
   
   import common.trigger.ValueTypeDefine;
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
            case ValueTypeDefine.ValueType_Boolean:
               return Boolean (value);
            case ValueTypeDefine.ValueType_String:
               return String (value);
            case ValueTypeDefine.ValueType_Number:
               return Number (value);
            case ValueTypeDefine.ValueType_Entity:
               return ValidateValueObject_Entity (value);
            case ValueTypeDefine.ValueType_CollisionCategory:
               return ValidateValueObject_CollisiontCategory (value);
            case ValueTypeDefine.ValueType_Array:
               return ValidateValueObject_Array (value);
            default:
               return value;
         }
      }
      
      public static function GetValueTypeName (valueType:int):String
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return "Bool";
            case ValueTypeDefine.ValueType_String:
               return "Text";
            case ValueTypeDefine.ValueType_Number:
               return "Number";
            case ValueTypeDefine.ValueType_Entity:
               return "Entity";
            case ValueTypeDefine.ValueType_CollisionCategory:
               return "CCat";
            case ValueTypeDefine.ValueType_Array:
               return "Array";
            default:
               return "void";
         }
      }
      
      public static function GetDefaultInitialValueByType (valueType:int):Object
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return false;
            case ValueTypeDefine.ValueType_String:
               return "";
            case ValueTypeDefine.ValueType_Number:
               return 0;
            case ValueTypeDefine.ValueType_Entity:
               return null;
            case ValueTypeDefine.ValueType_CollisionCategory:
               return null;
            case ValueTypeDefine.ValueType_Array:
               return null;
            default:
               return undefined;
         }
      }
      
      public static function CreateVariableDefinition (valueType:int, variableName:String):VariableDefinition
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return new VariableDefinitionBoolean (variableName);
            case ValueTypeDefine.ValueType_String:
               return new VariableDefinitionString (variableName);
            case ValueTypeDefine.ValueType_Number:
               return new VariableDefinitionNumber (variableName);
            case ValueTypeDefine.ValueType_Entity:
               return new VariableDefinitionEntity (variableName);
            case ValueTypeDefine.ValueType_CollisionCategory:
               return new VariableDefinitionCollisionCategory (variableName);
            case ValueTypeDefine.ValueType_Array:
               return new VariableDefinitionArray (variableName);
            default:
               throw new Error ("unknown type in CreateVariableDefinition");
         }
      }
      
      public static function ValidateValueObject_Entity (valueObject:Object):Object
      {
         var world:World = Runtime.GetCurrentWorld ();
         
         var entity:WorldEntity = valueObject as WorldEntity;
         if (entity != null && (entity.GetWorld () != world || entity.GetCreationOrderId () < 0))
            entity = null;
         
         return entity;
      }
      
      public static function ValidateValueObject_CollisiontCategory (valueObject:Object):Object
      {
         var world:World = Runtime.GetCurrentWorld ();
         
         var category:EntityCollisionCategory = valueObject as EntityCollisionCategory;
         if (category != null && category.GetAppearanceLayerId () < 0)
            category = null;
         
         return category;
      }
      
      public static function ValidateValueObject_Array (valueObject:Object):Object
      {
         return null; // currently
      }
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public var mName:String;
      public var mValueType:int;
      
      //public var mIsReference:Boolean = false;
      
      public var mDescription:String = null;
      
      // options
      
      private var mDefaultSourceType:int = ValueSourceTypeDefine.ValueSource_Direct;
      
      public function VariableDefinition (valueType:int, name:String, description:String = null, options:Object = null)
      {
         mValueType = valueType;
         mName = name;
         mDescription = description;
         
         if (options != null)
         {
            if (options.mDefaultSourceType != undefined)
               mDefaultSourceType = int (options.mDefaultSourceType);
         }
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function SetName (name:String):void
      {
         mName= name;
      }
      
      public function GetValueType ():int
      {
         return mValueType;
      }
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function IsCompatibleWith (variableDefinition:VariableDefinition):Boolean
      {
         return mValueType == variableDefinition.GetValueType ();
      }
      
      public function SetDefaultValue (valueObject:Object):void
      {
         // to override
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
         
         var variable_list:Array = variable_space.GetVariableSelectListDataProviderByValueType (mValueType, validVariableIndexes);
         
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
      
      public function GetDefaultPropertyValueTarget ():ValueTarget_Property
      {
         BuildPropertyVaribleDefinition ();
         return new ValueTarget_Property (mEntityVariableDefinition.GetDefaultDirectValueSource (), mPropertyVariableDefinition.GetDefaultVariableValueTarget (Runtime.GetCurrentWorld ().GetTriggerEngine ().GetEntityVariableSpace ()));
      }
      
      public function CreateControlForPropertyValueTarget (valueTargetProperty:ValueTarget_Property):UIComponent
      {
         BuildPropertyVaribleDefinition ();
         
         var entityValueSource:ValueSource = valueTargetProperty.GetEntityValueSource ();
         var propertyValueTarget:ValueTarget_Variable = valueTargetProperty.GetPropertyValueTarget ();
         
         var entityValueSourceControl:UIComponent = null;
         if (entityValueSource is ValueSource_Direct)
         {
            entityValueSourceControl = mEntityVariableDefinition.CreateControlForDirectValueSource (entityValueSource as ValueSource_Direct, false);
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
      
      public function RetrievePropertyValueTargetFromControl (valueTargetProperty:ValueTarget_Property, control:UIComponent):void
      {
   	   if (control is HBox)
   	   {
            BuildPropertyVaribleDefinition ();
            
            var box:HBox = control as HBox;
   	      var entityValueSource:ValueSource = valueTargetProperty.GetEntityValueSource ();
            var propertyValueTarget:ValueTarget_Variable = valueTargetProperty.GetPropertyValueTarget ();
            
         trace ("entityValueSource = " + entityValueSource + ", propertyValueTarget = " + propertyValueTarget);
            var entityValueSourceControl:UIComponent = box.getChildAt (0) as UIComponent;
            if (entityValueSource is ValueSource_Direct)
            {
               mEntityVariableDefinition.RetrieveDirectValueSourceFromControl (entityValueSource as ValueSource_Direct, entityValueSourceControl, Runtime.GetCurrentWorld ().GetTriggerEngine ());
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
   
   public function GetDefaultValueSource (triggerEngine:TriggerEngine):ValueSource
   {
      switch (mDefaultSourceType)
      {
         case ValueSourceTypeDefine.ValueSource_Variable:
            return GetDefaultVariableValueSource (triggerEngine.GetRegisterVariableSpace (mValueType));
         case ValueSourceTypeDefine.ValueSource_Direct:
         default:
            return GetDefaultDirectValueSource ();
      }
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
      
      public function CreateControlForDirectValueSource (valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         return null;
      }
      
      // return null for not changed
      public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent, triggerEngine:TriggerEngine):ValueSource
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
         
         var variable_list:Array = variable_space.GetVariableSelectListDataProviderByValueType (mValueType, validVariableIndexes);
         
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
            switch (mValueType)
            {
               case ValueTypeDefine.ValueType_Boolean:
                  mPropertyVariableDefinition = new VariableDefinitionBoolean ("Boolean Property");
                  break;
               case ValueTypeDefine.ValueType_String:
                  mPropertyVariableDefinition = new VariableDefinitionString ("String Property");
                  break;
               case ValueTypeDefine.ValueType_Number:
                  mPropertyVariableDefinition = new VariableDefinitionNumber ("Number Property");
                  break;
               case ValueTypeDefine.ValueType_Entity:
                  mPropertyVariableDefinition = new VariableDefinitionEntity ("Entity Property");
                  break;
               case ValueTypeDefine.ValueType_CollisionCategory:
                  mPropertyVariableDefinition = new VariableDefinitionCollisionCategory ("CCat Property");
                  break;
               case ValueTypeDefine.ValueType_Array:
                  mPropertyVariableDefinition = new VariableDefinitionArray ("Array Property");
                  break;
               default:
               {
                  trace ("unknown mValueType in BuildPropertyVaribleDefinition");
               }
            }
         }
      }
      
      public function GetDefaultPropertyValueSource ():ValueSource_Property
      {
         BuildPropertyVaribleDefinition ();
         return new ValueSource_Property (mEntityVariableDefinition.GetDefaultDirectValueSource (), mPropertyVariableDefinition.GetDefaultVariableValueSource (Runtime.GetCurrentWorld ().GetTriggerEngine ().GetEntityVariableSpace ()));
      }
      
      public function CreateControlForPropertyValueSource (valueSourceProperty:ValueSource_Property):UIComponent
      {
         BuildPropertyVaribleDefinition ();
         
         var entityValueSource:ValueSource = valueSourceProperty.GetEntityValueSource ();
         var propertyValueSource:ValueSource_Variable = valueSourceProperty.GetPropertyValueSource ();
         
         var entityValueSourceControl:UIComponent = null;
         if (entityValueSource is ValueSource_Direct)
         {
            entityValueSourceControl = mEntityVariableDefinition.CreateControlForDirectValueSource (entityValueSource as ValueSource_Direct, false);
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
      
      public function RetrievePropertyValueSourceFromControl (valueSourceProperty:ValueSource_Property, control:UIComponent):void
      {
   	   if (control is HBox)
   	   {
            BuildPropertyVaribleDefinition ();
            
            var box:HBox = control as HBox;
   	      var entityValueSource:ValueSource = valueSourceProperty.GetEntityValueSource ();
   	      var propertyValueSource:ValueSource_Variable = valueSourceProperty.GetPropertyValueSource ();
            
         trace ("entityValueSource = " + entityValueSource + ", propertyValueSource = " + propertyValueSource);
            var entityValueSourceControl:UIComponent = box.getChildAt (0) as UIComponent;
            if (entityValueSource is ValueSource_Direct)
            {
               mEntityVariableDefinition.RetrieveDirectValueSourceFromControl (entityValueSource as ValueSource_Direct, entityValueSourceControl, Runtime.GetCurrentWorld ().GetTriggerEngine ());
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
