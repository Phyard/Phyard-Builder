
package common.trigger {
   
   public class CoreFunctionDeclarations
   {
      public static var sCoreFunctionDeclarations:Array = new Array (CoreFunctionIds.NumPlayerFunctions);
      
      public static function Initialize ():void
      {
         if (Compile::Is_Debugging)
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
                     ]
                  );
                  
         }
         
      // global
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Return,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ReturnIfTrue,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ReturnIfFalse,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_AssignBoolenRegister0,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         
      // system / time
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetProgramMilliseconds,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetCurrentDateTime,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
          
      // string
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Assign,
                     [
                        ValueTypeDefine.ValueType_String, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Add,
                     [
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_String, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_NumberToString,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_BooleanToString,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_EntityToString,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_CollisionCategoryToString,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         
       // bool
          
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Assign,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Invert,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_IsTrue,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_IsFalse,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_EqualsNumber,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_EqualsBoolean,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_EqualsEntity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Larger,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Less,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_And,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Or,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Not,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Xor,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
          
       // math
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Assign,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Add,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Subtract,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Multiply,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Divide,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Random,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_RandomRange,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_RandomIntRange,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Max,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Min,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Inverse,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Negative,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Abs,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Sqrt,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Ceil,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Floor,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Round,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Log,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Exp,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_Power,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         
      // math / trogonomotry
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_DegreesToRadians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_RadiansToDegrees,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_SinRadians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_CosRadians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_TanRadians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_ArcSinRadians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_ArcCosRadians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_ArcTanRadians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Math_ArcTan2Radians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         
      // math / bitwise
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftLeft,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRight,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_And,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Or,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Not,
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Xor,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         
      // game / world
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees,
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_AttachCameraToShape,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         
     // game / collision category
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Cat_Assign,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ]
                  );
         
     // game / entity
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Assign,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsShapeEntity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsVisible,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetVisible,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetAlpha,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetAlpha,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetPosition,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         
      // game / entity / shape
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsSensor,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetAsSensor,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                     ],
                     null
                  );
         
      // game / entity / joint
         
         
         
      // game / entity / util
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_GetText,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetText,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_String, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_AppendText,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_String, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_AppendNewLine,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
      }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterCoreDeclaration (functionId:int, paramValueTypes:Array, returnValueTypes:Array):void
      {
         if (functionId < 0 || functionId >= CoreFunctionIds.NumPlayerFunctions)
            return;
         
         sCoreFunctionDeclarations [functionId] = new FunctionDeclaration (functionId, paramValueTypes, returnValueTypes);
      }
      
   }
}
