
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
                                   /*undefined*/null);
         
         RegisterClassDeclatation (CoreClassIds.ValueType_Boolean, 
                                   false);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Number, 
                                   0);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_String, 
                                   "");
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_CollisionCategory, 
                                   Define.CCatId_Hidden);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Entity,            
                                   Define.EntityId_None);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Module, 
                                   -1);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Sound, 
                                   -1);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Scene, 
                                   -1);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Array, 
                                   null);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Class, 
                                   CoreClassIds.ValueType_Void);
                                   
         RegisterClassDeclatation (CoreClassIds.ValueType_Object, 
                                   null);

         sVoidClassDeclaration = GetCoreClassDeclarationById (CoreClassIds.ValueType_Void);
      }
      
//===========================================================
// util functions
//===========================================================

      private static function RegisterClassDeclatation (classId:int, defaultDirectDefineValue:Object):void
      {
         if (classId < 0 || classId >= CoreClassIds.NumCoreClasses)
            return;

         var class_decl:ClassDeclaration = new ClassDeclaration (classId, defaultDirectDefineValue);

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
