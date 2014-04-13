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

         //if (Compile::Is_Debugging)
         //{
            RegisterCoreDeclaration (CoreFunctionIds.ID_ForDebug,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );

            RegisterCoreDeclaration (CoreFunctionIds.ID_GetDebugString,
                     null,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         //}

      // special,       some predefineds for internal using

         RegisterCoreDeclaration (CoreFunctionIds.ID_Void,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityFilter,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityPairFilter,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

      // global

         RegisterCoreDeclaration (CoreFunctionIds.ID_Return,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ReturnIfTrue,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ReturnIfFalse,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
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
                        [CoreClassIds.ValueType_String,       ""],
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
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true], // add from v1.56
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
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true], // add from v1.56
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EndWhile,
                     null,
                     null
                  );

      // class common

         RegisterCoreDeclaration (CoreFunctionIds.ID_CommonAssign,
                     [
                        [CoreClassIds.ValueType_Object,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Object,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CommonEquals,
                     [
                        [CoreClassIds.ValueType_Object,       null],
                        [CoreClassIds.ValueType_Object,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CommonNewInstance,
                     [
                        [CoreClassIds.ValueType_Class,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Object,       null],
                     ]
                  );

      // system / time

         RegisterCoreDeclaration (CoreFunctionIds.ID_GetProgramMilliseconds,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetCurrentDateTime,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetDay,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetTimeZone,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsKeyHold,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsMouseButtonHold,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_SetMouseVisible,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetMouseGestureEnabled,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsAccelerometerSupported,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetAcceleration,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsNativeApp,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ExitApp,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetScreenResolution,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetScreenDPI,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       100.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetOsNameString,
                     null,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_OpenURL,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_CopyToClipboard,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetLanguageCode,
                     null,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );

      // services

         RegisterCoreDeclaration (CoreFunctionIds.ID_SubmitHighScore,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_SubmitKeyValue_Number,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
                  
         //RegisterCoreDeclaration (CoreFunctionIds.ID_ConnectToMultiplePlayerServer,
         //            null,
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CreateNewGameInstanceDefine,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       2],
                     ],
                     [
                        [CoreClassIds.ValueType_MultiplePlayerInstanceDefine,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CreateNewGameInstanceChannelDefine,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,     0], //MultiplePlayerDefine.InstanceChannelMode_Free],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,      0],
                     ],
                     [
                        [CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GameInstanceDefineSetChannelDefine,
                     [
                        [CoreClassIds.ValueType_MultiplePlayerInstanceDefine,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_MultiplePlayerInstanceChannelDefine,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       null],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_CreateGameInstance,
         //            [
         //               [CoreClassIds.ValueType_MultiplePlayerInstanceDefine,       null],
         //               [CoreClassIds.ValueType_String,       ""],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_JoinGameInstanceRandomly,
                     [
                        [CoreClassIds.ValueType_MultiplePlayerInstanceDefine,       null],
                        //[CoreClassIds.ValueType_Boolean,      true],
                     ],
                     null
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_JoinGameInstanceByInstanceID,
         //            [
         //               [CoreClassIds.ValueType_MultiplePlayerInstanceDefine,       null],
         //               [CoreClassIds.ValueType_String,       ""],
         //               [CoreClassIds.ValueType_String,       ""],
         //            ],
         //            null
         //         );
                  
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsGameInstanceLoggedIn,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_IsGameInstanceInPlayingPhase,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetGameInstanceNumberOfSeats,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetMySeatIndexInGameInstance,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetGameInstanceSeatInfo,
                     null,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_GetGameInstanceChannelSeatInfo,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       null],
                     ]
                  );
                  
         RegisterCoreDeclaration (CoreFunctionIds.ID_SendGameInstanceChannelMessage,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ],
                     null
                  );
                  
         RegisterCoreDeclaration (CoreFunctionIds.ID_SendRestartInstanceSignal,
                     null,
                     null
                  );

      // string

         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Assign,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ConditionAssign,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_SwapValues,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_IsNull,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Equals,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Add,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetLength,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetCharAt,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_GetCharCodeAt,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_CharCode2Char,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ToLowerCase,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_ToUpperCase,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_IndexOf,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       -1],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_LastIndexOf,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0x7fffffff],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       -1],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Substring,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0x7fffffff],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Split,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ","],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_String_Replace,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );


       // bool

         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Assign,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_ConditionAssign,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_SwapValues,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Boolean_ToString,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_EqualsBoolean,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Invert,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_IsTrue,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_IsFalse,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_And,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Or,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Not,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bool_Xor,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );


      // array

         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_Assign,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_ConditionAssign,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SwapValues,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_Equals,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_ExactEquals,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_ToString,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_Create,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_IsNull,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetLength,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetLength,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SubArray,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       16777215],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_RemoveElements,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       1],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_InsertElements,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       1],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_Concat,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SwapElements,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_Reverse,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithBoolean,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsBoolean,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithNumber,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsNumber,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithString,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsString,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithCCat,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsCCat,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithEntity,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsEntity,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithModule,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Module,       Define.ModuleId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsModule,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Module,       Define.ModuleId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithSound,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Sound,       Define.SoundId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsSound,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Sound,       Define.SoundId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElementWithArray,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Array,       null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElementAsArray,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_SetElement,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Object,       null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Array_GetElement,
                     [
                        [CoreClassIds.ValueType_Array,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_Object,       null],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_Array_IndexOf,
         //            [
         //               [CoreClassIds.ValueType_Array,       null],
         //               [CoreClassIds.ValueType_Object,       null],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
         //            ],
         //            [
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       -1],
         //            ]
         //         );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_Array_LastIndexOf,
         //            [
         //               [CoreClassIds.ValueType_Array,       null],
         //               [CoreClassIds.ValueType_Object,       null],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0x7fffffff],
         //            ],
         //            [
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       -1],
         //            ]
         //         );

      // byte array
      
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArray_Create,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArray_CreateFromBase64String,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArray_ToBase64String,
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArray_Compress,
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArray_Uncompress,
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ]
                  );
                  
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_Create,
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_GetByteArray,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_SetByteArray,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                        [CoreClassIds.ValueType_ByteArray,       null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_GetCursorPosition,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_SetCursorPosition,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_ReadByteArray,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                        [CoreClassIds.ValueType_ByteArray,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_WriteByteArray,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                        [CoreClassIds.ValueType_ByteArray,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_ReadBoolean,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_WriteBoolean,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_ReadNumber,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                        [CoreClassIds.ValueType_Number,       CoreClassIds.NumberTypeDetail_Int32Number],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_WriteNumber,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number,       CoreClassIds.NumberTypeDetail_Int32Number],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_ReadUTF,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_ByteArrayStream_WriteUTF,
                     [
                        [CoreClassIds.ValueType_ByteArrayStream,       null],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     null
                  );
      
       // math basic op

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Assign,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ConditionAssign,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_SwapValues,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Equals,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_LargerThan,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_LessThan,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_IsNaN,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_IsInfinity,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Negative,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Add,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       1.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Subtract,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Multiply,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Divide,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Modulo,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / toString

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToString,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         // disabled for flex bug
         //RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToExponential,
         //            [
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       2.0],
         //            ],
         //            [
         //               [CoreClassIds.ValueType_String,       ""],
         //            ]
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToFixed,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       2],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToPrecision,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       6],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ToStringByRadix,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       10],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ParseFloat,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ParseInteger,
                     [
                        [CoreClassIds.ValueType_String,       ""],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       10],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / trogonomotry

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_SinRadians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_CosRadians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_TanRadians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcSinRadians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcCosRadians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcTanRadians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDyDx,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_ArcTan2Radians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );

      // math / bitwise

         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftLeft,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRight,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_And,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Or,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Not,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Bitwise_Xor,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / random

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Random,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RandomRange,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RandomIntRange,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0x7FFFFFFF],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngCreate,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngSetSeed,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandom,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandomRange,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RngRandomIntRange,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0x7FFFFFFF],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / number convert

          RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Degrees2Radians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Radians2Degrees,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
          RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Number2RGB,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_RGB2Number,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // math / more

         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Inverse,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Max,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Min,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Abs,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Sqrt,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Ceil,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Floor,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Round,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Log,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Exp,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Power,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.Id_Math_LinearInterpolation,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.Id_Math_LinearInterpolationColor,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Number_Clamp,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

      // game / design

         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_LoadLevel,
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       Define.SceneSwitchingStyle_FadingIn],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_MergeLevel,
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelByIdOffset,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       1.0],
                        [CoreClassIds.ValueType_Scene,         null],
                     ],
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelId,
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelByKey,
                     [
                        [CoreClassIds.ValueType_String,       null],
                     ],
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelKey,
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                     ],
                     [
                        [CoreClassIds.ValueType_String,         null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetCurrentLevel,
                     null,
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsNullLevel,
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SceneEquals,
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                        [CoreClassIds.ValueType_Scene,         null],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_Scene2String,
                     [
                        [CoreClassIds.ValueType_Scene,         null],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       null],
                     ]
                  );
                  
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_WriteSaveData,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_LoadSaveData,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_ResetSaveData,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_DeleteSaveData,
                     null,
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_RestartLevel,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       Define.SceneSwitchingStyle_FadingIn],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelPaused,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelPaused,
                     [
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetPlaySpeedX,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetPlaySpeedX,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       2],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetWorldScale,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetWorldScale,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       1.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelMilliseconds,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetLevelSteps,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetMousePosition,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_GetNumEntitiesPlacedInEditor,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelStatus,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelSuccessed,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelFailed,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_IsLevelUnfinished,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelBooleanProperty,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       Define.LevelProperty_Invalid],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelNumberProperty,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       Define.LevelProperty_Invalid],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_General,      0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Design_SetLevelStringProperty,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       Define.LevelProperty_Invalid],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     null
                  );

      // game / world / appearance
                  
          RegisterCoreDeclaration (CoreFunctionIds.ID_Level_GetFilledColor,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Level_SetFilledColor,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Level_GetFilledColorRGB,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Level_SetFilledColorRGB,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Level_GetBorderColor,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Level_SetBorderColor,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Level_GetBorderColorRGB,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Level_SetBorderColorRGB,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );

      // game / world / physics

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_IsPhysicsEngineEnabled,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetPhysicsEngineEnabled,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetRealtimeFPS,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       50],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetPreferredFpsAndStepTimeLangth,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       50],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.02],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetPreferredFpsAndStepTimeLangth,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       50],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.02],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearAccelerationMagnitude,       9.8],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearAccelerationMagnitude,       9.8],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearAccelerationX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearAccelerationY,       9.8],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetGravityAcceleration_Vector,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearAccelerationX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearAccelerationY,       9.8],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_UpdateShapeContactStatusInfos,
                     null,
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetPhysicsOnesAtPoint,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetFirstIncomingIntersectionWithLineSegment,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetFirstOutcomingIntersectionWithLineSegment,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetIntersectedShapesWithLineSegment,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Boolean,     false],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetIntersectionSegmentsWithLineSegment,
         //            [
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
         //            ],
         //            [
         //               [CoreClassIds.ValueType_Array,       null],
         //            ]
         //         );

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetViewportSize,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetCurrentCamera,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetCameraCenter,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetCameraRotationByDegrees,
                     null,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraWithShape,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                        //CoreClassIds.ValueType_Boolean,
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_FollowCameraRotationWithShape,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       30],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       30],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       30],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallScript,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_ConditionCallScript,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallBoolFunction,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_ConditionCallBoolFunction,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallScriptMultiTimes,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

     // game / world / create ...

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_CreateExplosion,
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       64],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       60],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       25.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.8],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearVelocityMagnitude,       50.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0x0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );

     // game / world / sound

         RegisterCoreDeclaration (CoreFunctionIds.ID_World_PlaySound,
                     [
                        [CoreClassIds.ValueType_Sound,       -1],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,      1  ],
                        [CoreClassIds.ValueType_Boolean,       false], // from v2.02
                        /*[CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       1.0],*/ // to add
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_StopSounds_InLevel,
                     null,
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_StopSound_CrossLevels,
                     [
                        [CoreClassIds.ValueType_Sound,       -1],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_IsSoundEnabled,
                     null,
                     [
                        [CoreClassIds.ValueType_Boolean,       true ],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetSoundEnabled,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_World_GetGlobalSoundVolume,
         //            null,
         //            [
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.5],
         //            ]
         //         );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_World_SetGlobalSoundVolume,
         //            [
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.5],
         //            ],
         //            null
         //         );

     // game / world / module

         RegisterCoreDeclaration (CoreFunctionIds.ID_Module_Assign,
                     [
                        [CoreClassIds.ValueType_Module,       -1],
                     ],
                     [
                        [CoreClassIds.ValueType_Module,       -1],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Module_Equals,
                     [
                        [CoreClassIds.ValueType_Module,       -1],
                        [CoreClassIds.ValueType_Module,       -1],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

     // game / world / appearance



     // game / collision category

         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_Assign,
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_ConditionAssign,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SwapValues,
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_IsNull,
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_ToString,
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_Equals,
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SetCollideInternally,
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_CCat_SetAsFriends,
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );

     // game / entity

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Assign,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_ConditionAssign,
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SwapValues,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsNull,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetEntityId,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetEntityByIdOffset,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_ToString,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Equals,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetTaskStatus,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskSuccessed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskFailed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTaskUnfinished,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsJointEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTriggerEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsVisible,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetVisible,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetAlpha,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetAlpha,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_AdjustAppearanceOrder,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_AdjustAppearanceOrderRelativeTo,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsEnabled,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetEnabled,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_SetPosition,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetAccumulatedRotationByRadians,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsFlipped,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_GetScale,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Clone,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_WorldVector2LocalVector,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       1.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       1.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_LocalVector2WorldVector,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       1.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       1.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsDestroyed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Destroy,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_Coincided,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.8],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.8],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       6],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

      // game / entity / shape

         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsCircleShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsRectangleShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsPolygonShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsPolylineShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsBombShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsCameraEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsTextShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsModuleShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_Entity_IsButtonShapeEntity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetOriginalCIType,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetOriginalCIType,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetCIType,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetCIType,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBodyTexture,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Module,       -1],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetBodyTexture,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Module,       -1],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledOpacity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       100.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledOpacity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       100.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsShowBorder,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetShowBorder,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderColor,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderColor,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderColorRGB,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderColorRGB,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderOpacity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       100.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderOpacity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       100.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetCacheAsBitmap,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetCollisionCategory,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetCollisionCategory,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_CollisionCategory,       Define.CCatId_None/*CCatId_Hidden*/],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsSensor,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetAsSensor,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsStatic,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       true],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetStatic,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsRotationFixed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetRotationFixed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //            ],
         //            [
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
         //            ]
         //         );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsSleeping,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetSleeping,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetLocalCentroid,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetWorldCentroid,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetMass,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Mass,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetMass,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Mass,       0.0],
         //               //[CoreClassIds.ValueType_Boolean,       false],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetInertia,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Inertia,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetInertia,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Inertia,       0.0],
         //               //[CoreClassIds.ValueType_Boolean,       false],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );


         // todo: use single instead of double
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetLinearVelocity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearVelocityX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearVelocityY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetLinearVelocity,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearVelocityX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearVelocityY,       0.0],
                     ]
                  );
         // todo: use single instead of double
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseByVelocityVector,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearVelocityX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearVelocityY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetAngularVelocityByRadians,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetAngularVelocityByDegrees,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetAngularVelocityByRadians,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_AngularVelocity,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetAngularVelocityByDegrees,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_AngularVelocity,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ChangeAngularVelocityByRadians,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ChangeAngularVelocityByDegrees,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForce,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ForceX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ForceY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ForceX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ForceY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtWorldPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ForceX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ForceY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepTorque,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_Torque,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulse,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ImpulseX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ImpulseY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtLocalPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ImpulseX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ImpulseY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtWorldPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ImpulseX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_ImpulseY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ApplyAngularImpulse,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_AngularImpulse,       0.0],
                     ],
                     null
                  );

         // ...

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Teleport,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_TeleportOffsets,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Translate,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_TranslateTo,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_RotateAroundWorldPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_RotateToAroundWorldPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationRadians,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_FlipSelf,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_FlipByWorldLinePoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearDeltaX,       1.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_ScaleWithFixedPoint,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       1.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                        [CoreClassIds.ValueType_Boolean,       true],
                        [CoreClassIds.ValueType_Boolean,       false],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBrothers,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsAttchedWith,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_Detach,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_AttachWith,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_DetachThenAttachWith,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_BreakupBrothers,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_DestroyBrothers,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_BreakAllJoints,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetAllSisters,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsConnectedWith,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsConnectedWithGround,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetAllContactedShapes,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Array,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_IsContactedWith,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );


      // game / entity / shape / text

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_GetText,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_String,       ""],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetText,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_AppendText,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_String,       ""],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_AppendNewLine,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_GetHorizontalScrollPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetHorizontalScrollPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_GetVerticalScrollPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetVerticalScrollPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_GetMaxHorizontalScrollPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_GetMaxVerticalScrollPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetSize,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       15.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetColor,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetColorByRGB,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetSize_MouseOver,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       15.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetColor_MouseOver,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetColorByRGB_MouseOver,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetSize_MouseDown,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       15.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetColor_MouseDown,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityText_SetBackgroundColor_MouseDown,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     null
                  );


      // game / entity / shape / circle

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeCircle_GetRadius,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeCircle_SetRadius,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       1.0],
                     ],
                     null
                  );

      // game / entity / shape / rectangle

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_GetSize,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_SetSize,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       1.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       1.0],
                     ],
                     null
                  );

      // game / entity / shape / poly

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexCount,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexLocalPosition,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
         //            ],
         //            null
         //         );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPosition,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
                     ]
                  );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexWorldPosition,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
         //            ],
         //            null
         //         );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_InsertVertexByLocalPosition,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearDeltaX,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearDeltaY,       0.0],
         //            ],
         //            null
         //         );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_InsertVertexByWorldPosition,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionX,       0.0],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Double | CoreClassIds.NumberTypeUsage_PositionY,       0.0],
         //            ],
         //            null
         //         );
         //RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_DeleteVertexAt,
         //            [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Integer | CoreClassIds.NumberTypeUsage_General,       0.0],
         //            ],
         //            null
         //         );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPositions,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Array | CoreClassIds.ArrayTypeUsage_Position,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexLocalPositions,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Array | CoreClassIds.ArrayTypeUsage_Position,       null],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPositions,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Array | CoreClassIds.ArrayTypeUsage_Position,       null],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapePoly_SetVertexWorldPositions,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Array | CoreClassIds.ArrayTypeUsage_Position,       null],
                     ],
                     null
                  );

      // game / entity / shape / thickness
      
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetBorderThickness,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetBorderThickness,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_GetCurveThickness,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShape_SetCurveThickness,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ],
                     null
                  );

      // game / entity / shape / module

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeModule_GetModule,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Module,       -1],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeModule_ChangeModule,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Module,       -1],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeModuleButton_GetOverModule,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Module,       -1],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeModuleButton_ChangeOverModule,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Module,       -1],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeModuleButton_GetDownModule,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Module,       -1],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityShapeModuleButton_ChangeDownModule,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Module,       -1],
                     ],
                     null
                  );

      // game / entity / joint

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetJointConnectedShapes,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ]
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointMotorEnabled,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointLimitsEnabled,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeAngleByDegrees,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_RotationDegrees,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeMotorSpeed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_AngularVelocity,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeMotorSpeed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_AngularVelocity,       0.0],
                     ],
                     null
                  );

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderTranslation,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderLimits,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderLimits,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_Length,       0.0],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderMotorSpeed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearVelocityMagnitude,       0.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderMotorSpeed,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_LinearVelocityMagnitude,       0.0],
                     ],
                     null
                  );

      // game / entity / event handler

         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_ResetTimer,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_IsTimerPaused,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Boolean,       false],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerPaused,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Boolean,       true],
                     ],
                     null
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_GetTimerInterval,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                     ],
                     [
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       1.0],
                     ]
                  );
         RegisterCoreDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerInterval,
                     [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number | CoreClassIds.NumberTypeDetailBit_Single | CoreClassIds.NumberTypeUsage_General,       1.0],
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

         sCoreFunctionDeclarations [functionId] = new FunctionCoreBasicDefine (functionId, inputParamDefines, outputParamDefines);
      }

      public static function GetCoreFunctionDeclaration (functionId:int):FunctionCoreBasicDefine
      {
         if (functionId < 0 || functionId >= IdPool.NumPlayerFunctions)
            return null;

         if (! mInitialized)
            Initialize ();

         return sCoreFunctionDeclarations [functionId];
      }

   }
}
