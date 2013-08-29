package player.trigger {

   import flash.utils.ByteArray;

   import player.design.Global;
   import player.world.World;

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
            var coreDecl:ClassDeclaration = CoreClassDeclarations.GetCoreClassDeclarationById (classId);
            if (coreDecl != null)
            {
               if (classId == CoreClassIds.ValueType_Void)
                  sCoreClassDefinitions [classId] = kVoidClassDefinition;
               else if (classId == CoreClassIds.ValueType_Object)
                  sCoreClassDefinitions [classId] = kObjectClassDefinition;
               else
                  sCoreClassDefinitions [classId] = new ClassDefinition_Core (coreDecl);
            }
         }
         
         // ...         
         
         for (classId = 0; classId < CoreClassIds.NumCoreClasses; ++ classId)
         {
            classDef = GetCoreClassDefinition (classId);
            if (classDef != null)
            {
               classDef.SetParentClasses ([kObjectClassDefinition]);
            }
         }
         
         // ...         
         
         for (classId = 0; classId < CoreClassIds.NumCoreClasses; ++ classId)
         {
            classDef = GetCoreClassDefinition (classId);
            if (classDef != null)
            {
               classDef.FindAncestorClasses ();
            }
         }
      }
      
      public static function GetCoreClassDefinition (coreClassId:int):ClassDefinition_Core
      {
         InitCoreClassDefinitions ();
         
         var classDefinition:ClassDefinition_Core = sCoreClassDefinitions [coreClassId] as ClassDefinition_Core;
         return classDefinition == null ? kVoidClassDefinition : classDefinition;
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

               var entityIndex:int = valueObject as int;
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
               
               var ccatIndex:int = valueObject as int;
               if (ccatIndex >= 0 && extraInfos != null)
                  ccatIndex += extraInfos.mBeinningCCatIndex;
               return playerWorld.GetCollisionCategoryById (ccatIndex);
            }
            case CoreClassIds.ValueType_Module:
            {
               var moduleIndex:int = valueObject as int;
               //return Global.GetImageModuleByGlobalIndex (moduleIndex);
               return moduleIndex;
            }
            case CoreClassIds.ValueType_Sound:
            {
               var soundIndex:int = valueObject as int;
               //return Global.GetSoundByIndex (soundIndex);
               return soundIndex;
            }
            case CoreClassIds.ValueType_Scene:
            {
               var sceneIndex:int = valueObject as int;
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
               var aClass:ClassDefinition = null;
               
               if (valueObject != null)
               {
                  if (valueObject.mClassType == ClassTypeDefine.ClassType_Custom)
                  {
                     var theClassId:int = valueObject.mValueType;
                     if (valueObject.mValueType >= 0 && extraInfos != null)
                        theClassId = theClassId + extraInfos.mBeginningCustomClassIndex;
                     
                     aClass = Global.GetCustomClassDefinition (theClassId);
                  }
                  else
                  {
                     aClass = GetCoreClassDefinition (valueObject.mValueType);
                  }
               }
               
               if (aClass == null)
               {
                  aClass = kVoidClassDefinition;
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
               throw new Error ("! wrong value");
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
               throw new Error ("! bad value");
            }
         }
      }
      
   }
}
