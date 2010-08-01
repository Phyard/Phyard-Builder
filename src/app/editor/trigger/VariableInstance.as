package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableInstance implements ValueSource, ValueTarget
   {
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableSpace:VariableSpace;
      private var mIndex:int = -1; // index in space
      
      private var mValueObject:Object;
      
      private var mVariableDefinition:VariableDefinition;
      
   // only valid when mVariableDefinition == null
      private var mValuetype:int = ValueTypeDefine.ValueType_Void; 
      private var mName:String = null;
      
      // used in VariableSpace.CreateVariableInstance () and GetNullVariableInstance ()
      public function VariableInstance (variableSpace:VariableSpace, id:int, variableDefinition:VariableDefinition, valueType:int = ValueTypeDefine.ValueType_Void, variableName:String = null, intialValue:Object = null)
      {
         mVariableSpace = variableSpace;
         SetIndex (id);
         
         if (variableDefinition == null)
         {
            mValuetype = valueType;
            SetName (variableName);
            SetValueObject (intialValue);
         }
         else
         {
            SetVariableDefinition (variableDefinition);
         }
      }
      
      public function GetVariableDefinition ():VariableDefinition
      {
         return mVariableDefinition;
      }
      
      public function SetVariableDefinition (variableDefinition:VariableDefinition):void
      {
         mVariableDefinition = variableDefinition;
         if (mVariableDefinition == null) // generally, shouldn't
         {
            mValuetype = ValueTypeDefine.ValueType_Void;
            return;
         }
         
         AssignValue (mVariableDefinition.GetDefaultValueSource (mVariableSpace.GetTriggerEngine ()));
         SetName (variableDefinition.GetName ());
      }
      
      public function ToVariableDefinitionString ():String
      {
         return ValueTypeDefine.GetTypeName (GetValueType ()) + " " + GetName ();
      }
      
      private function ToCodeStringForSourceOrTarget (forTarget:Boolean):String
      {
         if (mIndex < 0)
            return forTarget ? "void" : "null";
         else if (mVariableSpace.GetSpaceType () == ValueSpaceTypeDefine.ValueSpace_Entity)
            return "[" + mIndex + ":\"" + GetName () + "\"]";
         else if (mVariableSpace.GetSpaceType () == ValueSpaceTypeDefine.ValueSpace_GlobalRegister)
            return mVariableSpace.GetCodeName () + "[" + mIndex + "]";
         else
            return mVariableSpace.GetCodeName () + "[" + mIndex + ":\"" + GetName () + "\"]";
      }
      
      public function SourceToCodeString (vd:VariableDefinition):String
      {
         return ToCodeStringForSourceOrTarget (false);
      }
      
      public function TargetToCodeString (vd:VariableDefinition):String
      {
         return ToCodeStringForSourceOrTarget (true);
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
      
      public function IsNull ():Boolean
      {
         return mIndex < 0;
      }
      
      public function GetIndex ():int
      {
         return mIndex;
      }
      
      public function SetName (name:String):void
      {
         if (mVariableDefinition == null)
         {
            mName = name;
         }
      }
      
      public function GetName ():String
      {
         if (mVariableDefinition == null)
            return mName;
         
         return mVariableDefinition.GetName ();
      }
      
      public function GetLongName ():String
      {
         return mVariableSpace.GetShortName () + " [" + mIndex + "] " + GetName ();
      }
      
      public function GetValueType ():int
      {
         if (mVariableDefinition == null)
            return mValuetype;
         
         return mVariableDefinition.GetValueType ();
      }
      
      // should not call this
      public function Clone():VariableInstance
      {
         //var vi:VariableInstance = mVariableSpace.Create ... //new VariableInstance (mVariableSpace, mIndex, mVariableDefinition);
         //vi.AssignValue (this);
         //
         //return vi;
         
         return null;
      }
      
      public function SetValueObject (valueObject:Object):void
      {
         if (mVariableDefinition != null)
            valueObject = mVariableDefinition.ValidateDirectValueObject (valueObject);
         else
            valueObject = VariableDefinition.ValidateValueByType (valueObject, mValuetype);
         
          mValueObject = valueObject;
      }
      
//=========================================================================================
// as a target
//=========================================================================================
      
      public function GetValueTargetType ():int
      {
         return ValueTargetTypeDefine.ValueTarget_Self;
      }
      
      public function AssignValue (source:ValueSource):void
      {
         SetValueObject (source.GetValueObject ());
      }
      
      public function CloneTarget ():ValueTarget
      {
         return Clone ();
      }
      
      public function ValidateTarget ():void
      {
      }
      
//=========================================================================================
// as a ValueSource
//=========================================================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Direct;
      }
      
      public function GetValueObject ():Object
      {
         return mValueObject;
      }
      
      public function CloneSource ():ValueSource
      {
         return Clone ();
      }
      
      public function ValidateSource ():void
      {
         // ...
      }
   }
}

