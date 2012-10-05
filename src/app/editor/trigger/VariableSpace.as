package editor.trigger {
   
   import flash.utils.Dictionary;
   
   import editor.core.EditorObject;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   
   public class VariableSpace
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      //protected var mTriggerEngine:TriggerEngine;
      
      protected var mNullVariableInstance:VariableInstance;
      protected var mVariableInstances:Array = new Array ();
      
      private var mNumModifiedTimes:int = 0;
      
      public function VariableSpace (/*triggerEngine:TriggerEngine*/)
      {
         //mTriggerEngine = triggerEngine;
         
         mNullVariableInstance = new VariableInstance (this, -1, null, ValueTypeDefine.ValueType_Void, "(null)", null);
      }
      
      //public function GetTriggerEngine ():TriggerEngine
      //{
      //   return mTriggerEngine;
      //}
      
      public function SupportEditingInitialValues ():Boolean
      {
         return true;
      }
      
      public function GetSpaceType ():int
      {
         return -1;
      }
      
      public function IsVariableKeySupported ():Boolean
      {
         return false;
      }
      
      public function GetSpaceName ():String
      {
         return "Variable Space";
      }
      
      public function GetCodeName ():String
      {
         return "unknown";
      }
      
      public function GetShortName ():String
      {
         return "Unknown Space";
      }
      
      public function GetNumVariableInstances ():int
      {
         return mVariableInstances.length;
      }
      
      public function GetVariableInstanceAt (variableId:int):VariableInstance
      {
         //if (mVariableIdMapTable != null) // in importing
         //{
         //   var newId:Object = mVariableIdMapTable [variableId];
         //   if (newId != null)
         //      variableId = int (newId);
         //}
         
         if (variableId < 0 || variableId >= mVariableInstances.length)
            return mNullVariableInstance;
         
         return mVariableInstances [variableId];
      }
      
      public function GetNullVariableInstance ():VariableInstance
      {
         return mNullVariableInstance;
      }
      
      private function RearrangeVariableInstanceIndexes ():void
      {
         for (var i:int = 0; i < mVariableInstances.length; ++ i)
         {
            (mVariableInstances [i] as VariableInstance).SetIndex (i);
         }
      }
      
      public function DestroyAllVariableInstances ():void
      {
         for (var i:int = 0; i < mVariableInstances.length; ++ i)
         {
            (mVariableInstances [i] as VariableInstance).SetIndex (-1);
         }
         mVariableInstances.splice (0, mVariableInstances.length);
         
         mLookupTableByKey = new Dictionary ();
         
         RearrangeVariableInstanceIndexes (); // useless ?
         
         NotifyModified ();
      }
      
      public function DestroyVariableInstanceByIndex (variableId:int):void
      {
         if (variableId < 0 || variableId >= mVariableInstances.length)
            return;
         
         var vi:VariableInstance = mVariableInstances [variableId] as VariableInstance;
         vi.SetIndex (-1);
         mVariableInstances.splice (variableId, 1);
         
         delete mLookupTableByKey [vi.GetKey ()];
         
         RearrangeVariableInstanceIndexes ();
         
         NotifyModified ();
      }
      
      public function DestroyVariableInstance (vi:VariableInstance):void
      {
         var index:int = mVariableInstances.indexOf (vi);
         if (index >= 0)
         {
            // assert vi.GetVariableSpace () == this
            
            DestroyVariableInstanceByIndex (index);
         }
      }
      
      public function ChangeVariableInstanceIndex (variableOldId:int, variableNewId:int):void
      {
         if (variableOldId == variableNewId)
            return;
         
         if (variableOldId < 0 || variableOldId >= mVariableInstances.length)
            return;
         
         if (variableNewId < 0 || variableNewId >= mVariableInstances.length)
            return;
         
         var object:Object = mVariableInstances [variableOldId];
         mVariableInstances.splice (variableOldId, 1);
         mVariableInstances.splice (variableNewId, 0, object);
         
         RearrangeVariableInstanceIndexes ();
         
         NotifyModified ();
      }
      
      public function HasVariablesWithValueType (valueType:int):Boolean
      {
         var vi:VariableInstance;
         
         for (var i:int = 0; i < mVariableInstances.length; ++ i)
         {
            vi = mVariableInstances [i] as VariableInstance;
            
            if (vi.GetValueType () == valueType)
               return true;
         }
         
         return false;
      }
      
      public function HasVariablesSatisfiedBy (variableDefinition:VariableDefinition):Boolean
      {
         var viDef:VariableDefinition;
         var count:int = GetNumVariableInstances ();
         for (var i:int = 0; i < count; ++ i)
         {
            viDef = GetVariableInstanceAt (i).GetVariableDefinition ();
            if (viDef != null)
            {
               if (variableDefinition.IsCompatibleWith (viDef))
                  return true;
            }
         }
         
         return false;
      }
      
      public function GetVariableSelectListDataProviderByValueType (valueType:int, validVariableIndexes:Array = null):Array
      {
         var entity_list:Array = new Array ();
         
         var item:Object = new Object ();
         item.label = "(null)"; // mNullVariableInstance.GetLongName ();
         item.mVariableInstance = null;
         
         entity_list.push (item);
         
         var vi:VariableInstance;
         
         for (var i:int = 0; i < mVariableInstances.length; ++ i)
         {
            vi = mVariableInstances [i] as VariableInstance;
            
            if (vi.GetValueType () != valueType)
               continue;
            
            if (validVariableIndexes != null)
            {
               if (validVariableIndexes.indexOf (i) < 0)
                  continue;
            }
            
            item = new Object ();
            item.label = vi.GetLongName ();
            item.mVariableInstance = vi;
            
            entity_list.push (item);
         }
         
         return entity_list;
      }
      
      
      public function NotifyModified ():void
      {
         ++ mNumModifiedTimes;
      }
      
      public function GetNumModifiedTimes ():int
      {
         return mNumModifiedTimes;
      }
      
//============================================================================
// 
//============================================================================
      
      public function GetVariableInstanceByTypeAndName (valueType:int, variableName:String, createIfNotExist:Boolean = false):VariableInstance
      {
         for (var variableId:int = mVariableInstances.length - 1; variableId >= 0; -- variableId)
         {
            var variable_instance:VariableInstance = mVariableInstances [variableId];
            if (variable_instance.GetValueType () == valueType && variable_instance.GetName () == variableName)
               return variable_instance;
         }
       
         if (createIfNotExist)
         {
            var variableDefinition:VariableDefinition = VariableDefinition.CreateVariableDefinition (valueType, variableName);
            var newVi:VariableInstance = CreateVariableInstanceFromDefinition (variableDefinition);
            newVi.SetValueObject (VariableDefinition.GetDefaultInitialValueByType (valueType));
            
            return newVi;
         }
         
         return mNullVariableInstance;
      }
      
      
      //private var mVariableIdMapTable:Dictionary = null; 
      //private var mVirualVariablesCount:int;
      //public function BeginMergeVariablesWithSameNamesInCreatingVariables ():void
      //{
      //   mVariableIdMapTable = new Dictionary ();
      //   mVirualVariablesCount = GetNumVariableInstances ();
      //}
      //
      //public function EndMergeVariablesWithSameNamesInCreatingVariables ():void
      //{
      //   mVariableIdMapTable = null;
      //}
      
      public function CreateVariableInstanceFromDefinition (/*key:String, */variableDefinition:VariableDefinition, avoidNameConflicting:Boolean = false):VariableInstance
      {
         //if (mVariableIdMapTable != null) // in importing
         //{
         //   var vi:VariableInstance = GetVariableInstanceByTypeAndName (variableDefinition.GetValueType (), variableDefinition.GetName ());
         //   if (vi != null && vi != mNullVariableInstance)
         //   {
         //      mVariableIdMapTable [mVirualVariablesCount ++] = vi.GetIndex ();
         //      return vi;
         //   }
         //}
         
         if (avoidNameConflicting)
         {
            var vi:VariableInstance = GetVariableInstanceByTypeAndName (variableDefinition.GetValueType (), variableDefinition.GetName ());
            if (vi != null && vi != mNullVariableInstance)
            {
               return vi;
            }
         }
         
         //if (IsVariableKeySupported ())
         //{
         //}
         
         var variable_instance:VariableInstance = new VariableInstance(this, mVariableInstances.length, variableDefinition);
         
         mVariableInstances.push (variable_instance);
         
         ++ mAccVariableInstanceId; // never decrease
         
         ////>> bug fix: this line added from v2.03
         //if (mVariableIdMapTable != null)
         //   mVariableIdMapTable [mVirualVariablesCount++] = variable_instance.GetIndex ();
         ////<<

         NotifyModified ();
         
         return variable_instance;
      }
      
      public function CreateVariableInstanceByTypeNameValue (/*key:String, */valueType:int, variableName:String, intialValue:Object):VariableInstance
      {
         // it seems this function is only for create register variables
         // VariableSpaceRegister has overridden this function
         // 
         // the key (uuid) of register variables is not important.
         // so keys will not be created for register variables.
         
         throw new Error ();
      
         //if (mVariableIdMapTable != null) // in importing
         //{
         //   var vi:VariableInstance = GetVariableInstanceByTypeAndName (valueType, variableName);
         //   if (vi!= null && vi != mNullVariableInstance)
         //   {
         //      mVariableIdMapTable [mVirualVariablesCount ++] = vi.GetIndex ();
         //      return vi;
         //   }
         //}
         //
         //var variable_instance:VariableInstance = new VariableInstance(this, mVariableInstances.length, null, valueType, variableName, intialValue);
         //
         //mVariableInstances.push (variable_instance);
         //
         //++ mAccVariableInstanceId;
         //
         ////>> bug fix: this line added from v2.03
         //if (mVariableIdMapTable != null)
         //   mVariableIdMapTable [mVirualVariablesCount++] = variable_instance.GetIndex ();
         ////<<
         //
         //NotifyModified ();
         //
         //return variable_instance;
      }
      
//============================================================================
// lookup tables 
//============================================================================
      
      private var mLookupTableByKey:Dictionary = new Dictionary ();
      
      public function GetVariableInstanceByKey (key:String):VariableInstance
      {
         return mLookupTableByKey [key] as VariableInstance;
      }
      
      private var mAccVariableInstanceId:int = 0; // used to create key
      
      final public function GetAccVariableInstanceId ():int
      {
         return mAccVariableInstanceId;
      }
      
      protected function ValidateVariableInstanceKey (key:String):String
      {
         if (key != null && key.length == 0)
            key = null;
         
         while (key == null || mLookupTableByKey [key] != null)
         {
            key = EditorObject.BuildKey (GetAccVariableInstanceId ());
         }
         
         return key;
      }
      
   }
}

