
package common.trigger {
   
   public class CoreFunctionDeclarations
   {
      public static var sCoreFunctionDeclarations:Array = new Array (CoreFunctionIds.NumPlayerFunctions);
      
      public static function Initialize ():void
      {
         RegisterCoreDeclaration (CoreFunctionIds.ID_ForDebug,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     false
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_SetWorldGravityAcceleration,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     null,
                     false
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_SetWorldCameraFocusEntity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null,
                     false
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_SetShapeDensity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     null,
                     false
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsEntityVisible,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     true
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsPhysicsShape,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     true
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsSensorShape,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     true
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsTrue,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     true
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsFalse,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     true
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_SetShapeFilledColor,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     null,
                     true
                  );
      }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterCoreDeclaration (functionId:int, paramValueTypes:Array, returnValueTypes:Array, canBeCalledInConditionList:Boolean):void
      {
         if (functionId < 0 || functionId >= CoreFunctionIds.NumPlayerFunctions)
            return;
         
         sCoreFunctionDeclarations [functionId] = new FunctionDeclaration (functionId, paramValueTypes, returnValueTypes, canBeCalledInConditionList);
      }
      
   }
}
