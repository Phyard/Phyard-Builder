
package common.trigger {
   
   public class CoreFunctionDeclarations
   {
      public static var sCoreFunctionDeclarations:Array = new Array (IdPool.NumPlayerFunctions);
      
      private static var mInitialized:Boolean = false;
      
      public static function Initialize ():void
      {
         if (mInitialized)
            return;
         
         mInitialized = true;
         
      // ...
         
         if (Compile::Is_Debugging)
         {
            RegisterCoreDeclaration (CoreFunctionIds.ID_ForDebug,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ]
                  );
                  
         }
         
      // special
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Void,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool,
                     null,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityFilter,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityPairFilter,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
       
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
         RegisterCoreDeclaration (CoreFunctionIds.ID_Break,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Comment,
                     [
                        ValueTypeDefine.ValueType_String, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Blank,
                     null,
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_StartIf,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Else,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EndIf,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_StartWhile,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EndWhile,
                     null,
                     null
                  );
         
      // system / time
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetProgramMilliseconds,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetCurrentDateTime,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsKeyHold,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean,
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
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ConditionAssign,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_String, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_SwapValues,
                     [
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_String, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_IsNull,
                     [
                        ValueTypeDefine.ValueType_String, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Equals,
                     [
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_String, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
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
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetLength,
                     [
                        ValueTypeDefine.ValueType_String, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetCharAt,
                     [
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetCharCodeAt,
                     [
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_CharCode2Char,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ToLowerCase,
                     [
                        ValueTypeDefine.ValueType_String, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ToUpperCase,
                     [
                        ValueTypeDefine.ValueType_String, 
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
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_ConditionAssign,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_SwapValues,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean,
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Boolean_ToString,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
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
          
       // math basic op
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Assign,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ConditionAssign,
                     [
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_SwapValues,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Equals,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_LargerThan,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_LessThan,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_IsNaN,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_IsInfinity,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Negative,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Add,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Subtract,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Multiply,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Divide,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Modulo,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
      // math / toString
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToString,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         // disabled for flex bug
         //RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToExponential,
         //            [
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
         //            ],
         //            [
         //               ValueTypeDefine.ValueType_String, 
         //            ]
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToFixed,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToPrecision,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToStringByRadix,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ParseFloat,
                     [
                        ValueTypeDefine.ValueType_String, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ParseInteger,
                     [
                        ValueTypeDefine.ValueType_String, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
      // math / trogonomotry
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_SinRadians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_CosRadians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_TanRadians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcSinRadians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcCosRadians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcTanRadians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDyDx, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcTan2Radians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ]
                  );
         
      // math / bitwise
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftLeft,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRight,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_And,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Or,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Not,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Xor,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
      // math / random
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Random,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RandomRange,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RandomIntRange,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngCreate,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngSetSeed,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandom,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandomRange,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandomIntRange,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
      // math / number convert
         
          RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Degrees2Radians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Radians2Degrees,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ]
                  );
          RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Number2RGB,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RGB2Number,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
        
      // math / more
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Inverse,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Max,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Min,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Abs,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Sqrt,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Ceil,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,  
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Floor,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Round,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Log,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Exp,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Power,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.Id_Math_LinearInterpolation,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.Id_Math_LinearInterpolationColor,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Clamp,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
      // game / design
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_RestartLevel,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelPaused,
                     null,
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelPaused,
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetPlaySpeedX,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetPlaySpeedX,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetWorldScale,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetWorldScale,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelMilliseconds,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelSteps,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetMousePosition,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsMouseButtonHold,
                     null,
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelStatus,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelSuccessed,
                     null,
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelFailed,
                     null,
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelUnfinished,
                     null,
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         
      // game / world
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaY, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetCameraCenter,
                     null,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,  
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraWithShape,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                        //ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraRotationWithShape,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Boolean, 
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallScript,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_ConditionCallScript,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallBoolFunction,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_ConditionCallBoolFunction,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallScriptMultiTimes,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         
     // game / world / create ...
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CreateExplosion,
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,  
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearVelocityMagnitude, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         
     // game / world / appearance
         
         
         
     // game / collision category
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_Assign,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_ConditionAssign,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SwapValues,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_IsNull,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_ToString,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_Equals,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SetCollideInternally,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SetAsFriends,
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
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
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_ConditionAssign,
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SwapValues,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsNull,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetEntityByIdOffset,
                     [
                        ValueTypeDefine.ValueType_Entity,
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Entity,
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_ToString,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_String, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Equals,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetTaskStatus,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskSuccessed,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskFailed,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskUnfinished,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
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
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsJointEntity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTriggerEntity,
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
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetAlpha,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsEnabled,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetEnabled,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetPosition,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,  
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetPosition,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY, 
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY, 
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsDestroyed,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Destroy,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Coincided,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         
      // game / entity / shape
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsCircleShapeEntity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsRectangleShapeEntity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsPolygonShapeEntity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsPolylineShapeEntity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsBombShapeEntitiy,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntitiy,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean,
                     ]
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetOriginalCIType,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetOriginalCIType,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetCIType,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetCIType,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
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
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetCollisionCategory,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetCollisionCategory,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_CollisionCategory, 
                     ],
                     null
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
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //            ],
         //            [
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
         //            ]
         //         );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsSleeping,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Boolean, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetSleeping,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetMass,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Mass, 
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetMass,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Mass, 
         //               ValueTypeDefine.ValueType_Boolean, 
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetInertia,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Inertia, 
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetInertia,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Inertia, 
         //               ValueTypeDefine.ValueType_Boolean, 
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
         //            ],
         //            null
         //         );
         
         
         // todo: use single instead of double
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetLinearVelocity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityY, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetLinearVelocity,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityY, 
                     ]
                  );
         // todo: use single instead of double
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseByVelocityVector,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityY, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForce,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceY, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceY, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtWorldPoint,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceY, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepTorque,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_Torque, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulse,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseY, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtLocalPoint,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseY, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtWorldPoint,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseY, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyAngularImpulse,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_AngularImpulse, 
                     ],
                     null
                  );
         
         // ...
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Teleport,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_TeleportOffsets,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Clone,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians, 
         //               ValueTypeDefine.ValueType_Boolean, 
         //               ValueTypeDefine.ValueType_Boolean, 
         //            ],
         //            null
         //         );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Detach,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_AttachWith,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_DetachThenAttachWith,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_BreakupBrothers,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
		 
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_BreakAllJoints,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );


         
      // game / entity / shape / text
         
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
         
      // game / entity / shape / circle
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeCircle_GetRadius,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                     ]
                  );
         
      // game / entity / shape / rectangle
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_GetSize,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                     ]
                  );
         
      // game / entity / shape / poly
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexCount,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPosition,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,  
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPosition,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,  
                     ]
                  );
         
      // game / entity / joint
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointMotorEnabled,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointLimitsEnabled,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeAngleByDegrees,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeMotorSpeed,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_AngularVelocity, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeMotorSpeed,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_AngularVelocity, 
                     ],
                     null
                  );
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderTranslation,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderLimits,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderLimits,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderMotorSpeed,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     [
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearVelocityMagnitude, 
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderMotorSpeed,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearVelocityMagnitude, 
                     ],
                     null
                  );
         
      // game / entity / event handler
         
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_ResetTimer,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerPaused,
                     [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Boolean, 
                     ],
                     null
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerInterval,
         //            [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General, 
         //            ],
         //            null
         //         );
      
      
      } // initialze
         
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterCoreDeclaration (functionId:int, paramValueTypes:Array, returnValueTypes:Array):void
      {
         if (functionId < 0 || functionId >= IdPool.NumPlayerFunctions)
            return;
         
         sCoreFunctionDeclarations [functionId] = new FunctionDeclaration (functionId, paramValueTypes, returnValueTypes);
      }
      
      public static function GetCoreFunctionDeclaration (functionId:int):FunctionDeclaration
      {
         if (functionId < 0 || functionId >= IdPool.NumPlayerFunctions)
            return null;
         
         if (! mInitialized)
            Initialize ();
         
         return sCoreFunctionDeclarations [functionId];
      }
      
   }
}
