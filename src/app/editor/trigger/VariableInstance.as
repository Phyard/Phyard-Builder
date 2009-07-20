package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueSourceTypeDefine;
   
   public class VariableInstance extends ValueSource
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableSpace:VariableSpace;
      private var mIndex:int = -1; // index in space
      
      private var mVariableDefinition:VariableDefinition;
      
      private var mValueObject:Object;
      
      // used in VariableSpace.CreateVariableInstance ()
      public function VariableInstance (variableSpace:VariableSpace, id:int, variableDefinition:VariableDefinition)
      {
         mVariableSpace = variableSpace;
         SetIndex (mIndex);
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
      public function SetIndex (id:int):void
      {
         mIndex = id;
      }
      
      public function GetIndex ():int
      {
         return mIndex;
      }
      
      public function GetName ():String
      {
         return mVariableDefinition.GetName ();
      }
      
      public function GetValueType ():int
      {
         return mVariableDefinition.GetValueType ();
      }
      
      public function AssignValue (source:ValueSource):void
      {
         mValueObject = source.GetValueObject ();
      }
      
//=========================================================================================
// as a ValueSource
//=========================================================================================
      
      override public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Direct;
      }
      
      override public function GetValueObject ():Object
      {
         return mValueObject;
      }
   }
}

