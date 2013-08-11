package editor.trigger {
   
   import flash.utils.Dictionary;
   
   import editor.world.World;
   
   import editor.core.EditorObject;
   
   import common.trigger.CoreClassIds;
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
         
         //mNullVariableInstance = new VariableInstance (this, -1, null, CoreClassIds.ValueType_Void, "(null)", null);
         mNullVariableInstance = new VariableInstance (this, -1, 
                                    new VariableDefinitionVoid (
                                                World.GetCoreClassById (CoreClassIds.ValueType_Void).GetDefaultInstanceName (), 
                                                null)
                                 );
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
         
         if (IsVariableKeySupported ())
         {
            mLookupTableByKey = new Dictionary ();
         }
         
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
         
         if (IsVariableKeySupported ())
         {
            delete mLookupTableByKey [vi.GetKey ()];
         }
         
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
      
      //public function HasVariablesWithValueType (valueType:int):Boolean
      //{
      //   var vi:VariableInstance;
      //   
      //   for (var i:int = 0; i < mVariableInstances.length; ++ i)
      //   {
      //      vi = mVariableInstances [i] as VariableInstance;
      //      
      //      if (vi.GetValueType () == valueType)
      //         return true;
      //   }
      //   
      //   return false;
      //}
      
      public function HasVariablesSatisfiedBy (variableDefinition:VariableDefinition, deepIntoCustomClass:Boolean = true):Boolean
      {
         var viDef:VariableDefinition;
         var count:int = GetNumVariableInstances ();
         for (var i:int = 0; i < count; ++ i)
         {
            viDef = GetVariableInstanceAt (i).GetVariableDefinition ();
            if (viDef != null) // always
            {
               if (variableDefinition.IsCompatibleWith (viDef))
                  return true;
               
               if (deepIntoCustomClass && viDef is VariableDefinition_Custom)
               {
                  if ((viDef as VariableDefinition_Custom).GetCustomProperties ().HasVariablesSatisfiedBy (variableDefinition, false))
                     return true;
               }
            }
         }
         
         return false;
      }
      
      //public function GetVariableSelectListDataProviderByValueType (typeType:int, valueType:int, validVariableIndexes:Array = null):Array
      public function GetVariableSelectListDataProviderByVariableDefinition (variableDefinition:VariableDefinition, validVariableIndexes:Array = null, deepIntoCustomClass:Boolean = true, 
                                                                             deepLevel:int = 0, lastLevelName:String = null, dataList:Array = null):Array
      {
         var item:Object;
         
         if (dataList == null)
         {
            dataList = new Array ();
            
            item = new Object ();
            item.label = "(null)"; // mNullVariableInstance.GetLongName ();
            item.mVariableInstance = null;
            
            dataList.push (item);
         }
         
         var vi:VariableInstance;
         var viDef:VariableDefinition;
         var label:String;
         
         for (var i:int = 0; i < mVariableInstances.length; ++ i)
         {  
            if (validVariableIndexes != null)
            {
               if (validVariableIndexes.indexOf (i) < 0)
                  continue;
            }
            
            vi = mVariableInstances [i] as VariableInstance;
            viDef = GetVariableInstanceAt (i).GetVariableDefinition ();
            
            if (viDef != null) // always
            {
               var added:Boolean = false;
               
               if (variableDefinition.IsCompatibleWith (viDef))
               {
                  item = new Object ();
                  item.mVariableInstance = vi;
                  
                  if (lastLevelName == null) // or deepLevel > 0
                  {
                     label = vi.GetLongName ();
                  }
                  else
                  {
                     label = lastLevelName + "[" + i + "] " + vi.GetName ();
                     for (var j:int = 0; j < deepLevel; ++ j)
                        label = "\t\t" + label;
                  }
                  item.label = label;
                  
                  dataList.push (item);
                  
                  added = true;
               }
               
               if (deepIntoCustomClass && viDef is VariableDefinition_Custom)
               {
                  if ((viDef as VariableDefinition_Custom).GetCustomProperties ().HasVariablesSatisfiedBy (variableDefinition, false))
                  {
                     if (! added)
                     {
                        item = new Object ();
                        item.mVariableInstance = vi;
                        label = vi.GetLongName ();
                        item.label = label;
                        
                        dataList.push (item);
                     }
                     
                     (viDef as VariableDefinition_Custom).GetCustomProperties ().GetVariableSelectListDataProviderByVariableDefinition (variableDefinition, null, false, deepLevel + 1, vi.GetName (), dataList);
                  }
               }
            }
         }
         
         return dataList;
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
      
      // this function is slow if the number of variables is large.
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
            var variableDefinition:VariableDefinition = VariableDefinition.CreateCoreVariableDefinition (valueType, variableName);
            var newVi:VariableInstance = CreateVariableInstanceFromDefinition (null, variableDefinition);
            //newVi.SetValueObject (VariableDefinition.GetDefaultInitialValueByType (valueType));
            newVi.SetValueObject (World.GetCoreClassById (valueType).GetInitialInstacneValue ());
            
            return newVi;
         }
         
         return mNullVariableInstance;
      }
      
      public function GetVariableInstanceByTypeAndKey (valueType:int, variableKey:String, variableName:String, createIfNotExist:Boolean = false):VariableInstance
      {
         if (IsVariableKeySupported ())
         {
            if (variableKey != null && variableKey.length > 0)
            {
               var variable_instance:VariableInstance = mLookupTableByKey [variableKey];
               if (variable_instance != null && variable_instance.GetValueType () == valueType)
                  return variable_instance;
            }
            
            if (createIfNotExist)
            {
               var variableDefinition:VariableDefinition = VariableDefinition.CreateCoreVariableDefinition (valueType, variableName);
               var newVi:VariableInstance = CreateVariableInstanceFromDefinition (variableKey, variableDefinition);
               //newVi.SetValueObject (VariableDefinition.GetDefaultInitialValueByType (valueType));
               newVi.SetValueObject (World.GetCoreClassById (valueType).GetInitialInstacneValue ());
               
               return newVi;
            }
            
            return mNullVariableInstance;
         }
         
         throw new Error ();
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
      
      public function CreateVariableInstanceFromDefinition (key:String, variableDefinition:VariableDefinition, avoidConflicting:Boolean = false):VariableInstance
      {
         var vi:VariableInstance;
         
         //if (mVariableIdMapTable != null) // in importing
         //{
         //   vi = GetVariableInstanceByTypeAndName (variableDefinition.GetValueType (), variableDefinition.GetName ());
         //   if (vi != null && vi != mNullVariableInstance)
         //   {
         //      mVariableIdMapTable [mVirualVariablesCount ++] = vi.GetIndex ();
         //      return vi;
         //   }
         //}
         
         if (avoidConflicting)
         {
            if (IsVariableKeySupported () && key != null && key.length > 0)
            {
               vi = GetVariableInstanceByTypeAndKey (variableDefinition.GetValueType (), key, variableDefinition.GetName ());
               if (vi != null && vi != mNullVariableInstance)
               {
                  return vi;
               }
            }
            else
            {
               vi = GetVariableInstanceByTypeAndName (variableDefinition.GetValueType (), variableDefinition.GetName ());
               if (vi != null && vi != mNullVariableInstance)
               {
                  return vi;
               }
            }
         }
         
         vi = new VariableInstance (this, mVariableInstances.length, variableDefinition);
         
         mVariableInstances.push (vi);
         
         if (IsVariableKeySupported ())
         {
            vi.SetKey (ValidateVariableInstanceKey (key));
            mLookupTableByKey [vi.GetKey ()] = vi;
         }
         
         ++ mAccVariableInstanceId; // never decrease
         
         ////>> bug fix: this line added from v2.03
         //if (mVariableIdMapTable != null)
         //   mVariableIdMapTable [mVirualVariablesCount++] = vi.GetIndex ();
         ////<<

         NotifyModified ();
         
         return vi;
      }
      
      //public function CreateVariableInstanceByTypeNameValue (/*key:String, */valueType:int, variableName:String, intialValue:Object):VariableInstance
      //{
      //   // it seems this function is only for create register variables
      //   // VariableSpaceRegister has overridden this function
      //   // 
      //   // the key (uuid) of register variables is not important.
      //   // so keys will not be created for register variables.
      //   
      //   throw new Error ();
      //
      //   //if (mVariableIdMapTable != null) // in importing
      //   //{
      //   //   var vi:VariableInstance = GetVariableInstanceByTypeAndName (valueType, variableName);
      //   //   if (vi!= null && vi != mNullVariableInstance)
      //   //   {
      //   //      mVariableIdMapTable [mVirualVariablesCount ++] = vi.GetIndex ();
      //   //      return vi;
      //   //   }
      //   //}
      //   //
      //   //var variable_instance:VariableInstance = new VariableInstance(this, mVariableInstances.length, null, valueType, variableName, intialValue);
      //   //
      //   //mVariableInstances.push (variable_instance);
      //   //
      //   //++ mAccVariableInstanceId;
      //   //
      //   ////>> bug fix: this line added from v2.03
      //   //if (mVariableIdMapTable != null)
      //   //   mVariableIdMapTable [mVirualVariablesCount++] = variable_instance.GetIndex ();
      //   ////<<
      //   //
      //   //NotifyModified ();
      //   //
      //   //return variable_instance;
      //}
      
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

