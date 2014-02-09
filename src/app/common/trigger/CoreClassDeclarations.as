
package common.trigger {

   import common.Define;

   public class CoreClassDeclarations
   {
      //public static const

      public static var sVoidClassDeclaration:ClassDeclaration = null;
      public static var sCoreClassDeclarations:Array = new Array (CoreClassIds.NumCoreClasses);

      private static var mInitialized:Boolean = false;

      public static function Initialize ():void
      {
         if (mInitialized)
            return;

         mInitialized = true;

      // ...
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Void, 
                                   "Void", // Class Name
                                   /*undefined*/null,
                                   true);
         
         RegisterClassDeclatation (CoreClassIds.ValueType_Boolean, 
                                   "Boolean", // Class Name
                                   false,
                                   true);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Number, 
                                   "Number", // Class Name
                                   0,
                                   true);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_String, 
                                   "Text", // Class Name
                                   "",
                                   true);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_CollisionCategory, 
                                   "CCat", // Class Name
                                   Define.CCatId_None/*CCatId_Hidden*/,
                                   true);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Entity,               
                                   "Entity", // Class Name        
                                   Define.EntityId_None,
                                   false);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Module, 
                                   "Module", // Class Name
                                   -1,
                                   true);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Sound, 
                                   "Sound", // Class Name
                                   -1,
                                   true);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Scene, 
                                   "Scene", // Class Name
                                   -1,
                                   false);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Array, 
                                   "Array", // Class Name
                                   null,
                                   true);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Class, 
                                   "Class", // Class Name
                                   {mClassType : ClassTypeDefine.ClassType_Core, mValueType : CoreClassIds.ValueType_Void},
                                   true);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Object, 
                                   "Object", // Class Name
                                   null,
                                   false);

         sVoidClassDeclaration = GetCoreClassDeclarationById (CoreClassIds.ValueType_Void);
      }
      
//===========================================================
// util functions
//===========================================================

      private static function RegisterClassDeclatation (classId:int, name:String,  defaultDirectDefineValue:Object, isFinal:Boolean):void
      {
         if (classId < 0 || classId >= CoreClassIds.NumCoreClasses)
            return;

         var class_decl:ClassDeclaration = new ClassDeclaration (classId, name, defaultDirectDefineValue, isFinal);

         sCoreClassDeclarations [classId] = class_decl;
      }

      public static function GetCoreClassDeclarationById (classId:int):ClassDeclaration
      {
         if (! mInitialized)
            Initialize ();
         
         if (classId < 0 || classId >= CoreClassIds.NumCoreClasses)
            return sVoidClassDeclaration;

         var class_decl:ClassDeclaration = sCoreClassDeclarations [classId];
         
         return class_decl == null ? sVoidClassDeclaration : class_decl;
      }
      
      public static function GetCoreClassDefaultDirectDefineValue (classId:int):Object
      {
         return GetCoreClassDeclarationById (classId).mDefaultDirectDefineValue;
      }

   }
}
