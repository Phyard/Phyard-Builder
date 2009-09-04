package editor.trigger {
   
   import mx.core.UIComponent;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   
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
      public function VariableInstance (variableSpace:VariableSpace, id:int, variableDefinition:VariableDefinition, valueType:int = 0 /*ValueTypeDefine.ValueType_void*/, variableName:String = null, intialValue:Object = null)
      {
         mVariableSpace = variableSpace;
         SetIndex (id);
         mVariableDefinition = variableDefinition;
         
         if (mVariableDefinition != null)
            AssignValue (mVariableDefinition.GetDefaultValueSource ());
         else
         {
            mValuetype = valueType;
            mName = variableName;
            SetValueObject (intialValue);
         }
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
      
      public function GetName ():String
      {
         if (mVariableDefinition == null)
            return mName;
         
         return mVariableDefinition.GetName ();
      }
      
      public function GetLongName ():String
      {
         return mVariableSpace.GetSpaceShortName () + "[" + mIndex + "] " + GetName ();
      }
      
      public function GetValueType ():int
      {
         if (mVariableDefinition == null)
            return mValuetype;
         
         return mVariableDefinition.GetValueType ();
      }
      
      // should call this
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

