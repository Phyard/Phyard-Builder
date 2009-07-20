package editor.trigger {
   
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableInstances:Array = new Array ();
      
      public function VariableSpace ()
      {
      }
      
      public function GetSpaceType ():int
      {
         return -1;
      }
      
      public function GetVariableInstanceAt (variableId:int):VariableInstance
      {
         if (variableId < 0 || variableId >= mVariableInstances.length)
            return null;
         
         return mVariableInstances [variableId];
      }
      
      public function CreateVariableInstance (variableDefinition:VariableDefinition):VariableInstance
      {
         var variable_instance:VariableInstance = new VariableInstance(this, mVariableInstances.length, variableDefinition);
         
         mVariableInstances.push (variable_instance);
         
         return variable_instance;
      }
      
      private function RearrangeVariableInstanceIDs ():void
      {
         for (var i:int = 0; i < mVariableInstances.length; ++ i)
            (mVariableInstances [i] as VariableInstance).SetIndex (i);
      }
      
      public function DestroyVariableInstance (variableId:int):void
      {
         if (variableId < 0 || variableId >= mVariableInstances.length)
            return;
         
         mVariableInstances.splice (variableId, 1);
         
         RearrangeVariableInstanceIDs ();
      }
      
      public function ChangeVariableInstanceId (variableOldId:int, variableNewId:int):void
      {
         if (variableOldId < 0 || variableOldId >= mVariableInstances.length)
            return;
         
         if (variableNewId < 0 || variableNewId >= mVariableInstances.length)
            return;
         
         var object:Object = mVariableInstances.splice (variableOldId, 1);
         mVariableInstances.splice (variableNewId, 0, object);
         
         RearrangeVariableInstanceIDs ();
      }
      
   }
}

