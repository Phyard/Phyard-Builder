package player.trigger {

   import flash.utils.ByteArray;

   import player.world.World;

   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   import common.trigger.ClassDeclaration;
   import common.trigger.CoreClassDeclarations;

   import common.Define;

   public class CoreClasses
   {
      
      // define -> instance
      
      public static function ValidateDirectValueObject_Define2Object (playerWorld:World, classType:int, valueType:int, valueObject:Object, extraInfos:Object = null):Object
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
               //if (valueObject == null)
               //{
                  return null;
               //}
               //else
               //{
               //   
               //}
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
            default:
            {
               throw new Error ("! bad value");
            }
         }
      }
      
   }
}
