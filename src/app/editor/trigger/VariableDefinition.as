package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   import mx.controls.Label;
   
   import editor.world.World;
   import editor.entity.WorldEntity;
   import editor.entity.EntityCollisionCategory;
   
   import editor.runtime.Runtime;
   
   import common.trigger.ValueTypeDefine;
   
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
               return ValidateValueObject_CollisiontCategory (valueType);
            default:
               return value;
         }
      }
      
      public static function GetValueTypeName (valueType:int):String
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return "bool";
            case ValueTypeDefine.ValueType_String:
               return "text";
            case ValueTypeDefine.ValueType_Number:
               return "number";
            case ValueTypeDefine.ValueType_Entity:
               return "entity";
            case ValueTypeDefine.ValueType_CollisionCategory:
               return "ccat";
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
            default:
               return undefined;
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
      
   //========================================================================================================
   //
   //========================================================================================================
      
      public var mName:String;
      public var mValueType:int;
      
      //public var mIsReference:Boolean = false;
      
      private var mDescription:String = null;
      
      private var mTypeClassPrototype:Object = null;
      
      public function VariableDefinition (valueType:int, name:String, description:String = null, typeClassPrototype:Object = null)
      {
         mValueType = valueType;
         mName = name;
         mDescription = description;
         
         mTypeClassPrototype = typeClassPrototype;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetValueType ():int
      {
         return mValueType;
      }
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function GetTypeClassPrototype ():Object
      {
         return mTypeClassPrototype != null ? mTypeClassPrototype : GetDefaultTypeClassPrototype ();
      }
      
      public function GetDefaultTypeClassPrototype ():Object
      {
         return Object.prototype;
      }
      
      public function IsCompatibleWith (variableDefinition:VariableDefinition):Boolean
      {
         if (mValueType != variableDefinition.GetValueType ())
            return false;
         
         // 
         //var variablePrototype:Object = variableDefinition.GetTypeClassPrototype ();
         //var selfPrototype:Object = GetTypeClassPrototype ();
         //if (variablePrototype != selfPrototype && (! variablePrototype.isPrototypeOf (selfPrototype)))
         //   return false;
         
         return true;
      }
      
//==============================================================================
// common used for value target and value source
//==============================================================================
      
      public static function VariableIndex2SelectListSelectedIndex (variableIndex:int, selectListDataProvider:Array):int
      {
         for (var i:int = 0; i < selectListDataProvider.length; ++ i)
         {
            if (selectListDataProvider[i].mVariableIndex == variableIndex)
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
         label.text = "(nothing)";
         
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
            
            valueTargetVariable.SetVariableInstance (variable_space.GetVariableInstanceAt (combo_box.selectedItem == null ? -1 : combo_box.selectedItem.mVariableIndex));
         }
      }
      
   //==============================================================================
   // todo: property target
   //==============================================================================
      
      //public function GetDefaultPropertyValueTarget ():ValueTarget_Property
      //{
      //   return new ValueTarget_Property ();
      //}
      //
      //public function CreateControlForPropertyValueTarget (valueTargetProperty:ValueTarget_Property):UIComponent
      //{
      //   return null;
      //}
      //
      //public function RetrievePropertyValueTargetFromControl (valueTargetProperty:ValueTarget_Property, control:UIComponent):void
      //{
      //}
      
//==============================================================================
// for value source
//==============================================================================
      
      public function GetDefaultValueSource ():ValueSource
      {
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
         
         public function CreateControlForDirectValueSource (valueSourceDirect:ValueSource_Direct):UIComponent
         {
            return null;
         }
         
         public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSource_Direct, control:UIComponent):void
         {
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
            combo_box.selectedIndex = VariableIndex2SelectListSelectedIndex (currentVariable.IsNull () ? -1 : currentVariable.GetIndex (), variable_list);;
            
            return combo_box;
         }
         
         public function RetrieveVariableValueSourceFromControl (valueSourceVariable:ValueSource_Variable, control:UIComponent):void
         {
            if (control is ComboBox)
            {
               var combo_box:ComboBox = control as ComboBox;
               
               var currentVariable:VariableInstance = valueSourceVariable.GetVariableInstance ();
               var variable_space:VariableSpace = currentVariable.GetVariableSpace ();
               
               valueSourceVariable.SetVariableInstance (variable_space.GetVariableInstanceAt (combo_box.selectedItem == null ? -1 : combo_box.selectedItem.mVariableIndex));
            }
         }
         
   //==============================================================================
   // to do: property source
   //==============================================================================
         
         //public function GetDefaultPropertyValueSource ():ValueSource_Property
         //{
         //   return null;
         //}
         //
         //public function CreateControlForPropertyValueSource (valueSourceProperty:ValueSource_Property):UIComponent
         //{
         //   return null;
         //}
         //
         //public function RetrievePropertyValueSourceFromControl (valueSourceProperty:ValueSource_Property, control:UIComponent):void
         //{
         //}
         
   }
}

