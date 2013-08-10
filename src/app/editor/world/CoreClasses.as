package editor.world {

   import editor.trigger.ClassCore;
   import editor.trigger.CodePackage;

   import common.trigger.CoreClassIds;
   import common.trigger.ClassDeclaration;
   import common.trigger.CoreClassDeclarations;

   import common.Define;

   public class CoreClasses
   {
      public static var sVoidClass:ClassCore = null;
      public static var mCoreClasses:Array = new Array (CoreClassIds.NumCoreClasses);
      
      private static const sCoreCodePackage:CodePackage = new CodePackage ("Core");

      public static function GetCoreClassPackage ():CodePackage
      {
         return sCoreCodePackage
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
                            "Void", // Class Name
                            "aVoid",
                            undefined
                            ).SetSceneDataDependent (false);
         
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Boolean, 
                            "Boolean", // Class Name
                            "aBool",
                            false
                            ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Number, 
                            "Number", // Class Name
                            "aNumber",
                            0
                            ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_String, 
                            "Text", // Class Name
                            "aText",
                            ""
                            ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Entity,            
                            "Entity", // Class Name
                            "anEntity",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_CollisionCategory, 
                            "CCat", // Class Name
                            "aCCat",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Module, 
                            "Module", // Class Name
                            "aModule",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Sound, 
                            "Sound", // Class Name
                            "aSound",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Scene, 
                            "Scene", // Class Name
                            "aScene",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (sCoreCodePackage,
                            CoreClassIds.ValueType_Array, 
                            "Array", // Class Name
                            "anArray",
                            null
                            ).SetSceneDataDependent (false);
         
      // ...
      
         sVoidClass = GetCoreClassById (CoreClassIds.ValueType_Void);
      }
      
//===========================================================
// util functions
//===========================================================

      private static function RegisterCoreClass (codePacakge:CodePackage, classId:int, typeName:String, defaultInstanceName:String, initialInitialValue:Object, valueValidateFunc:Function = null):ClassCore
      {
         var coreDecl:ClassDeclaration = CoreClassDeclarations.GetCoreClassDeclarationById (classId);

         var coreClass:ClassCore = new ClassCore (coreDecl, 
                                                  typeName, 
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

      public static function GetCoreClassById (classId:int):ClassCore
      {
         if (! mInitialized)
            Initialize ();
         
         if (classId < 0 || classId >= CoreClassIds.NumCoreClasses)
            return sVoidClass;

         var coreClass:ClassCore = mCoreClasses [classId];
         
         return coreClass == null ? sVoidClass : coreClass;
      }
      
   }
}
