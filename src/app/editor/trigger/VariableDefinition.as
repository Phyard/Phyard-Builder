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
      
      public function CreateControlForValueSource (valueSourceVariable:ValueSourceVariable, variableSpace:VariableSpace):ComboBox
      {
         return null;
      }
      
      public function RetrieveValueSourceFromControl (valueSourceVariable:ValueSourceVariable, control:ComboBox):void
      {
      }
      
//==============================================================================
// to override
//==============================================================================
      
      public function GetDefaultDirectValueSource ():ValueSourceDirect
      {
         return null;
      }
      
      public function ValidateDirectValueSource (valueSourceDirect:ValueSourceDirect):void
      {
      }
      
      public function CreateControlForDirectValueSource (valueSourceDirect:ValueSourceDirect):UIComponent
      {
         return null;
      }
      
      public function RetrieveDirectValueSourceFromControl (valueSourceDirect:ValueSourceDirect, control:UIComponent):void
      {
      }
      
   }
}

