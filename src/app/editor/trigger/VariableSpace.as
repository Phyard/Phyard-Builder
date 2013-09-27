package editor.trigger {
   
   import flash.utils.Dictionary;
   
   import editor.world.World;
   import editor.entity.Scene;
   import editor.codelib.CodeLibManager;
   
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
      
      public function IsVariableKeySupported ():Boolean
      {
         return false;
      }
      
      public function GetSpaceType ():int
      {
         return -1;
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
         
         mLookupTableByName = new Dictionary ();
         
         if (IsVariableKeySupported ())
         {
            mLookupTableByKey = new Dictionary ();
         }
         
         RearrangeVariableInstanceIndexes (); // useless ?
         
         NotifyModified ();
      }
      
      public function DestroyVariableInstanceAtIndex (variableId:int):void
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
         
         delete mLookupTableByName [vi.GetName ()];
         
         RearrangeVariableInstanceIndexes ();
         
         NotifyModified ();
      }
      
      public function DestroyVariableInstance (vi:VariableInstance):void
      {
         var index:int = mVariableInstances.indexOf (vi);
         if (index >= 0)
         {
            // assert vi.GetVariableSpace () == this
            
            DestroyVariableInstanceAtIndex (index);
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
      
      public function HasVariablesSatisfiedBy (variableDefinition:VariableDefinition, deepIntoCustomClass:Boolean = true, inPhaseForAddingVariablesOfOtherClasses:Boolean = false):Boolean
      {
         var count:int = GetNumVariableInstances ();

         if (variableDefinition.AllowVariablesOfOtherClasses ())
            return count > 0;
            
         var viDef:VariableDefinition;
         for (var i:int = 0; i < count; ++ i)
         {
            viDef = GetVariableInstanceAt (i).GetVariableDefinition ();
            if (viDef != null) // always
            {
               var compitable:Boolean = variableDefinition.IsCompatibleWith (viDef) || viDef.IsCompatibleWith (variableDefinition);
               if (inPhaseForAddingVariablesOfOtherClasses)
                  compitable = ! compitable;
               
               if (compitable)
                  return true;
               
               if (deepIntoCustomClass && viDef is VariableDefinition_Custom)
               {
                  if ((viDef as VariableDefinition_Custom).GetCustomProperties ().HasVariablesSatisfiedBy (variableDefinition, false, inPhaseForAddingVariablesOfOtherClasses))
                     return true;
               }
            }
         }
         
         return false;
      }
      
      // why use validVariableIndexes filters? (wondering at v2.05)
      // - ok, after merging FunctionDeclaration and FunctionDefinition, validVariableIndexes param is removed.
      //public function GetVariableSelectListDataProviderByValueType (typeType:int, valueType:int, validVariableIndexes:Array = null):Array
      public function GetVariableSelectListDataProviderByVariableDefinition (variableDefinition:VariableDefinition):Array
      {
         var dataList:Array = GetVariableSelectListDataProvider (variableDefinition); //, validVariableIndexes);
         
         if (variableDefinition.AllowVariablesOfOtherClasses () && HasVariablesSatisfiedBy (variableDefinition, true, true))
         {
            // .
            var item:Object = new Object ();
            item.label = "----------------";
            //item.mIndex = -1; // bug
            item.mVariableInstance = mNullVariableInstance;
            item.mProperty = -1;
            
            dataList.push (item);
            
            // ...
            GetVariableSelectListDataProvider (variableDefinition,// null, 
                                               null, null, true,
                                               dataList);
            
            // ...
         }
         
         return dataList;
      }

      // labelPrefix and dataList are both null or non-null
      private function GetVariableSelectListDataProvider ( variableDefinition:VariableDefinition, 
                                                           //validVariableIndexes:Array = null,
                                                           labelPrefix:String = null, 
                                                           propertyOwnerVi:VariableInstance = null,
                                                           inPhaseForAddingVariablesOfOtherClasses:Boolean = false,
                                                           dataList:Array = null
                                                        ):Array
      {
         var item:Object;
         
         if (dataList == null)
         {
            dataList = new Array ();
            
            item = new Object ();
            item.label = "(null)"; // mNullVariableInstance.GetLongName ();
            //item.mIndex = -1; // bug
            item.mVariableInstance = mNullVariableInstance;
            item.mProperty = -1;
            
            dataList.push (item);
         }
         
         var vi:VariableInstance;
         var viDef:VariableDefinition;
         
         for (var i:int = 0; i < mVariableInstances.length; ++ i)
         {  
            //if (validVariableIndexes != null)
            //{
            //   if (validVariableIndexes.indexOf (i) < 0)
            //      continue;
            //}
            
            vi = mVariableInstances [i] as VariableInstance;
            viDef = GetVariableInstanceAt (i).GetVariableDefinition ();
            
            if (viDef != null) // always
            {
               var toDeepInto:Boolean =   labelPrefix == null 
                                       && viDef is VariableDefinition_Custom
                                       && (viDef as VariableDefinition_Custom).GetCustomProperties ().HasVariablesSatisfiedBy (variableDefinition, false, inPhaseForAddingVariablesOfOtherClasses)
                                       ;
               
               var generalLabel:String = null;
               if (toDeepInto)
                  generalLabel = vi.GetLongName ();
               
               var campatible:Boolean = variableDefinition.IsCompatibleWith (viDef) || viDef.IsCompatibleWith (variableDefinition);
               if (inPhaseForAddingVariablesOfOtherClasses)
                  campatible = ! campatible;
               
               if (campatible)
               {
                  item = new Object ();
                  
                  if (labelPrefix == null)
                  {
                     item.label = generalLabel == null ? vi.GetLongName () : generalLabel;
                     //item.mIndex = i; // bug
                     item.mVariableInstance = vi;
                     item.mProperty = -1;
                  }
                  else
                  {
                     item.label = labelPrefix + " [" + i + "] " + vi.GetName ();
                     //item.mIndex = propertyOwnerViIndex; // bug
                     item.mVariableInstance = propertyOwnerVi;
                     item.mProperty = i;
                  }
                  
                  dataList.push (item);
               }
               
               if (toDeepInto)
               {
                  //if ((viDef as VariableDefinition_Custom).GetCustomProperties ().HasVariablesSatisfiedBy (variableDefinition, false, inPhaseForAddingVariablesOfOtherClasses))
                  //{
                     (viDef as VariableDefinition_Custom).GetCustomProperties ().GetVariableSelectListDataProvider (variableDefinition, //null, 
                                                                                       generalLabel, vi, inPhaseForAddingVariablesOfOtherClasses, dataList);
                  //}
               }
            }
         }
         
         return dataList;
      }
      
      public static function VariableIndex2SelectListSelectedIndex (selectListDataProvider:Array, variableInstance:VariableInstance, propertyIndex:int = -1):int
      {
         for (var i:int = 0; i < selectListDataProvider.length; ++ i)
         {
            var item:Object = selectListDataProvider[i];
            if (item.mVariableInstance == variableInstance && item.mProperty == propertyIndex)
               return i;
         }
         
         return 0; // null
      }
      
      public function RetrieveValueForVariableValueSource (variableValueSource:ValueSource_Variable, selectItem:Object):void
      {
         var currentVariable:VariableInstance = variableValueSource.GetVariableInstance ();
         var variable_space:VariableSpace = currentVariable.GetVariableSpace ();
         
         variableValueSource.ClearProperty ();
         
         var vi:VariableInstance = selectItem.mVariableInstance;
         if (vi.GetIndex () < 0)
         {
            variableValueSource.SetVariableInstance (variable_space.GetNullVariableInstance ());
            return;
         }
         
         variableValueSource.SetVariableInstance (vi);
         
         if (selectItem.mProperty >= 0)
         {
            variableValueSource.SetPropertyIndex (selectItem.mProperty);
         }
      }
      
      public function RetrieveValueForVariableValueTarget (variableValueTarget:ValueTarget_Variable, selectItem:Object):void
      {
         var currentVariable:VariableInstance = variableValueTarget.GetVariableInstance ();
         var variable_space:VariableSpace = currentVariable.GetVariableSpace ();
         
         variableValueTarget.ClearProperty ();
         
         var vi:VariableInstance = selectItem.mVariableInstance;
         if (vi.GetIndex () < 0)
         {
            variableValueTarget.SetVariableInstance (variable_space.GetNullVariableInstance ());
            return;
         }
         
         variableValueTarget.SetVariableInstance (vi);
         
         if (selectItem.mProperty >= 0)
         {
            variableValueTarget.SetPropertyIndex (selectItem.mProperty);
         }
      }
      
      //public static function CreateSelectionListItemValue (variableInstanceIndex:int, propertyVariableInstanceIndex:int = -1):int
      //{
      //   if (variableInstanceIndex < 0 || variableInstanceIndex > 0xFFFF)
      //      return -1;
      //   
      //   if (propertyVariableInstanceIndex < 0)
      //      return variableInstanceIndex;
      //   else
      //      return (propertyVariableInstanceIndex << 16) | variableInstanceIndex;
      //}
      
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
      // if createIfNotExist is false or classType is core, scene can be null.
      public function GetVariableInstanceByTypeAndName (scene:Scene, classType:int, valueType:int, variableName:String, createIfNotExist:Boolean = false):VariableInstance
      {
         for (var variableId:int = mVariableInstances.length - 1; variableId >= 0; -- variableId)
         {
            var variable_instance:VariableInstance = mVariableInstances [variableId];
            if (variable_instance.GetClassType () == classType && variable_instance.GetValueType () == valueType && variable_instance.GetName () == variableName)
               return variable_instance;
         }
       
         if (createIfNotExist)
         {
            //var variableDefinition:VariableDefinition = VariableDefinition.CreateCoreVariableDefinition (valueType, variableName);
            var variableDefinition:VariableDefinition = CodeLibManager.CreateVariableDefinition (scene.GetCodeLibManager (), classType, valueType, variableName);
            var newVi:VariableInstance = CreateVariableInstanceFromDefinition (null, variableDefinition);
            //newVi.SetValueObject (VariableDefinition.GetDefaultInitialValueByType (valueType));
            //newVi.SetValueObject (World.GetCoreClassById (valueType).GetInitialInstacneValue ());
            
            return newVi;
         }
         
         return mNullVariableInstance;
      }
      
      //public function GetVariableInstanceByTypeAndKey (valueType:int, variableKey:String, variableName:String, createIfNotExist:Boolean = false):VariableInstance
      public function GetVariableInstanceByDefinitionAndKey (variableDefinition:VariableDefinition, variableKey:String, createIfNotExist:Boolean = false):VariableInstance
      {
         if (IsVariableKeySupported ())
         {
            if (variableKey != null && variableKey.length > 0)
            {
               var variable_instance:VariableInstance = mLookupTableByKey [variableKey];
               if (variable_instance != null && variable_instance.GetClassType () == variableDefinition.GetClassType () && variable_instance.GetValueType () == variableDefinition.GetValueType ())
                  return variable_instance;
            }
            
            if (createIfNotExist)
            {
               //var variableDefinition:VariableDefinition = VariableDefinition.CreateCoreVariableDefinition (valueType, variableName);
               var newVi:VariableInstance = CreateVariableInstanceFromDefinition (variableKey, variableDefinition);
               //newVi.SetValueObject (VariableDefinition.GetDefaultInitialValueByType (valueType));
               //newVi.SetValueObject (World.GetCoreClassById (valueType).GetInitialInstacneValue ());
               
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
               vi = GetVariableInstanceByDefinitionAndKey (variableDefinition, key);
               if (vi != null && vi != mNullVariableInstance)
               {
                  return vi;
               }
            }
            else
            {
               vi = GetVariableInstanceByTypeAndName (null, variableDefinition.GetClassType (), variableDefinition.GetValueType (), variableDefinition.GetName ());
               if (vi != null && vi != mNullVariableInstance)
               {
                  return vi;
               }
            }
         }
         
         // ...
         
         vi = new VariableInstance (this, mVariableInstances.length, variableDefinition);
         vi.SetValueObject (variableDefinition.GetClass ().GetInitialInstacneValue ());
         
         ValidateVariableDefinitionName (variableDefinition);
         mLookupTableByName [variableDefinition.GetName ()] = vi; // vi.GetName () == variableDefinition.GetName ()
         
         //...
         
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
      
      //public function RemoveReferencesOfClass (customClass:ClassDefinition):void
      //{
      //   for (var i:int = GetNumVariableInstances () - 1; i >= 0; -- i)
      //   {
      //      var viDef:VariableDefinition = GetVariableInstanceAt (i).GetVariableDefinition ();
      //      if (viDef.GetClass () == customClass)
      //      {
      //         DestroyVariableInstanceAtIndex (i);
      //      }
      //   }
      //}
      
      public function Validate ():void
      {
         for (var i:int = GetNumVariableInstances () - 1; i >= 0; -- i)
         {
            var viDef:VariableDefinition = GetVariableInstanceAt (i).GetVariableDefinition ();
            
            if (   (( viDef.GetClass () is ClassDefinition_Custom) && (viDef.GetClass ().GetID () < 0))
                || (( viDef.GetClass () is ClassDefinition_Core) && (viDef.GetClass ().GetID () == CoreClassIds.ValueType_Void))
               )
            {
               DestroyVariableInstanceAtIndex (i);
            }
         }
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
      
      private var mLookupTableByName:Dictionary = new Dictionary ();
      
      public function GetVariableInstanceByName (name:String):VariableInstance
      {
         return mLookupTableByName [name] as VariableInstance;
      }
      
      public function ValidateVariableName (name:String):String
      {  
         var baseName:String = name + " ";
         var i:int = 1;
         while (mLookupTableByName [name] != null)
         {
            name = baseName + (i ++);
         }
         
         return name;
      }
      
      private function ValidateVariableDefinitionName (variableDefinition:VariableDefinition):void
      {
         var name:String = variableDefinition.GetName ();
         if (name == null || name.length == 0)
         {
            name = variableDefinition.GetClass ().GetDefaultInstanceName ();
         }
         
         variableDefinition.SetName (ValidateVariableName (name));
      }
      
      internal function ChangeVariableName (vi:VariableInstance, newName:String):void
      {
         if (newName == vi.GetName ())
            return;
         
         delete mLookupTableByName [vi.GetName ()];
         
         vi.GetVariableDefinition ().SetName (newName);
         ValidateVariableDefinitionName (vi.GetVariableDefinition ());
         
         mLookupTableByName [vi.GetName ()] = vi; // vi.GetName () == vi.GetVariableDefinition ().GetName ()
      }
      
   }
}

