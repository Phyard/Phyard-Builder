package editor.world {

   import editor.trigger.CoreClass;

   import common.trigger.CoreClassIds;
   import common.trigger.ClassDeclaration;
   import common.trigger.CoreClassDeclarations;

   import common.Define;

   public class CoreClasses
   {
      public static var sVoidClass:CoreClass = null;
      public static var mCoreClasses:Array = new Array (CoreClassIds.NumCoreClasses);

      private static var mInitialized:Boolean = false;

      public static function Initialize ():void
      {
         if (mInitialized)
            return;

         mInitialized = true;

      // ...
                                   
         RegisterCoreClass (CoreClassIds.ValueType_Void, 
                            "Void", // Class Name
                            "aVoid",
                            undefined
                            ).SetSceneDataDependent (false);
         
         RegisterCoreClass (CoreClassIds.ValueType_Boolean, 
                            "Bool", // Class Name
                            "aBool",
                            false
                            ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (CoreClassIds.ValueType_Number, 
                            "Number", // Class Name
                            "aNumber",
                            0
                            ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (CoreClassIds.ValueType_String, 
                            "Text", // Class Name
                            "aText",
                            ""
                            ).SetSceneDataDependent (false);
                                   
         RegisterCoreClass (CoreClassIds.ValueType_CollisionCategory, 
                            "CCat", // Class Name
                            "aCCat",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (CoreClassIds.ValueType_Entity,            
                            "Entity", // Class Name
                            "anEntity",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (CoreClassIds.ValueType_Module, 
                            "Module", // Class Name
                            "aModule",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (CoreClassIds.ValueType_Sound, 
                            "Sound", // Class Name
                            "aSound",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (CoreClassIds.ValueType_Scene, 
                            "Scene", // Class Name
                            "aScene",
                            null
                            ).SetSceneDataDependent (true);
                                   
         RegisterCoreClass (CoreClassIds.ValueType_Array, 
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

      private static function RegisterCoreClass (classId:int, typeName:String, defaultInstanceName:String, initialInitialValue:Object, valueValidateFunc:Function = null):CoreClass
      {
         var coreDecl:ClassDeclaration = CoreClassDeclarations.GetCoreClassDeclarationById (classId);

         var coreClass:CoreClass = new CoreClass (coreDecl, 
                                                  typeName, 
                                                  defaultInstanceName, 
                                                  initialInitialValue, 
                                                  valueValidateFunc
                                                 );
         
         mCoreClasses [coreDecl.GetID ()] = coreClass;
         
         return coreClass;
      }

      public static function GetCoreClassById (classId:int):CoreClass
      {
         if (! mInitialized)
            Initialize ();
         
         if (classId < 0 || classId >= CoreClassIds.NumCoreClasses)
            return sVoidClass;

         var coreClass:CoreClass = mCoreClasses [classId];
         
         return coreClass == null ? sVoidClass : coreClass;
      }
      
   }
}
