package editor.world {
   
   import flash.utils.ByteArray;
   
   import editor.codelib.CodeLibManager;
   import editor.entity.Scene;
   import editor.entity.Entity;
   import editor.ccat.CollisionCategory;
   import editor.image.AssetImageModule;
   import editor.sound.AssetSound;

   import editor.trigger.ClassDefinition;
   import editor.trigger.ClassDefinition_Core;
   import editor.trigger.CodePackage;

   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   import common.trigger.ClassDeclaration;
   import common.trigger.CoreClassDeclarations;

   import common.Define;

   public class CoreClassesHub
   {
      public static var sVoidClass:ClassDefinition_Core = null;
      public static var mCoreClasses:Array = new Array (CoreClassIds.NumCoreClasses);
      
      private static const sCoreCodePackage:CodePackage = new CodePackage ("Core");
         private static const sMultiplePlayerCodePackage:CodePackage = new CodePackage ("Multiple Player", sCoreCodePackage);

      public static function GetCoreClassPackage ():CodePackage
      {
         return sCoreCodePackage;
      }

      private static var mInitialized:Boolean = false;

      public static function Initialize ():void
      {
         if (mInitialized)
            return;

         mInitialized = true;

      // ...
                                   
         RegisterCoreClass (null, //sCoreCodePackage,
                            CoreClassIds.ValueType_Void, 
                            "aVoid",
                            null, // undefined,
                            ValidateValueObject_Void
                         ).SetSceneDataDependent (false);
                         
         sVoidClass = GetCoreClassById (CoreClassIds.ValueType_Void); // should put here for Class_Type will ref this.
         
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Boolean, 
                            "aBool",
                            false,
                            ValidateValueObject_Boolean
                         ).SetSceneDataDependent (false).SetGameSavable (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Number, 
                            "aNumber",
                            0,
                            ValidateValueObject_Number
                         ).SetSceneDataDependent (false).SetGameSavable (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_String, 
                            "aText",
                            "",
                            ValidateValueObject_String
                         ).SetSceneDataDependent (false).SetGameSavable (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Entity, 
                            "anEntity",
                            null,
                            ValidateValueObject_Entity
                         ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_CollisionCategory, 
                            "aCCat",
                            null,
                            ValidateValueObject_CollisionCategory
                         ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Module, 
                            "aModule",
                            null,
                            ValidateValueObject_Module
                         ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Sound, 
                            "aSound",
                            null,
                            ValidateValueObject_Sound
                         ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Scene, 
                            "aScene",
                            null,
                            ValidateValueObject_Scene
                         ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Array, 
                            "anArray",
                            null,
                            ValidateValueObject_ArrayAndCustomObject
                         ).SetSceneDataDependent (false).SetGameSavable (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_ByteArray, 
                            "aByteArray",
                            null,
                            ValidateValueObject_ArrayAndCustomObject
                         ).SetSceneDataDependent (false).SetGameSavable (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_ByteArrayStream, 
                            "aByteArrayStream",
                            null,
                            ValidateValueObject_ArrayAndCustomObject
                         ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (null,
                            CoreClassIds.ValueType_MultiplePlayerInstance, 
                            "aMultiPlayerInstance",
                            null,
                            ValidateValueObject_ArrayAndCustomObject
                         ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (sMultiplePlayerCodePackage,
                            CoreClassIds.ValueType_MultiplePlayerInstanceDefine, 
                            "aMultiPlayerInstanceDefine",
                            null,
                            ValidateValueObject_ArrayAndCustomObject
                         ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (sMultiplePlayerCodePackage,
                            CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine, 
                            "aMultiPlayerInstanceChannelDefine",
                            null,
                            ValidateValueObject_ArrayAndCustomObject
                         ).SetSceneDataDependent (false);
                         
         RegisterCoreClass (sCoreCodePackage,
                           CoreClassIds.ValueType_Advertisement,
                            "anAdvertisement",
                            null,
                            ValidateValueObject_ArrayAndCustomObject
                         ).SetSceneDataDependent (false);
                         
         RegisterCoreClass (null, //sCoreCodePackage,
                            CoreClassIds.ValueType_Class, 
                            "aClass",
                            sVoidClass,
                            ValidateValueObject_Class
                         ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (null, //sCoreCodePackage,
                            CoreClassIds.ValueType_Object, 
                            "anObject",
                            null,
                            ValidateValueObject_ArrayAndCustomObject
                         ).SetSceneDataDependent (true);
         
      // ...
         
      }
      
//===========================================================
// validate objects
//===========================================================
      
      // options param may be null
      
      public static function ValidateValueObject_Void (valueObject:Object, options:Object):Object
      {
         return null; //undefined;
      }
      
      public static function ValidateValueObject_Boolean (valueObject:Object, options:Object):Object
      {
         return Boolean (valueObject);
      }
      
      public static function ValidateValueObject_Number (valueObject:Object, options:Object):Object
      {
         var num:Number = Number (valueObject);
         if (isNaN (num))
         {
            if(options != null && options.mDefaultValue != null)
               num = Number (options.mDefaultValue);
            else
               num = 0.0;
         }
         
         if (options != null)
         {
            if (options.mMinValue != null && num < options.mMinValue)
               num = options.mMinValue;
            if (options.mMaxValue != null && num > options.mMaxValue)
               num = options.mMaxValue;
         }
         
         return num;
      }
      
      public static function ValidateValueObject_String (valueObject:Object, options:Object):Object
      {
         var text:String = String (valueObject);
         
         if (text == null)
            return null;
         
         if (options != null)
         {
            if (options.mMaxLength != null && options.mMaxLength > 0 && text.length > options.mMaxLength)
               return text.substr (0, options.mMaxLength);
         }
         
         return text;
      }
      
      public static function ValidateValueObject_Scene (valueObject:Object, options:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var scene:Scene = valueObject as Scene;
         //if (scene != null && scene.GetWorld () != world)
         if (scene != null && scene.GetSceneIndex () < 0)
            scene = null;
         
         return scene;
      }
      
      public static function ValidateValueObject_Entity (valueObject:Object, options:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var entity:Entity = valueObject as Entity;
         //if (entity != null && (entity.GetWorld () != world || entity.GetCreationOrderId () < 0))
         if (entity != null && entity.GetCreationOrderId () < 0)
            entity = null;
         
         return entity;
      }
      
      public static function ValidateValueObject_CollisionCategory (valueObject:Object, options:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var category:CollisionCategory = valueObject as CollisionCategory;
         if (category != null && category.GetAppearanceLayerId () < 0)
            category = null;
         
         return category;
      }
      
      public static function ValidateValueObject_Module (valueObject:Object, options:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var module:AssetImageModule = valueObject as AssetImageModule;
         if (module != null && module.GetAppearanceLayerId () < 0)
            module = null;
         
         return module;
      }
      
      public static function ValidateValueObject_Sound (valueObject:Object, options:Object):Object
      {
         //var world:World = EditorContext.GetEditorApp ().GetWorld (); // in loading stage, it would be null
         
         var sound:AssetSound = valueObject as AssetSound;
         if (sound != null && sound.GetAppearanceLayerId () < 0)
            sound = null;
         
         return sound;
      }
      
      public static function ValidateValueObject_Class (valueObject:Object, options:Object):Object
      {
         return (valueObject as ClassDefinition) == null ? sVoidClass : valueObject;
      }
      
      public static function ValidateValueObject_ArrayAndCustomObject (valueObject:Object, options:Object):Object
      {
         return null; // currently
      }
      
//===========================================================
// util functions
//===========================================================

      private static function RegisterCoreClass (codePacakge:CodePackage, classId:int, 
                                                 defaultInstanceName:String, initialInitialValue:Object, valueValidateFunc:Function = null
                                                 ):ClassDefinition_Core
      {
         var coreDecl:ClassDeclaration = CoreClassDeclarations.GetCoreClassDeclarationById (classId);

         var coreClass:ClassDefinition_Core = new ClassDefinition_Core (coreDecl, 
                                                  defaultInstanceName, 
                                                  initialInitialValue, 
                                                  valueValidateFunc
                                                 );
         
         mCoreClasses [coreDecl.GetID ()] = coreClass;
         
         if (codePacakge != null)
         {
            codePacakge.AddClass (coreClass);
         }
         
         return coreClass;
      }

      public static function GetCoreClassById (classId:int):ClassDefinition_Core
      {
         if (! mInitialized)
            Initialize ();
         
         if (classId < 0 || classId >= CoreClassIds.NumCoreClasses)
            return sVoidClass;

         var coreClass:ClassDefinition_Core = mCoreClasses [classId];
         
         return coreClass == null ? sVoidClass : coreClass;
      }
      
//===========================================================
// validate values for IO
//===========================================================
      
      // scene may be null for Scene Common variable spaces
      public static function ValidateDirectValueObject_Object2Define (scene:Scene, classType:int, valueType:int, valueObject:Object):Object
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
               var entity:Entity = valueObject as Entity;
               
               if (entity == null)
               {
                  if (valueObject is World)
                     return Define.EntityId_Ground;
                  else
                     return Define.EntityId_None;
               }
               else
               {
                  if (scene == null)
                     return Define.EntityId_None;
                  
                  return scene.GetAssetCreationId (entity);
               }
            }
            case CoreClassIds.ValueType_CollisionCategory:
            {
               var ccat:CollisionCategory = valueObject as CollisionCategory;
               if (ccat == null || scene == null)
                  return -1;
               
               return scene.GetCollisionCategoryManager ().GetCollisionCategoryIndex (ccat, true);
            }
            case CoreClassIds.ValueType_Module:
            {
               var module:AssetImageModule = valueObject as AssetImageModule;
               if (module == null || scene == null)
                  return -1;
               
               return scene.GetWorld ().GetImageModuleIndex (module);
            }
            case CoreClassIds.ValueType_Sound:
            {
               var sound:AssetSound = valueObject as AssetSound;
               if (sound == null || scene == null)
                  return -1;
               
               return scene.GetWorld ().GetSoundIndex (sound);
            }
            case CoreClassIds.ValueType_Scene:
            {
               var sceneValue:Scene = valueObject as Scene;
               if (sceneValue == null || scene == null)
                  return -1;
               
               return scene.GetWorld ().GetSceneIndex (sceneValue);
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
            case CoreClassIds.ValueType_ByteArray:
               return null; // maybe non-null direct values will be supported.
            case CoreClassIds.ValueType_ByteArrayStream:
               return null;
            case CoreClassIds.ValueType_MultiplePlayerInstance:
            case CoreClassIds.ValueType_MultiplePlayerInstanceDefine:
            case CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine:
            case CoreClassIds.ValueType_Advertisement:
               return null;
            case CoreClassIds.ValueType_Class:
               var aClass:ClassDefinition = valueObject as ClassDefinition;
               if (aClass == null)
                  aClass = sVoidClass;
               
               return {mClassType: aClass.GetClassType (), mValueType: aClass.GetID ()};
            case CoreClassIds.ValueType_Object:
               return null;
            default:
            {
               //throw new Error ("! wrong value");
               return null;
            }
         }
      }
      
      // scene may be null for Scene Common Variable Spaces
      public static function ValidateDirectValueObject_Define2Object (scene:Scene, classType:int, valueType:int, valueObject:Object):Object
      {
         if (classType != ClassTypeDefine.ClassType_Core)
            return null;
         
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               return Boolean (valueObject);
            case CoreClassIds.ValueType_Number:
               return Number (valueObject);
            case CoreClassIds.ValueType_String:
               // "as String in commented off, otherwise value_object will be always null, bug?!
               // re: add back  "as String", in xml -> define: String (valueSourceElement.@direct_value)
               var text:String = valueObject as String
               if (text == null)
                  text = "";
               return text;
            case CoreClassIds.ValueType_Entity:
            {
               if (scene == null) // for Scene Common Variable Spaces
                  return null;

               var entityIndex:int = valueObject as int;
               if (entityIndex < 0)
               {
                  if (entityIndex == Define.EntityId_Ground)
                  {
                     return scene.GetWorld ();
                  }
                  else // if (entityIndex == Define.EntityId_None)
                  {
                     return null;
                  }
               }
               else
               {
                  return scene.GetAssetByCreationId (entityIndex);
               }
            }
            case CoreClassIds.ValueType_CollisionCategory:
            {
               if (scene == null)
                  return null;
               
               return scene.GetCollisionCategoryManager ().GetCollisionCategoryByIndex (valueObject as int);
            }
            case CoreClassIds.ValueType_Module:
            {
               if (scene == null)
                  return null;
               
               var moduleIndex:int = valueObject as int;
               
               return scene.GetWorld ().GetImageModuleByIndex (moduleIndex);
            }
            case CoreClassIds.ValueType_Sound:
            {
               if (scene == null)
                  return null;
               
               var soundIndex:int = valueObject as int;
               return scene.GetWorld ().GetSoundByIndex (soundIndex);
            }
            case CoreClassIds.ValueType_Scene:
            {
               if (scene == null)
                  return null;
               
               var sceneIndex:int = valueObject as int;
               return scene.GetWorld ().GetSceneByIndex (sceneIndex);
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
            case CoreClassIds.ValueType_ByteArray:
               return null;
            case CoreClassIds.ValueType_ByteArrayStream:
               return null;
            case CoreClassIds.ValueType_MultiplePlayerInstance:
            case CoreClassIds.ValueType_MultiplePlayerInstanceDefine:
            case CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine:
            case CoreClassIds.ValueType_Advertisement:
               return null;
            case CoreClassIds.ValueType_Class:
               return CodeLibManager.GetClass (scene.GetCodeLibManager (), valueObject.mClassType, valueObject.mValueType);
            case CoreClassIds.ValueType_Object:
               // alwaus null, do nothing
               return null;
            default:
            {
               //throw new Error ("!wrong balue");
               return null;
            }
         }
      }
      
      public static function ValidateDirectValueObject_Xml2Define (classType:int, valueType:int, direct_value:String):Object
      {
         if (classType != ClassTypeDefine.ClassType_Core)
            return null;
         
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               return parseInt (String (direct_value)) != 0;
            case CoreClassIds.ValueType_Number:
               return parseFloat (String (direct_value));
            case CoreClassIds.ValueType_String:
               var text:String = String (direct_value); // valueSourceElement.@direct_value is not a string, ??? 
               if (text == null)
                  text = "";
               return text;
            case CoreClassIds.ValueType_Entity:
               return parseInt (String (direct_value));
            case CoreClassIds.ValueType_CollisionCategory:
               return parseInt (String (direct_value));
            case CoreClassIds.ValueType_Module:
               return parseInt (String (direct_value));
            case CoreClassIds.ValueType_Sound:
               return parseInt (String (direct_value));
            case CoreClassIds.ValueType_Scene:
               return parseInt (String (direct_value));
            case CoreClassIds.ValueType_Array:
               //if (direct_value == null) 
               //{
                  return null;
               //}
               //else 
               //{
               //   
               //}
            case CoreClassIds.ValueType_ByteArray:
               return null;
            case CoreClassIds.ValueType_ByteArrayStream:
               return null;
            case CoreClassIds.ValueType_MultiplePlayerInstance:
            case CoreClassIds.ValueType_MultiplePlayerInstanceDefine:
            case CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine:
            case CoreClassIds.ValueType_Advertisement:
               return null;
            case CoreClassIds.ValueType_Class:
               var tokens:Array = String (direct_value).split (",");
               return {mClassType : parseInt (tokens [0]), mValueType : parseInt (tokens [1])};
            case CoreClassIds.ValueType_Object:
               // alwaus null, do nothing
               return null;
            default:
            {
               //throw new Error ("! wrong value");
               return null;
            }
         }
      }
      
      public static function WriteDirectValueObjectIntoBinFile (binFile:ByteArray, classType:int, valueType:int, numberDetail:int, valueObject:Object):void
      {
         if (classType != ClassTypeDefine.ClassType_Core)
            return;
         
         switch (valueType)
         {
            case CoreClassIds.ValueType_Boolean:
               binFile.writeByte ((valueObject as Boolean) ? 1 : 0);
               break;
            case CoreClassIds.ValueType_Number:
               switch (numberDetail)
               {
                  case CoreClassIds.NumberTypeDetailBit_Single:
                     binFile.writeFloat (valueObject as Number);
                     break;
                  case CoreClassIds.NumberTypeDetailBit_Integer:
                     binFile.writeInt (valueObject as Number);
                     break;
                  case CoreClassIds.NumberTypeDetailBit_Double:
                  default:
                     binFile.writeDouble (valueObject as Number);
                     break;
               }
               
               break;
            case CoreClassIds.ValueType_String:
               binFile.writeUTF (valueObject == null ? "" : valueObject as String);
               break;
            case CoreClassIds.ValueType_Entity:
               binFile.writeInt (valueObject as int);
               break;
            case CoreClassIds.ValueType_CollisionCategory:
               binFile.writeInt (valueObject as int); // short is ok, in fact
               break;
            case CoreClassIds.ValueType_Module:
               binFile.writeInt (valueObject as int); // short is ok, in fact
               break;
            case CoreClassIds.ValueType_Sound:
               binFile.writeInt (valueObject as int); // short is ok, in fact
               break;
            case CoreClassIds.ValueType_Scene:
               binFile.writeInt (valueObject as int); // short is ok, in fact
               break;
            case CoreClassIds.ValueType_Array:
               //if (valueObject == null) 
               //{
                  binFile.writeByte (0); // means null.
               //}
               //else
               //{
               //   binFile.writeByte (1);
               //   
               //   var values:Array = valueObject as Array;
               //   if (values.length > 1024)
               //      throw new Error ("array i too length: " + values.length);
               //   
               //   binFile.writeShort (values.length);
               //}
               
               break;
            case CoreClassIds.ValueType_ByteArray:
               binFile.writeByte (0); // null
               break;
            case CoreClassIds.ValueType_ByteArrayStream:
               binFile.writeByte (0); // null
               break;
            case CoreClassIds.ValueType_MultiplePlayerInstance:
            case CoreClassIds.ValueType_MultiplePlayerInstanceDefine:
            case CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine:
            case CoreClassIds.ValueType_Advertisement:
               binFile.writeByte (0); // null
               break;
            case CoreClassIds.ValueType_Class:
               binFile.writeByte (valueObject.mClassType);
               binFile.writeShort (valueObject.mValueType);
               break;
            case CoreClassIds.ValueType_Object:
               //if (valueObject == null) 
               //{
                  binFile.writeByte (0); // means null.
               //}
               //else
               //{
               //   binFile.writeByte (1);
               //}
               break;
            default:
            {
               //throw new Error ("! bad value");
               // do nothing
            }
         }
      }
      
   }
}
