package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.ComboBox;
   
   public class VariableDefinition
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      public var mName:String;
      public var mValueType:int;
      
      private var mDescription:String = null;
      
      public function VariableDefinition (name:String, valueType:int, description:String = null)
      {
         mName = name;
         mValueType = valueType;
         mDescription = description;
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
      
//==============================================================================
// 
//==============================================================================
      
      public function CreateControlForVariableValueSource (valueSourceVariable:VariableValueSourceVariable, variableSpace:VariableSpace):ComboBox
      {
         return null;
      }
      
      public function RetrieveVariableValueSourceFromControl (valueSourceVariable:VariableValueSourceVariable, control:ComboBox):void
      {
      }
      
//==============================================================================
// to override
//==============================================================================
      
      public function GetDefaultDirectValueSource ():VariableValueSourceDirect
      {
         return null;
      }
      
      public function ValidateDirectValueSource (valueSourceDirect:VariableValueSourceDirect):void
      {
      }
      
      public function CreateControlForDirectValueSource (valueSourceDirect:VariableValueSourceDirect):UIComponent
      {
         return null;
      }
      
      public function RetrieveDirectValueSourceFromControl (valueSourceDirect:VariableValueSourceDirect, control:UIComponent):void
      {
      }
      
   }
}

