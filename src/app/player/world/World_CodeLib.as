
      public function GetWorldCrossStagesData ():Object
      {
         return {
               mWorldVariableSpace : mWorldVariableSpace,
               mGameSaveVariableSpace : mGameSaveVariableSpace,
               mGameSaveVariableSpace_WithInitialValues : mGameSaveVariableSpace_WithInitialValues,
               
               mSessionVariableSpace : mSessionVariableSpace
            };
      }
      
      public function SetWorldCrossStagesData (isRestartLevel:Boolean, dontReloadGlobalAssets:Boolean, worldCrossSessionsData:Object):void
      {
         if (dontReloadGlobalAssets)
         {
            mWorldVariableSpace = worldCrossSessionsData.mWorldVariableSpace;
            mGameSaveVariableSpace = worldCrossSessionsData.mGameSaveVariableSpace;
            mGameSaveVariableSpace_WithInitialValues = worldCrossSessionsData.mGameSaveVariableSpace_WithInitialValues;
         }
         
         if (isRestartLevel)
         {
            mSessionVariableSpace = worldCrossSessionsData.mSessionVariableSpace;
         }
      }
      
      public /*static*/ var mRegisterVariableSpace_Boolean:VariableSpace;
      public /*static*/ var mRegisterVariableSpace_String :VariableSpace;
      public /*static*/ var mRegisterVariableSpace_Number :VariableSpace;
      public /*static*/ var mRegisterVariableSpace_Entity :VariableSpace;
      public /*static*/ var mRegisterVariableSpace_CollisionCategory:VariableSpace;
      public /*static*/ var mRegisterVariableSpace_Array:VariableSpace;
      
      public /*static*/ var mWorldVariableSpace:VariableSpace;
      public /*static*/ var mGameSaveVariableSpace:VariableSpace;
         private /*static*/ var mGameSaveVariableSpace_WithInitialValues:VariableSpace;
      
      public /*static*/ var mSessionVariableSpace:VariableSpace;
      
      //public /*static*/ var mGlobalVariableSpaces:Array;
      public /*static*/ var mGlobalVariableSpace:VariableSpace;
      public /*static*/ var mCommonGlobalVariableSpace:VariableSpace;
      
      //public /*static*/ var mEntityVariableSpaces:Array;
      public /*static*/ var mEntityVariableSpace:VariableSpace;
      public /*static*/ var mCommonEntityVariableSpace:VariableSpace;
                  // consider scene mergings, the above two are also world related.
      
      public /*static*/ var mCustomClassDefinitions:Array;
      
      public /*static*/ var mCustomFunctionDefinitions:Array;
      
      protected /*static*/ function CreateRegisterVariableSpace (initValueObject:Object, classDefinition:ClassDefinition):VariableSpace
      {
         var vs:VariableSpace = new VariableSpace (Define.NumRegistersPerVariableType);
         var vi:VariableInstance;
         var varDeclaration:VariableDeclaration;
         
         for (var i:int = 0; i < Define.NumRegistersPerVariableType; ++ i)
         {
            vi = vs.GetVariableByIndex (i);
               // must be not null (VariableInstance.kVoidVariableInstance).
            
            varDeclaration = new VariableDeclaration (classDefinition);
            varDeclaration.SetIndex (i);
            //varDeclaration.SetKey (variableDefine.mKey);
            //varDeclaration.SetName (variableDefine.mName);

            vi.SetDeclaration (varDeclaration);                  
            
            vi.SetValueObject (initValueObject);
            vi.SetRealClassDefinition (classDefinition); // !!! otherwise, reg variables will trated as void in compare
         }
         
         return vs;
      }
      
      public /*static*/ function GetRegisterVariableSpace (valueType:int):VariableSpace
      {
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               return mRegisterVariableSpace_Boolean;
            case CoreClassIds.ValueType_String:
               return mRegisterVariableSpace_String;
            case CoreClassIds.ValueType_Number:
               return mRegisterVariableSpace_Number;
            case CoreClassIds.ValueType_Entity:
               return mRegisterVariableSpace_Entity;
            case CoreClassIds.ValueType_CollisionCategory:
               return mRegisterVariableSpace_CollisionCategory;
            case CoreClassIds.ValueType_Array:
               return mRegisterVariableSpace_Array;
            default:
               return null;
         }
      }
      
      // playerWorld is only useful for switch or merge levels.
      public /*static*/ function InitWorldCustomVariables (playerWorld:World, worldVarialbeSpaceDefines:Array, gameSaveVarialbeSpaceDefines:Array):void
      {
         if (mWorldVariableSpace == null)
         {
            mWorldVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/null, worldVarialbeSpaceDefines, null, 0); // 0 is meaningless
         }
         else // switch/restart level
         {
            TriggerFormatHelper2.ValidateVariableSpaceInitialValues (/*mCurrentWorld*/playerWorld, mWorldVariableSpace, worldVarialbeSpaceDefines, true, false);          
         }
         
         if (mGameSaveVariableSpace == null)
         {
            mGameSaveVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/null, gameSaveVarialbeSpaceDefines, null, 0, // 0 is meaningless
                                                                                          true); // support key mapping from v2.05. In fact, it can supported from v2.00
            mGameSaveVariableSpace_WithInitialValues = mGameSaveVariableSpace.CloneSpace ();
         }
         else // switch/restart level
         {
            TriggerFormatHelper2.ValidateVariableSpaceInitialValues (/*mCurrentWorld*/playerWorld, mGameSaveVariableSpace, gameSaveVarialbeSpaceDefines, true, false);
         }
      }
      
      //public /*static*/ function InitSceneCustomVariables (globalVarialbeSpaceDefines:Array, entityVarialbeSpaceDefines:Array):void // v1.52 only
      public /*static*/ function InitSceneCustomVariables (playerWorld:World, 
                                                      globalVarialbeDefines:Array, commonGlobalVarialbeDefines:Array, entityVarialbeDefines:Array, commonEntityVarialbeDefines:Array, 
                                                      sessionVariableDefines:Array, sessionVariableIndexMappingTable:Array,  // sessionVariableDefines added from v1.57
                                                      isMerging:Boolean/* = false*/,
                                                      customClassIdShiftOffset:int):void // customClassIdShiftOffset added from v2.05
      {
         //>> v1.52 only
         //var numSpaces:int;
         //
         //numSpaces = globalVarialbeSpaceDefines.length;
         //mGlobalVariableSpaces = new Array (numSpaces);
         //
         //for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
         //{
         //   mGlobalVariableSpaces [spaceId] = TriggerFormatHelper2.VariableSpaceDefine2VariableSpace (/*mCurrentWorld*/playerWorld, globalVarialbeSpaceDefines [spaceId] as VariableSpaceDefine);
         //}
         //
         //numSpaces = entityVarialbeSpaceDefines.length;
         //mEntityVariableSpaces = new Array (numSpaces);
         //
         //for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
         //{
         //   mEntityVariableSpaces [spaceId] = TriggerFormatHelper2.VariableSpaceDefine2VariableSpace (/*mCurrentWorld*/playerWorld, entityVarialbeSpaceDefines [spaceId] as VariableSpaceDefine);
         //}
         //<<
         
         if (mSessionVariableSpace == null) // load from stretch
         {
            mSessionVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/playerWorld, sessionVariableDefines, null, customClassIdShiftOffset, true);
         }
         else // restart level or merge level
         {
            if (isMerging)
            {
               // todo: for session, should use the CreatePnlyOnNotExist policy.
               
               mSessionVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/playerWorld, sessionVariableDefines, mSessionVariableSpace, customClassIdShiftOffset, true, sessionVariableIndexMappingTable);
            }
            else
            {
               // reevaluate placed-in-editor entities and ccats
               // nullify non-placed-in-editor entities and ccats
               // potiential decision: discard session variables since a later version, use Game_Data_Save API alikes instead. 
   
               TriggerFormatHelper2.ValidateVariableSpaceInitialValues (/*mCurrentWorld*/playerWorld, mSessionVariableSpace, sessionVariableDefines, false, true);
            }
         }
         
         mGlobalVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/playerWorld, globalVarialbeDefines, isMerging ? mGlobalVariableSpace : null, customClassIdShiftOffset);
         mEntityVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/playerWorld, entityVarialbeDefines, isMerging ? mEntityVariableSpace : null, customClassIdShiftOffset);
         if (! isMerging)
         {
            mCommonGlobalVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/playerWorld, commonGlobalVarialbeDefines, null, customClassIdShiftOffset);
            mCommonEntityVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/playerWorld, commonEntityVarialbeDefines, null, customClassIdShiftOffset);
         }
      }
      
      public /*static*/ function GetWorldVariableSpace ():VariableSpace
      {
         return mWorldVariableSpace;
      }
      
      public /*static*/ function GetGameSaveVariableSpace ():VariableSpace
      {
         return mGameSaveVariableSpace;
      }
      
      public /*static*/ function ResetGameSaveVariableSpace ():void
      {
         if (mGameSaveVariableSpace_WithInitialValues != null) // shouldn't
         {
            mGameSaveVariableSpace = mGameSaveVariableSpace_WithInitialValues.CloneSpace ();
         }
      }
      
      public /*static*/ function GetSessionVariableSpace ():VariableSpace
      {
         return mSessionVariableSpace;
      }
      
      public /*static*/ function GetGlobalVariableSpace ():VariableSpace
      {
         //>> v1.52 only
         //if (spaceId < 0 || spaceId >= mGlobalVariableSpaces.length)
         //   return null;
         //
         //return mGlobalVariableSpaces [spaceId] as VariableSpace;
         //<<
         
         return mGlobalVariableSpace;
      }
      
      public /*static*/ function GetCommonGlobalVariableSpace ():VariableSpace
      {
         return mCommonGlobalVariableSpace;
      }
      
      public /*static*/ function GetCustomEntityVariableSpace ():VariableSpace
      {
         return mEntityVariableSpace;
      }
      
      public /*static*/ function GetCommonCustomEntityVariableSpace ():VariableSpace
      {
         return mCommonEntityVariableSpace;
      }
      
      //>> v1.52 only
      //// propertyValues should not be null
      //public /*static*/ function InitEntityPropertyValues (proeprtySpaces:Array):void
      //{
      //   var numSpaces:int = mEntityVariableSpaces.length;
      //   
      //   proeprtySpaces.length = numSpaces;
      //   for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
      //   {
      //      proeprtySpaces [spaceId] = (mEntityVariableSpaces [spaceId] as VariableSpace).CloneSpace ();
      //   }
      //}
      //<<
      
      //public /*static*/ function CloneEntityPropertyInitialValues ():VariableSpace
      //{
      //   return mEntityVariableSpace.CloneSpace ();
      //}
      
      public /*static*/ function GetDefaultEntityPropertyValue (spaceId:int, propertyId:int):Object
      {
         var vi:VariableInstance;
         
         if (spaceId == ValueSpaceTypeDefine.ValueSpace_CommonEntityProperties)
            vi = mCommonEntityVariableSpace.GetVariableByIndex (propertyId);
         else // if (spaceId == ValueSpaceTypeDefine.ValueSpace_EntityProperties) or 0
            vi = mEntityVariableSpace.GetVariableByIndex (propertyId);
         
         //return vi == null ? null : vi.GetValueObject ();
         return vi.GetValueObject (); // vi must be not null now. it may be VariableInstance.kVoidVariableInstance.
      }
      
      // custom classes
      
      public /*static*/ function InitCustomClassDefinitions (playerWorld:World, classDefines:Array, isMerging:Boolean):void
      {
         var numNewClasses:int = classDefines.length;
         var numOldClasses:int = mCustomClassDefinitions == null ? 0 : mCustomClassDefinitions.length;
         if (isMerging)
         {
            mCustomClassDefinitions.length = numOldClasses + numNewClasses;
         }
         else
         {
            mCustomClassDefinitions = new Array (numNewClasses);
         }
         
         var classId:int;
         var newClassId:int;
         var classDefine:ClassDefine;
         var customClass:ClassDefinition_Custom;
         for (classId = 0; classId < numNewClasses; ++ classId)
         {
            newClassId = numOldClasses + classId;
            classDefine = classDefines [classId] as ClassDefine;
            mCustomClassDefinitions [newClassId] = new ClassDefinition_Custom (newClassId, classDefine.mName);
         }

         for (classId = 0; classId < numNewClasses; ++ classId)
         {
            newClassId = numOldClasses + classId;
            customClass = /*Global*/this.GetCustomClassDefinition (newClassId);
            
            customClass.SetParentClasses ([CoreClasses.kObjectClassDefinition]);
            
            classDefine = classDefines [classId] as ClassDefine;
            customClass.SetPropertyVariableSpaceTemplate (TriggerFormatHelper2.VariableDefines2VariableSpace (/*mCurrentWorld*/playerWorld, classDefine.mPropertyVariableDefines, null, numOldClasses));
         }

         for (classId = 0; classId < numNewClasses; ++ classId)
         {
            newClassId = numOldClasses + classId;
            customClass = /*Global*/this.GetCustomClassDefinition (newClassId);

            customClass.FindAncestorClasses ();
         }
      }
      
      public /*static*/ function GetNumCustomClasses ():int
      {
         return mCustomClassDefinitions == null ? 0 : mCustomClassDefinitions.length;
      }
      
      public /*static*/ function GetCustomClassDefinition (classId:int):ClassDefinition_Custom
      {
         if (classId < 0 || mCustomClassDefinitions == null || classId >= mCustomClassDefinitions.length)
            return null;
         
         return mCustomClassDefinitions [classId] as ClassDefinition_Custom;
      }
      
      // custom functions
      
      public /*static*/ function CreateCustomFunctionDefinitions (playerWorld:World, functionDefines:Array, isMerging:Boolean, customClassIdShiftOffset:int):void
      {
         var numOldFunctions:int = mCustomFunctionDefinitions == null ? 0 : mCustomFunctionDefinitions.length;
         var numNewFunctions:int = functionDefines.length;
         if (isMerging)
         {
            mCustomFunctionDefinitions.length = numOldFunctions + numNewFunctions;
         }
         else
         {
            mCustomFunctionDefinitions = new Array (numNewFunctions);
         }
         
         for (var functionId:int = 0; functionId < numNewFunctions; ++ functionId)
         {
            mCustomFunctionDefinitions [numOldFunctions + functionId] = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (/*mCurrentWorld*/playerWorld, functionDefines [functionId] as FunctionDefine, null, customClassIdShiftOffset);
         }
      }
      
      public /*static*/ function GetNumCustomFunctions ():int
      {
         return mCustomFunctionDefinitions == null ? 0 : mCustomFunctionDefinitions.length;
      }
      
      public /*static*/ function GetCustomFunctionDefinition (functionId:int):FunctionDefinition_Custom
      {
         if (functionId < 0 || mCustomFunctionDefinitions == null || functionId >= mCustomFunctionDefinitions.length)
            return null;
         
         return mCustomFunctionDefinitions [functionId] as FunctionDefinition_Custom;
      }

//==============================================================================
// 
//==============================================================================
   
   public /*static*/ function GetSavedData ():ByteArray
   {
      try
      {
         var binData:ByteArray = new ByteArray ();
         
         // data format version
         // binData.writeShort (0); // before v2.05 (custom classes not supported yet)
         binData.writeShort (1); // since v2.05 (add support for custom classes), totally compatible with version 0
         
         var alreadySavedArrayLookupTable:Dictionary = new Dictionary ();
         
         var numVariables:int = mGameSaveVariableSpace.GetNumVariables ();
         binData.writeInt (numVariables);
         for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         {
            var variableInstance:VariableInstance = mGameSaveVariableSpace.GetVariableByIndex (variableId) as VariableInstance;
                  // must be not null (VariableInstance.kVoidVariableInstance)
                  
            binData.writeUTF (variableInstance.GetDeclaration ().GetKey ());

            WriteTypeAndValue (binData, variableInstance.GetRealClassType (), variableInstance.GetRealValueType (), variableInstance.GetValueObject (), alreadySavedArrayLookupTable);
         }
         
         return binData;
      }
      catch (error:Error)
      {
         trace ("GetSavedData error: " + error.getStackTrace ());
         
         if (Capabilities.isDebugger)
            throw error;
      }
      
      return null;
   }
   
   private /*static*/ function WriteTypeAndValue (binData:ByteArray, classType:int, valueType:int, value:Object, alreadySavedArrayLookupTable:Dictionary):void
   {
      if (classType != ClassTypeDefine.ClassType_Core) // only core types supported now.
         valueType = CoreClassIds.ValueType_Void;
         
      switch (valueType)
      {
         case CoreClassIds.ValueType_Boolean:
            binData.writeShort (CoreClassIds.ValueType_Boolean);
            binData.writeByte (Boolean (value) ? 1 : 0);
            break;
         case CoreClassIds.ValueType_Number:
            binData.writeShort (CoreClassIds.ValueType_Number);
            binData.writeDouble (Number (value));
            break;
         case CoreClassIds.ValueType_String:
            binData.writeShort (CoreClassIds.ValueType_String);
            var text:String = value as String;
            binData.writeInt (text == null ? -1 : text.length);
            if (text != null)
            {
               binData.writeUTFBytes (text);
            }
            break;
         case CoreClassIds.ValueType_Array:
            var valuesArray:Array = value as Array;
            if (alreadySavedArrayLookupTable [valuesArray] == true)
            {
               binData.writeShort (CoreClassIds.ValueType_Void);
            }
            else
            {
               if (! CoreClasses.kArrayClassDefinition.mIsNullFunc (valuesArray))
               {
                  alreadySavedArrayLookupTable [valuesArray] = true;
               }

               binData.writeShort (CoreClassIds.ValueType_Array);
               binData.writeInt (valuesArray == null ? -1 : valuesArray.length);
               if (valuesArray != null)
               {
                  //for each (var arrValue:Object in valuesArray) // faint! bug: undefined value is not iterated.
                  for (var i:int = 0; i < valuesArray.length; ++ i)
                  {
                     // before v2.05
                     //
                     //var arrValue:Object = valuesArray [i];
                     //
                     //if (arrValue is Boolean)
                     //{
                     //   WriteTypeAndValue (binData, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Boolean, arrValue, alreadySavedArrayLookupTable);
                     //}
                     //else if (arrValue is Number)
                     //{
                     //   WriteTypeAndValue (binData, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Number, arrValue, alreadySavedArrayLookupTable);
                     //}
                     //else if (arrValue is String)
                     //{
                     //   WriteTypeAndValue (binData, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_String, arrValue, alreadySavedArrayLookupTable);
                     //}
                     //else if (arrValue is Array)
                     //{
                     //   WriteTypeAndValue (binData, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Array, arrValue, alreadySavedArrayLookupTable);
                     //}
                     //else
                     //{
                     //   WriteTypeAndValue (binData, ClassTypeDefine.ClassType_Core, CoreClassIds.ValueType_Void, null, alreadySavedArrayLookupTable);
                     //}
                     
                     // since v2.05
                     
                     var arrayElement:ClassInstance = CoreClasses.GetArrayElement (valuesArray, i);
                     
                     WriteTypeAndValue (binData, arrayElement.GetRealClassType (), arrayElement.GetRealValueType (), arrayElement.GetValueObject (), alreadySavedArrayLookupTable);
                  }
               }
            }
            break;
         default:
         {
            binData.writeShort (CoreClassIds.ValueType_Void);
            break;
         }
      }      
   }
   
   public /*static*/ function SetSavedData (savedData:ByteArray):void
   {
      if (savedData == null)
         return;
      
      var savedVariables:Array = null;
      var numSavedVariables:int;
      var savedVariableId:int;
      
      try
      {
         savedData.position = 0;
         var dataFormatVersion:int = savedData.readShort ();
         
         numSavedVariables = savedData.readInt ();
         savedVariables = new Array (numSavedVariables);
         for (savedVariableId = 0; savedVariableId < numSavedVariables; ++ savedVariableId)
         {
            var key:String = savedData.readUTF ();
            
            var ci:ClassInstance = ReadNextVariableValue (savedData, false);

            savedVariables [savedVariableId] = {mKey: key, mClassInstance: ci};
         }
      }
      catch (error:Error)
      {
         trace ("GetSavedData error: " + error.getStackTrace ());
         
         if (Capabilities.isDebugger)
            throw error;
         
         savedVariables = null;
      }
      
      if (savedVariables != null)
      {
         var variableInstance:VariableInstance;
         
         //var variableLookupTable:Dictionary = new Dictionary ();
         //var numVariables:int = mGameSaveVariableSpace.GetNumVariables ();
         //for (var variableId:int = 0; variableId < numVariables; ++ variableId)
         //{
         //   variableInstance = mGameSaveVariableSpace.GetVariableByIndex (variableId);
         //   variableLookupTable [variableInstance.GetKey ()] = variableInstance;
         //}
            // now key support is available for variable space.
         
         for (savedVariableId = 0; savedVariableId < numSavedVariables; ++ savedVariableId)
         {
            var savedVariable:Object = savedVariables [savedVariableId];
            
            //variableInstance = variableLookupTable [savedVariable.mKey];
            variableInstance = mGameSaveVariableSpace.GetVariableByKey (savedVariable.mKey);
            
            //if (variableInstance != null) // now must not be null, may be VariableInstance.kVoidVariableInstance
            //{
               //variableInstance.SetValueObject (savedVariable.mClassInstance.mValueObject);
               var classInstance:ClassInstance = savedVariable.mClassInstance as ClassInstance;
               //variableInstance.Assign (classInstance.GetRealClassDefinition (), classInstance.GetValueObject ());
               CoreClasses.AssignValue (classInstance, variableInstance);
            //}
         } // for
      }
   }
   
   private /*static*/ function ReadNextVariableValue (savedData:ByteArray, forArrayElement:Boolean):ClassInstance
   {
      var type:int = savedData.readShort ();
      var value:Object;
      
      switch (type)
      {
         case CoreClassIds.ValueType_Boolean:
            value = savedData.readByte () != 0;
            break;
         case CoreClassIds.ValueType_Number:
            value = savedData.readDouble ();
            break;
         case CoreClassIds.ValueType_String:
            var strLen:int = savedData.readInt ();
            if (strLen < 0)
               value = null;
            else
            {
               value = savedData.readUTFBytes (strLen);
            }
            break;
         case CoreClassIds.ValueType_Array:
            var arrLen:int = savedData.readInt ();
            if (arrLen < 0)
               value = null;
            else
            {
               var valuesArray:Array = new Array (arrLen);
               for (var i:int = 0; i < arrLen; ++ i)
               {
                  valuesArray [i] = ReadNextVariableValue (savedData, true);
               }
               
               value = valuesArray ;
            }
            
            break;
         default:
         {
            value = null;
         }
      } 
      
      var ci:ClassInstance;
      if (forArrayElement && value == null)
         ci = null;
      else
      {
         ci = new ClassInstance ();
         ci.SetRealClassDefinition (CoreClasses.GetCoreClassDefinition (type));
         ci.SetValueObject (value);
      }
      
      return ci;
   }
   