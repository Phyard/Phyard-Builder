package editor.trigger {
   
   import editor.world.World;
   
   import common.trigger.ValueSpaceTypeDefine;
   
   import common.Define;
   
   public class VariableSpaceRegister extends VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mValueType:int;
      
      public function VariableSpaceRegister (/*triggerEngine:TriggerEngine, */valueType:int)
      {
         //super (triggerEngine);
         
         mValueType = valueType;
         
         ////var init_value:Object = VariableDefinition.GetDefaultInitialValueByType (mValueType);
         //var init_value:Object = World.GetCoreClassById (mValueType).GetInitialInstacneValue ();
         
         for (var i:int = 0; i < Define.NumRegistersPerVariableType; ++ i)
         {
            //CreateVariableInstanceByTypeNameValue (mValueType, "", init_value);
            
            CreateVariableInstanceFromDefinition (null, VariableDefinition.CreateCoreVariableDefinition (mValueType, ""));
         }
      }
      
      override public function SupportEditingInitialValues ():Boolean
      {
         return false;
      }
      
      override public function GetSpaceType ():int
      {
         return ValueSpaceTypeDefine.ValueSpace_Register;
      }
      
      override public function GetSpaceName ():String
      {
         return "Register Variable Space";
      }
      
      override public function GetShortName ():String
      {
         //return VariableDefinition.GetValueTypeName (mValueType) + " Register";
         return World.GetCoreClassById (mValueType).GetName () + " Register";
      }
      
      override public function GetCodeName ():String
      {
         //return "reg" + VariableDefinition.GetValueTypeName (mValueType);
         return "reg" + World.GetCoreClassById (mValueType).GetName ();
      }
      
      //override public function CreateVariableInstanceFromDefinition (key:String, variableDefinition:VariableDefinition, avoidNameConflicting:Boolean = false):VariableInstance
      //{
      //   // it seems this function is never called.
      //   throw new Error ();
      //
      //   //if (variableDefinition.GetValueType () != mValueType)
      //   //   throw new Error ("reg space valye type != variable value type");
      //   //
      //   //var variable_instance:VariableInstance = new VariableInstance(this, mVariableInstances.length, variableDefinition);
      //   //
      //   //mVariableInstances.push (variable_instance);
      //   //
      //   //return variable_instance;
      //}
      
      //override public function CreateVariableInstanceByTypeNameValue (valueType:int, variableName:String, intialValue:Object):VariableInstance
      //{
      //   if (valueType != mValueType)
      //      throw new Error ("reg space valye type != variable value type");
      //   
      //   var variable_instance:VariableInstance = new VariableInstance(this, mVariableInstances.length, null, valueType, variableName, intialValue);
      //   
      //   mVariableInstances.push (variable_instance);
      //   
      //   return variable_instance;
      //}
      
   }
}
