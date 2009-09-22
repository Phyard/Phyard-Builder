package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   import common.Define;
   
   public class VariableSpaceRegister extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mValueType:int;
      
      public function VariableSpaceRegister (valueType:int)
      {
         mValueType = valueType;
         
         var init_value:Object = VariableDefinition.GetDefaultInitialValueByType (mValueType);
         
         for (var i:int = 0; i < Define.NumRegistersPerType; ++ i)
            CreateVariableInstance(mValueType, "", init_value)
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_GlobalRegister;
      }
      
      override public function GetSpaceName ():String
      {
         return "Register Variable Space";
      }
      
      override public function GetSpaceShortName ():String
      {
         return VariableDefinition.GetValueTypeName (mValueType) + " Reg";
      }
      
      override public function CreateVariableInstanceFromDefinition (variableDefinition:VariableDefinition):VariableInstance
      {
         if (variableDefinition.GetValueType () != mValueType)
            throw new Error ("reg space valye type != variable value type");
         
         var variable_instance:VariableInstance = new VariableInstance(this, mVariableInstances.length, variableDefinition);
         
         mVariableInstances.push (variable_instance);
         
         return variable_instance;
      }
      
      override public function CreateVariableInstance(valueType:int, variableName:String, intialValue:Object):VariableInstance
      {
         if (valueType != mValueType)
            throw new Error ("reg space valye type != variable value type");
         
         var variable_instance:VariableInstance = new VariableInstance(this, mVariableInstances.length, null, valueType, variableName, intialValue);
         
         mVariableInstances.push (variable_instance);
         
         return variable_instance;
      }
      
   }
}