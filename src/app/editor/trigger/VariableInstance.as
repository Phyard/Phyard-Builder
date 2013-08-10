package editor.trigger {
   
   import mx.core.UIComponent;
   
   import editor.world.World;
   
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableInstance // implements ValueSource, ValueTarget
   {
   //========================================================================================================
   // !!! revert some bad changes in revison 2b7b691dca3f454921e229eb20163850675adda1 - "now ccats and functions are edit in dialogs"
   // for ConvertRegisterVariablesToGlobalVariables
   //========================================================================================================
      
      public var mCorrespondingGlobalVariable:VariableInstance = null;
      
      public function GetCodeStringAsRegisterVariable ():String
      {
         return mVariableSpace.GetCodeName () + "[" + mIndex + "]";
      }
      
   //========================================================================================================
   //
   //========================================================================================================
      
      private var mVariableSpace:VariableSpace;
      private var mIndex:int = -1; // index in space
      
      private var mValueObject:Object;
      
      private var mVariableDefinition:VariableDefinition;
      
   // only valid when mVariableDefinition == null
      private var mValuetype:int = CoreClassIds.ValueType_Void;
      private var mName:String = null;
      
      // used in VariableSpace.CreateVariableInstance () and GetNullVariableInstance ()
      public function VariableInstance (variableSpace:VariableSpace, id:int, variableDefinition:VariableDefinition, 
                        valueType:int=0, /*CoreClassIds.ValueType_Void,*/ // shit, mxmlc bug 
                        variableName:String = null, intialValue:Object = null)
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
            mValuetype = CoreClassIds.ValueType_Void;
            return;
         }
         
         SetValueObject (mVariableDefinition.GetDefaultValueSource (/*mVariableSpace.GetTriggerEngine ()*/).GetValueObject ());
         SetName (variableDefinition.GetName ());
      }
      
      public function ToVariableDefinitionString ():String
      {
         //return VariableDefinition.GetValueTypeName (GetValueType ()) + " " + GetName ();
         //return World.GetCoreClassById (GetValueType ()).GetName () + " " + GetName ();
         if (mVariableDefinition != null)
            return mVariableDefinition.GetTypeName () + " : " + GetName ();
         
         return "null";
      }
      
      private function ToCodeStringForSourceOrTarget (forTarget:Boolean):String
      {
         if (mIndex < 0)
            return forTarget ? "void" : "null";
         else if (mVariableSpace.GetSpaceType () == ValueSpaceTypeDefine.ValueSpace_EntityProperties)
            return "[" + mIndex + ":\"" + GetName () + "\"]";
         else if (mVariableSpace.GetSpaceType () == ValueSpaceTypeDefine.ValueSpace_Register)
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
      
      public function IsNull ():Boolean
      {
         return mIndex < 0;
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
      
      public function GetTypeType ():int
      {
         if (mVariableDefinition == null) // never
            return ClassTypeDefine.ClassType_Unknown;
         
         return mVariableDefinition.GetTypeType ();
      }
      
      public function GetValueType ():int
      {
         if (mVariableDefinition == null)
            return mValuetype;
         
         return mVariableDefinition.GetValueType ();
      }
      
      // should not call this
      //public function Clone():VariableInstance
      //{
      //   //var vi:VariableInstance = mVariableSpace.Create ... //new VariableInstance (mVariableSpace, mIndex, mVariableDefinition);
      //   //vi.AssignValue (this);
      //   //
      //   //return vi;
      //   
      //   return null;
      //}
      
      public function SetValueObject (valueObject:Object):void
      {
         if (mVariableDefinition != null)
         {
            valueObject = mVariableDefinition.ValidateDirectValueObject (valueObject);
            mVariableDefinition.SetDefaultValue (valueObject);
         }
         else
         {
            valueObject = VariableDefinition.ValidateValueByType (valueObject, mValuetype);
         }
         
          mValueObject = valueObject;
      }
      
      public function GetValueObject ():Object
      {
         return mValueObject;
      }
      
      // it seems VariableDefinition has no the "GetDefaultValue" function.
      // even if mVariableDefinition != null, the mValueObject is still in use.
      // 
      // todo: if seems "mVariableDefinition == null" is only for register and null variables.
      // to check why and try to make register and null variables also use mVariableDefinition.
      // if it is possible to achieve this, then one VariableInstance must have a private mVariableDefinition,
      // then, the VariableInstance class will be not essential?
      
      //public function GetValueObject ():Object
      //{
      //   if (mVariableDefinition == null)
      //      return mValueObject;
      //   
      //   return mVariableDefinition.GetDefaultValue (); 
      //}
   
   // uuid
   
      private var mKey:String = "";
      
      public function GetKey ():String
      {
         return mKey;
      }
      
      public function SetKey (key:String):void
      {
         mKey = key;
      }
      
//=========================================================================================
// as a target
//=========================================================================================
      
      //public function GetValueTargetType ():int
      //{
      //   return ValueTargetTypeDefine.ValueTarget_Self;
      //}
      
      //public function AssignValue (source:ValueSource):void
      //{
      //   SetValueObject (source.GetValueObject ());
      //}
      
      //public function CloneTarget ():ValueTarget
      //{
      //   return Clone ();
      //}
      
      //public function ValidateTarget ():void
      //{
      //}
      
//=========================================================================================
// as a ValueSource
//=========================================================================================
      
      //public function GetValueSourceType ():int
      //{
      //   return ValueSourceTypeDefine.ValueSource_Direct;
      //}
      
      //public function GetValueObject ():Object
      //{
      //   return mValueObject;
      //}
      
      //public function CloneSource ():ValueSource
      //{
      //   return Clone ();
      //}
      
      //public function ValidateSource ():void
      //{
      //   // ...
      //}
   }
}

