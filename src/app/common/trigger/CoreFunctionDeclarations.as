package common.trigger {

   import common.Define;

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
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                        [ValueTypeDefine.ValueType_Array,       null],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                        [ValueTypeDefine.ValueType_Array,       null],
                     ]
                  );

         }

      // special,       some predefineds for internal using

         RegisterCoreDeclaration (CoreFunctionIds.ID_Void,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityFilter,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityPairFilter,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

      // global

         RegisterCoreDeclaration (CoreFunctionIds.ID_Return,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ReturnIfTrue,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ReturnIfFalse,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Break,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Continue,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Comment,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Blank,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Removed,
                     null,
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_StartIf,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true], // add from v1.56
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
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true], // add from v1.56
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
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetCurrentDateTime,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetDay,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetTimeZone,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsKeyHold,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsMouseButtonHold,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_SetMouseVisible,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     null
                  );

      // string

         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Assign,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ConditionAssign,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_SwapValues,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_IsNull,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Equals,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Add,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetLength,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetCharAt,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetCharCodeAt,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_CharCode2Char,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ToLowerCase,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ToUpperCase,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_IndexOf,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       -1],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_LastIndexOf,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0x7fffffff],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       -1],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Substring,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0x7fffffff],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );

       // bool

         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Assign,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_ConditionAssign,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_SwapValues,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Boolean_ToString,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_EqualsBoolean,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Invert,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_IsTrue,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_IsFalse,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_And,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Or,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Not,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Xor,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );


      // array

         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_Assign,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_ConditionAssign,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Array,       null],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SwapValues,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Array,       null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_Equals,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Array,       null],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_Create,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_IsNull,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetLength,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetLength,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_RemoveElementAt,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithBoolean,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsBoolean,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithNumber,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsNumber,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithString,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsString,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithCCat,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsCCat,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithEntity,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsEntity,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithArray,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                        [ValueTypeDefine.ValueType_Array,       null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsArray,
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ]
                  );

       // math basic op

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Assign,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ConditionAssign,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_SwapValues,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Equals,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_LargerThan,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_LessThan,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_IsNaN,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_IsInfinity,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Negative,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Add,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Subtract,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Multiply,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Divide,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Modulo,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / toString

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToString,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         // disabled for flex bug
         //RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToExponential,
         //            [
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       2.0],
         //            ],
         //            [
         //               [ValueTypeDefine.ValueType_String,       ""],
         //            ]
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToFixed,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       2],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToPrecision,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       6],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToStringByRadix,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       10],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ParseFloat,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ParseInteger,
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       10],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / trogonomotry

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_SinRadians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_CosRadians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_TanRadians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcSinRadians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcCosRadians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcTanRadians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDyDx,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcTan2Radians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );

      // math / bitwise

         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftLeft,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRight,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_And,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Or,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Not,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Xor,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / random

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Random,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RandomRange,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RandomIntRange,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0x7FFFFFFF],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngCreate,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngSetSeed,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandom,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandomRange,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandomIntRange,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0x7FFFFFFF],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / number convert

          RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Degrees2Radians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Radians2Degrees,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
          RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Number2RGB,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RGB2Number,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / more

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Inverse,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Max,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Min,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Abs,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Sqrt,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Ceil,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Floor,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Round,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Log,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Exp,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Power,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.Id_Math_LinearInterpolation,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.Id_Math_LinearInterpolationColor,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Clamp,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
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
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelPaused,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetPlaySpeedX,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetPlaySpeedX,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       2],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetWorldScale,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetWorldScale,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       1.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelMilliseconds,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelSteps,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetMousePosition,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelStatus,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelSuccessed,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelFailed,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelUnfinished,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

      // game / world

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearAccelerationMagnitude,       9.8],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearAccelerationMagnitude,       9.8],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearAccelerationX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearAccelerationY,       9.8],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetGravityAcceleration_Vector,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearAccelerationX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearAccelerationY,       9.8],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetCurrentCamera,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetCameraCenter,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetCameraRotationByDegrees,
                     null,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraWithShape,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        //ValueTypeDefine.ValueType_Boolean,
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraRotationWithShape,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       30],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       30],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       30],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallScript,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_ConditionCallScript,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallBoolFunction,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_ConditionCallBoolFunction,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallScriptMultiTimes,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

     // game / world / create ...

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CreateExplosion,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       64],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       60],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       25.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.8],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearVelocityMagnitude,       50.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0x0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );

     // game / world / appearance



     // game / collision category

         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_Assign,
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_ConditionAssign,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SwapValues,
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_IsNull,
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_ToString,
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_Equals,
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SetCollideInternally,
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SetAsFriends,
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );

     // game / entity

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Assign,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_ConditionAssign,
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SwapValues,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsNull,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetEntityId,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetEntityByIdOffset,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_ToString,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Equals,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetTaskStatus,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskSuccessed,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskFailed,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskUnfinished,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsShapeEntity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsJointEntity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTriggerEntity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsVisible,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetVisible,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetAlpha,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetAlpha,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsEnabled,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetEnabled,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetPosition,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetPosition,
         //            [
         //               [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetAccumulatedRotationByRadians,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Clone,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_WorldVector2LocalVector,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       1.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       1.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_LocalVector2WorldVector,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       1.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       1.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsDestroyed,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Destroy,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Coincided,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.8],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.8],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       6],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

      // game / entity / shape

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsCircleShapeEntity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsRectangleShapeEntity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsPolygonShapeEntity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsPolylineShapeEntity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsBombShapeEntitiy,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntitiy,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetOriginalCIType,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetOriginalCIType,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetCIType,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetCIType,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledOpacity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       100.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledOpacity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       100.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderColor,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderColor,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderColorRGB,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderColorRGB,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderOpacity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       100.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderOpacity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       100.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsStatic,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetCollisionCategory,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetCollisionCategory,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_CollisionCategory,       Define.CCatId_Hidden],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsSensor,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetAsSensor,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity,
         //            [
         //               [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
         //            ],
         //            [
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
         //            ]
         //         );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity,
         //            [
         //               [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsSleeping,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetSleeping,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetMass,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Mass,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetMass,
         //            [
         //               [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Mass,       0.0],
         //               [ValueTypeDefine.ValueType_Boolean,       false],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetInertia,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Inertia,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetInertia,
         //            [
         //               [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Inertia,       0.0],
         //               [ValueTypeDefine.ValueType_Boolean,       false],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity,
         //            [
         //               [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
         //               [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       0.0],
         //            ],
         //            null
         //         );


         // todo: use single instead of double
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetLinearVelocity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetLinearVelocity,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityY,       0.0],
                     ]
                  );
         // todo: use single instead of double
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseByVelocityVector,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearVelocityY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetAngularVelocityByRadians,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetAngularVelocityByDegrees,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetAngularVelocityByRadians,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_AngularVelocity,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetAngularVelocityByDegrees,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_AngularVelocity,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ChangeAngularVelocityByRadians,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ChangeAngularVelocityByDegrees,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForce,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtWorldPoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ForceY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepTorque,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_Torque,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulse,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtLocalPoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtWorldPoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_ImpulseY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyAngularImpulse,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_AngularImpulse,       0.0],
                     ],
                     null
                  );

         // ...

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetPhysicsOnesAtPoint,
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Teleport,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_TeleportOffsets,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Translate,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_TranslateTo,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_RotateAroundWorldPoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_RotateToAroundWorldPoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationRadians,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_FlipByWorldLinePoint,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       1.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                        [ValueTypeDefine.ValueType_Boolean,       false],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBrothers,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsAttchedWith,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Detach,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_AttachWith,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_DetachThenAttachWith,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_BreakupBrothers,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_DestroyBrothers,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_BreakAllJoints,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );



      // game / entity / shape / text

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_GetText,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetText,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_AppendText,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_AppendNewLine,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

      // game / entity / shape / circle

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeCircle_GetRadius,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeCircle_SetRadius,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       1.0],
                     ],
                     null
                  );

      // game / entity / shape / rectangle

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_GetSize,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_SetSize,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       1.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       1.0],
                     ],
                     null
                  );

      // game / entity / shape / poly

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexCount,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPosition,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexLocalPosition,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPosition,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexWorldPosition,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_InsertVertexByLocalPosition,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_InsertVertexByWorldPosition,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionX,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Double | ValueTypeDefine.NumberTypeUsage_PositionY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_DeleteVertexAt,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Integer | ValueTypeDefine.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );

      // game / entity / joint

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointMotorEnabled,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointLimitsEnabled,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeAngleByDegrees,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_RotationDegrees,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeMotorSpeed,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_AngularVelocity,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeMotorSpeed,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderTranslation,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderLimits,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderLimits,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.0],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_Length,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderMotorSpeed,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearVelocityMagnitude,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderMotorSpeed,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_LinearVelocityMagnitude,       0.0],
                     ],
                     null
                  );

      // game / entity / event handler

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_ResetTimer,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_IsTimerPaused,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerPaused,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_GetTimerInterval,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       1.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerInterval,
                     [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number | ValueTypeDefine.NumberTypeDetail_Single | ValueTypeDefine.NumberTypeUsage_General,       1.0],
                     ],
                     null
                  );


      } // initialze

//===========================================================
// util functions
//===========================================================

      private static function RegisterCoreDeclaration (functionId:int, inputParamDefines:Array, outputParamDefines:Array):void
      {
         if (functionId < 0 || functionId >= IdPool.NumPlayerFunctions)
            return;

         sCoreFunctionDeclarations [functionId] = new FunctionDeclaration (functionId, inputParamDefines, outputParamDefines);
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
