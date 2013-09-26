package player.trigger {

   import flash.utils.ByteArray;
   import flash.utils.Dictionary;

   import player.design.Global;
   import player.world.World;
   import player.world.CollisionCategory;
   
   import player.entity.Entity;

   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   import common.trigger.ClassDeclaration;
   import common.trigger.CoreClassDeclarations;

   import common.Define;

   public class CoreClasses
   {
      public static const kVoidClassDefinition:ClassDefinition_Core = new ClassDefinition_Core (CoreClassDeclarations.GetCoreClassDeclarationById (CoreClassIds.ValueType_Void));
      public static const kObjectClassDefinition:ClassDefinition_Core = new ClassDefinition_Core (CoreClassDeclarations.GetCoreClassDeclarationById (CoreClassIds.ValueType_Object));
      private static var sCoreClassDefinitions:Array = null;
      
      public static function InitCoreClassDefinitions ():void
      {
         if (sCoreClassDefinitions != null)
            return;
         
         // ...
         
         var classId:int;
         var classDef:ClassDefinition_Core;
         
         sCoreClassDefinitions = new Array (CoreClassIds.NumCoreClasses);
         for (classId = 0; classId < CoreClassIds.NumCoreClasses; ++ classId)
         {
            if (classId == CoreClassIds.ValueType_Void)
            {
               sCoreClassDefinitions [classId] = kVoidClassDefinition;
               continue;
            }
            else if (classId == CoreClassIds.ValueType_Object)
            {
               sCoreClassDefinitions [classId] = kObjectClassDefinition;
               continue;
            }
            
            var coreDecl:ClassDeclaration = CoreClassDeclarations.GetCoreClassDeclarationById (classId);
            if (coreDecl != null)
            {
               if (coreDecl.GetID () != classId) // void
                  continue;

               sCoreClassDefinitions [classId] = new ClassDefinition_Core (coreDecl);
            }
         }
         
         // ...         
         
         for (classId = 0; classId < CoreClassIds.NumCoreClasses; ++ classId)
         {
            classDef = GetCoreClassDefinition (classId);
            if (classDef.GetID () == classId)
            {
               classDef.SetParentClasses ([kObjectClassDefinition]);
            }
         }
                  
         for (classId = 0; classId < CoreClassIds.NumCoreClasses; ++ classId)
         {
            classDef = GetCoreClassDefinition (classId);
            if (classDef.GetID () == classId)
            {
               classDef.FindAncestorClasses ();
            }
         }
         
         // ...      
         
         for (classId = 0; classId < CoreClassIds.NumCoreClasses; ++ classId)
         {
            classDef = GetCoreClassDefinition (classId);
            if (classDef.GetID () == classId)
            {
               // set default ones
               classDef.mToNumberFunc = Object2Number;
               classDef.mToBooleanFunc = Object2Boolean;
               classDef.mToStringFunc = Object2String;
               classDef.mIsNullFunc = IsNullObjectValue;
               classDef.mGetNullFunc = GetNullObjectValue;
               
               classDef.mValueConvertOrder = ClassDefinition.ValueConvertOrder_Others;
            }
         }
         
         for each (var assetClassId:int in [CoreClassIds.ValueType_Module, 
                                            CoreClassIds.ValueType_Sound, 
                                            CoreClassIds.ValueType_Scene]
                                            )
         {
            GetCoreClassDefinition (assetClassId).mToNumberFunc = Asset2Number;
            GetCoreClassDefinition (assetClassId).mToBooleanFunc = Asset2Boolean;
            GetCoreClassDefinition (assetClassId).mToStringFunc = Asset2String;
            GetCoreClassDefinition (assetClassId).mIsNullFunc = IsNullAssetValue;
            GetCoreClassDefinition (assetClassId).mGetNullFunc = GetNullAssetValue;
         }
         
         GetCoreClassDefinition (CoreClassIds.ValueType_Entity).mToStringFunc = Entity2String;
         GetCoreClassDefinition (CoreClassIds.ValueType_CollisionCategory).mToStringFunc = CCat2String;
         GetCoreClassDefinition (CoreClassIds.ValueType_Array).mToStringFunc = Array2String;
         
         for each (var primitiveClassId:int in [CoreClassIds.ValueType_Boolean, 
                                                CoreClassIds.ValueType_Number, 
                                                CoreClassIds.ValueType_String]
                                                )
         {
            GetCoreClassDefinition (primitiveClassId).mIsNullFunc = null;
            GetCoreClassDefinition (primitiveClassId).mGetNullFunc = null;
         }
         
         GetCoreClassDefinition (CoreClassIds.ValueType_Boolean).mToNumberFunc = Boolean2Number;
         GetCoreClassDefinition (CoreClassIds.ValueType_Boolean).mToBooleanFunc = DoNothing;
         GetCoreClassDefinition (CoreClassIds.ValueType_Boolean).mToStringFunc = Boolean2String;
         GetCoreClassDefinition (CoreClassIds.ValueType_Boolean).mValueConvertOrder = ClassDefinition.ValueConvertOrder_Boolean;
         
         GetCoreClassDefinition (CoreClassIds.ValueType_Number).mToNumberFunc = DoNothing;
         GetCoreClassDefinition (CoreClassIds.ValueType_Number).mToBooleanFunc = Number2Boolean;
         GetCoreClassDefinition (CoreClassIds.ValueType_Number).mToStringFunc = Number2String;
         GetCoreClassDefinition (CoreClassIds.ValueType_Number).mValueConvertOrder = ClassDefinition.ValueConvertOrder_Number;
         
         GetCoreClassDefinition (CoreClassIds.ValueType_String).mToNumberFunc = String2Number;
         GetCoreClassDefinition (CoreClassIds.ValueType_String).mToBooleanFunc = String2Boolean;
         GetCoreClassDefinition (CoreClassIds.ValueType_String).mToStringFunc = DoNothing;
         GetCoreClassDefinition (CoreClassIds.ValueType_String).mValueConvertOrder = ClassDefinition.ValueConvertOrder_String;
         
         // ...
         
         // use constants instead now.
         //GetSceneClassDefinition ();
         //GetEntityClassDefinition ();
         //GetCCatClassDefinition ();
         //GetArrayClassDefinition ();
         //GetModuleClassDefinition ();
         //GetBooleanClassDefinition ();
         //GetNumberClassDefinition ();
         //GetStringClassDefinition ();
         
         //var iii:int = 999;
         //trace ("iii as Number = " + (iii as Number)); // no null (0), still is 999. good.
      }
      
      public static function GetCoreClassDefinition (coreClassId:int):ClassDefinition_Core
      {
         InitCoreClassDefinitions ();
         
         var classDefinition:ClassDefinition_Core = sCoreClassDefinitions [coreClassId] as ClassDefinition_Core;
         return classDefinition == null ? kVoidClassDefinition : classDefinition;
      }
      
      //======
      
      public static const kSceneClassDefinition:ClassDefinition_Core = GetCoreClassDefinition (CoreClassIds.ValueType_Scene);
      //public static function GetSceneClassDefinition ():ClassDefinition_Core // should be called in InitCoreClassDefinitions ()
      //{
      //   if (sSceneClassDefinition == null)
      //      sSceneClassDefinition = GetCoreClassDefinition (CoreClassIds.ValueType_Scene);
      //   
      //   return sSceneClassDefinition;
      //}
      
      public static const kEntityClassDefinition:ClassDefinition_Core = GetCoreClassDefinition (CoreClassIds.ValueType_Entity);
      //public static function GetEntityClassDefinition ():ClassDefinition_Core // should be called in InitCoreClassDefinitions ()
      //{
      //   if (sEntityClassDefinition == null)
      //      sEntityClassDefinition = GetCoreClassDefinition (CoreClassIds.ValueType_Entity);
      //   
      //   return sEntityClassDefinition;
      //}
      
      public static const kCCatClassDefinition:ClassDefinition_Core = GetCoreClassDefinition (CoreClassIds.ValueType_CollisionCategory);
      //public static function GetCCatClassDefinition ():ClassDefinition_Core // should be called in InitCoreClassDefinitions ()
      //{
      //   if (sCCatClassDefinition == null)
      //      sCCatClassDefinition = GetCoreClassDefinition (CoreClassIds.ValueType_CollisionCategory);
      //   
      //   return sCCatClassDefinition;
      //}
      
      public static const kArrayClassDefinition:ClassDefinition_Core = GetCoreClassDefinition (CoreClassIds.ValueType_Array);
      //public static function GetArrayClassDefinition ():ClassDefinition_Core // should be called in InitCoreClassDefinitions ()
      //{
      //   if (sArrayClassDefinition == null)
      //      sArrayClassDefinition = GetCoreClassDefinition (CoreClassIds.ValueType_Array);
      //   
      //   return sArrayClassDefinition;
      //}
      
      public static const kModuleClassDefinition:ClassDefinition_Core = GetCoreClassDefinition (CoreClassIds.ValueType_Module);
      //public static function GetModuleClassDefinition ():ClassDefinition_Core // should be called in InitCoreClassDefinitions ()
      //{
      //   if (sModuleClassDefinition == null)
      //      sModuleClassDefinition = GetCoreClassDefinition (CoreClassIds.ValueType_Module);
      //   
      //   return sModuleClassDefinition;
      //}
      
      public static const kBooelanClassDefinition:ClassDefinition_Core = GetCoreClassDefinition (CoreClassIds.ValueType_Boolean);
      //public static function GetBooleanClassDefinition ():ClassDefinition_Core // should be called in InitCoreClassDefinitions ()
      //{
      //   if (sBooelanClassDefinition == null)
      //      sBooelanClassDefinition = GetCoreClassDefinition (CoreClassIds.ValueType_Boolean);
      //   
      //   return sBooelanClassDefinition;
      //}
      
      public static const kNumberClassDefinition:ClassDefinition_Core = GetCoreClassDefinition (CoreClassIds.ValueType_Number);
      //public static function GetNumberClassDefinition ():ClassDefinition_Core // should be called in InitCoreClassDefinitions ()
      //{
      //   if (sNumberClassDefinition == null)
      //      sNumberClassDefinition = GetCoreClassDefinition (CoreClassIds.ValueType_Number);
      //   
      //   return sNumberClassDefinition;
      //}
      
      public static const kStringClassDefinition:ClassDefinition_Core = GetCoreClassDefinition (CoreClassIds.ValueType_String);
      //public static function GetStringClassDefinition ():ClassDefinition_Core // should be called in InitCoreClassDefinitions ()
      //{
      //   if (sStringClassDefinition == null)
      //      sStringClassDefinition = GetCoreClassDefinition (CoreClassIds.ValueType_String);
      //   
      //   return sStringClassDefinition;
      //}
      
//==============================================================
// 
//==============================================================

      // -----------------
      
      public static function DoNothing (valueObject:Object):Object
      {
         return valueObject;
      }
      
      // ------------------
      
      public static function Number2Boolean (valueObject:Object):Boolean
      {
         return Boolean (Number (valueObject));
      }
      
      public static function Boolean2Number (valueObject:Object):Number
      {
         return Boolean (valueObject) ? 1 : 0;
      }      
            
      public static function Number2String (valueObject:Object):String
      {
         return String (Number (valueObject));
      }
      
      public static function String2Number (valueObject:Object):Number
      {
         var str:String = valueObject as String;
         return (str == null || str.length == 0) ? 0 : 1;
      }      
            
      public static function Boolean2String (valueObject:Object):String
      {
         return String (Boolean (valueObject));
      }
      
      public static function String2Boolean (valueObject:Object):Boolean
      {
         var str:String = valueObject as String;
         return (str == null || str.length == 0) ? false : true;
      }
      
      //---------------
      
      public static function Object2Number (valueObject:Object):Number
      {
         return valueObject == null ? 0 : 1;
      }
      
      public static function Object2Boolean (valueObject:Object):Boolean
      {
         return valueObject == null ? false : true;
      }
            
      public static function Object2String (valueObject:Object, className:String, extraInfos:Object):String
      {
         return className;
      }
      
      public static function IsNullObjectValue (valueObject:Object):Boolean
      {
         return valueObject == null;
      }
      
      public static function GetNullObjectValue ():Object
      {
         return null;
      }
      
      //----------------
            
      public static function Asset2Number (valueObject:Object):Number
      {
         return int (valueObject) < 0 ? 0 : 1;
      }
      
      public static function Asset2Boolean (valueObject:Object):Boolean
      {
         return int (valueObject) < 0 ? false : true;
      }
      
      public static function Asset2String (valueObject:Object, className:String, extraInfos:Object):String
      {
         return className + "#" + int (valueObject);
      }
      
      public static function IsNullAssetValue (valueObject:Object):Boolean
      {
         return (valueObject == null) || (int (valueObject) < 0);
      }
      
      public static function GetNullAssetValue ():Object
      {
         return -1;
      }
      
      //--------------
            
      public static function Entity2String (valueObject:Object, className:String, extraInfos:Object):String
      {
         var entity:Entity = valueObject as Entity; // not null for sure
            
         return className + "#" + entity.GetCreationId ();
      }
            
      public static function CCat2String (valueObject:Object, className:String, extraInfos:Object):String
      {
         var ccat:CollisionCategory = valueObject as CollisionCategory; // not null for sure
            
         return className + "#" + ccat.GetIndexInEditor ();
      }
      
      public static function Array2String (valueObject:Object, className:String, extraInfos:Object):String
      {
         var anArray:Array = valueObject as Array; // not null for sure
            
         return className + "#" + ConvertArrayToString (anArray, extraInfos as Dictionary);
      }

      private static function ConvertArrayToString (values:Array, convertedArrays:Dictionary = null):String
      {
         //if (values == null) // not null for sure
         //   return null; // "null";

         var returnText:String = "[";

         var numElements:int = values.length;
         //var value:Object;
         var ci:ClassInstance;
         if (numElements > 0)
         {
            var valuesString:String;
            if (convertedArrays == null)
            {
               convertedArrays = new Dictionary ();
               valuesString = null;
            }
            else
            {
               valuesString = convertedArrays [values];
            }

            if (valuesString != null)
            {
               return valuesString;
            }
            else
            {
               convertedArrays [values] = "(<Array>#length: " + numElements + ")"; // A not good but not worst value. Avoid dead loop.

               var sep:String = "";

               for (var i:int = 0; i < numElements; ++ i)
               {
                  // before v2.05
                  
                  //value = values [i];
                  //
                  //if (value is Array)
                  //   returnText = returnText + sep + ConvertArrayToString (value as Array, convertedArrays);
                  //else if (value is Entity)
                  //   returnText = returnText + sep + (value as Entity).ToString ();
                  ////else if (value is CollisionCategory)
                  ////   returnText = returnText + sep + (value as CollisionCategory).ToString ();
                  //else
                  //   returnText = returnText + sep + String (value);
                  
                  // sicne v2.05
                  
                  ci = GetArrayElement (values, i) as ClassInstance; // must be not null.
                  
                  returnText = returnText + sep + ci._mRealClassDefinition.ToString (ci._mValueObject, convertedArrays);
                  
                  sep = ",";
               }

               convertedArrays [values] = returnText; // correct the value. Avoid dead loop.
            }
         }

         returnText = returnText + "]";

         return returnText;
      }
      
//========================================================
// array special
//========================================================
      
      // todo: create a MyArray class.
      // but can't extend from Array. see b2GrowableStack. (bug on iOS)
      // make sure anArray is not null and index is in [0, anArray.length)
      public static function GetArrayElement (anArray:Array, index:int):ClassInstance
      {
         var element:ClassInstance = anArray [index];
         return element != null ? element : VariableInstanceConstant.kVoidVariableInstance;
      }
      
      // make sure anArray is not null
      public static function CovertArrayElementsToClassInstances (anArray:Array, classDefinition:ClassDefinition):void
      {
         for (var i:int = anArray.length - 1; i >= 0; -- i)
         {
            var element:Object = anArray [i];
            if (element != null)
            {
               anArray [i] = ClassInstance.CreateClassInstance (classDefinition, element);
            }
         }
         
         //return anArray;
      }
      
      // make sure anArray is not null
      public static function CovertClassInstancesToArrayElements (anArray:Array):void
      {
         for (var i:int = anArray.length - 1; i >= 0; -- i)
         {
            var ci:ClassInstance = anArray [i] as ClassInstance;
            anArray [i] = ci == null ? null : ci._mValueObject;
         }
         
         //return anArray;
      }
      
//==============================================================
// these functions are very important.
// they represent the spirit of piapia lang.
//==============================================================
      
      // if value classes are different, auto convert source to target
      public static function AssignValue (sourceCi:ClassInstance, targetVi:VariableInstance):void
      {
         if (sourceCi._mRealClassDefinition == targetVi._mRealClassDefinition) // the most common case
         {
            //targetVi._mValueObject = sourceCi._mValueObject; // bug, constant will be chagned.
            targetVi.SetValueObject (sourceCi._mValueObject);
         }
         else
         {
            var targetShellClass:ClassDefinition = targetVi._mDeclaration._mShellClassDefinition;
            var sourceClass:ClassDefinition = sourceCi._mRealClassDefinition;
            
            if (targetShellClass.mValueConvertOrder == sourceClass.mValueConvertOrder)
            {
               // both are not primitive classes (ClassDefinition.ValueConvertOrder_Others)
               
               if (targetShellClass == sourceClass ||
                  //sourceClass.mExtendOrder > targetShellClass.mExtendOrder &&
                   sourceClass.mAncestorClasses.indexOf (targetShellClass) >= 0)
               {
                  //targetVi._mRealClassDefinition = sourceClass;
                  //targetVi._mValueObject = sourceCi._mValueObject; // bug, constant will be chagned.
                  targetVi.Assign (sourceClass, sourceCi._mValueObject);
               }
               else // not convertable
               {
                  //targetVi._mRealClassDefinition = CoreClasses.kVoidClassDefinition; // targetShellClass
                  //targetVi._mValueObject = null; // targetShellClass.mGetNullValue (); // bug, constant will be chagned.
                  targetVi.Assign (CoreClasses.kVoidClassDefinition, null);
               }
            }
            else if (targetShellClass.mValueConvertOrder == ClassDefinition.ValueConvertOrder_Others)
            {
               // source must be primitive, which is not convertable to non-primitive (except Object class).
               
               if (targetShellClass == CoreClasses.kObjectClassDefinition)
               {
                  targetVi.Assign (sourceClass, sourceCi._mValueObject);
               }
               else
               {
                  //targetVi._mRealClassDefinition = CoreClasses.kVoidClassDefinition; // targetShellClass
                  //targetVi._mValueObject = null; // targetShellClass.mGetNullValue (); // bug, constant will be chagned.
                  targetVi.Assign (CoreClasses.kVoidClassDefinition, null);
               }
            }
            else // target must be primitive. Primitive classes are final classes (have no sub classes).
            {
               //targetVi._mRealClassDefinition = targetShellClass; // bug, constant will be chagned.
               //targetVi._mValueObject = sourceClass.mValueConvertFunctions [targetShellClass.mValueConvertOrder] (sourceCi._mValueObject);;
                           // bug, constant will be chagned.
               
               //targetVi.Assign (targetShellClass, ...);
                           // the current targetVi._mRealClassDefinition must be targetShellClass, for primitive classes has no sub classes.
               
               targetVi.SetValueObject (sourceClass.mValueConvertFunctions [targetShellClass.mValueConvertOrder] (sourceCi._mValueObject));
            }
         }
      }
      
      // compare with auto convert
      public static function CompareEquals (ci_1:ClassInstance, ci_2:ClassInstance):Boolean
      {
         if (ci_1._mRealClassDefinition == ci_2._mRealClassDefinition) // the most common case
         {
            return ci_1.GetValueObject () == ci_2.GetValueObject ();
         }
         else 
         {
            var class_1:ClassDefinition = ci_1._mRealClassDefinition;
            var class_2:ClassDefinition = ci_2._mRealClassDefinition;
            
            if (class_1.mValueConvertOrder == class_2.mValueConvertOrder)
            {
               // both are not primitive classes (ClassDefinition.ValueConvertOrder_Others).
               // true when only both are null
               
               return class_1.mIsNullFunc (ci_1._mValueObject) && class_2.mIsNullFunc (ci_2._mValueObject);
            }
            else // at least one is primitive
            {
               if (class_1.mValueConvertOrder > class_2.mValueConvertOrder) // v2 is target
               {
                  return ci_2._mValueObject == class_1.mValueConvertFunctions [class_2.mValueConvertOrder] (ci_1._mValueObject);
               }
               else // if (class_1.mValueConvertOrder < class_2.mValueConvertOrder) // v1 is target
               {
                  return ci_1._mValueObject == class_2.mValueConvertFunctions [class_1.mValueConvertOrder] (ci_2._mValueObject);
               }
            }
         }
      }
      
      public static function ToNumber (ci:ClassInstance):Number
      {
         return ci._mRealClassDefinition.ToNumber (ci._mValueObject);
      }
      
      public static function ToBoolean (ci:ClassInstance):Boolean
      {
         return ci._mRealClassDefinition.ToBoolean (ci._mValueObject);
      }
      
      public static function ToString (ci:ClassInstance):String
      {
         return ci._mRealClassDefinition.ToString (ci._mValueObject);
      }
      
//==============================================================
// 
//==============================================================
      
      // define -> instance
      
      public static function ValidateInitialDirectValueObject_Define2Object (playerWorld:World, classType:int, valueType:int, valueObject:Object, extraInfos:Object = null):Object
      {
         if (classType != ClassTypeDefine.ClassType_Core)
            return null;
         
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               return valueObject as Boolean;
            case CoreClassIds.ValueType_Number:
               return valueObject as Number;
            case CoreClassIds.ValueType_String:
               return valueObject as String;
            case CoreClassIds.ValueType_Entity:
            {
               if (playerWorld == null)
                  return null;

               //var entityIndex:int = valueObject as int; // before v2.05. bug: null -> 0
               var entityIndex:int = valueObject == null ? Define.EntityId_None : (valueObject as int);

               if (entityIndex < 0)
               {
                  if (entityIndex == Define.EntityId_Ground)
                     return playerWorld;
                  else // if (entityIndex == Define.EntityId_None)
                     return null;
               }
               else
               {
                  if (extraInfos != null)
                     entityIndex = extraInfos.mEntityIdCorrectionTable [entityIndex];
                  //return playerWorld.GetEntityByCreateOrderId (entityIndex, false); // must be an entity placed in editor (before v2.02)
                  return playerWorld.GetEntityByCreateOrderId (entityIndex, true); // may be an entity runtime created (from v2.02, merging scene is added)
               }
            }
            case CoreClassIds.ValueType_CollisionCategory:
            {
               if (playerWorld == null)
                  return null;
               
               //var ccatIndex:int = valueObject as int; // before v2.05. bug: null -> 0
               var ccatIndex:int = valueObject == null ? Define.CCatId_Hidden : (valueObject as int);
               if (ccatIndex >= 0 && extraInfos != null)
                  ccatIndex += extraInfos.mBeinningCCatIndex;
               return playerWorld.GetCollisionCategoryById (ccatIndex);
            }
            case CoreClassIds.ValueType_Module:
            {
               var moduleIndex:int = valueObject == null ? -1 : (valueObject as int);
               //return Global.GetImageModuleByGlobalIndex (moduleIndex);
               return moduleIndex;
            }
            case CoreClassIds.ValueType_Sound:
            {
               var soundIndex:int = valueObject == null ? -1 : (valueObject as int);
               //return Global.GetSoundByIndex (soundIndex);
               return soundIndex;
            }
            case CoreClassIds.ValueType_Scene:
            {
               var sceneIndex:int = valueObject == null ? -1 : (valueObject as int);
               //return Global.GetSceneByIndex (sceneIndex);
               return sceneIndex;
            }
            case CoreClassIds.ValueType_Array:
            {
               //if (valueObject == null)
               //{
                  return null;
               //}
               //else
               //{
               //   
               //}
            }
            case CoreClassIds.ValueType_Class:
               var aClass:ClassDefinition = kVoidClassDefinition;
               
               if (valueObject != null)
               {  
                  var theClassId:int = valueObject.mValueType;
                  if (valueObject.mClassType == ClassTypeDefine.ClassType_Custom)
                  {
                     if (theClassId >= 0 && extraInfos != null)
                        theClassId = theClassId + extraInfos.mBeginningCustomClassIndex;
                  }
                  
                  aClass = Global.GetClassDefinition (valueObject.mClassType, theClassId);
               }
                  
               return aClass;
            case CoreClassIds.ValueType_Object:
               return null;
            default:
            {
               return null;
            }
         }
      }
      
      // define -> xml
      
      public static function ValidateDirectValueObject_Define2Xml (classType:int, valueType:int, valueObject:Object):Object
      {
         if (classType != ClassTypeDefine.ClassType_Core)
            return null;
         
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               return (valueObject as Boolean) ? 1 : 0;
            case CoreClassIds.ValueType_Number:
               return valueObject as Number;
            case CoreClassIds.ValueType_String:
               var text:String = valueObject as String;
               if (text == null)
                  text = "";
               return text;
            case CoreClassIds.ValueType_Entity:
               return valueObject as int;
            case CoreClassIds.ValueType_CollisionCategory:
               return valueObject as int;
            case CoreClassIds.ValueType_Module:
               return valueObject as int;
            case CoreClassIds.ValueType_Sound:
               return valueObject as int;
            case CoreClassIds.ValueType_Scene:
               return valueObject as int;
            case CoreClassIds.ValueType_Array:
               //if (valueObject == null) 
               //{
                  return null;
               //}
               //else 
               //{
               //   
               //}
            case CoreClassIds.ValueType_Class:
               if (valueObject == null)
                  return ClassTypeDefine.ClassType_Core + "," + CoreClassIds.ValueType_Void;
                  
               return valueObject.mClassType + "," + valueObject.mValueType;
            case CoreClassIds.ValueType_Object:
               return null;
            default:
            {
               //throw new Error ("! wrong value. valueType = " + valueType);
               return null;
            }
         }
      }
      
      public static function LoadDirectValueObjectFromBinFile (binFile:ByteArray, classType:int, valueType:int, numberDetail:int):Object
      {
         if (classType != ClassTypeDefine.ClassType_Core)
            return null;
         
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               return binFile.readByte () != 0;
            case CoreClassIds.ValueType_Number:
               switch (numberDetail)
               {
                  case CoreClassIds.NumberTypeDetail_Single:
                     return binFile.readFloat ();
                  case CoreClassIds.NumberTypeDetail_Integer:
                     return binFile.readInt ();
                  case CoreClassIds.NumberTypeDetail_Double:
                  default:
                     return binFile.readDouble ();
               }
            case CoreClassIds.ValueType_String:
               return binFile.readUTF ();
            case CoreClassIds.ValueType_Entity:
               return binFile.readInt ();
            case CoreClassIds.ValueType_CollisionCategory:
               return binFile.readInt (); // in fact, short is ok
            case CoreClassIds.ValueType_Module:
               return binFile.readInt (); // in fact, short is ok
            case CoreClassIds.ValueType_Sound:
               return binFile.readInt (); // in fact, short is ok
            case CoreClassIds.ValueType_Scene:
               return binFile.readInt (); // in fact, short is ok
            case CoreClassIds.ValueType_Array:
               var nullArray:Boolean = binFile.readByte () == 0;
               //if (nullArray == null) 
               //{
                  return null;
               //}
               //else
               //{
               //   var values:Array = valueObject as Array;
               //   if (values.length > 1024)
               //      throw new Error ("array i too length: " + values.length);
               //   
               //   binFile.writeShort (values.length);
               //}
               
               break;
            case CoreClassIds.ValueType_Class:
               return {mClassType : binFile.readByte (), mValueType : binFile.readShort ()};
            case CoreClassIds.ValueType_Object:
               var isNull:Boolean = binFile.readByte () == 0;
               return null;
            default:
            {
               //throw new Error ("! bad value");
               return null;
            }
         }
      }
      
   }
}
