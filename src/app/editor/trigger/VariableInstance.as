package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class VariableInstance extends VariableValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableSpace:VariableSpace;
      private var mID:int = -1; // index in space
      
      private var mVariableDefinition:VariableDefinition;
      
      private var mValueObject:Object;
      
      // used in VariableSpace.CreateVariableInstance ()
      public function VariableInstance (variableSpace:VariableSpace, id:int, variableDefinition:VariableDefinition)
      {
         mVariableSpace = variableSpace;
         SetID (id);
         mVariableDefinition = variableDefinition;
         
         AssignValue (mVariableDefinition.GetDefaultDirectValueSource ());
      }
      
      public function GetVariableSpace ():VariableSpace
      {
         return mVariableSpace;
      }
      
      public function GetSpaceType ():int
      {
         return mVariableSpace.GetSpaceType ();
      }
      
      // only for mVariableSpace to arrange the id
      public function SetID (id:int):void
      {
         mID = id;
      }
      
      public function GetID ():int
      {
         return mID;
      }
      
      public function GetName ():String
      {
         return mVariableDefinition.GetName ();
      }
      
      public function GetValueType ():int
      {
         return mVariableDefinition.GetValueType ();
      }
      
      public function AssignValue (source:VariableValueSource):void
      {
         mValueObject = source.GetValueObject ();
      }
      
//=========================================================================================
// as a VariableValueSource
//=========================================================================================
      
      override public function GetSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Direct;
      }
      
      override public function GetValueObject ():Object
      {
         return mValueObject;
      }
   }
}

