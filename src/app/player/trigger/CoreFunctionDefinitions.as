
package player.trigger {
   import flash.utils.getTimer;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.utils.Dictionary;

   import player.design.Global;

   import player.world.*;
   import player.entity.*;
   import player.trigger.entity.*;

   import player.module.Module;

   import player.sound.Sound;

   import player.physics.PhysicsEngine;

   //import player.trigger.FunctionDefinition_Core;
   //import player.trigger.Parameter;
   //import player.trigger.Parameter_DirectConstant;
   //import player.trigger.CoreClasses;
   //import player.trigger.ClassInstance;

   import com.tapirgames.util.RandomNumberGenerator;

   import common.trigger.CoreFunctionIds;
   import common.trigger.FunctionCoreBasicDefine;
   import common.trigger.CoreFunctionDeclarations;

   import common.trigger.ValueDefine;
   import common.trigger.IdPool;
   import common.trigger.CoreEventIds;

   import common.SceneDefine;
   import common.Define;
   import common.ValueAdjuster;

   import common.TriggerFormatHelper2;

   public class CoreFunctionDefinitions
   {

//=============================

      public static var sCoreFunctionDefinitions:Array = new Array (IdPool.NumPlayerFunctions);

      public static function Initialize (playerWorld:World):void
      {
         //if (Compile::Is_Debugging)
         //{
            RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_ForDebug,                     ForDebug);
            RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetDebugString,               GetDebugString);
         //}

      // some specail

         //

      // code flow

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Return,                        null);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_ReturnIfTrue,                  null);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_ReturnIfFalse,                 null);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_StartIf,                       null);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Else,                          null);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EndIf,                         null);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_StartWhile,                    null);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Break,                         null);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Continue,                      null);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EndWhile,                      null);

      // class common
         
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CommonAssign,                      null); // CommonAssign);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CommonEquals,                      CommonEquals);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CommonNewInstance,                 CommonNewInstance);

      // system / time

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetProgramMilliseconds,           GetProgramMilliseconds);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetCurrentDateTime,               GetCurrentDateTime);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetDay,                           GetDay);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetTimeZone,                      GetTimeZone);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_IsKeyHold,                        IsKeyHold);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_SetMouseVisible,                  SetMouseVisible);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_IsAccelerometerSupported,                  IsAccelerometerSupported);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetAcceleration,                     GetAccelerationVector);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_IsNativeApp,                     IsNativeApp);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_ExitApp,                     ExitApp);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetScreenResolution,         GetScreenResolution);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetScreenDPI,                GetScreenDPI);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetOsNameString,                GetOsNameString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_OpenURL,                     OpenURL);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CopyToClipboard,                     CopyToClipboard);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_GetLanguageCode,                     GetLanguageCode);

      // services

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_SubmitHighScore,                     SubmitHighScore);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_SubmitKeyValue_Number,               SubmitKeyValue_Number);

      // string

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_Assign,                      AssignString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_ConditionAssign,             ConditionAssignString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_SwapValues,                  SwapStringValues);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_IsNull,                      IsNullString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_Equals,                      EqualsWith_Strings);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_Add,                         AddTwoStrings);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_GetLength,                   GetStringLength);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_GetCharAt,                   StringCharAt);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_GetCharCodeAt,               StringCharCodeAt);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_CharCode2Char,               CharCode2Char);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_ToLowerCase,                 ToLowerCaseString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_ToUpperCase,                 ToUpperCaseString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_IndexOf,                     IndexOfSubstring);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_LastIndexOf,                 LastIndexOfSubstring);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_Substring,                   Substring);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_Split,                       SplitString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_String_Replace,                     ReplaceString);

      // bool

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_Assign,                AssignBoolean);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_ConditionAssign,       ConditionAssignBoolean);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_SwapValues,    SwapBooleanValues);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_EqualsBoolean,         EqualsWith_Booleans);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Boolean_ToString,           BooleanToString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_Invert,                BooleanInvert);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_IsTrue,                IsTrue);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_IsFalse,               IsFalse);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_LargerThan,            LargerThan);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_LessThan,              LessThan);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_And,               BoolAnd);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_Or,                BoolOr);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_Not,               BoolNot);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bool_Xor,               BoolXor);

      // array

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_Assign,               AssignArray);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_ConditionAssign,      ConditionAssignArray);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SwapValues,           SwapArrayValues);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_Equals,               EqualsWith_Arrays);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_ExactEquals,               ExactEqualsWith_Arrays);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_ToString,             ArrayToString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_Create,               CreateArray);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_IsNull,               IsNullArray);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetLength,               GetArrayLength);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetLength,               SetArrayLength);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SubArray,               SubArray);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_RemoveElements,               RemoveArrayElements);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_InsertElements,               InsertArrayElements);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_Concat,                       ConcatArrays);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SwapElements,                SwapArrayElements);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_Reverse,                     ReverseArray);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElementWithBoolean,     SetArrayElement); // SetArrayElementWithBoolean);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElementAsBoolean,       GetArrayElement); // GetArrayElementAsBoolean);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElementWithNumber,      SetArrayElement); // SetArrayElementWithNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElementAsNumber,        GetArrayElement); // GetArrayElementAsNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElementWithString,      SetArrayElement); // SetArrayElementWithString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElementAsString,        GetArrayElement); // GetArrayElementAsString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElementWithCCat,        SetArrayElement); // SetArrayElementWithCCat);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElementAsCCat,          GetArrayElement); // GetArrayElementAsCCat);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElementWithEntity,      SetArrayElement); // SetArrayElementWithEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElementAsEntity,        GetArrayElement); // GetArrayElementAsEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElementWithModule,      SetArrayElement); // SetArrayElementWithModule);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElementAsModule,        GetArrayElement); // GetArrayElementAsModule);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElementWithSound,       SetArrayElement); // SetArrayElementWithSound);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElementAsSound,         GetArrayElement); // GetArrayElementAsSound);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElementWithArray,       SetArrayElement); // SetArrayElementWithArray);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElementAsArray,         GetArrayElement); // GetArrayElementAsArray);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_SetElement,       SetArrayElement);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_GetElement,       GetArrayElement);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_IndexOf,                     IndexOfArrayElement);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Array_LastIndexOf,                 LastIndexOfArrayElement);

      // math ops

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Assign,               AssignNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ConditionAssign,      ConditionAssignNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_SwapValues,           SwapNumberValues);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Equals,               EqualsWith_Numbers);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_IsNaN,               IsNaN);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_IsInfinity,          IsInfinity);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ToString,             NumberToString);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ToExponential,      NumberToExponentialString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ToFixed,              NumberToFixedString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ToPrecision,          NumberToPrecisionString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ToStringByRadix,      NumberToStringByRadix);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ParseFloat,           ParseFloat);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ParseInteger,         ParseInteger);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Negative,                   NegativeNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Add,                        AddTwoNumbers);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Subtract,                   SubtractTwoNumbers);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Multiply,                   MultiplyTwoNumbers);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Divide,                     DivideTwoNumbers);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Modulo,                     ModuloTwoNumbers);

      // math / bitwise

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bitwise_ShiftLeft,             ShiftLeft);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bitwise_ShiftRight,            ShiftRight);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned,    ShiftRightUnsigned);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bitwise_And,                   BitwiseAnd);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bitwise_Or,                    BitwiseOr);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bitwise_Not,                   BitwiseNot);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Bitwise_Xor,                   BitwiseXor);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_SinRadians,                SinRadian);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_CosRadians,                CosRadian);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_TanRadians,                TanRadian);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ArcSinRadians,             AsinRadian);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ArcCosRadians,             AcosRadian);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ArcTanRadians,             AtanRadian);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_ArcTan2Radians,            AtanRadianTwoNumbers);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Random,                     RandomNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_RandomRange,                RandomNumberRange);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_RandomIntRange,             RandomIntegerRange);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_RngCreate,                  RngCreate);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_RngSetSeed,                 RngSetSeed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_RngRandom,                  RngRandom);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_RngRandomRange,             RngRandomNumberRange);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_RngRandomIntRange,          RngRandomIntegerRange);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Degrees2Radians,             Degrees2Radians);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Radians2Degrees,             Radians2Degrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Number2RGB,                  Number2RGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_RGB2Number,                  RGB2Number);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_MillisecondsToMinutesSeconds,     MillisecondsToMinutesSeconds);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Inverse,                   InverseNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Max,                        MaxOfTwoNumbers);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Min,                        MinOfTwoNumbers);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Abs,                       AbsNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Sqrt,                      SqrtNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Ceil,                      CeilNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Floor,                     FloorNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Round,                     RoundNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Log,                       LogNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Exp,                       ExpNumber);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Power,                     Power);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Number_Clamp,                     Clamp);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.Id_Math_LinearInterpolation,               LinearInterpolation);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.Id_Math_LinearInterpolationColor,          LinearInterpolationColor);

      // game / design

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_LoadLevel,              LoadLevel);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_MergeLevel,             MergeLevelIntoTheCurrentOne);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetLevelByIdOffset,           GetLevelByIdOffset);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetLevelId,           GetLevelId);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetLevelByKey,           GetLevelByKey);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetLevelKey,           GetLevelKey);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetCurrentLevel,           GetCurrentLevel);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_IsNullLevel,            IsNullLevel);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SceneEquals,            EqualsWith_Scenes);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_Scene2String,           SceneToString);
         
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_WriteSaveData,          WriteSaveData);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_LoadSaveData,           LoadSaveData);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_ResetSaveData,          ResetSaveData);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_DeleteSaveData,          DeleteSaveData);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_RestartLevel,              RestartLevel);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_IsLevelPaused,             IsLevelPaused);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SetLevelPaused,            SetLevelPaused);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetPlaySpeedX,             GetPlaySpeedX);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SetPlaySpeedX,             SetPlaySpeedX);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetWorldScale,             GetWorldScale);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SetWorldScale,             SetWorldScale);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetLevelMilliseconds,             GetLevelMilliseconds);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetLevelSteps,                    GetLevelSteps);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetMousePosition,                 GetWorldMousePosition);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_IsMouseButtonHold,                IsMouseButtonHold);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_GetNumEntitiesPlacedInEditor,     GetNumEntitiesPlacedInEditor);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SetLevelStatus,                   SetLevelStatus);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_IsLevelSuccessed,                 IsLevelSuccessed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_IsLevelFailed,                    IsLevelFailed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_IsLevelUnfinished,                IsLevelUnfinished);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SetMouseGestureEnabled,                SetMouseGestureEnabled);
         
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SetLevelBooleanProperty,                SetLevelProperty_Boolean);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SetLevelNumberProperty,                SetLevelProperty_Number);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Design_SetLevelStringProperty,                SetLevelProperty_String);

      // game / world / appearance
      
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Level_GetFilledColor,         GetLevelFilledColor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Level_SetFilledColor,         SetLevelFilledColor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Level_GetFilledColorRGB,      GetLevelFilledColorRGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Level_SetFilledColorRGB,      SetLevelFilledColorRGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Level_GetBorderColor,         GetLevelBorderColor);         
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Level_SetBorderColor,         SetLevelBorderColor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Level_GetBorderColorRGB,      GetLevelBorderColorRGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Level_SetBorderColorRGB,      SetLevelBorderColorRGB);

      // game / world / physics

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_IsPhysicsEngineEnabled,          IsPhysicsEngineEnabled);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_SetPhysicsEngineEnabled,         SetPhysicsEngineEnabled);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetRealtimeFPS,                       GetRealtimeFPS);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetPreferredFpsAndStepTimeLangth,     GetPreferredFpsAndStepTimeLangth);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_SetPreferredFpsAndStepTimeLangth,     SetPreferredFpsAndStepTimeLangth);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_SetGravityAcceleration_Radians,     SetWorldGravityAcceleration_Radians);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees,     SetWorldGravityAcceleration_Degrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_SetGravityAcceleration_Vector,      SetWorldGravityAcceleration_Vector);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetGravityAcceleration_Vector,      GetWorldGravityAcceleration_Vector);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_UpdateShapeContactStatusInfos,                   UpdateShapeContactStatusInfos);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetPhysicsOnesAtPoint,                   GetPhysicsShapesAtPoint);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetFirstIncomingIntersectionWithLineSegment,         GetFirstIncomingIntersectionWithLineSegment);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetFirstOutcomingIntersectionWithLineSegment,         GetFirstOutcomingIntersectionWithLineSegment);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetIntersectedShapesWithLineSegment,         GetIntersectedShapesWithLineSegment);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetViewportSize,                           GetViewportSize);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_SetCurrentCamera,                           SetCurrentCamera);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetCameraCenter,                           GetCameraCenter);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetCameraRotationByDegrees,                GetCameraRotation_Degrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_FollowCameraWithShape,                       FollowCameraWithShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_FollowCameraCenterXWithShape,                FollowCameraCenterXWithShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_FollowCameraCenterYWithShape,                FollowCameraCenterYWithShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_FollowCameraRotationWithShape,               FollowCameraRotationWithShape);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn,                CameraFadeOutThenFadeIn);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_CallScript,                          CallScript);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_ConditionCallScript,                 ConditionCallScript);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_CallBoolFunction,                          CallBoolFunction);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_ConditionCallBoolFunction,                 ConditionCallBoolFunction);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_CallScriptMultiTimes,                    CallScriptMultiTimes);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes,              CallBoolFunctionMultiTimes);

      // game / world / create

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_CreateExplosion,                            CreateExplosion);

      // game / world / sound

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_PlaySound,                            PlaySound);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_StopSounds_InLevel,                   StopAllSounds_InLevel);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_StopSound_CrossLevels,                StopSound_CrossLevels);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_IsSoundEnabled,                       IsSoundEnabled);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_SetSoundEnabled,                      SetSoundEnabled);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_GetGlobalSoundVolume,                 GetGlobalSoundVolume);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_World_SetGlobalSoundVolume,                 SetGlobalSoundVolume);

      // game / world / module

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Module_Assign,                   AssignModule);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Module_Equals,                   EqualsWith_Module);

      // game / collision category

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CCat_Assign,                                       AssignCollisionCategory);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CCat_ConditionAssign,                              ConditionAssignCollisionCategory);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CCat_SwapValues,                                   SwapCCatValues);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CCat_IsNull,                                       IsNullCCat);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CCat_Equals,                                       EqualsWith_CollisiontCategories);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CCat_ToString,                                     CollisionCategoryToString);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CCat_SetCollideInternally,                         SetCollisionCategoryCollideInternally);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_CCat_SetAsFriends,                                 SetCollisionCategoriesAsFriends);

      // game / entity

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_Assign,                      AssignEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_ConditionAssign,             ConditionAssignEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_SwapValues,                  SwapEntityValues);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsNull,                      IsNullEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_Equals,                      EqualsWith_Entities);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_ToString,                    EntityToString);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_GetEntityId,                 GetEntityId);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_GetEntityByIdOffset,         GetAnotherEntityByIdOffset);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_SetTaskStatus,                         SetEntityTaskStatus);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsTaskSuccessed,                       IsEntityTaskSuccessed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsTaskFailed,                          IsEntityTaskFailed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsTaskUnfinished,                      IsEntityTaskUnfinished);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsShapeEntity,                    IsShapeEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsJointEntity,                    IsJointEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsTriggerEntity,                  IsTriggerEntity);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsVisible,                   IsEntityVisible);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_SetVisible,                  SetEntityVisible);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_GetAlpha,                    GetEntityAlpha);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_SetAlpha,                    SetEntityAlpha);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_AdjustAppearanceOrder,                    AdjustEntityAppearanceOrder);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_AdjustAppearanceOrderRelativeTo,          AdjustEntityAppearanceOrderRelativeTo);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsEnabled,                   IsEntityEnabled);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_SetEnabled,                  SetEntityEnabled);



         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_GetPosition,                 GetEntityPosition);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_SetPosition,                 SetEntityPosition);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_GetRotationByDegrees,        GetEntityRotationByDegrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_GetRotationByRadians,        GetEntityRotationByRadians);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_GetAccumulatedRotationByRadians,        GetEntityAccumulatedRotationByDegrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsFlipped,        IsEntityFlipped);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_GetScale,        GetEntityScale);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint,        WorldPoint2EntityLocalPoint);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint,        EntityLocalPoint2WorldPoint);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_WorldVector2LocalVector,        WorldVector2EntityLocalVector);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_LocalVector2WorldVector,        EntityLocalVector2WorldVector);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsDestroyed,        IsEntityDestroyed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_Destroy,        DestroyEntity);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_Coincided,        AreTwoEntitiesCoincided);

      // game / entity / shape

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_Clone,                       CloneShape);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsCircleShapeEntity,              IsCircleShapeEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsRectangleShapeEntity,           IsRectangleShapeEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsPolygonShapeEntity,             IsPolygonShapeEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsPolylineShapeEntity,            IsPolylineShapeEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsBombShapeEntity,               IsBombShapeEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntity,        IsWorldBorderEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsCameraEntity,        IsCameraEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsTextShapeEntity,     IsTextShapeEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsModuleShapeEntity,   IsModuleShapeEntity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_Entity_IsButtonShapeEntity,   IsButtonShapeEntity);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetOriginalCIType,           GetShapeOriginalCIType);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetOriginalCIType,           SetShapeOriginalCIType);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetCIType,                   GetShapeCIType);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetCIType,                   SetShapeCIType);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetBodyTexture,              GetBodyTexture);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetBodyTexture,              SetBodyTexture);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetFilledColor,              GetShapeFilledColor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetFilledColor,              SetShapeFilledColor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetFilledColorRGB,           GetShapeFilledColorRGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetFilledColorRGB,           SetShapeFilledColorRGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetFilledOpacity,            GetFilledOpacity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetFilledOpacity,            SetFilledOpacity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsShowBorder,                IsShapeShowBorder);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetShowBorder,               SetShapeShowBorder);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetBorderColor,              GetShapeBorderColor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetBorderColor,              SetShapeBorderColor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetBorderColorRGB,           GetShapeBorderColorRGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetBorderColorRGB,           SetShapeBorderColorRGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetBorderOpacity,            GetBorderOpacity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetBorderOpacity,            SetBorderOpacity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetCacheAsBitmap,            SetCacheAsBitmap);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled,            IsShapePhysicsEnabled);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetPhysicsEnabled,         SetShapePhysicsEnabled);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetCollisionCategory,        GetShapeCollisionCategory);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetCollisionCategory,        SetShapeCollisionCategory);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsSensor,                    IsSensorShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetAsSensor,                 SetShapeAsSensor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsStatic,                    IsStatic);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetStatic,                   SetStatic);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsRotationFixed,                  IsShapeRotationFixed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetRotationFixed,                 SetShapeRotationFixed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsSleeping,                  IsShapeSleeping);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetSleeping,                 SetShapeSleeping);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetLocalCentroid,                        GetLocalCentroid);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetWorldCentroid,                        GetWorldCentroid);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetMass,                        GetShapeMass);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetMass,                        SetShapeMass);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetInertia,                     GetShapeInertia);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetInertia,                     SetShapeInertia);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetDensity,                     GetShapeDensity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetDensity,                     SetShapeDensity);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetLinearVelocity,                        SetShapeLinearVelocity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetLinearVelocity,                        GetShapeLinearVelocity);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseByVelocityVector,       AddLinearImpulseByVelocityVector);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetAngularVelocityByRadians,           SetAngularVelocityByRadians);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetAngularVelocityByDegrees,           SetAngularVelocityByDegrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetAngularVelocityByRadians,           GetAngularVelocityByRadians);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetAngularVelocityByDegrees,           GetAngularVelocityByDegrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ChangeAngularVelocityByRadians,        ChangeAngularVelocityByRadians);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ChangeAngularVelocityByDegrees,        ChangeAngularVelocityByDegrees);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyStepForce,                        ApplyStepForceOnShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint,            ApplyStepForceAtLocalPointOnShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyStepForceAtWorldPoint,            ApplyStepForceAtWorldPointOnShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyStepTorque,                       ApplyStepTorque);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyLinearImpulse,                        ApplyLinearImpulseOnShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtLocalPoint,            ApplyLinearImpulseAtLocalPointOnShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtWorldPoint,            ApplyLinearImpulseAtWorldPointOnShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ApplyAngularImpulse,                       ApplyAngularImpulse);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_Teleport,                      TeleportShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_TeleportOffsets,               TeleportShape_Offsets);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_Translate,                      TranslateShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_TranslateTo,                    TranslateShapeTo);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_RotateAroundWorldPoint,                      RotateShapeAroundWorldPoint);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_RotateToAroundWorldPoint,                    RotateShapeToAroundWorldPoint);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_FlipSelf,                       FlipShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_FlipByWorldLinePoint,                   FlipShapeByWorldLinePoint);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_ScaleWithFixedPoint,                    ScaleShapeWithFixedPoint);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetBrothers,                 GetBrothers);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsAttchedWith,               IsAttchedWith);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_Detach,                      DetachShape);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_AttachWith,                  AttachTwoShapes);
		   RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_DetachThenAttachWith,        DetachShapeThenAttachWithAnother);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_BreakupBrothers,             BreakupShapeBrothers);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_DestroyBrothers,             DestroyBrothers);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_BreakAllJoints,                 BreakShapeJoints);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetAllSisters,                 GetAllSisters);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsConnectedWith,                 IsConnectedWith);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsConnectedWithGround,                 IsConnectedWithGround);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetAllContactedShapes,             GetAllContactedShapes);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_IsContactedWith,                   IsContactedWith);

      // game / entity / shape / text

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_GetText,                  GetTextFromTextComponent);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetText,                  SetTextForTextComponent);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_AppendText,               AppendTextToTextComponent);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_AppendNewLine,            AppendNewLineToTextComponent);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_GetHorizontalScrollPosition,                  GetHorizontalScrollPosition);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetHorizontalScrollPosition,                  SetHorizontalScrollPosition);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_GetVerticalScrollPosition,                  GetVerticalScrollPosition);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetVerticalScrollPosition,                  SetVerticalScrollPosition);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_GetMaxHorizontalScrollPosition,                GetMaxHorizontalScrollPosition);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_GetMaxVerticalScrollPosition,                  GetMaxVerticalScrollPosition);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetSize,                  SetTextDefaultSize);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetColor,                 SetTextDefaultColor);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetColorByRGB,            SetTextDefaultColorByRGB);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetSize_MouseOver,                  SetTextDefaultSize_MouseOver);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetColor_MouseOver,                 SetTextDefaultColor_MouseOver);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityText_SetColorByRGB_MouseOver,            SetTextDefaultColorByRGB_MouseOver);

      // game / entity / shape / circle

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeCircle_GetRadius,            GetShapeCircleRadius);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeCircle_SetRadius,            SetShapeCircleRadius);

      // game / entity / shape / rectangle

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeRectangle_GetSize,            GetShapeRectangleSize);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeRectangle_SetSize,            SetShapeRectangleSize);

      // game / entity / shape / poly shapes

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_GetVertexCount,                    GetVertexCount);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPosition,            GetVertexLocalPosition);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_SetVertexLocalPosition,            SetVertexLocalPosition);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPosition,            GetVertexWorldPosition);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_SetVertexWorldPosition,            SetVertexWorldPosition);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_InsertVertexByLocalPosition,            InsertVertexByLocalPosition);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_InsertVertexByWorldPosition,            InsertVertexByWorldPosition);
         //RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_DeleteVertexAt,            DeleteVertexAt);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPositions,            GetVertexLocalPositions);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_SetVertexLocalPositions,            SetVertexLocalPositions);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPositions,            GetVertexWorldPositions);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapePoly_SetVertexWorldPositions,            SetVertexWorldPositions);

      // game / entity / shape / thickness
      
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetBorderThickness,            GetShapeBorderThickness);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetBorderThickness,            SetShapeBorderThickness);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_GetCurveThickness,            GetCurveThickness);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShape_SetCurveThickness,            SetCurveThickness);

      // game / entity / shape / module

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeModule_GetModule,            GetShapeModule);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeModule_ChangeModule,            ChangeShapeModule);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeModuleButton_GetOverModule,            GetShapeModuleButton_OverState);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeModuleButton_ChangeOverModule,            ChangeShapeModuleButton_OverState);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeModuleButton_GetDownModule,            GetShapeModuleButton_DownState);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityShapeModuleButton_ChangeDownModule,            ChangeShapeModuleButton_DownState);

      // game / entity / joint

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_GetJointConnectedShapes,                      GetJointConnectedShapes);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_SetJointMotorEnabled,                      SetJointMotorEnabled);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_SetJointLimitsEnabled,                     SetJointLimitsEnabled);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_GetHingeAngleByDegrees,                      GetHingeAngleByDegrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees,                      GetHingeLimitsByDegrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees,                      SetHingeLimitsByDegrees);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_GetHingeMotorSpeed,                      GetHingeMotorSpeed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_SetHingeMotorSpeed,                      SetHingeMotorSpeed);

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_GetSliderTranslation,                     GetSliderTranslation);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_GetSliderLimits,                     GetSliderLimits);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_SetSliderLimits,                     SetSliderLimits);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_GetSliderMotorSpeed,                     GetSliderMotorSpeed);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityJoint_SetSliderMotorSpeed,                     SetSliderMotorSpeed);

      // game / entity / event handler

         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityTrigger_ResetTimer,                           ResetTimer);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityTrigger_IsTimerPaused,                       IsTimerPaused);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityTrigger_SetTimerPaused,                      SetTimerPaused);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityTrigger_GetTimerInterval,                   GetTimerInterval);
         RegisterCoreFunction (playerWorld, CoreFunctionIds.ID_EntityTrigger_SetTimerInterval,                   SetTimerInterval);

      }

      private static function RegisterCoreFunction (playerWorld:World, functionId:int, callback:Function):void
      {
         if (functionId < 0 || functionId >= IdPool.NumPlayerFunctions)
            return;

         var func_decl:FunctionCoreBasicDefine = CoreFunctionDeclarations.GetCoreFunctionDeclaration (functionId);

         sCoreFunctionDefinitions [functionId] = TriggerFormatHelper2.CreateCoreFunctionDefinition (playerWorld, sCoreFunctionDefinitions [functionId] as FunctionDefinition_Core, func_decl, callback);
      }

//===========================================================
// core function definitions
//===========================================================

   // for debug

      public static function ForDebug (valueSource:Parameter, valueTarget:Parameter):void
      {
      }

      public static function GetDebugString (valueSource:Parameter, valueTarget:Parameter):void
      {
         if (Global._GetDebugString != null)
         {
            valueTarget.AssignValueObject (Global._GetDebugString ());
         }
      }
      
   //*******************************************************************
   // class common
   //*******************************************************************
      
      // now move into FunctionCalling_CommonAssign
      //public static function CommonAssign (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //}
      
      public static const kTempClassInstanceForNewInstance:ClassInstance = ClassInstance.CreateClassInstance (CoreClasses.kVoidClassDefinition, null);

      public static function CommonNewInstance (valueSource:Parameter, valueTarget:Parameter):void
      {
         var aClass:ClassDefinition = valueSource.EvaluateValueObject () as ClassDefinition;
         if (aClass == null)
            aClass = CoreClasses.kVoidClassDefinition;
         
         kTempClassInstanceForNewInstance.SetRealClassDefinition (aClass);
         kTempClassInstanceForNewInstance._SetValueObject (aClass.CreateDefaultInitialValue ());
         
         CoreClasses.AssignValue (kTempClassInstanceForNewInstance, valueTarget.GetVariableInstance ());
      }

      public static const kTempClassInstanceForComparing:ClassInstance = ClassInstance.CreateClassInstance (CoreClasses.kBooelanClassDefinition, false);

      public static function CommonEquals (valueSource:Parameter, valueTarget:Parameter):void
      {
         kTempClassInstanceForComparing._SetValueObject (CoreClasses.CompareEquals (valueSource.GetVariableInstance (), valueSource.mNextParameter.GetVariableInstance ()));
         
         CoreClasses.AssignValue (kTempClassInstanceForComparing, valueTarget.GetVariableInstance ());
      }
      
   //*******************************************************************
   // system / time
   //*******************************************************************

      public static function GetProgramMilliseconds (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (getTimer ());
      }

      public static function GetCurrentDateTime (valueSource:Parameter, valueTarget:Parameter):void
      {
         var isUTC:Boolean = Boolean(valueSource.EvaluateValueObject ());

         var date:Date = new Date ();

         if (isUTC)
         {
            valueTarget.AssignValueObject (date.getUTCFullYear ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getUTCMonth () + 1);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getUTCDate ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getUTCHours ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getUTCMinutes ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getUTCSeconds ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getUTCMilliseconds ());
         }
         else
         {
            valueTarget.AssignValueObject (date.getFullYear ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getMonth () + 1);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getDate ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getHours ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getMinutes ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getSeconds ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (date.getMilliseconds ());
        }
      }

      public static function GetDay (valueSource:Parameter, valueTarget:Parameter):void
      {
         var isUTC:Boolean = Boolean(valueSource.EvaluateValueObject ());

         if (isUTC)
         {
            valueTarget.AssignValueObject (new Date ().getUTCDay ());
         }
         else
         {
            valueTarget.AssignValueObject (new Date ().getDay ());
         }
      }

      public static function GetTimeZone (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (- int (new Date ().getTimezoneOffset() / 60));
      }

      public static function IsKeyHold (valueSource:Parameter, valueTarget:Parameter):void
      {
         var keyCode:int = int (valueSource.EvaluateValueObject ());

         valueTarget.AssignValueObject (Global.GetCurrentWorld ().IsKeyHold (keyCode));
      }

      public static function IsMouseButtonHold (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().IsMouseButtonDown ());
      }

      public static function SetMouseVisible (valueSource:Parameter, valueTarget:Parameter):void
      {
         var visible:Boolean = Boolean (valueSource.EvaluateValueObject ());

         Global.GetCurrentWorld ().SetMouseVisible (visible);
      }

      public static function IsAccelerometerSupported (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.Viewer_mLibCapabilities.IsAccelerometerSupported ());
      }

      public static function GetAccelerationVector (valueSource:Parameter, valueTarget:Parameter):void
      {
         var vector3d:Array = Global.Viewer_mLibCapabilities.GetAcceleration ();

         valueTarget.AssignValueObject (vector3d [0] as Number);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (vector3d [1] as Number);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (vector3d [2] as Number);
      }

      public static function IsNativeApp (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.Viewer_mLibAppp.IsNativeApp ());
      }

      public static function ExitApp (valueSource:Parameter, valueTarget:Parameter):void
      {
         Global.Viewer_mLibAppp.OnExitApp ();
      }

      public static function GetScreenResolution (valueSource:Parameter, valueTarget:Parameter):void
      {
         var size:Point = Global.Viewer_mLibCapabilities.GetScreenResolution ();

         valueTarget.AssignValueObject (size.x);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (size.y);
      }

      public static function GetScreenDPI (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.Viewer_mLibCapabilities.GetScreenDPI ());
      }
      
      public static function GetOsNameString (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Capabilities.os);
      }
      
      public static function OpenURL (valueSource:Parameter, valueTarget:Parameter):void
      {
         var url:String = valueSource.EvaluateValueObject () as String;
         
         if (url != null && url.length > 0)
         {
            Global.Viewer_mLibAppp.OpenURL (url);
         }
      }
      
      public static function CopyToClipboard (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = valueSource.EvaluateValueObject () as String;
         
         if (text != null && text.length > 0)
         {
            try
            {
               System.setClipboard (text);
            }
            catch (error:Error)
            {
               trace (error.getStackTrace ());
            }
         }
      }
      
      public static function GetLanguageCode (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Capabilities.language);
      }

   //*******************************************************************
   // services
   //*******************************************************************
   
      public static function SubmitHighScore (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = Number (valueSource.EvaluateValueObject ());

         if (Global.Viewer_mLibServices != null && Global.Viewer_mLibServices.SubmitKeyValue)
         {
            Global.Viewer_mLibServices.SubmitKeyValue ("HighScore", value);
         }
      }
      
      public static function SubmitKeyValue_Number (valueSource:Parameter, valueTarget:Parameter):void
      {
         var key:String = valueSource.EvaluateValueObject () as String;

         valueSource = valueSource.mNextParameter;
         var value:Number = Number (valueSource.EvaluateValueObject ());

         if (Global.Viewer_mLibServices != null && Global.Viewer_mLibServices.SubmitKeyValue)
         {
            Global.Viewer_mLibServices.SubmitKeyValue (key, value);
         }
      }

   //*******************************************************************
   // string
   //*******************************************************************

      public static function AssignString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:String = valueSource.EvaluateValueObject () as String;

         valueTarget.AssignValueObject (value);
      }

      public static function ConditionAssignString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var condtion:Boolean = Boolean (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var string1:String = valueSource.EvaluateValueObject () as String;

         valueSource = valueSource.mNextParameter;
         var string2:String = valueSource.EvaluateValueObject () as String;

         valueTarget.AssignValueObject (condtion ? string1 : string2);
      }

      public static function SwapStringValues (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text1:String = valueSource.EvaluateValueObject () as String;

         var source1:Parameter = valueSource;

         valueSource = valueSource.mNextParameter;
         var text2:String = valueSource.EvaluateValueObject () as String;

         source1.AssignValueObject (text2);
         valueSource.AssignValueObject (text1); // appeneded and fixed v1.54
      }

      public static function IsNullString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = valueSource.EvaluateValueObject () as String;

         valueTarget.AssignValueObject (text == null);
      }

      public static function AddTwoStrings (valueSource:Parameter, valueTarget:Parameter):void
      {
         //var value1:String = valueSource.EvaluateValueObject () as String;
         //
         //valueSource = valueSource.mNextParameter;
         //var value2:String = valueSource.EvaluateValueObject () as String;
         //
         //valueTarget.AssignValueObject (value1 + value2);
         
         valueTarget.AssignValueObject (
                                 CoreClasses.ToString (valueSource.GetVariableInstance ())
                                 +
                                 CoreClasses.ToString (valueSource.mNextParameter.GetVariableInstance ())
                              );
      }

      public static function GetStringLength (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:String = valueSource.EvaluateValueObject () as String;

         valueTarget.AssignValueObject (value == null ? 0 : value.length);
      }

      public static function StringCharAt (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = valueSource.EvaluateValueObject () as String;

         valueSource = valueSource.mNextParameter;
         var index:int = int (valueSource.EvaluateValueObject ());

         if (text == null || index < 0 || index >= text.length)
         {
            valueTarget.AssignValueObject (null);
            return;
         }

         valueTarget.AssignValueObject (text.charAt (index));
      }

      public static function StringCharCodeAt (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = valueSource.EvaluateValueObject () as String;

         valueSource = valueSource.mNextParameter;
         var index:int = int (valueSource.EvaluateValueObject ());

         if (text == null || index < 0 || index >= text.length)
         {
            valueTarget.AssignValueObject (0);
            return;
         }

         valueTarget.AssignValueObject (text.charCodeAt (index));
      }

      public static function CharCode2Char (valueSource:Parameter, valueTarget:Parameter):void
      {
         var char_code:int = int (valueSource.EvaluateValueObject ());

         valueTarget.AssignValueObject (char_code == 0 ? "" : String.fromCharCode (char_code));
      }

      public static function ToLowerCaseString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = valueSource.EvaluateValueObject () as String;

         valueTarget.AssignValueObject (text == null ? null : text.toLowerCase ());
      }

      public static function ToUpperCaseString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = valueSource.EvaluateValueObject () as String;

         valueTarget.AssignValueObject (text == null ? null : text.toUpperCase ());
      }

      public static function IndexOfSubstring (valueSource:Parameter, valueTarget:Parameter):void
      {
         _IndexOfSubstring (valueSource, valueTarget, false);
      }

      public static function LastIndexOfSubstring (valueSource:Parameter, valueTarget:Parameter):void
      {
         _IndexOfSubstring (valueSource, valueTarget, true);
      }

      public static function _IndexOfSubstring (valueSource:Parameter, valueTarget:Parameter, fromLast:Boolean):void
      {
         var text:String = valueSource.EvaluateValueObject () as String;
         if (text == null)
         {
            valueTarget.AssignValueObject (-1);

            return;
         }

         valueSource = valueSource.mNextParameter;
         var substring:String = valueSource.EvaluateValueObject () as String;
         if (substring == null)
         {
            valueTarget.AssignValueObject (-1);
            return;
         }

         valueSource = valueSource.mNextParameter;
         var fromIndex:int = int (valueSource.EvaluateValueObject ());

         if (fromLast)
            valueTarget.AssignValueObject (text.lastIndexOf (substring, fromIndex));
         else
            valueTarget.AssignValueObject (text.indexOf (substring, fromIndex));
      }

      public static function SplitString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var substrings:Array = null;

         var text:String = valueSource.EvaluateValueObject () as String;
         if (text != null)
         {
            valueSource = valueSource.mNextParameter;
            var delimiter:String = valueSource.EvaluateValueObject () as String;
            if (delimiter != null)
            {
               var texts:Array = text.split (delimiter);

               if (texts != null)
               {
                  substrings = texts.concat ();
                  CoreClasses.CovertArrayElementsToClassInstances (substrings, CoreClasses.kStringClassDefinition);
               }
            }
         }

         if (substrings == null)
         {
            substrings = new Array ();
         }

         valueTarget.AssignValueObject (substrings);
      }
      
      public static function ReplaceString(valueSource:Parameter, valueTarget:Parameter):void
      {
         var resultString:String = null;

         var text:String = valueSource.EvaluateValueObject () as String;
         if (text != null)
         {
            valueSource = valueSource.mNextParameter;
            var from:String = valueSource.EvaluateValueObject () as String;
            if (from != null && from.length > 0)
            {
               valueSource = valueSource.mNextParameter;
               var to:String = valueSource.EvaluateValueObject () as String;
               resultString = text.replace (from, to == null ? "" : to);
            }
            else
            {
               resultString = text;
            }
         }

         valueTarget.AssignValueObject (resultString);
      }

      public static function Substring (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = valueSource.EvaluateValueObject () as String;
         if (text == null)
         {
            valueTarget.AssignValueObject (null);
            return;
         }

         valueSource = valueSource.mNextParameter;
         var fromIndex:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var toIndex:int = int (valueSource.EvaluateValueObject ());

         valueTarget.AssignValueObject (text.substring (fromIndex, toIndex));
      }

      public static function NumberToString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = Number (valueSource.EvaluateValueObject ());

         //valueTarget.AssignValueObject (value.toString (10));
         valueTarget.AssignValueObject (CoreClasses.Number2String (value));
      }

      //public static function NumberToExponentialString (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   var value:Number = valueSource.EvaluateValueObject () as Number;
      //
      //   valueSource = valueSource.mNextParameter;
      //   var fractionDigits:int = int (valueSource.EvaluateValueObject ());
      //
      //   if (fractionDigits < 0 || fractionDigits > 20)
      //      valueTarget.AssignValueObject (null);
      //   else
      //   {
      //      trace ("value = " + value);
      //      trace ("value.toExponential (fractionDigits) = " + value.toExponential (fractionDigits));
      //      valueTarget.AssignValueObject (value.toExponential (fractionDigits));
      //   }
      //}

      public static function NumberToFixedString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var fractionDigits:int = int (valueSource.EvaluateValueObject ());

         if (fractionDigits < 0 || fractionDigits > 20)
            valueTarget.AssignValueObject (null);
         else
         {
            //valueTarget.AssignValueObject (value.toFixed (fractionDigits));
            valueTarget.AssignValueObject (ValueAdjuster.Number2FixedString (value, fractionDigits));
         }
      }

      public static function NumberToPrecisionString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var precision:int = int (valueSource.EvaluateValueObject ());

         if (precision < 1 || precision > 21)
            valueTarget.AssignValueObject (null);
         else
         {
            //valueTarget.AssignValueObject (value.toPrecision (precision));
            valueTarget.AssignValueObject (ValueAdjuster.Number2PrecisionString (value, precision));
         }
      }

      public static function NumberToStringByRadix (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = Number (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var radix:int = int (valueSource.EvaluateValueObject ());

         if (radix < 2 || radix > 36)
            valueTarget.AssignValueObject (null);
         else
            valueTarget.AssignValueObject (value.toString (radix));
      }

      public static function ParseFloat (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = String (valueSource.EvaluateValueObject ());

         valueTarget.AssignValueObject (parseFloat (text));
      }

      public static function ParseInteger (valueSource:Parameter, valueTarget:Parameter):void
      {
         var text:String = String (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var radix:int = int (valueSource.EvaluateValueObject ());

         if (radix < 2 || radix > 36)
            valueTarget.AssignValueObject (NaN);
         else
            valueTarget.AssignValueObject (parseInt (text, radix));
      }

      public static function BooleanToString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Boolean = Boolean (valueSource.EvaluateValueObject ());

         //valueTarget.AssignValueObject (String (value));
         valueTarget.AssignValueObject (CoreClasses.Boolean2String (value));
      }

      public static function EntityToString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         
         //if (entity == null)
         //   valueTarget.AssignValueObject ("null");
         //else
         //   valueTarget.AssignValueObject (CoreClasses.Entity2String (entity));
         
         // since v2.05. A little non-compatible: old "null" vs new null.
         valueTarget.AssignValueObject (CoreClasses.kEntityClassDefinition.ToString (entity));
      }

      public static function CollisionCategoryToString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var ccat:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         //if (ccat == null)
         //   valueTarget.AssignValueObject ("null");
         //else
         //   valueTarget.AssignValueObject (CoreClasses.CCat2String (ccat));
         
         // since v2.05. A little non-compatible: old "null" vs new null.
         valueTarget.AssignValueObject (CoreClasses.kCCatClassDefinition.ToString (ccat));
      }

   //************************************************
   // bool
   //************************************************

      public static function AssignBoolean (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (value);
      }

      public static function ConditionAssignBoolean (valueSource:Parameter, valueTarget:Parameter):void
      {
         var condtion:Boolean = Boolean (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var bool1:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bool2:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (condtion ? bool1 : bool2);
      }

      public static function SwapBooleanValues (valueSource:Parameter, valueTarget:Parameter):void
      {
         var bool1:Boolean = Boolean (valueSource.EvaluateValueObject ());

         var source1:Parameter = valueSource;

         valueSource = valueSource.mNextParameter;
         var bool2:Boolean = Boolean (valueSource.EvaluateValueObject ());

         source1.AssignValueObject (bool2);
         valueSource.AssignValueObject (bool1);
      }

      public static function BooleanInvert (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (! value);
      }

      public static function IsTrue (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (value);
      }

      public static function IsFalse (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (! value);
      }

      public static function EqualsWith_Numbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         var dv:Number = value1 - value2;

         valueTarget.AssignValueObject (- Number.MIN_VALUE <= dv && dv <= Number.MIN_VALUE); // todo maybe the tolerance value is too small
      }

      public static function EqualsWith_Booleans (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var value2:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (value1 == value2);
      }

      public static function EqualsWith_Entities (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Entity = valueSource.EvaluateValueObject () as Entity;

         valueSource = valueSource.mNextParameter;
         var value2:Entity = valueSource.EvaluateValueObject () as Entity;

         valueTarget.AssignValueObject (value1 == value2);
      }

      public static function EqualsWith_Strings (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:String = valueSource.EvaluateValueObject () as String;

         valueSource = valueSource.mNextParameter;
         var value2:String = valueSource.EvaluateValueObject () as String;

         valueTarget.AssignValueObject (value1 == value2);
      }

      public static function EqualsWith_CollisiontCategories (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueSource = valueSource.mNextParameter;
         var value2:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueTarget.AssignValueObject (value1 == value2);
      }

      public static function EqualsWith_Arrays (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Array = valueSource.EvaluateValueObject () as Array;

         valueSource = valueSource.mNextParameter;
         var value2:Array = valueSource.EvaluateValueObject () as Array;

         valueTarget.AssignValueObject (value1 == value2);
      }
      

      public static function ExactEqualsWith_Arrays (valueSource:Parameter, valueTarget:Parameter):void
      {
         //var value1:Array = valueSource.EvaluateValueObject () as Array;
         //
         //valueSource = valueSource.mNextParameter;
         //var value2:Array = valueSource.EvaluateValueObject () as Array;
         //
         //valueTarget.AssignValueObject (CompareArrays (value1, value2));
         
         valueTarget.AssignValueObject (CompareByEachArrayElement (valueSource.GetVariableInstance (), valueSource.mNextParameter.GetVariableInstance ()));
      }
      
      // for both Array type, compare each elements individually.
      // for other cases, use CoreClasses.CompareEqualsExactly

      private static function CompareByEachArrayElement (ci_1:ClassInstance, ci_2:ClassInstance, numRegisteredArrays:int = 0, registerdArrays:Dictionary = null, registedComparePairs:Dictionary = null):Boolean
      {
         if (ci_1._mRealClassDefinition == ci_2._mRealClassDefinition)
         {
            if (ci_1._mRealClassDefinition == CoreClasses.kArrayClassDefinition)
            {
               var values1:Array = ci_1._mValueObject as Array;
               var values2:Array = ci_2._mValueObject as Array;
               
               if (values1 == values2)
                  return true;

               if (values1 == null || values2 == null || values1.length != values2.length)
                  return false;
               
               if (numRegisteredArrays == 0)
               {
                  registerdArrays = new Dictionary ();
                  registedComparePairs = new Dictionary ();
               }
               
               var index1:Object = registerdArrays [values1];
               if (index1 == null)
                  registerdArrays [values1] = index1 = numRegisteredArrays ++;
               var index2:Object = registerdArrays [values2];
               if (index2 == null)
                  registerdArrays [values2] = index2 = numRegisteredArrays ++;
               var pairId:int = (index1 as int) < (index2 as int) ? (((index1 as int) << 16) | (index2 as int)) : (((index2 as int) << 16) | (index1 as int)); // !! max 65536 aryays
               if (registedComparePairs [pairId] != null)
                  return true;
               registedComparePairs [pairId] = 1;            
               
               var count:int = values1.length;
               for (var i:int = 0; i < count; ++ i)
               {
                  var ci_element1:ClassInstance = CoreClasses.GetArrayElement (values1, i) as ClassInstance;
                  var ci_element2:ClassInstance = CoreClasses.GetArrayElement (values2, i) as ClassInstance;
                  
                  return CompareByEachArrayElement (ci_element1, ci_element2, numRegisteredArrays, registerdArrays, registedComparePairs);
               }
               
               return true;
            }
            
            return ci_1._mValueObject != ci_2._mValueObject;
         }
         
         return false;
      }
      
      // before v2.05
      //private static function CompareArrays (array_1:, values2:Array, numRegisterdArrays:int = 0, registerdArrays:Dictionary = null, registedComparePairs:Dictionary = null):Boolean
      //{
      //   if (values1 == values2)
      //      return true;
      //
      //   if (values1 == null || values2 == null || values1.length != values2.length)
      //      return false;
      //   
      //   if (numRegisterdArrays == 0)
      //   {
      //      registerdArrays = new Dictionary ();
      //      registedComparePairs = new Dictionary ();
      //   }
      //   var index1:Object = registerdArrays [values1];
      //   if (index1 == null)
      //      registerdArrays [values1] = index1 = numRegisterdArrays ++;
      //   var index2:Object = registerdArrays [values2];
      //   if (index2 == null)
      //      registerdArrays [values2] = index2 = numRegisterdArrays ++;
      //   var pairId:int = (index1 as int) < (index2 as int) ? (((index1 as int) << 16) | (index2 as int)) : (((index2 as int) << 16) | (index1 as int)); // !! max 65536 aryays
      //   if (registedComparePairs [pairId] != null)
      //      return true;
      //   registedComparePairs [pairId] = 1;            
      //   
      //   var count:int = values1.length;
      //   for (var i:int = 0; i < count; ++ i)
      //   {
      //      var element1:Object = values1 [i];
      //      var element2:Object = values2 [i];
      //      
      //      if (element1 != element2)
      //      {
      //         if (element1 is Array && element2 is Array)
      //         {
      //            if (CompareArrays (element1 as Array, element2 as Array, numRegisterdArrays, registerdArrays, registedComparePairs))
      //               continue;
      //         }
      //         else
      //         {
      //            return false;
      //         }
      //      }
      //   }
      //   
      //   return true;
      //}

      public static function ArrayToString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var values:Array = valueSource.EvaluateValueObject () as Array;
         
         //if (values == null)
         //   valueTarget.AssignValueObject ("null");
         //else
         //   valueTarget.AssignValueObject (ConvertArrayToString (values));
         
         // since v2.05. A little non-compatible: old "null" vs new null.
         valueTarget.AssignValueObject (CoreClasses.kArrayClassDefinition.ToString (values));
      }

      public static function LargerThan (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         var dv:Number = value1 - value2;

         valueTarget.AssignValueObject (dv >= Number.MIN_VALUE);
      }

      public static function LessThan (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         var dv:Number = value1 - value2;

         valueTarget.AssignValueObject (dv <= - Number.MIN_VALUE);
      }

      public static function BoolAnd (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var value2:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (value1 && value2);
      }

      public static function BoolOr (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var value2:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (value1 || value2);
      }

      public static function BoolNot (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (! value);
      }

      public static function BoolXor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var value2:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (value1 != value2);
      }

   //************************************************
   // array
   //************************************************

      public static function AssignArray (valueSource:Parameter, valueTarget:Parameter):void
      {
         var array:Array = valueSource.EvaluateValueObject () as Array;

         valueTarget.AssignValueObject (array);
      }

      public static function ConditionAssignArray (valueSource:Parameter, valueTarget:Parameter):void
      {
         var condition:Boolean = Boolean (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var array1:Array = valueSource.EvaluateValueObject () as Array;

         valueSource = valueSource.mNextParameter;
         var array2:Array = valueSource.EvaluateValueObject () as Array;

         valueTarget.AssignValueObject (condition ? array1 : array2);
      }

      public static function SwapArrayValues(valueSource:Parameter, valueTarget:Parameter):void
      {
         var array1:Array = valueSource.EvaluateValueObject () as Array;

         var source1:Parameter = valueSource;

         valueSource = valueSource.mNextParameter;
         var array2:Array = valueSource.EvaluateValueObject () as Array;

         source1.AssignValueObject (array2);
         valueSource.AssignValueObject (array1);
      }

      public static function IsNullArray (valueSource:Parameter, valueTarget:Parameter):void
      {
         var array:Array = valueSource.EvaluateValueObject () as Array;

         valueTarget.AssignValueObject (array == null);
      }

      public static function CreateArray (valueSource:Parameter, valueTarget:Parameter):void
      {
         //var length:int = valueSource.EvaluateValueObject () as int;
         var length:int = int (valueSource.EvaluateValueObject ());
         if (length < 0)
            length = 0;

         var array:Array = new Array (length);
         valueTarget.AssignValueObject (array);
      }

      public static function GetArrayLength (valueSource:Parameter, valueTarget:Parameter):void
      {
         var array:Array = valueSource.EvaluateValueObject () as Array;

         valueTarget.AssignValueObject (array == null ? 0 : array.length);
      }

      public static function SetArrayLength (valueSource:Parameter, valueTarget:Parameter):void
      {
         var array:Array = valueSource.EvaluateValueObject () as Array;

         if (array != null)
         {
            valueSource = valueSource.mNextParameter;
            //var new_len:int = valueSource.EvaluateValueObject () as int;
            var new_len:int = int (valueSource.EvaluateValueObject ());
            if (new_len < 0)
               new_len = 0;

            array.length = new_len;
         }
      }
      
      public static function SubArray (valueSource:Parameter, valueTarget:Parameter):void
      {
         var resultArray:Array = null;
         
         var inputArray:Array = valueSource.EvaluateValueObject () as Array;
         if (inputArray != null)
         {
            valueSource = valueSource.mNextParameter;
            var startIndex:int = int (valueSource.EvaluateValueObject ());

            valueSource = valueSource.mNextParameter;
            var endIndex:int = int (valueSource.EvaluateValueObject ());
            
            resultArray = inputArray.slice (startIndex, endIndex);
         }
         
         valueTarget.AssignValueObject (resultArray);
      }

      public static function RemoveArrayElements (valueSource:Parameter, valueTarget:Parameter):void
      {
         SpliceArrayElements (valueSource, valueTarget, true);
      }

      public static function InsertArrayElements (valueSource:Parameter, valueTarget:Parameter):void
      {
         SpliceArrayElements (valueSource, valueTarget, false);
      }

      private static function SpliceArrayElements (valueSource:Parameter, valueTarget:Parameter, toRemove:Boolean):void
      {
         var array:Array = valueSource.EvaluateValueObject () as Array;

         if (array == null)
            return;

         valueSource = valueSource.mNextParameter;
         //var index:int = valueSource.EvaluateValueObject () as int;
         var index:int = int (valueSource.EvaluateValueObject ()); // from v1.56

         valueSource = valueSource.mNextParameter;
         var num:int = int (valueSource.EvaluateValueObject ()); // from v1.56

         if (num <= 0)
            return;

         if (toRemove)
         {
            if (index >= 0 && index < array.length)
            {
               array.splice (index, num);
            }
         }
         else
         {
            if (index < 0)
               index = 0;
            if (index > array.length)
               index = array.length;

            while (-- num >= 0)
            {
               array.splice (index, 0, null); //undefined);
            }
         }
      }

      private static function ConcatArrays (valueSource:Parameter, valueTarget:Parameter):void
      {
         var array1:Array = valueSource.EvaluateValueObject () as Array;

         valueSource = valueSource.mNextParameter;
         var array2:Array = valueSource.EvaluateValueObject () as Array;

         var resultArray:Array;
         if (array1 == null)
         {
            if (array2 == null)
               resultArray = null;
            else
               resultArray = array2.concat ();
         }
         else
         {
            if (array2 == null)
               resultArray = array1.concat ();
            else
               resultArray = array1.concat (array2);
         }

         valueTarget.AssignValueObject (resultArray);
      }

      private static function SwapArrayElements (valueSource:Parameter, valueTarget:Parameter):void
      {
         var array:Array = valueSource.EvaluateValueObject () as Array;

         if (array == null)
            return;

         valueSource = valueSource.mNextParameter;
         //var index:int = valueSource.EvaluateValueObject () as int;
         var index1:int = int (valueSource.EvaluateValueObject ()); // from v1.56

         if (index1 < 0 || index1 > array.length)
            return;

         valueSource = valueSource.mNextParameter;
         var index2:int = int (valueSource.EvaluateValueObject ()); // from v1.56

         if (index2 < 0 || index2 > array.length)
            return;
         
         // no needs to use CoreClasses.GetArrayElement
         var temp:Object = array [index1];
         array [index1] = array [index2];
         array [index2] = temp;
      }

      private static function ReverseArray (valueSource:Parameter, valueTarget:Parameter):void
      {
         var array:Array = valueSource.EvaluateValueObject () as Array;

         if (array != null)
         {
            array.reverse ();
         }
      }

      public static function SetArrayElement (valueSource:Parameter, valueTarget:Parameter):void
      {
         var array:Array = valueSource.EvaluateValueObject () as Array;
         if (array == null)
            return;

         valueSource = valueSource.mNextParameter;
         //var index:int = valueSource.EvaluateValueObject () as int;
         var index:int = int (valueSource.EvaluateValueObject ()); // from v1.56
         if (index < 0)
            return;

         valueSource = valueSource.mNextParameter;

         // if index >= length, length will extend to index automtically.
         array [index] = valueSource.GetVariableInstance ().CloneClassInstance ();
      }
      
      //public static function IndexOfArrayElement (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   _IndexOfArrayElement (valueSource, valueTarget, false);
      //}
      //
      //public static function LastIndexOfArrayElement (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   _IndexOfArrayElement (valueSource, valueTarget, true);
      //}
      
      // in the current piapia language implementation, it is hard to use Array.indexOf to search a element, 
      // for every elements in array are a different ClassInstance.
      // so piapia implementation needs some changes.
      // - change ClassInstacne as a property of VariableInstance, mClassInstance may be
      //   - boolean, number (and later int), string and array
      //   - custom types as current.
      // - use mixin to add GetClassDefinition fucntion on boolean/number/...
      //   - maybe not possible to do this.
      //
      // - for CCat and Entity, etc, add a mPiapiaValueInstance = new ClassInstance (CoreType, Type_XXX, this); 
      // 
      // - use mixin: http://tobyho.com/2009/05/02/modifying-core-types-in/
      //              http://www.josha.me/2009/06/17/prototype-and-as3/
      //              http://help.adobe.com/en_US/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7f3f.html
      //              http://help.adobe.com/en_US/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7f3f.html#WS5b3ccc516d4fbf351e63e3d118a9b90204-7fa3
      // - int.prototype.mClassDefinition = CoreClasses.GetClassDefintion (id_int);
      //     ...
      //     var aInt:int;
      //     trace (aInt.mClassDefinition):
      
      //public static function _IndexOfArrayElement (valueSource:Parameter, valueTarget:Parameter, forLast:Boolean):void
      //{
      //   var theArray:Array = valueSource.EvaluateValueObject () as Array;
      //   if (theArray == null)
      //   {
      //      valueTarget.AssignValueObject (-1);
      //      return;
      //   }
      //
      //   valueSource = valueSource.mNextParameter;
      //   var element:Object = valueSource.EvaluateValueObject ();
      //
      //   valueSource = valueSource.mNextParameter;
      //   var fromIndex:int = int (valueSource.EvaluateValueObject ());
      //   
      //   if (forLast)
      //      valueTarget.AssignValueObject (theArray.indexOf (element, fromIndex));
      //   else
      //      valueTarget.AssignValueObject (theArray.lastIndexOf (element, fromIndex));
      //}

      public static function GetArrayElement (valueSource:Parameter, valueTarget:Parameter):void
      {
         do
         {
            var array:Array = valueSource.EvaluateValueObject () as Array;
            if (array == null)
               break;

            valueSource = valueSource.mNextParameter;
            //var index:int = valueSource.EvaluateValueObject () as int;
            var index:int = int (valueSource.EvaluateValueObject ()); // from v1.56
            if (index < 0 || index >= array.length)
               break;
            
            // before v2.05
            //var sourceCi:ClassInstance = array [index] as ClassInstance;
            //if (sourceCi == null)
            //   break;
            // since v2.05
            var sourceCi:ClassInstance = CoreClasses.GetArrayElement (array, index) as ClassInstance; // not null for sure
            
            CoreClasses.AssignValue (sourceCi, valueTarget.GetVariableInstance ());

            return;
         }
         while (false);

         // for invalid params
         CoreClasses.AssignValue (VariableInstanceConstant.kVoidVariableInstance, valueTarget.GetVariableInstance ());
      }

      //private static function SetArrayElementWithSpecfiedClass (valueSource:Parameter, valueTarget:Parameter, specfiedClass:Class):void
      //{
      //   var array:Array = valueSource.EvaluateValueObject () as Array;
      //   if (array == null)
      //      return;
      //
      //   valueSource = valueSource.mNextParameter;
      //   //var index:int = valueSource.EvaluateValueObject () as int;
      //   var index:int = int (valueSource.EvaluateValueObject ()); // from v1.56
      //   if (index < 0)
      //      return;
      //
      //   valueSource = valueSource.mNextParameter;
      //
      //   //trace ("set index = " + index + ", value = " + (valueSource.EvaluateValueObject () as specfiedClass));
      //   array [index] = valueSource.EvaluateValueObject () as specfiedClass;
      //}

      //private static function GetArrayElementAsSpecfiedClass  (valueSource:Parameter, valueTarget:Parameter, specfiedClass:Class):void
      //{
      //   do
      //   {
      //      var array:Array = valueSource.EvaluateValueObject () as Array;
      //      if (array == null)
      //         break;
      //
      //      valueSource = valueSource.mNextParameter;
      //      //var index:int = valueSource.EvaluateValueObject () as int;
      //      var index:int = int (valueSource.EvaluateValueObject ()); // from v1.56
      //      if (index < 0)
      //         break;
      //
      //      //trace ("- get index = " + index + ", value = " + (array [index] as specfiedClass));
      //      valueTarget.AssignValueObject (array [index] as specfiedClass);
      //
      //      return;
      //   }
      //   while (false);
      //
      //   // for invalid params
      //   valueTarget.AssignValueObject (null); // undefined);
      //}

      //public static function SetArrayElementWithBoolean (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetArrayElementWithSpecfiedClass (valueSource, valueTarget, Boolean);
      //}
      //
      //public static function GetArrayElementAsBoolean (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   GetArrayElementAsSpecfiedClass (valueSource, valueTarget, Boolean);
      //}
      //
      //public static function SetArrayElementWithNumber (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetArrayElementWithSpecfiedClass (valueSource, valueTarget, Number);
      //}
      //
      //public static function GetArrayElementAsNumber (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   GetArrayElementAsSpecfiedClass (valueSource, valueTarget, Number);
      //}
      //
      //public static function SetArrayElementWithString (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetArrayElementWithSpecfiedClass (valueSource, valueTarget, String);
      //}
      //
      //public static function GetArrayElementAsString (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   GetArrayElementAsSpecfiedClass (valueSource, valueTarget, String);
      //}
      //
      //public static function SetArrayElementWithCCat (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetArrayElementWithSpecfiedClass (valueSource, valueTarget, CollisionCategory);
      //}
      //
      //public static function GetArrayElementAsCCat (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   GetArrayElementAsSpecfiedClass (valueSource, valueTarget, CollisionCategory);
      //}
      //
      //public static function SetArrayElementWithEntity (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetArrayElementWithSpecfiedClass (valueSource, valueTarget, Entity);
      //}
      //
      //public static function GetArrayElementAsEntity (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   GetArrayElementAsSpecfiedClass (valueSource, valueTarget, Entity);
      //}
      //
      //public static function SetArrayElementWithModule (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetArrayElementWithSpecfiedClass (valueSource, valueTarget, int); //Module);
      //}
      //
      //public static function GetArrayElementAsModule (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   GetArrayElementAsSpecfiedClass (valueSource, valueTarget, int); //Module);
      //}
      //
      //public static function SetArrayElementWithSound (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetArrayElementWithSpecfiedClass (valueSource, valueTarget, int); //Sound);
      //}
      //
      //public static function GetArrayElementAsSound (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   GetArrayElementAsSpecfiedClass (valueSource, valueTarget, int); //Sound);
      //}
      //
      //public static function SetArrayElementWithArray (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetArrayElementWithSpecfiedClass (valueSource, valueTarget, Array);
      //}
      //
      //public static function GetArrayElementAsArray (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   GetArrayElementAsSpecfiedClass (valueSource, valueTarget, Array);
      //}

   //************************************************
   // math
   //************************************************

      // + - * / x=y -x

      public static function AssignNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value);
      }

      public static function ConditionAssignNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var contionResult:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var trueValue:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var falseValue:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (contionResult ? trueValue : falseValue);
      }

      public static function SwapNumberValues (valueSource:Parameter, valueTarget:Parameter):void
      {
         var number1:Number = Number (valueSource.EvaluateValueObject ());

         var source1:Parameter = valueSource;

         valueSource = valueSource.mNextParameter;
         var number2:Number = Number (valueSource.EvaluateValueObject ());

         source1.AssignValueObject (number2);
         valueSource.AssignValueObject (number1);
      }

      public static function IsNaN (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (isNaN (value));
      }

      public static function IsInfinity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (! isFinite (value));
      }

      public static function NegativeNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (- value);
      }

      public static function AddTwoNumbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value1 + value2);
      }

      public static function SubtractTwoNumbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value1 - value2);
      }

      public static function MultiplyTwoNumbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value1 * value2);
      }

      public static function DivideTwoNumbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value1 / value2);
      }

      public static function ModuloTwoNumbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value1 % value2);
      }

      // bitwise

      public static function ShiftLeft (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var numBitsToShift:int = int (valueSource.EvaluateValueObject () as Number);

         value <<= numBitsToShift;
         valueTarget.AssignValueObject (value);
      }

      public static function ShiftRight (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var numBitsToShift:int = int (valueSource.EvaluateValueObject () as Number);

         value >>= numBitsToShift;
         valueTarget.AssignValueObject (value);
      }

      public static function ShiftRightUnsigned (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var numBitsToShift:int = int (valueSource.EvaluateValueObject () as Number);

         value >>>= numBitsToShift;
         valueTarget.AssignValueObject (value);
      }

      public static function BitwiseAnd (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Number(value1 & value2));
      }

      public static function BitwiseOr (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Number(value1 | value2));
      }

      public static function BitwiseNot (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Number(~value));
      }

      public static function BitwiseXor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Number(value1 ^ value2));
      }

      // sin, cos, tan, asin, acos, atan, atan2

      public static function SinRadian (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.sin (value));
      }

      public static function CosRadian (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.cos (value));
      }

      public static function TanRadian (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.tan (value));
      }

      public static function AsinRadian (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.asin (value));
      }

      public static function AcosRadian (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.acos (value));
      }

      public static function AtanRadian (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.atan (value));
      }

      public static function AtanRadianTwoNumbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.atan2 (value1, value2));
      }

      // random

      public static function RandomNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Math.random ());
      }

      public static function RandomNumberRange (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value1 + (value2 - value1) * Math.random ());
      }

      public static function RandomIntegerRange (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:int = Math.round (valueSource.EvaluateValueObject () as Number);

         valueSource = valueSource.mNextParameter;
         var value2:int = Math.round (valueSource.EvaluateValueObject () as Number);

         var r:Number = value1 + (value2 - value1) * Math.random ();
         valueTarget.AssignValueObject (value1 < value2 ? Math.floor (r) : Math.ceil (r));
      }

      public static function RngCreate (valueSource:Parameter, valueTarget:Parameter):void
      {
         var rngSlot:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var rngMethod:int = int (valueSource.EvaluateValueObject ());

         Global.CreateRandomNumberGenerator (rngSlot, rngMethod);
      }

      public static function RngSetSeed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var rngSlot:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var seedId:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var seed:uint = uint (valueSource.EvaluateValueObject ());

         Global.GetRandomNumberGenerator (rngSlot).SetSeed (seedId, seed);
      }

      public static function RngRandom (valueSource:Parameter, valueTarget:Parameter):void
      {
         var rngSlot:int = int (valueSource.EvaluateValueObject ());

         valueTarget.AssignValueObject (Global.GetRandomNumberGenerator (rngSlot).NextFloat ());
      }

      public static function RngRandomNumberRange (valueSource:Parameter, valueTarget:Parameter):void
      {
         var rngSlot:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value1 + (value2 - value1) * Global.GetRandomNumberGenerator (rngSlot).NextFloat ());
      }

      public static function RngRandomIntegerRange (valueSource:Parameter, valueTarget:Parameter):void
      {
         var rngSlot:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var value1:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var value2:int = int (valueSource.EvaluateValueObject ());

         valueTarget.AssignValueObject (Global.GetRandomNumberGenerator (rngSlot).NextIntegerBetween (value1, value2));
      }

      // degree <-> radian

      public static function Degrees2Radians (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value * Define.kDegrees2Radians);
      }

      public static function Radians2Degrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value * Define.kRadians2Degrees);
      }

      public static function Number2RGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var color:int = (valueSource.EvaluateValueObject () as Number) & 0xFFFFFFFF;

         valueTarget.AssignValueObject ((color >> 16) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((color >> 8) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((color >> 0) & 0xFF);
      }

      public static function RGB2Number (valueSource:Parameter, valueTarget:Parameter):void
      {
         var red:int = (valueSource.EvaluateValueObject () as Number) & 0xFF;

         valueSource = valueSource.mNextParameter;
         var green:int = (valueSource.EvaluateValueObject () as Number) & 0xFF;

         valueSource = valueSource.mNextParameter;
         var blue:Number = (valueSource.EvaluateValueObject () as Number) & 0xFF;

         valueTarget.AssignValueObject ((red << 16) | (green << 8) | (blue));
      }

      public static function MillisecondsToMinutesSeconds (valueSource:Parameter, valueTarget:Parameter):void
      {
         var millseconds:int = valueSource.EvaluateValueObject () as Number;

         var minutes:int = millseconds / 60000;
         millseconds -= minutes * 60000;
         var seconds:int = millseconds / 1000;
         millseconds -= seconds * 1000;

         valueTarget.AssignValueObject (Number (minutes));

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (Number (seconds));

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (Number (millseconds));
      }

      // invert

      public static function InverseNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (1.0 / value);
      }

      // max, min

      public static function MaxOfTwoNumbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.max (value1, value2));
      }

      public static function MinOfTwoNumbers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.min (value1, value2));
      }

      // abs, sqrt, ceil, floor, round, log, exp

      public static function AbsNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.abs (value));
      }

      public static function SqrtNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.sqrt (value));
      }

      public static function CeilNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.ceil (value));
      }

      public static function FloorNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.floor (value));
      }

      public static function RoundNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.round (value));
      }

      public static function LogNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.log (value));
      }

      public static function ExpNumber (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.exp (value));
      }

      public static function Power (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Math.pow (value1, value2));
      }

      public static function Clamp (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var limit1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var limit2:Number = valueSource.EvaluateValueObject () as Number;

         if (limit1 <= limit2)
         {
            if (value < limit1)
               value = limit1;
            else if (value > limit2)
               value = limit2;
         }
         else
         {
            if (value < limit2)
               value = limit2;
            else if (value > limit1)
               value = limit1;
         }

         valueTarget.AssignValueObject (value);
      }

      public static function LinearInterpolation (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var factor:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (value1 * factor + (1.0 - factor) * value2);
      }

      public static function LinearInterpolationColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var value1:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var value2:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var factor:Number = valueSource.EvaluateValueObject () as Number;
         var factor2:Number = 1.0 - factor;

         var red  :int = ((value1 >> 16) & 0xFF) * factor + ((value2 >> 16) & 0xFF) * factor2;
         var green:int = ((value1 >>  8) & 0xFF) * factor + ((value2 >>  8) & 0xFF) * factor2;
         var blue :int = ((value1 >>  0) & 0xFF) * factor + ((value2 >>  0) & 0xFF) * factor2;

         valueTarget.AssignValueObject ((red << 16) | (green << 8) | (blue));
      }


   //*******************************************************************
   // game / design
   //*******************************************************************

      public static function LoadLevel (valueSource:Parameter, valueTarget:Parameter):void
      {
         var levelIndex:int = int (valueSource.EvaluateValueObject ());
         if (Global.IsInvalidScene (levelIndex))
            return;
         
         valueSource = valueSource.mNextParameter;
         var sceneSwitchingStyle:int = valueSource.EvaluateValueObject () as int;

         //Global.Viewer_OnLoadScene (levelIndex); // if call this at this time, there will be many check point needed to be aded.
         Global.GetCurrentWorld ().SetDelayToLoadSceneIndex (levelIndex, sceneSwitchingStyle);
      }
      
      public static function MergeLevelIntoTheCurrentOne (valueSource:Parameter, valueTarget:Parameter):void
      {
         var levelIndex:int = int (valueSource.EvaluateValueObject ());
         if (Global.IsInvalidScene (levelIndex))
            return;
         
         Global.MergeScene (levelIndex);
      }
      
      public static function GetLevelByIdOffset (valueSource:Parameter, valueTarget:Parameter):void
      {
         var indexOffset:int = int (valueSource.EvaluateValueObject ());
         
         valueSource = valueSource.mNextParameter;
         var relativeTolevelIndex:int = valueSource.EvaluateValueObject () as int;
         
         if (Global.IsInvalidScene (relativeTolevelIndex))
            relativeTolevelIndex =  Global.GetCurrentWorld ().GetCurrentSceneId ();
         
         var levelIndex:int = relativeTolevelIndex + indexOffset;
         valueTarget.AssignValueObject (Global.IsInvalidScene (levelIndex) ? -1 : levelIndex);
      }
      
      public static function GetLevelId (valueSource:Parameter, valueTarget:Parameter):void
      {
         var levelIndex:int = int (valueSource.EvaluateValueObject ());
         
         if (Global.IsInvalidScene (levelIndex))
            levelIndex = -1;
         
         valueTarget.AssignValueObject (levelIndex);
      }
      
      public static function GetLevelByKey (valueSource:Parameter, valueTarget:Parameter):void
      {
         var key:String = valueSource.EvaluateValueObject () as String;
         
         valueTarget.AssignValueObject (Global.GetSceneByKey (key));
      }
      
      public static function GetLevelKey (valueSource:Parameter, valueTarget:Parameter):void
      {
         var levelIndex:int = int (valueSource.EvaluateValueObject ());
         
         var sceneDefine:SceneDefine = Global.GetSceneDefine (levelIndex);
         if (sceneDefine == null)
            valueTarget.AssignValueObject (null);
         else
            valueTarget.AssignValueObject (sceneDefine.mKey);
      }
      
      public static function GetCurrentLevel (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCurrentSceneId ());
      }
      
      public static function IsNullLevel (valueSource:Parameter, valueTarget:Parameter):void
      {
         var levelIndex:int = valueSource.EvaluateValueObject () as int;
         valueTarget.AssignValueObject (Global.IsInvalidScene (levelIndex));
      }
      
      public static function EqualsWith_Scenes (valueSource:Parameter, valueTarget:Parameter):void
      {
         var levelIndex1:int = valueSource.EvaluateValueObject () as int;

         valueSource = valueSource.mNextParameter;
         var levelIndex2:int = valueSource.EvaluateValueObject () as int;

         if (Global.IsInvalidScene (levelIndex1) && Global.IsInvalidScene (levelIndex2))
            valueTarget.AssignValueObject (true);
         else
            valueTarget.AssignValueObject (levelIndex1 == levelIndex2);
      }
      
      public static function SceneToString (valueSource:Parameter, valueTarget:Parameter):void
      {
         var levelIndex:int = valueSource.EvaluateValueObject () as int;
         
         //var sceneDefine:SceneDefine = Global.GetSceneDefine (levelIndex);
         //if (sceneDefine == null)
         //   valueTarget.AssignValueObject ("null");
         //else
         //   valueTarget.AssignValueObject ("scene#" + levelIndex + "[" + sceneDefine.mName + "]");
         
         valueTarget.AssignValueObject (CoreClasses.kSceneClassDefinition.ToString (levelIndex));
      }
      
      public static function WriteSaveData (valueSource:Parameter, valueTarget:Parameter):void
      {
         Global.Viewer_mLibCookie.WriteCookie (Define.GetDefaultWorldSavedDataFilename (Global.GetCurrentWorld ().GetWorldKey ()), Global.GetSavedData ());
      }
      
      public static function LoadSaveData (valueSource:Parameter, valueTarget:Parameter):void
      {
         Global.SetSavedData (Global.Viewer_mLibCookie.LoadCookie (Define.GetDefaultWorldSavedDataFilename (Global.GetCurrentWorld ().GetWorldKey ())));
      }
      
      public static function ResetSaveData (valueSource:Parameter, valueTarget:Parameter):void
      {
         Global.ResetGameSaveVariableSpace ();
      }
      
      public static function DeleteSaveData (valueSource:Parameter, valueTarget:Parameter):void
      {
         Global.Viewer_mLibCookie.ClearCookie (Define.GetDefaultWorldSavedDataFilename (Global.GetCurrentWorld ().GetWorldKey ()));
      }

      public static function RestartLevel (valueSource:Parameter, valueTarget:Parameter):void
      {
         var sceneSwitchingStyle:int = valueSource.EvaluateValueObject () as int;

         //Global.UI_RestartPlay (); // cause bug
         Global.GetCurrentWorld ().SetDelayRestartRequested (sceneSwitchingStyle);
      }
      
      public static function IsLevelPaused (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (! Global.UI_IsPlaying ());
      }

      public static function SetLevelPaused (valueSource:Parameter, valueTarget:Parameter):void
      {
         var paused:Boolean = Boolean (valueSource.EvaluateValueObject ());

         Global.UI_SetPlaying (! paused);
      }

      public static function GetPlaySpeedX (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.UI_GetSpeedX ());
      }

      public static function SetPlaySpeedX (valueSource:Parameter, valueTarget:Parameter):void
      {
         var speedX:int = int (valueSource.EvaluateValueObject ());
         if (speedX < 0)
            speedX = 0;
         else if (speedX > 9)
            speedX = 9;

         Global.UI_SetSpeedX (speedX);
      }

      public static function GetWorldScale (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.UI_GetZoomScale());
      }

      public static function SetWorldScale (valueSource:Parameter, valueTarget:Parameter):void
      {
         var scale:Number = Number (valueSource.EvaluateValueObject ());
         if (scale < 0.0625)
            scale = 0.0625;
         else if (scale > 16.0)
            scale = 16.0;

         valueSource = valueSource.mNextParameter;
         var smoothly:Boolean = valueSource.EvaluateValueObject () as Boolean;

         Global.UI_SetZoomScale (scale, smoothly);
      }

      public static function GetLevelMilliseconds (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetLevelMilliseconds ());
      }

      public static function GetLevelSteps (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetSimulatedSteps ());
      }

      public static function GetWorldMousePosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCurrentMouseX ());

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCurrentMouseY ());
      }

      public static function GetNumEntitiesPlacedInEditor (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetNumEntitiesInEditor ());
      }

      public static function SetLevelStatus (valueSource:Parameter, valueTarget:Parameter):void
      {
         switch (int (valueSource.EvaluateValueObject ()))
         {
            case ValueDefine.LevelStatus_Failed:
               Global.GetCurrentWorld ().SetLevelFailed ();
               break;
            case ValueDefine.LevelStatus_Successed:
               Global.GetCurrentWorld ().SetLevelSuccessed ();
               break;
            case ValueDefine.LevelStatus_Unfinished:
               Global.GetCurrentWorld ().SetLevelUnfinished ();
               break;
            default:
               break;
         }
      }

      public static function IsLevelSuccessed (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().IsLevelSuccessed ());
      }

      public static function IsLevelFailed (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().IsLevelFailed ());
      }

      public static function IsLevelUnfinished (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().IsLevelUnfinished ());
      }

      public static function SetMouseGestureEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         var enableGesture:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var drawGesture:Boolean = valueSource.EvaluateValueObject () as Boolean;

         Global.Viewer_SetMouseGestureSupported (enableGesture, drawGesture);
      }
      
      public static function SetLevelProperty_Boolean (valueSource:Parameter, valueTarget:Parameter):void
      {
         var property:int = valueSource.EvaluateValueObject () as int;

         valueSource = valueSource.mNextParameter;
         var value:Boolean = valueSource.EvaluateValueObject () as Boolean;
         
         Global.GetCurrentWorld ().SetLevelProperty (property, value);
      }
      
      public static function SetLevelProperty_Number (valueSource:Parameter, valueTarget:Parameter):void
      {
         var property:int = valueSource.EvaluateValueObject () as int;

         valueSource = valueSource.mNextParameter;
         var value:Number = valueSource.EvaluateValueObject () as Number;
         
         Global.GetCurrentWorld ().SetLevelProperty (property, value);
      }
      
      public static function SetLevelProperty_String (valueSource:Parameter, valueTarget:Parameter):void
      {
         var property:int = valueSource.EvaluateValueObject () as int;
      
         valueSource = valueSource.mNextParameter;
         var value:String = valueSource.EvaluateValueObject () as String;
         
         Global.GetCurrentWorld ().SetLevelProperty (property, value);
      }

   //*******************************************************************
   // game / world / appearance
   //*******************************************************************
      
      public static function GetLevelFilledColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var filledColor:uint = Global.GetCurrentWorld ().GetBackgroundColor ();

         valueTarget.AssignValueObject (filledColor);
      }

      public static function SetLevelFilledColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var color:uint = uint (valueSource.EvaluateValueObject ());
         
         Global.GetCurrentWorld ().SetBackgroundColor (color);
      }

      public static function GetLevelFilledColorRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var filledColor:uint = Global.GetCurrentWorld ().GetBackgroundColor ();

         valueTarget.AssignValueObject ((filledColor >> 16) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((filledColor >> 8) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((filledColor >> 0) & 0xFF);
      }

      public static function SetLevelFilledColorRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var red:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var green:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var blue:int =  valueSource.EvaluateValueObject () as Number;
         
         Global.GetCurrentWorld ().SetBackgroundColor ((red << 16) | (green << 8) | (blue));
      }

      public static function GetLevelBorderColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var borderColor:uint = Global.GetCurrentWorld ().GetBorderColor ();

         valueTarget.AssignValueObject (borderColor);
      }

      public static function SetLevelBorderColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var color:uint = uint (valueSource.EvaluateValueObject ());

         Global.GetCurrentWorld ().SetBorderColor (color);
      }

      public static function GetLevelBorderColorRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var borderColor:uint = Global.GetCurrentWorld ().GetBorderColor ();

         valueTarget.AssignValueObject ((borderColor >> 16) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((borderColor >> 8) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((borderColor >> 0) & 0xFF);
      }

      public static function SetLevelBorderColorRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var red:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var green:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var blue:int =  valueSource.EvaluateValueObject () as Number;
         
         Global.GetCurrentWorld ().SetBorderColor ((red << 16) | (green << 8) | (blue));
      }

   //*******************************************************************
   // game / world / physics
   //*******************************************************************

      public static function IsPhysicsEngineEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().IsPhysicsEngineEnabled ());
      }

      public static function SetPhysicsEngineEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         var enabled:Boolean = valueSource.EvaluateValueObject () as Boolean;

         Global.GetCurrentWorld ().SetPhysicsEngineEnabled (enabled);
      }

      public static function GetRealtimeFPS (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.Viewer_mLibAppp.GetRealtimeFps ());
      }

      public static function GetPreferredFpsAndStepTimeLangth (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetPreferredFPS ());
         
         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetPhysicsSimulationStepTimeLength ());
      }

      public static function SetPreferredFpsAndStepTimeLangth (valueSource:Parameter, valueTarget:Parameter):void
      {
         var preferredFps:Number = Number (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var timeLength:Number = Number (valueSource.EvaluateValueObject ());

         Global.GetCurrentWorld ().SetPreferredFPS (preferredFps);
         Global.GetCurrentWorld ().SetPhysicsSimulationStepTimeLength (timeLength);
      }
      
      public static function SetWorldGravityAcceleration_Radians (valueSource:Parameter, valueTarget:Parameter):void
      {
         var magnitude:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var radians:Number = (valueSource.EvaluateValueObject () as Number) % 360.0;

         Global.GetCurrentWorld ().SetCurrentGravityAcceleration (magnitude * Math.cos (radians), magnitude * Math.sin (radians));
      }

      public static function SetWorldGravityAcceleration_Degrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         var magnitude:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var radians:Number = ((valueSource.EvaluateValueObject () as Number) % 360.0) * Define.kDegrees2Radians;

         Global.GetCurrentWorld ().SetCurrentGravityAcceleration (magnitude * Math.cos (radians), magnitude * Math.sin (radians));
      }

      public static function SetWorldGravityAcceleration_Vector (valueSource:Parameter, valueTarget:Parameter):void
      {
         var gaX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var gaY:Number = valueSource.EvaluateValueObject () as Number;

         Global.GetCurrentWorld ().SetCurrentGravityAcceleration (gaX, gaY);
      }

      public static function GetWorldGravityAcceleration_Vector (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCurrentGravityAccelerationX ());

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCurrentGravityAccelerationY ());
      }
      
      public static function GetViewportSize (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetRealViewportWidth ());

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetRealViewportHeight ());
      }

      public static function SetCurrentCamera (valueSource:Parameter, valueTarget:Parameter):void
      {
         var camera:EntityShape_Camera = valueSource.EvaluateValueObject () as EntityShape_Camera;
         if (camera == null)
            return;

         camera.SetAsCurrent ();
      }

      public static function GetCameraCenter (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCameraCenterPhysicsX ());

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCameraCenterPhysicsY ());
      }

      public static function GetCameraRotation_Degrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCameraPhysicsRotationIn360Degrees ());
      }

      public static function FollowCameraWithShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         //if (shape == null)
         //   return;

         valueSource = valueSource.mNextParameter;
         var isSmooth:Boolean = valueSource.EvaluateValueObject () as Boolean;

         //valueSource = valueSource.mNextParameter;
         //var folowRotation:Boolean = valueSource.EvaluateValueObject () as Boolean;
         var folowRotation:Boolean = true;

         Global.GetCurrentWorld ().FollowCameraWithEntity (shape, isSmooth, folowRotation);
      }

      public static function FollowCameraCenterXWithShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         //if (shape == null)
         //   return;

         valueSource = valueSource.mNextParameter;
         var isSmooth:Boolean = valueSource.EvaluateValueObject () as Boolean;

         Global.GetCurrentWorld ().FollowCameraCenterXWithEntity (shape, isSmooth);
      }

      public static function FollowCameraCenterYWithShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         //if (shape == null)
         //   return;

         valueSource = valueSource.mNextParameter;
         var isSmooth:Boolean = valueSource.EvaluateValueObject () as Boolean;

         Global.GetCurrentWorld ().FollowCameraCenterYWithEntity (shape, isSmooth);
      }

      public static function FollowCameraRotationWithShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         valueSource = valueSource.mNextParameter;
         var isSmooth:Boolean = valueSource.EvaluateValueObject () as Boolean;

         Global.GetCurrentWorld ().FollowCameraAngleWithEntity (shape, isSmooth);
      }

      public static function CameraFadeOutThenFadeIn (valueSource:Parameter, valueTarget:Parameter):void
      {
         var fadeColor:uint = uint (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var stepsFadeOut:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var stepsFadeStaying:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var stepsFadeIn:int = int (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var scriptToRun:ScriptHolder = valueSource.EvaluateValueObject () as ScriptHolder;

         Global.GetCurrentWorld ().CameraFadeOutThenFadeIn (fadeColor, stepsFadeOut, stepsFadeIn, stepsFadeStaying, scriptToRun);
      }

      public static function CallScript (valueSource:Parameter, valueTarget:Parameter):void
      {
         var scriptToRun:ScriptHolder = valueSource.EvaluateValueObject () as ScriptHolder;

         if (scriptToRun != null)
            scriptToRun.RunScript ();
      }

      public static function ConditionCallScript (valueSource:Parameter, valueTarget:Parameter):void
      {
         var condtion:Boolean = Boolean (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var script1:ScriptHolder = valueSource.EvaluateValueObject () as ScriptHolder;

         valueSource = valueSource.mNextParameter;
         var script2:ScriptHolder = valueSource.EvaluateValueObject () as ScriptHolder;

         if (condtion)
         {
            if (script1 != null)
               script1.RunScript ();
         }
         else
         {
            if (script2 != null)
               script2.RunScript ();
         }
      }

      public static function CallBoolFunction (valueSource:Parameter, valueTarget:Parameter):void
      {
         var boolFunction:EntityBasicCondition = valueSource.EvaluateValueObject () as EntityBasicCondition;

         valueTarget.AssignValueObject (boolFunction == null ? false : boolFunction.RunBoolFunction ());
      }

      public static function ConditionCallBoolFunction  (valueSource:Parameter, valueTarget:Parameter):void
      {
         var condtion:Boolean = Boolean (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var boolFunction1:EntityBasicCondition = valueSource.EvaluateValueObject () as EntityBasicCondition;

         valueSource = valueSource.mNextParameter;
         var boolFunction2:EntityBasicCondition = valueSource.EvaluateValueObject () as EntityBasicCondition;

         if (condtion)
            valueTarget.AssignValueObject (boolFunction1 == null ? false : boolFunction1.RunBoolFunction ());
         else
            valueTarget.AssignValueObject (boolFunction2 == null ? false : boolFunction2.RunBoolFunction ());
      }

      public static function CallScriptMultiTimes (valueSource:Parameter, valueTarget:Parameter):void
      {
         var scriptToRun:ScriptHolder = valueSource.EvaluateValueObject () as ScriptHolder;

         valueSource = valueSource.mNextParameter;
         var times:int = int (valueSource.EvaluateValueObject ());

         while (-- times >= 0)
            scriptToRun.RunScript ();
      }

      public static function CallBoolFunctionMultiTimes (valueSource:Parameter, valueTarget:Parameter):void
      {
         var boolFunction:EntityBasicCondition = valueSource.EvaluateValueObject () as EntityBasicCondition;

         if (boolFunction != null)
         {
            while (boolFunction.RunBoolFunction ())
            {
               // do nothing
            }
         }
      }

   //*******************************************************************
   // game / world / create
   //*******************************************************************

      public static function CreateExplosion (valueSource:Parameter, valueTarget:Parameter):void
      {
         var worldX:Number = Number (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var worldY:Number = Number (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var numParticles:int = int (valueSource.EvaluateValueObject ());
         if (numParticles > Define.MaxNumParticls_CreateExplosion)
            numParticles = Define.MaxNumParticls_CreateExplosion;
         else if (numParticles < Define.MinNumParticls_CreateExplosion)
            numParticles = Define.MinNumParticls_CreateExplosion;

         valueSource = valueSource.mNextParameter;
         var lifeSteps:int = int (valueSource.EvaluateValueObject ());
         if (lifeSteps < 0)
            lifeSteps = 0;

         valueSource = valueSource.mNextParameter;
         var density:Number = Number (valueSource.EvaluateValueObject ());
         if (density < 0.0)
            density = 0.0;

         valueSource = valueSource.mNextParameter;
         var restitution:Number = Number (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var speed:Number = Number (valueSource.EvaluateValueObject ());
         if (speed < 0.0)
            speed = - speed;

         valueSource = valueSource.mNextParameter;
         var color:uint = uint (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var visible:Boolean = Boolean (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var cat:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         numParticles = Global.GetCurrentWorld ().CreateExplosion (null, worldX, worldY, cat, numParticles,
                     lifeSteps * Global.GetCurrentWorld ().GetPhysicsSimulationStepTimeLength (),
                     density, restitution, speed, 1.0, color, visible);

         valueTarget.AssignValueObject (numParticles);
      }

   //*******************************************************************
   // game / world / create
   //*******************************************************************

      public static function PlaySound (valueSource:Parameter, valueTarget:Parameter):void
      {
         var soundIndex:int = valueSource.EvaluateValueObject () as int;
         if (isNaN (soundIndex))
            soundIndex = -1;

         var sound:Sound = Global.GetSoundByIndex (soundIndex);
         if (sound != null && sound.GetSoundObject () != null)
         {
            valueSource = valueSource.mNextParameter;
            var times:int = int (valueSource.EvaluateValueObject ());
   
            valueSource = valueSource.mNextParameter;
            var crossingLevels:Boolean = Boolean (valueSource.EvaluateValueObject ());
            
            Global.Viewer_mLibSound.PlaySound (sound.GetSoundObject (), times, crossingLevels);
         }
      }

      public static function StopAllSounds_InLevel (valueSource:Parameter, valueTarget:Parameter):void
      {
         Global.Viewer_mLibSound.StopAllInLevelSounds ();
      }
      
      public static function StopSound_CrossLevels (valueSource:Parameter, valueTarget:Parameter):void
      {
         var soundIndex:int = valueSource.EvaluateValueObject () as int;
         if (isNaN (soundIndex))
            soundIndex = -1;
         
         var sound:Sound = null;
         if (soundIndex >= 0)
         {
            sound = Global.GetSoundByIndex (soundIndex);
            if (sound == null || sound.GetSoundObject () == null)
               return;
         }
         
         // null means all (when soundIndex < 0)
            
         Global.Viewer_mLibSound.StopCrossLevelsSound (sound == null ? null : sound.GetSoundObject ());
      }
      
      public static function IsSoundEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         valueTarget.AssignValueObject (Global.UI_IsSoundEnabled ());
      }
      
      public static function SetSoundEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         var soundOn:Boolean = Boolean (valueSource.EvaluateValueObject ());
         
         Global.UI_SetSoundEnabled (soundOn);
      }
      
      //public static function GetGlobalSoundVolume (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //}
      //
      //public static function SetGlobalSoundVolume (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //}
      
   //*******************************************************************
   // game / world / module
   //*******************************************************************

      public static function AssignModule (valueSource:Parameter, valueTarget:Parameter):void
      {
         //var module:Module = valueSource.EvaluateValueObject () as Module;
         var moduleIndex:int = valueSource.EvaluateValueObject () as int;

         valueTarget.AssignValueObject (Global.ValiddateModuleIndex (moduleIndex));
      }

      public static function EqualsWith_Module (valueSource:Parameter, valueTarget:Parameter):void
      {
         //var module:Module = valueSource.EvaluateValueObject () as Module;
         var moduleIndex:int = valueSource.EvaluateValueObject () as int;
         
         valueSource = valueSource.mNextParameter;
         //var module2:Module = valueSource.EvaluateValueObject () as Module;
         var moduleIndex2:int = valueSource.EvaluateValueObject () as int;

         valueTarget.AssignValueObject (Global.ValiddateModuleIndex (moduleIndex) == Global.ValiddateModuleIndex (moduleIndex2));
      }

   //*******************************************************************
   // game collision category
   //*******************************************************************

      public static function AssignCollisionCategory (valueSource:Parameter, valueTarget:Parameter):void
      {
         var cat:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueTarget.AssignValueObject (cat);
      }

      public static function ConditionAssignCollisionCategory (valueSource:Parameter, valueTarget:Parameter):void
      {
         var condtion:Boolean = Boolean (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var cat1:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueSource = valueSource.mNextParameter;
         var cat2:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueTarget.AssignValueObject (condtion ? cat1 : cat2);
      }

      public static function SwapCCatValues (valueSource:Parameter, valueTarget:Parameter):void
      {
         var ccat1:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         var source1:Parameter = valueSource;

         valueSource = valueSource.mNextParameter;
         var ccat2:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         source1.AssignValueObject (ccat2);
         valueSource.AssignValueObject (ccat1);
      }

      public static function IsNullCCat (valueSource:Parameter, valueTarget:Parameter):void
      {
         var ccat:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueTarget.AssignValueObject (ccat == null);
      }

      public static function SetCollisionCategoryCollideInternally (valueSource:Parameter, valueTarget:Parameter):void
      {
         var cat:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueSource = valueSource.mNextParameter;
         var collideInternally:Boolean = valueSource.EvaluateValueObject () as Boolean;

         Global.GetCurrentWorld ().BreakOrCreateCollisionCategoryFriendLink (cat, cat, collideInternally);
      }

      public static function SetCollisionCategoriesAsFriends (valueSource:Parameter, valueTarget:Parameter):void
      {
         var cat1:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueSource = valueSource.mNextParameter;
         var cat2:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;

         valueSource = valueSource.mNextParameter;
         var asFriends:Boolean = valueSource.EvaluateValueObject () as Boolean;

         Global.GetCurrentWorld ().BreakOrCreateCollisionCategoryFriendLink (cat1, cat2, ! asFriends);
      }

   //*******************************************************************
   // game entity
   //*******************************************************************

      public static function AssignEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;

         valueTarget.AssignValueObject (entity);
      }

      public static function ConditionAssignEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var condition:Boolean = Boolean (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var entity1:Entity = valueSource.EvaluateValueObject () as Entity;

         valueSource = valueSource.mNextParameter;
         var entity2:Entity = valueSource.EvaluateValueObject () as Entity;

         valueTarget.AssignValueObject (condition ? entity1 : entity2);
      }

      public static function SwapEntityValues(valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity1:Entity = valueSource.EvaluateValueObject () as Entity;

         var source1:Parameter = valueSource;

         valueSource = valueSource.mNextParameter;
         var entity2:Entity = valueSource.EvaluateValueObject () as Entity;

         source1.AssignValueObject (entity2);
         valueSource.AssignValueObject (entity1);
      }

      public static function IsNullEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;

         valueTarget.AssignValueObject (entity == null);
      }

      public static function GetEntityId (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (Define.EntityId_None);
         }
         else
         {
            valueTarget.AssignValueObject (entity.GetCreationId ());
         }
      }

      public static function GetAnotherEntityByIdOffset (valueSource:Parameter, valueTarget:Parameter):void
      {
         var baseEntity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (baseEntity == null || baseEntity.GetCreationId () < 0)
         {
            valueTarget.AssignValueObject (null);
         }
         else
         {
            valueSource = valueSource.mNextParameter;
            var idOffset:int = int (valueSource.EvaluateValueObject ());

            valueSource = valueSource.mNextParameter;
            var supportRuntimeEntity:Boolean = valueSource.EvaluateValueObject () as Boolean;

            valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetEntityByCreateOrderId (baseEntity.GetCreationId () + idOffset, supportRuntimeEntity));
         }
      }

      public static function SetEntityTaskStatus (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
            return;

         valueSource = valueSource.mNextParameter;
         switch (int (valueSource.EvaluateValueObject ()))
         {
            case ValueDefine.TaskStatus_Failed:
               entity.SetTaskFailed ();
               break;
            case ValueDefine.TaskStatus_Successed:
               entity.SetTaskSuccessed ();
               break;
            case ValueDefine.TaskStatus_Unfinished:
               entity.SetTaskUnfinished ();
               break;
            default:
               break;
         }
      }

      public static function IsEntityTaskSuccessed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;

         var succeeded:Boolean = entity == null ? false : entity.IsTaskSuccessed ();

         valueTarget.AssignValueObject (succeeded);
      }

      public static function IsEntityTaskFailed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;

         var failed:Boolean = entity == null ? false : entity.IsTaskFailed ();

         valueTarget.AssignValueObject (failed);
      }

      public static function IsEntityTaskUnfinished (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;

         var unfinished:Boolean = entity == null ? true : entity.IsTaskUnfinished ();

         valueTarget.AssignValueObject (unfinished);
      }

      public static function IsShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsJointEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var joint:EntityJoint = valueSource.EvaluateValueObject () as EntityJoint;

         valueTarget.AssignValueObject (joint != null);
      }

      public static function IsTriggerEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var trigger:EntityLogic = valueSource.EvaluateValueObject () as EntityLogic;

         valueTarget.AssignValueObject (trigger != null);
      }

      public static function IsEntityVisible (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;

         var visible:Boolean = entity == null ? false : entity.IsVisible ();
         valueTarget.AssignValueObject (visible);
      }

      public static function SetEntityVisible (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
            return;

         valueSource = valueSource.mNextParameter;
         var visible:Boolean = valueSource.EvaluateValueObject () as Boolean;

         entity.SetVisible (visible);
      }

      public static function GetEntityAlpha (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;

         var alpha:Number = entity == null ? 1.0 : entity.GetAlpha ();

         valueTarget.AssignValueObject (alpha);
      }

      public static function SetEntityAlpha (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
            return;

         valueSource = valueSource.mNextParameter;
         var alpha:Number = valueSource.EvaluateValueObject () as Number;

         entity.SetAlpha (alpha);
      }

      public static function AdjustEntityAppearanceOrder (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
            return;

         valueSource = valueSource.mNextParameter;
         var toTop:Boolean = valueSource.EvaluateValueObject () as Boolean;

         entity.AdjustAppearanceOrder (null, toTop);
      }

      public static function AdjustEntityAppearanceOrderRelativeTo (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
            return;

         valueSource = valueSource.mNextParameter;
         var relativeToEntity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (relativeToEntity == null)
            return;

         valueSource = valueSource.mNextParameter;
         var frontOf:Boolean = valueSource.EvaluateValueObject () as Boolean;

         entity.AdjustAppearanceOrder (relativeToEntity, frontOf);
      }

      public static function IsEntityEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;

         var enabled:Boolean = entity == null ? false : entity.IsEnabled ();
         valueTarget.AssignValueObject (enabled);
      }

      public static function SetEntityEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null || entity.IsDestroyedAlready ())
            return;

         // move into SetEnabled
         // if (! entity.CanBeDisabled ())
         //    return;

         valueSource = valueSource.mNextParameter;
         var enabled:Boolean = valueSource.EvaluateValueObject () as Boolean;

         entity.SetEnabled (enabled);
      }

      public static function GetEntityPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
         {
            // error

            valueTarget.AssignValueObject (0.0);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (0.0);

            return;
         }

         valueTarget.AssignValueObject (entity.GetPositionX ());

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (entity.GetPositionY ());
      }

      //public static function SetEntityPosition (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
      //   if (shape == null)
      //      return;
      //
      //   if (entity.IsDestroyedAlready ())
      //      return;
      //
      //   valueSource = valueSource.mNextParameter;
      //   var pos_x:Number = valueSource.EvaluateValueObject () as Number;
      //
      //   valueSource = valueSource.mNextParameter;
      //   var pos_y:Number = valueSource.EvaluateValueObject () as Number;
      //
      //   shape.MoveTo (pos_x, pos_y);
      //}

      public static function GetEntityRotationByRadians (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (0.0);

            return;
         }

         valueTarget.AssignValueObject (entity.GetRotationInTwoPI ());
      }

      //public static function SetEntityRotationByRadians (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //}

      public static function GetEntityRotationByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (0.0);

            return;
         }

         valueTarget.AssignValueObject (entity.GetRotationInTwoPI () * Define.kRadians2Degrees);
      }

      //public static function SetEntityRotationByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //}

      public static function GetEntityAccumulatedRotationByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (0.0);

            return;
         }

         valueTarget.AssignValueObject (entity.GetRotation ());
      }

      public static function IsEntityFlipped (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (false);

            return;
         }

         valueTarget.AssignValueObject (entity.IsFlipped ());
      }

      public static function GetEntityScale (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (1.0);

            return;
         }

         valueTarget.AssignValueObject (entity.GetScale ());
      }

      public static function WorldPoint2EntityLocalPoint (valueSource:Parameter, valueTarget:Parameter):void
      {
         var localPoint:Point = new Point ();

         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
         {
            localPoint.x = 0.0;
            localPoint.y = 0.0;
         }
         else
         {
            valueSource = valueSource.mNextParameter;
            var world_x:Number = valueSource.EvaluateValueObject () as Number;

            valueSource = valueSource.mNextParameter;
            var world_y:Number = valueSource.EvaluateValueObject () as Number;

            shape.WorldPoint2LocalPoint (world_x, world_y, localPoint);
         }

         // ...

         valueTarget.AssignValueObject (localPoint.x);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (localPoint.y);
      }

      public static function EntityLocalPoint2WorldPoint (valueSource:Parameter, valueTarget:Parameter):void
      {
         var worldPoint:Point = new Point ();

         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
         {
            worldPoint.x = 0.0;
            worldPoint.y = 0.0;
         }
         else
         {
            valueSource = valueSource.mNextParameter;
            var local_x:Number = valueSource.EvaluateValueObject () as Number;

            valueSource = valueSource.mNextParameter;
            var local_y:Number = valueSource.EvaluateValueObject () as Number;

            shape.LocalPoint2WorldPoint (local_x, local_y, worldPoint);
         }

         // ...

         valueTarget.AssignValueObject (worldPoint.x);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (worldPoint.y);
      }

      public static function WorldVector2EntityLocalVector (valueSource:Parameter, valueTarget:Parameter):void
      {
         var localVector:Point = new Point ();

         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
         {
            localVector.x = 0.0;
            localVector.y = 0.0;
         }
         else
         {
            valueSource = valueSource.mNextParameter;
            var world_dx:Number = valueSource.EvaluateValueObject () as Number;

            valueSource = valueSource.mNextParameter;
            var world_dy:Number = valueSource.EvaluateValueObject () as Number;

            shape.WorldVector2LocalVector (world_dx, world_dy, localVector);
         }

         // ...

         valueTarget.AssignValueObject (localVector.x);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (localVector.y);
      }

      public static function EntityLocalVector2WorldVector (valueSource:Parameter, valueTarget:Parameter):void
      {
         var worldVector:Point = new Point ();

         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
         {
            worldVector.x = 0.0;
            worldVector.y = 0.0;
         }
         else
         {
            valueSource = valueSource.mNextParameter;
            var local_dx:Number = valueSource.EvaluateValueObject () as Number;

            valueSource = valueSource.mNextParameter;
            var local_dy:Number = valueSource.EvaluateValueObject () as Number;

            shape.LocalVector2WorldVector (local_dx, local_dy, worldVector);
         }

         // ...

         valueTarget.AssignValueObject (worldVector.x);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (worldVector.y);
      }

      public static function IsEntityDestroyed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (false);
         }
         else
         {
            valueTarget.AssignValueObject (entity.IsDestroyedAlready ());
         }
      }

      public static function DestroyEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity == null)
            return;

         if (entity.IsDestroyedAlready ())
            return;

         entity.DestroyEntity ();
      }

      public static function AreTwoEntitiesCoincided (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity1:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity1 == null)
            return;

         valueSource = valueSource.mNextParameter;
         var entity2:Entity = valueSource.EvaluateValueObject () as Entity;
         if (entity2 == null)
            return;

         valueSource = valueSource.mNextParameter;
         var toleranceDx:Number = Number (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var toleranceDy:Number = Number (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var toleranceDr:Number = Number (valueSource.EvaluateValueObject ());

         var dx:Number = entity1.GetPositionX () - entity2.GetPositionX ();
         var dy:Number = entity1.GetPositionY () - entity2.GetPositionY ();
         var dr:Number = ((entity1.GetRotationInTwoPI () - entity2.GetRotationInTwoPI ()) * Define.kRadians2Degrees) % 360;
         if (dx < 0) dx = -dx;
         if (dy < 0) dy = -dy;
         //if (dr < 0) dr = -dr;
         if (dr < 0) dr = -dr;
         if (dr > 180) dr = 360 - dr;

         var coincided:Boolean = dx < toleranceDx && dy < toleranceDy && dr < toleranceDr;

         valueTarget.AssignValueObject (coincided);
      }

   //*******************************************************************
   // entity / shape
   //*******************************************************************

      public static function CloneShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
         {
            valueTarget.AssignValueObject (null);
            return;
         }

         valueSource = valueSource.mNextParameter;
         var targetX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var targetY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var bCloneBrothers:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bCloneConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bCloneConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (EntityShape.CloneShape (shape, targetX, targetY, bCloneBrothers, bCloneConnectedMovables, bCloneConnectedStatics));
      }

      public static function IsCircleShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShapeCircle = valueSource.EvaluateValueObject () as EntityShapeCircle;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsRectangleShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShapeRectangle = valueSource.EvaluateValueObject () as EntityShapeRectangle;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsPolygonShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShapePolygon = valueSource.EvaluateValueObject () as EntityShapePolygon;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsPolylineShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShapePolyline = valueSource.EvaluateValueObject () as EntityShapePolyline;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsBombShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape

         valueTarget.AssignValueObject (shape is EntityShape_CircleBomb || shape is EntityShape_RectangleBomb);
      }

      public static function IsWorldBorderEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape_WorldBorder = valueSource.EvaluateValueObject () as EntityShape_WorldBorder;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsCameraEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape_Camera = valueSource.EvaluateValueObject () as EntityShape_Camera;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsTextShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsModuleShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShapeImageModule = valueSource.EvaluateValueObject () as EntityShapeImageModule;

         valueTarget.AssignValueObject (shape != null);
      }

      public static function IsButtonShapeEntity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         valueTarget.AssignValueObject (shape != null && (shape is EntityShape_TextButton || shape is EntityShapeImageModuleButton));
      }

      // ...

      public static function GetShapeOriginalCIType (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var aiType:int = shape == null ? Define.ShapeAiType_Unknown : shape.GetOriginalShapeAiType ();
         valueTarget.AssignValueObject (aiType);
      }

      public static function SetShapeOriginalCIType (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         if (! shape.IsAiTypeChangeable ())
            return;

         valueSource = valueSource.mNextParameter;
         var ciType:int = uint (valueSource.EvaluateValueObject ());

         shape.SetOriginalShapeAiType (ciType);
      }

      public static function GetShapeCIType (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var aiType:int = shape == null ? Define.ShapeAiType_Unknown : shape.GetShapeAiType ();
         valueTarget.AssignValueObject (aiType);
      }

      public static function SetShapeCIType (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         if (! shape.IsAiTypeChangeable ())
            return;

         valueSource = valueSource.mNextParameter;
         var ciType:int = uint (valueSource.EvaluateValueObject ());

         shape.SetShapeAiType (ciType);
      }
      
      public static function GetBodyTexture (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape_WithBodyTexture = valueSource.EvaluateValueObject () as EntityShape_WithBodyTexture;

         valueTarget.AssignValueObject (shape == null ? -1 : shape.GetBodyTextureModuleIndex ());       
      }
      
      public static function SetBodyTexture (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape_WithBodyTexture = valueSource.EvaluateValueObject () as EntityShape_WithBodyTexture;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var textureModuleIndex:int = valueSource.EvaluateValueObject () as int;
         
         shape.SetBodyTextureModuleIndex (Global.ValiddateModuleIndex (textureModuleIndex));
      }

      public static function GetShapeFilledColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var filledColor:uint = 0x000000;

         if (shape == null)
         {
            var world:World = valueSource.EvaluateValueObject () as World;
            if (world != null)
               filledColor = world.GetBackgroundColor ();
         }
         else
         {
            filledColor = shape.GetFilledColor ();
         }

         valueTarget.AssignValueObject (filledColor);
      }

      public static function SetShapeFilledColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var world:World;
         if (shape == null)
         {
            world = valueSource.EvaluateValueObject () as World;
            if (world == null)
               return;
         }

         valueSource = valueSource.mNextParameter;
         var color:uint = uint (valueSource.EvaluateValueObject ());

         if (shape == null)
         {
            world.SetBackgroundColor (color);
         }
         else
         {
            shape.SetFilledColor (color);
         }
      }

      public static function GetShapeFilledColorRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var filledColor:uint = 0x000000;

         if (shape == null)
         {
            var world:World = valueSource.EvaluateValueObject () as World;
            if (world != null)
               filledColor = world.GetBackgroundColor ();
         }
         else
         {
            filledColor = shape.GetFilledColor ();
         }

         valueTarget.AssignValueObject ((filledColor >> 16) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((filledColor >> 8) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((filledColor >> 0) & 0xFF);
      }

      public static function SetShapeFilledColorRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var world:World;
         if (shape == null)
         {
            world = valueSource.EvaluateValueObject () as World;
            if (world == null)
               return;
         }

         valueSource = valueSource.mNextParameter;
         var red:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var green:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var blue:int =  valueSource.EvaluateValueObject () as Number;

         if (shape == null)
         {
            world.SetBackgroundColor ((red << 16) | (green << 8) | (blue));
         }
         else
         {
            shape.SetFilledColor ((red << 16) | (green << 8) | (blue));
         }
      }

      public static function GetFilledOpacity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         valueTarget.AssignValueObject (shape == null ? 100 : shape.GetTransparency ());
      }

      public static function SetFilledOpacity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         valueSource = valueSource.mNextParameter;
         var opacity:Number = Number (valueSource.EvaluateValueObject ());

         shape.SetTransparency (opacity);
      }
      
      public static function IsShapeShowBorder (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         valueTarget.AssignValueObject (shape == null ? true : shape.IsDrawBorder ());
      }
      
      public static function SetShapeShowBorder (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         valueSource = valueSource.mNextParameter;
         var drawBorder:Boolean = valueSource.EvaluateValueObject () as Boolean;

         shape.SetDrawBorder (drawBorder);
      }

      public static function GetShapeBorderColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var borderColor:uint = 0x000000;

         if (shape == null)
         {
            var world:World = valueSource.EvaluateValueObject () as World;
            if (world != null)
               borderColor = world.GetBorderColor ();
         }
         else
         {
            borderColor = shape.GetBorderColor ();
         }

         valueTarget.AssignValueObject (borderColor);
      }

      public static function SetShapeBorderColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var world:World;
         if (shape == null)
         {
            world = valueSource.EvaluateValueObject () as World;
            if (world == null)
               return;
         }

         valueSource = valueSource.mNextParameter;
         var color:uint = uint (valueSource.EvaluateValueObject ());

         if (shape == null)
         {
            world.SetBorderColor (color);
         }
         else
         {
            shape.SetBorderColor (color);
         }
      }

      public static function GetShapeBorderColorRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var borderColor:uint = 0x000000;

         if (shape == null)
         {
            var world:World = valueSource.EvaluateValueObject () as World;
            if (world != null)
               borderColor = world.GetBorderColor ();
         }
         else
         {
            borderColor = shape.GetBorderColor ();
         }

         valueTarget.AssignValueObject ((borderColor >> 16) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((borderColor >> 8) & 0xFF);

         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject ((borderColor >> 0) & 0xFF);
      }

      public static function SetShapeBorderColorRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var world:World;
         if (shape == null)
         {
            world = valueSource.EvaluateValueObject () as World;
            if (world == null)
               return;
         }

         valueSource = valueSource.mNextParameter;
         var red:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var green:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var blue:int =  valueSource.EvaluateValueObject () as Number;

         if (shape == null)
         {
            world.SetBorderColor ((red << 16) | (green << 8) | (blue));
         }
         else
         {
            shape.SetBorderColor ((red << 16) | (green << 8) | (blue));
         }
      }

      public static function GetBorderOpacity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         valueTarget.AssignValueObject (shape == null ? 100 : shape.GetBorderTransparency ());
      }

      public static function SetBorderOpacity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         valueSource = valueSource.mNextParameter;
         var opacity:Number = Number (valueSource.EvaluateValueObject ());

         shape.SetBorderTransparency (opacity);
      }
      
      public static function SetCacheAsBitmap (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         valueSource = valueSource.mNextParameter;
         var asBitmap:Boolean = valueSource.EvaluateValueObject () as Boolean;

         shape.SetCacheAsBitmap (asBitmap);
      }

      public static function IsShapePhysicsEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var enabled:Boolean = shape == null ? false : shape.IsPhysicsShape ();
         valueTarget.AssignValueObject (enabled);
      }

      //public static function SetShapePhysicsEnabled (valueSource:Parameter, valueTarget:Parameter):void
      //{
         //if (shape.IsDestroyedAlready ())
         //   return;
         //
      //}

      public static function GetShapeCollisionCategory (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var ccat:CollisionCategory = shape == null ? null : shape.GetCollisionCategory ();
         valueTarget.AssignValueObject (ccat);
      }

      public static function SetShapeCollisionCategory (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         //if (shape.IsDestroyedAlready ())
         //   return;

         valueSource = valueSource.mNextParameter;
         var ccat:CollisionCategory = valueSource.EvaluateValueObject () as CollisionCategory;
         //if (ccat == null)
         //   return;

         shape.SetCollisionCategory (ccat);
      }

      public static function IsSensorShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var sensor:Boolean = shape == null ? false : shape.IsSensor ();
         valueTarget.AssignValueObject (sensor);
      }

      public static function SetShapeAsSensor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var sensor:Boolean = valueSource.EvaluateValueObject () as Boolean;

         shape.SetAsSensor (sensor);
      }

      public static function IsStatic (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var static:Boolean = shape == null ? true : (shape.IsDestroyedAlready () ? shape.IsStatic () : shape.GetBody ().IsStatic ());
         valueTarget.AssignValueObject (static);
      }

      public static function SetStatic (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextParameter;
         var static:Boolean = valueSource.EvaluateValueObject () as Boolean;
         
         shape.GetBody ().ModifyShapeStatic (shape, static);
      }

      public static function IsShapeRotationFixed(valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         var sensor:Boolean = shape == null ? false : (shape.IsDestroyedAlready () ? shape.IsRotationFixed () : shape.GetBody ().IsRotationFixed ());
         valueTarget.AssignValueObject (sensor);
      }

      public static function SetShapeRotationFixed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var fixRotation:Boolean = valueSource.EvaluateValueObject () as Boolean;

         shape.GetBody ().ModifyShapeRotationFixed (shape, fixRotation);
      }

      public static function IsShapeSleeping (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         if (shape == null || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (false);
         else
         {
            var body:EntityBody = shape.GetBody ();

            valueTarget.AssignValueObject (body.IsSleeping ());
         }
      }

      public static function SetShapeSleeping (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var sleeping:Boolean = valueSource.EvaluateValueObject () as Boolean;

         shape.GetBody ().SetSleeping (sleeping);
      }

      public static function GetLocalCentroid (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         if (shape == null || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (0.0);
         else
         {
            valueTarget.AssignValueObject (shape.GetLocalCentroidXInShapeSpace ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (shape.GetLocalCentroidYInShapeSpace ());
         }
      }

      public static function GetWorldCentroid (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         if (shape == null || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (0.0);
         else
         {
            valueSource = valueSource.mNextParameter;
            var isBodyValue:Boolean = valueSource.EvaluateValueObject () as Boolean;

            if (isBodyValue)
            {
               var body:EntityBody = shape.GetBody ();

               valueTarget.AssignValueObject (body.GetPositionX ());

               valueTarget = valueTarget.mNextParameter;
               valueTarget.AssignValueObject (body.GetPositionY ());
            }
            else
            {
               valueTarget.AssignValueObject (shape.GetWorldCentroidX ());

               valueTarget = valueTarget.mNextParameter;
               valueTarget.AssignValueObject (shape.GetWorldCentroidY ());
            }
         }
      }

      public static function GetShapeMass (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         if (shape == null || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (0.0);
         else
         {
            valueSource = valueSource.mNextParameter;
            var isBodyValue:Boolean = valueSource.EvaluateValueObject () as Boolean;

            if (isBodyValue)
            {
               valueTarget.AssignValueObject (shape.GetBody ().GetMass ());
            }
            else
            {
               valueTarget.AssignValueObject (shape.GetMass ());
            }
         }
      }

      //public static function SetShapeMass (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
      //
      //   if (shape == null || shape.IsDestroyedAlready ())
      //     return;
      //
      //   valueSource = valueSource.mNextParameter;
      //   var newMass:Number = valueSource.EvaluateValueObject () as Number;
      //
      //   shape.ChangeMass (newMass);
      //}

      public static function GetShapeInertia (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         if (shape == null || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (0.0);
         else
         {
            valueSource = valueSource.mNextParameter;
            var isBodyValue:Boolean = valueSource.EvaluateValueObject () as Boolean;

            if (isBodyValue)
            {
               valueTarget.AssignValueObject (shape.GetBody ().GetInertia ());
            }
            else
            {
               valueTarget.AssignValueObject (shape.GetInertia ());
            }
         }
      }

      //public static function SetShapeInertia (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
      //
      //   if (shape == null || shape.IsDestroyedAlready ())
      //     return;
      //
      //   valueSource = valueSource.mNextParameter;
      //   var newIntertia:Number = valueSource.EvaluateValueObject () as Number;
      //
      //   shape.ChangeInteria (newIntertia);
      //}

      public static function GetShapeDensity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         if (shape == null) // || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (0.0);
         else
         {
            valueTarget.AssignValueObject (shape.GetDensity ());
         }
      }

      public static function SetShapeDensity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         if (shape == null || shape.IsDestroyedAlready ())
           return;

         valueSource = valueSource.mNextParameter;
         var newDensity:Number = valueSource.EvaluateValueObject () as Number;

         shape.ChangeDensity (newDensity); // don't call SetDensity
      }

      public static function SetShapeLinearVelocity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var velocityX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var velocityY:Number = valueSource.EvaluateValueObject () as Number;

         shape.AddLinearMomentum (velocityX - shape.GetLinearVelocityX (), velocityY - shape.GetLinearVelocityY (), true, false);
      }

      public static function GetShapeLinearVelocity (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null || shape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (shape.GetLinearVelocityX ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (shape.GetLinearVelocityY ());
         }
      }

      public static function SetAngularVelocityByRadians (valueSource:Parameter, valueTarget:Parameter):void
      {
         SetAngularVelocity (valueSource, valueTarget, false);
      }

      public static function SetAngularVelocityByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         SetAngularVelocity (valueSource, valueTarget, true);
      }

      private static function SetAngularVelocity (valueSource:Parameter, valueTarget:Parameter, byDegrees:Boolean):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var angularVelocity:Number = valueSource.EvaluateValueObject () as Number;
         if (byDegrees)
         {
             angularVelocity *= Define.kDegrees2Radians;
         }

         shape.AddAngularMomentum (angularVelocity - shape.GetAngularVelocity (), true);
      }

      public static function GetAngularVelocityByRadians (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null || shape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (shape.GetAngularVelocity ());
         }
      }

      public static function GetAngularVelocityByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null || shape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (shape.GetAngularVelocity () * Define.kRadians2Degrees);
         }
      }

      public static function AddLinearImpulseByVelocityVector (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var deltaVelocityX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var deltaVelocityY:Number = valueSource.EvaluateValueObject () as Number;

         shape.AddLinearMomentum (deltaVelocityX, deltaVelocityY, true, false);
      }

      public static function ApplyLinearImpulseOnShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         _ApplyLinearImpulseOnShape (valueSource, valueTarget);
      }

      public static function ApplyLinearImpulseAtLocalPointOnShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         _ApplyLinearImpulseOnShape (valueSource, valueTarget, true);
      }

      public static function ApplyLinearImpulseAtWorldPointOnShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         _ApplyLinearImpulseOnShape (valueSource, valueTarget, false);
      }

      public static function _ApplyLinearImpulseOnShape (valueSource:Parameter, valueTarget:Parameter, isLocalPoint:Boolean = false):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var impulseX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var impulseY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var isLocalImpulse:Boolean = valueSource.EvaluateValueObject () as Boolean;

         if (isLocalImpulse)
         {
            var worldVector:Point = new Point ();
            shape.LocalVector2WorldVector (impulseX, impulseY, worldVector);
            impulseX = worldVector.x;
            impulseY = worldVector.y;
         }

         var body:EntityBody = shape.GetBody ();

         valueSource = valueSource.mNextParameter;

         if (valueSource.mNextParameter == null)
         {
            var onBodyCenter:Boolean = valueSource.EvaluateValueObject () as Boolean;

            if (onBodyCenter)
               body.ApplyLinearImpulse (impulseX, impulseY, body.GetPositionX (), body.GetPositionY ());
            else
               body.ApplyLinearImpulse (impulseX, impulseY, shape.GetWorldCentroidX (), shape.GetWorldCentroidY ());
         }
         else
         {
            var pointX:Number = valueSource.EvaluateValueObject () as Number;

            valueSource = valueSource.mNextParameter;
            var pointY:Number = valueSource.EvaluateValueObject () as Number;

            if (isLocalPoint)
            {
               var worldPoint:Point = new Point ();
               shape.LocalPoint2WorldPoint (pointX, pointY, worldPoint);
               pointX = worldPoint.x;
               pointY = worldPoint.y;
            }

            body.ApplyLinearImpulse (impulseX, impulseY, pointX, pointY);
         }
      }

      public static function ApplyAngularImpulse (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var angularImpulse:Number = valueSource.EvaluateValueObject () as Number;

         shape.GetBody ().ApplyAngularImpulse (angularImpulse);
      }

      public static function ChangeAngularVelocityByRadians (valueSource:Parameter, valueTarget:Parameter):void
      {
         ChangeAngularVelocity (valueSource, valueTarget, false);
      }

      public static function ChangeAngularVelocityByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         ChangeAngularVelocity (valueSource, valueTarget, true);
      }

      private static function ChangeAngularVelocity (valueSource:Parameter, valueTarget:Parameter, byDegrees:Boolean):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var deltaAngularVelocity:Number = valueSource.EvaluateValueObject () as Number;
         if (byDegrees)
         {
            deltaAngularVelocity *= Define.kDegrees2Radians;
         }

         shape.AddAngularMomentum (deltaAngularVelocity, true);
      }

      public static function ApplyStepForceOnShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         _ApplyStepForceOnShape (valueSource, valueTarget);
      }

      public static function ApplyStepForceAtLocalPointOnShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         _ApplyStepForceOnShape (valueSource, valueTarget, true);
      }

      public static function ApplyStepForceAtWorldPointOnShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         _ApplyStepForceOnShape (valueSource, valueTarget, false);
      }

      public static function _ApplyStepForceOnShape (valueSource:Parameter, valueTarget:Parameter, isLocalPoint:Boolean = false):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var forceX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var forceY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var isLocalForce:Boolean = valueSource.EvaluateValueObject () as Boolean;

         if (isLocalForce)
         {
            var worldVector:Point = new Point ();
            shape.LocalVector2WorldVector (forceX, forceY, worldVector);
            forceX = worldVector.x;
            forceY = worldVector.y;
         }

         var body:EntityBody = shape.GetBody ();

         valueSource = valueSource.mNextParameter;

         if (valueSource.mNextParameter == null)
         {
            var onBodyCenter:Boolean = valueSource.EvaluateValueObject () as Boolean;

            if (onBodyCenter)
            {
               body.ApplyForceAtPoint (forceX, forceY, body.GetPositionX (), body.GetPositionY ());
            }
            else
            {
               body.ApplyForceAtPoint (forceX, forceY, shape.GetWorldCentroidX (), shape.GetWorldCentroidY ());
            }
         }
         else
         {
            var pointX:Number = valueSource.EvaluateValueObject () as Number;

            valueSource = valueSource.mNextParameter;
            var pointY:Number = valueSource.EvaluateValueObject () as Number;

            if (isLocalPoint)
            {
               var worldPoint:Point = new Point ();
               shape.LocalPoint2WorldPoint (pointX, pointY, worldPoint);
               pointX = worldPoint.x;
               pointY = worldPoint.y;
            }

            body.ApplyForceAtPoint (forceX, forceY, pointX, pointY);
         }
      }

      public static function ApplyStepTorque (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var torque:Number = valueSource.EvaluateValueObject () as Number;

         shape.GetBody ().ApplyTorque (torque);
      }

      public static function UpdateShapeContactStatusInfos(valueSource:Parameter, valueTarget:Parameter):void
      {
         Global.GetCurrentWorld ().UpdateShapeContactStatusInfos ();
      }

      public static function GetPhysicsShapesAtPoint(valueSource:Parameter, valueTarget:Parameter):void
      {
         var pointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var pointY:Number = valueSource.EvaluateValueObject () as Number;
         
         var shapes:Array = Global.GetCurrentWorld ().GetPhysicsEngine ().GetShapesAtPoint (pointX, pointY);
         CoreClasses.CovertArrayElementsToClassInstances (shapes, CoreClasses.kEntityClassDefinition);
         
         valueTarget.AssignValueObject (shapes);
      }

      public static function GetFirstIncomingIntersectionWithLineSegment(valueSource:Parameter, valueTarget:Parameter):void
      {
         var startPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var startPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var endPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var endPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetPhysicsEngine ().GetFirstIncomingIntersection (startPointX, startPointY, endPointX, endPointY));
      }

      public static function GetFirstOutcomingIntersectionWithLineSegment(valueSource:Parameter, valueTarget:Parameter):void
      {
         var startPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var startPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var endPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var endPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetPhysicsEngine ().GetFirstOutcomingIntersection (startPointX, startPointY, endPointX, endPointY));
      }

      public static function GetIntersectedShapesWithLineSegment(valueSource:Parameter, valueTarget:Parameter):void
      {
         var startPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var startPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var endPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var endPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var includingHalfIntersecteds:Boolean = valueSource.EvaluateValueObject () as Boolean;

         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetPhysicsEngine ().GetIntersectedShapes (startPointX, startPointY, endPointX, endPointY, includingHalfIntersecteds));
      }


      public static function TeleportShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var targetX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var targetY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var targetRotation:Number = (valueSource.EvaluateValueObject () as Number) * Define.kDegrees2Radians;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         EntityShape.Teleport (shape, targetX - shape.GetPositionX (), targetY - shape.GetPositionY (), shape.GetRotationOffset (targetRotation), bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);
      }

      public static function TeleportShape_Offsets (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var deltaX:Number =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var deltaY:Number =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var deltaRotation:Number = (valueSource.EvaluateValueObject () as Number) * Define.kDegrees2Radians;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         EntityShape.Teleport (shape, deltaX, deltaY, deltaRotation, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);
      }

      public static function TranslateShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var deltaX:Number =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var deltaY:Number =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         EntityShape.Translate (shape, deltaX, deltaY, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);
      }

      public static function TranslateShapeTo (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var targetX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var targetY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         EntityShape.Translate (shape, targetX - shape.GetPositionX (), targetY - shape.GetPositionY (), bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);
      }

      public static function RotateShapeAroundWorldPoint (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var fixedPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var fixedPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var deltaRotation:Number = (valueSource.EvaluateValueObject () as Number) * Define.kDegrees2Radians;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var rotateVelocity:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         EntityShape.Rotate (shape, fixedPointX, fixedPointY, deltaRotation, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints, rotateVelocity);
      }

      public static function RotateShapeToAroundWorldPoint (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var fixedPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var fixedPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var targetRotation:Number = (valueSource.EvaluateValueObject () as Number) * Define.kDegrees2Radians;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var rotateVelocity:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         EntityShape.Rotate (shape, fixedPointX, fixedPointY, shape.GetRotationOffset (targetRotation), bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints, rotateVelocity);
      }

      public static function FlipShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var flipVelocity:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         var worldPoint:Point = new Point ();
         shape.LocalPoint2WorldPoint (0, 0, worldPoint);
         var worldVector:Point = new Point ();
         shape.LocalVector2WorldVector (1, 0, worldVector);

         EntityShape.Flip (shape, worldPoint.x, worldPoint.y, worldVector.x, worldVector.y, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints, flipVelocity);
      }

      public static function FlipShapeByWorldLinePoint (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var pointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var pointY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var normalX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var normalY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var flipVelocity:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         EntityShape.Flip (shape, pointX, pointY, normalX, normalY, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints, flipVelocity);
      }

      public static function ScaleShapeWithFixedPoint (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var scaleRatio:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var fixedPointX:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var fixedPointY:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         valueSource = valueSource.mNextParameter;
         var conserveMomentum:Boolean =  valueSource.EvaluateValueObject () as Boolean;

         EntityShape.Scale (shape, scaleRatio, fixedPointX, fixedPointY, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints, conserveMomentum);
      }

      public static function GetBrothers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shapes:Array = new Array ();

         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape != null && (! shape.IsDestroyedAlready ()))
         {
            var body:EntityBody = shape.GetBody ();
            if (body != null)
            {
               body.PutShapesInArray (shapes);
            }
         }

         valueTarget.AssignValueObject (shapes);
      }

      public static function IsAttchedWith (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape1:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape1 == null || shape1.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (false);
            return;
         }

         valueSource = valueSource.mNextParameter;
         var shape2:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape2 == null || shape2.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (false);
            return;
         }

         valueTarget.AssignValueObject (shape1.GetBody () == shape2.GetBody ());
      }

      public static function DetachShape (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         //shape.DetachFromBrothers ();
         EntityShape.DetachShape (shape);
      }

	  public static function AttachTwoShapes (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape1:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape1 == null || shape1.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var shape2:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape2 == null || shape2.IsDestroyedAlready ())
            return;

         if (shape1.GetBody () != shape2.GetBody ())
         {
            //shape1.AttachWith (shape2);
            EntityShape.AttachTwoShapes (shape1, shape2);
         }
      }

	  public static function DetachShapeThenAttachWithAnother (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape1:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape1 == null || shape1.IsDestroyedAlready ())
            return;

         EntityShape.DetachShape (shape1);

         valueSource = valueSource.mNextParameter;
         var shape2:EntityShape = valueSource.EvaluateValueObject () as EntityShape;

         if (shape2 != null && (! shape2.IsDestroyedAlready ()))
         {
            EntityShape.AttachTwoShapes (shape1, shape2);
         }
      }

      public static function BreakupShapeBrothers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null || shape.IsDestroyedAlready ())
            return;

         shape.BreakupBrothers ();
      }

      public static function DestroyBrothers (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null || shape.IsDestroyedAlready ())
            return;

         var body:EntityBody = shape.GetBody ();
         if (body != null)
         {
            body.DestroyEntity ();
         }
     }

     public static function BreakShapeJoints (valueSource:Parameter, valueTarget:Parameter):void
     {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)
            return;

         if (shape.IsDestroyedAlready ())
            return;

         shape.BreakAllJoints ();
     }

     public static function GetAllSisters (valueSource:Parameter, valueTarget:Parameter):void
     {
         var shapes:Array = new Array ();

         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape != null && (! shape.IsDestroyedAlready ()))
         {
            shape.PutConnectedShapesInArray (shapes);
         }

         valueTarget.AssignValueObject (shapes);
     }

     public static function IsConnectedWith (valueSource:Parameter, valueTarget:Parameter):void
     {
         var shape1:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape1 == null || shape1.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (false);
            return;
         }

         valueSource = valueSource.mNextParameter;
         var shape2:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape2 == null || shape2.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (false);
            return;
         }

         valueTarget.AssignValueObject (shape1.IsConnectedWith (shape2));
     }

     public static function IsConnectedWithGround (valueSource:Parameter, valueTarget:Parameter):void
     {
         var shape1:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape1 == null || shape1.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (false);
            return;
         }

         valueTarget.AssignValueObject (shape1.IsConnectedWith (null));
     }

     public static function GetAllContactedShapes (valueSource:Parameter, valueTarget:Parameter):void
     {
         var shapes:Array = new Array ();

         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape != null && (! shape.IsDestroyedAlready ()))
         {
            shape.PutContactedShapesInArray (shapes);
         }

         valueTarget.AssignValueObject (shapes);
     }

     public static function IsContactedWith (valueSource:Parameter, valueTarget:Parameter):void
     {
         var shape1:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape1 == null || shape1.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (false);
            return;
         }

         valueSource = valueSource.mNextParameter;
         var shape2:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape2 == null || shape2.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (false);
            return;
         }

         valueTarget.AssignValueObject (shape1.IsContactedWith (shape2));
     }

   //*******************************************************************
   // entity / shape / text
   //*******************************************************************

      public static function GetTextFromTextComponent (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;

         var text:String = entity_text == null ? "" : entity_text.GetText ();
         valueTarget.AssignValueObject (text);
      }

      public static function SetTextForTextComponent (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         //valueSource = valueSource.mNextParameter;
         //var text:String = valueSource.EvaluateValueObject () as String;
         var text:String = CoreClasses.ToString (valueSource.mNextParameter.GetVariableInstance ());

         entity_text.SetText (text);
      }

      public static function AppendTextToTextComponent (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         //valueSource = valueSource.mNextParameter;
         //var text:String = valueSource.EvaluateValueObject () as String;
         var text:String = CoreClasses.ToString (valueSource.mNextParameter.GetVariableInstance ());

         entity_text.SetText (entity_text.GetText () + text);
      }

      public static function AppendNewLineToTextComponent (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         entity_text.SetText (entity_text.GetText () + "\n");
      }
      
      public static function GetHorizontalScrollPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueTarget.AssignValueObject (entity_text.ScrollInfo (true, 1));
      }

      public static function SetHorizontalScrollPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var scrollValue:Number = Number (valueSource.EvaluateValueObject ());

         entity_text.ScrollInfo (true, 2, scrollValue);
      }

      public static function GetVerticalScrollPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueTarget.AssignValueObject (entity_text.ScrollInfo (false, 1));
      }

      public static function SetVerticalScrollPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var scrollValue:Number = Number (valueSource.EvaluateValueObject ());

         entity_text.ScrollInfo (false, 2, scrollValue);
      }

      public static function GetMaxHorizontalScrollPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueTarget.AssignValueObject (entity_text.ScrollInfo (true, 0));
      }

      public static function GetMaxVerticalScrollPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueTarget.AssignValueObject (entity_text.ScrollInfo (false, 0));
      }

      public static function SetTextDefaultSize (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var size:Number = Number (valueSource.EvaluateValueObject ());

         entity_text.SetFontSize (size);
      }

      public static function SetTextDefaultColor (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var color:uint = uint (valueSource.EvaluateValueObject ());

         entity_text.SetTextColor (color);
      }

      public static function SetTextDefaultColorByRGB (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_Text = valueSource.EvaluateValueObject () as EntityShape_Text;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var red:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var green:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var blue:int =  valueSource.EvaluateValueObject () as Number;

         entity_text.SetTextColor ((red << 16) | (green << 8) | (blue));
      }

      public static function SetTextDefaultSize_MouseOver (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_TextButton = valueSource.EvaluateValueObject () as EntityShape_TextButton;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var size:Number = Number (valueSource.EvaluateValueObject ());

         entity_text.SetFontSize_MouseOver (size);
      }

      public static function SetTextDefaultColor_MouseOver (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_TextButton = valueSource.EvaluateValueObject () as EntityShape_TextButton;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var color:uint = uint (valueSource.EvaluateValueObject ());

         entity_text.SetTextColor_MouseOver (color);
      }

      public static function SetTextDefaultColorByRGB_MouseOver (valueSource:Parameter, valueTarget:Parameter):void
      {
         var entity_text:EntityShape_TextButton = valueSource.EvaluateValueObject () as EntityShape_TextButton;
         if (entity_text == null || entity_text.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var red:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var green:int =  valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var blue:int =  valueSource.EvaluateValueObject () as Number;

         entity_text.SetTextColor_MouseOver ((red << 16) | (green << 8) | (blue));
      }

   //*******************************************************************
   // entity / shape
   //*******************************************************************

      public static function GetShapeBorderThickness (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null)// || shape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (shape.GetBorderThickness ());
         }
      }
      
      public static function SetShapeBorderThickness (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShape = valueSource.EvaluateValueObject () as EntityShape;
         if (shape == null || shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var thickness:Number = valueSource.EvaluateValueObject () as Number;

         EntityShape.ChangeBorderThickness (shape, thickness);
      }

      public static function GetCurveThickness (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShapePolyline = valueSource.EvaluateValueObject () as EntityShapePolyline;
         if (shape == null)// || shape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (shape.GetCurveThickness ());
         }
      }

      public static function SetCurveThickness (valueSource:Parameter, valueTarget:Parameter):void
      {
         var shape:EntityShapePolyline = valueSource.EvaluateValueObject () as EntityShapePolyline;
         if (shape == null || shape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var thickness:Number = valueSource.EvaluateValueObject () as Number;

         EntityShape.ChangeCurveThickness (shape, thickness);
      }

   //*******************************************************************
   // entity / shape / circle
   //*******************************************************************

      public static function GetShapeCircleRadius (valueSource:Parameter, valueTarget:Parameter):void
      {
         var circle:EntityShapeCircle = valueSource.EvaluateValueObject () as EntityShapeCircle;
         if (circle == null)// || circle.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (circle.GetRadius ());
         }
      }

      public static function SetShapeCircleRadius (valueSource:Parameter, valueTarget:Parameter):void
      {
         var circle:EntityShapeCircle = valueSource.EvaluateValueObject () as EntityShapeCircle;
         if (circle == null || circle.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var radius:Number = valueSource.EvaluateValueObject () as Number;

         EntityShape.ChangeCircleRadius (circle, radius);
      }

   //*******************************************************************
   // entity / shape / rectangle
   //*******************************************************************

      public static function GetShapeRectangleSize (valueSource:Parameter, valueTarget:Parameter):void
      {
         var rect:EntityShapeRectangle = valueSource.EvaluateValueObject () as EntityShapeRectangle;
         if (rect == null)// || rect.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (2.0 * rect.GetHalfWidth ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (2.0 * rect.GetHalfHeight ());
         }
      }

      public static function SetShapeRectangleSize (valueSource:Parameter, valueTarget:Parameter):void
      {
         var rect:EntityShapeRectangle = valueSource.EvaluateValueObject () as EntityShapeRectangle;
         if (rect == null || rect.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var width:Number = valueSource.EvaluateValueObject () as Number;

         valueSource = valueSource.mNextParameter;
         var height:Number = valueSource.EvaluateValueObject () as Number;

         EntityShape.ChangeRectangleSize (rect, width, height);
      }

   //*******************************************************************
   // entity / shape / poly shape
   //*******************************************************************

      public static function GetVertexCount (valueSource:Parameter, valueTarget:Parameter):void
      {
         var polyShape:EntityShapePolyShape = valueSource.EvaluateValueObject () as EntityShapePolyShape;

         if (polyShape == null)// || polyShape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0);
         }
         else
         {
            valueTarget.AssignValueObject (polyShape.GetVertexPointsCount ());
         }
      }

      public static function GetVertexLocalPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         GetVertexPosition (valueSource, valueTarget, false);
      }

      public static function GetVertexWorldPosition (valueSource:Parameter, valueTarget:Parameter):void
      {
         GetVertexPosition (valueSource, valueTarget, true);
      }

      public static function GetVertexPosition (valueSource:Parameter, valueTarget:Parameter, isWorldPoint:Boolean):void
      {
         var polyShape:EntityShapePolyShape = valueSource.EvaluateValueObject () as EntityShapePolyShape;

         if (polyShape == null)// || polyShape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueSource = valueSource.mNextParameter;
            var vertexIndex:int = int (valueSource.EvaluateValueObject ());

            var point:Point = polyShape.GetLocalVertex (vertexIndex);
            if (point == null)
            {
               point = new Point (0.0, 0.0);
            }
            else
            {
               if (isWorldPoint)
               {
                  polyShape.LocalPoint2WorldPoint (point.x, point.y, point);
               }
            }

            valueTarget.AssignValueObject (point.x);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (point.y);
         }
      }

      //public static function SetVertexLocalPosition (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetVertexPosition (valueSource, valueTarget, false, false);
      //}
      //
      //public static function SetVertexWorldPosition (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetVertexPosition (valueSource, valueTarget, true, false);
      //}
      //
      //public static function InsertVertexByLocalPosition (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetVertexPosition (valueSource, valueTarget, false, true);
      //}
      //
      //public static function InsertVertexByWorldPosition (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   SetVertexPosition (valueSource, valueTarget, true, true);
      //}
      //
      //public static function SetVertexPosition (valueSource:Parameter, valueTarget:Parameter, isWorldPoint:Boolean, isInsert:Boolean):void
      //{
      //   var polyShape:EntityShapePolyShape = valueSource.EvaluateValueObject () as EntityShapePolyShape;
      //
      //   if (polyShape == null || polyShape.IsDestroyedAlready ())
      //      return;
      //
      //   valueSource = valueSource.mNextParameter;
      //   var vertexIndex:int = int (valueSource.EvaluateValueObject ());
      //
      //   valueSource = valueSource.mNextParameter;
      //   var posX:Number = int (valueSource.EvaluateValueObject ());
      //
      //   valueSource = valueSource.mNextParameter;
      //   var posY:Number = int (valueSource.EvaluateValueObject ());
      //
      //   if (isWorldPoint)
      //   {
      //      var point:Point = new Point ();
      //      polyShape.WorldPoint2LocalPoint (posX, posY, point);
      //      posX = point.x;
      //      posY = point.y;
      //   }
      //
      //   EntityShape.ModifyPolyShapeVertex (polyShape, vertexIndex, posX, posY, isInsert);
      //}
      //
      //public static function DeleteVertexAt (valueSource:Parameter, valueTarget:Parameter):void
      //{
      //   var polyShape:EntityShapePolyShape = valueSource.EvaluateValueObject () as EntityShapePolyShape;
      //
      //   if (polyShape == null || polyShape.IsDestroyedAlready ())
      //      return;
      //
      //   valueSource = valueSource.mNextParameter;
      //   var vertexIndex:int = int (valueSource.EvaluateValueObject ());
      //
      //   EntityShape.DeletePolyShapeVertex (polyShape, vertexIndex);
      //}

      public static function GetVertexLocalPositions (valueSource:Parameter, valueTarget:Parameter):void
      {
         var polyShape:EntityShapePolyShape = valueSource.EvaluateValueObject () as EntityShapePolyShape;

         if (polyShape == null || polyShape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (null);
            return;
         }
         
         var positions:Array = polyShape.GetVertexPositions (false);
         if (positions != null)
            CoreClasses.CovertArrayElementsToClassInstances (positions, CoreClasses.kNumberClassDefinition)

         valueTarget.AssignValueObject (positions);
      }

      public static function SetVertexLocalPositions (valueSource:Parameter, valueTarget:Parameter):void
      {
         var polyShape:EntityShapePolyShape = valueSource.EvaluateValueObject () as EntityShapePolyShape;

         if (polyShape == null || polyShape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var positions:Array = valueSource.EvaluateValueObject () as Array;
         
         if (positions != null)
            CoreClasses.CovertClassInstancesToArrayElements (positions);
         
         EntityShape.ModifyPolyShapeVertexPositions (polyShape, positions, false);
      }

      public static function GetVertexWorldPositions (valueSource:Parameter, valueTarget:Parameter):void
      {
         var polyShape:EntityShapePolyShape = valueSource.EvaluateValueObject () as EntityShapePolyShape;

         if (polyShape == null || polyShape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (null);
            return;
         }
         
         var positions:Array = polyShape.GetVertexPositions (true);
         if (positions != null)
            CoreClasses.CovertArrayElementsToClassInstances (positions, CoreClasses.kNumberClassDefinition)

         valueTarget.AssignValueObject (positions);
      }

      public static function SetVertexWorldPositions (valueSource:Parameter, valueTarget:Parameter):void
      {
         var polyShape:EntityShapePolyShape = valueSource.EvaluateValueObject () as EntityShapePolyShape;

         if (polyShape == null || polyShape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         var positions:Array = valueSource.EvaluateValueObject () as Array;
         
         if (positions != null)
            CoreClasses.CovertClassInstancesToArrayElements (positions);

         EntityShape.ModifyPolyShapeVertexPositions (polyShape, positions, true);
      }

   //*******************************************************************
   // entity / joint
   //*******************************************************************

      public static function GetShapeModule (valueSource:Parameter, valueTarget:Parameter):void
      {
         var moduleShape:EntityShapeImageModule = valueSource.EvaluateValueObject () as EntityShapeImageModule;

         if (moduleShape == null)
         {
            valueTarget.AssignValueObject (-1);
         }
         else
         {
            valueTarget.AssignValueObject (moduleShape.GetModuleIndex ());
         }
      }

      public static function ChangeShapeModule (valueSource:Parameter, valueTarget:Parameter):void
      {
         var moduleShape:EntityShapeImageModule = valueSource.EvaluateValueObject () as EntityShapeImageModule;

         if (moduleShape == null || moduleShape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         //var module:Module = valueSource.EvaluateValueObject () as Module;
         var moduleIndex:int = valueSource.EvaluateValueObject () as int;

         valueSource = valueSource.mNextParameter;
         var loopToEndHandler:EntityEventHandler = valueSource.EvaluateValueObject () as EntityEventHandler;
         if (loopToEndHandler != null && loopToEndHandler.GetEventId () != CoreEventIds.ID_OnSequencedModuleLoopToEnd) // generally, impossible
            loopToEndHandler = null;

         moduleShape.SetModuleIndexByAPI (Global.ValiddateModuleIndex (moduleIndex), loopToEndHandler);
      }

      public static function GetShapeModuleButton_OverState (valueSource:Parameter, valueTarget:Parameter):void
      {
         var buttonModuleShape:EntityShapeImageModuleButton = valueSource.EvaluateValueObject () as EntityShapeImageModuleButton;

         if (buttonModuleShape == null)
         {
            valueTarget.AssignValueObject (-1);
         }
         else
         {
            valueTarget.AssignValueObject (buttonModuleShape.GetModuleIndexOver ());
         }
      }

      public static function ChangeShapeModuleButton_OverState (valueSource:Parameter, valueTarget:Parameter):void
      {
         var buttonModuleShape:EntityShapeImageModuleButton = valueSource.EvaluateValueObject () as EntityShapeImageModuleButton;

         if (buttonModuleShape == null || buttonModuleShape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         //var module:Module = valueSource.EvaluateValueObject () as Module;
         var moduleIndex:int = valueSource.EvaluateValueObject () as int;

         buttonModuleShape.SetModuleIndexOver (Global.ValiddateModuleIndex (moduleIndex));
      }

      public static function GetShapeModuleButton_DownState (valueSource:Parameter, valueTarget:Parameter):void
      {
         var buttonModuleShape:EntityShapeImageModuleButton = valueSource.EvaluateValueObject () as EntityShapeImageModuleButton;

         if (buttonModuleShape == null)
         {
            valueTarget.AssignValueObject (-1);
         }
         else
         {
            valueTarget.AssignValueObject (buttonModuleShape.GetModuleIndexDown ());
         }
      }

      public static function ChangeShapeModuleButton_DownState (valueSource:Parameter, valueTarget:Parameter):void
      {
         var buttonModuleShape:EntityShapeImageModuleButton = valueSource.EvaluateValueObject () as EntityShapeImageModuleButton;

         if (buttonModuleShape == null || buttonModuleShape.IsDestroyedAlready ())
            return;

         valueSource = valueSource.mNextParameter;
         //var module:Module = valueSource.EvaluateValueObject () as Module;
         var moduleIndex:int = valueSource.EvaluateValueObject () as int;

         buttonModuleShape.SetModuleIndexDown (Global.ValiddateModuleIndex (moduleIndex));
      }

   //*******************************************************************
   // entity / joint
   //*******************************************************************

      public static function GetJointConnectedShapes (valueSource:Parameter, valueTarget:Parameter):void
      {
         var joint:EntityJoint = valueSource.EvaluateValueObject () as EntityJoint;

         var shape1:EntityShape = null;
         var shape2:EntityShape = null;
         
         if (joint != null)
         {
            shape1 = joint.GetAnchor1 ().GetShape ();
            shape2 = joint.GetAnchor2 ().GetShape ();
         }
         
         valueTarget.AssignValueObject (shape1);
         
         valueTarget = valueTarget.mNextParameter;
         valueTarget.AssignValueObject (shape2);
      }

      public static function SetJointMotorEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         var joint:EntityJoint = valueSource.EvaluateValueObject () as EntityJoint;

         if (joint == null)
            return;

         valueSource = valueSource.mNextParameter;
         var enabled:Boolean = valueSource.EvaluateValueObject () as Boolean;

         joint.SetEnableMotor (enabled);
      }

      public static function SetJointLimitsEnabled (valueSource:Parameter, valueTarget:Parameter):void
      {
         var joint:EntityJoint = valueSource.EvaluateValueObject () as EntityJoint;

         if (joint == null)
            return;

         valueSource = valueSource.mNextParameter;
         var enabled:Boolean = valueSource.EvaluateValueObject () as Boolean;

         joint.SetEnableLimits (enabled);
      }

      public static function GetHingeAngleByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         var hinge:EntityJointHinge = valueSource.EvaluateValueObject () as EntityJointHinge;

         if (hinge == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (hinge.GetCurrentAngle () * Define.kRadians2Degrees);
         }
      }

      public static function GetHingeLimitsByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         var hinge:EntityJointHinge = valueSource.EvaluateValueObject () as EntityJointHinge;

         if (hinge == null)
         {
            valueTarget.AssignValueObject (0.0);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (hinge.GetLowerAngle () * Define.kRadians2Degrees);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (hinge.GetUpperAngle () * Define.kRadians2Degrees);
         }
      }

      public static function SetHingeLimitsByDegrees (valueSource:Parameter, valueTarget:Parameter):void
      {
         var hinge:EntityJointHinge = valueSource.EvaluateValueObject () as EntityJointHinge;
         if (hinge == null)
            return;

         valueSource = valueSource.mNextParameter;
         var lowerLimit:Number = Number (valueSource.EvaluateValueObject ()) * Define.kDegrees2Radians;

         valueSource = valueSource.mNextParameter;
         var upperLimit:Number = Number (valueSource.EvaluateValueObject ()) * Define.kDegrees2Radians;

         hinge.SetAngleLimits (lowerLimit, upperLimit);
      }

     public static function GetHingeMotorSpeed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var hinge:EntityJointHinge = valueSource.EvaluateValueObject () as EntityJointHinge;

         if (hinge == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (hinge.GetMotorSpeed () * Define.kRadians2Degrees);
         }
      }

      public static function SetHingeMotorSpeed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var hinge:EntityJointHinge = valueSource.EvaluateValueObject () as EntityJointHinge;
         if (hinge == null)
            return;

         valueSource = valueSource.mNextParameter;
         var motorSpeed:Number = Number (valueSource.EvaluateValueObject ()) * Define.kDegrees2Radians;

         hinge.SetMotorSpeed (motorSpeed);
      }

      public static function GetSliderTranslation (valueSource:Parameter, valueTarget:Parameter):void
      {
         var slider:EntityJointSlider = valueSource.EvaluateValueObject () as EntityJointSlider;

         if (slider == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (slider.GetCurrentTranslation ());
         }
      }

      public static function GetSliderLimits (valueSource:Parameter, valueTarget:Parameter):void
      {
         var slider:EntityJointSlider = valueSource.EvaluateValueObject () as EntityJointSlider;

         if (slider == null)
         {
            valueTarget.AssignValueObject (0.0);

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (slider.GetLowerTranslation ());

            valueTarget = valueTarget.mNextParameter;
            valueTarget.AssignValueObject (slider.GetUpperTranslation ());
         }
      }

      public static function SetSliderLimits (valueSource:Parameter, valueTarget:Parameter):void
      {
         var slider:EntityJointSlider = valueSource.EvaluateValueObject () as EntityJointSlider;
         if (slider == null)
            return;

         valueSource = valueSource.mNextParameter;
         var lowerLimit:Number = Number (valueSource.EvaluateValueObject ());

         valueSource = valueSource.mNextParameter;
         var upperLimit:Number = Number (valueSource.EvaluateValueObject ());

         slider.SetTranslationLimits (lowerLimit, upperLimit);
      }

      public static function GetSliderMotorSpeed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var slider:EntityJointSlider = valueSource.EvaluateValueObject () as EntityJointSlider;

         if (slider == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (slider.GetMotorSpeed ());
         }
      }

      public static function SetSliderMotorSpeed (valueSource:Parameter, valueTarget:Parameter):void
      {
         var slider:EntityJointSlider = valueSource.EvaluateValueObject () as EntityJointSlider;
         if (slider == null)
            return;

         valueSource = valueSource.mNextParameter;
         var motorSpeed:Number = Number (valueSource.EvaluateValueObject ());

         slider.SetMotorSpeed (motorSpeed);
      }

      // game / entity / event handler

      public static function ResetTimer (valueSource:Parameter, valueTarget:Parameter):void
      {
         var timer:EntityEventHandler_Timer = valueSource.EvaluateValueObject () as EntityEventHandler_Timer;
         if (timer == null)
            return;

         timer.Reset ();
      }

      public static function IsTimerPaused(valueSource:Parameter, valueTarget:Parameter):void
      {
         var timer:EntityEventHandler_Timer = valueSource.EvaluateValueObject () as EntityEventHandler_Timer;

         if (timer == null)
         {
            valueTarget.AssignValueObject (false);
         }
         else
         {
            valueTarget.AssignValueObject (timer.IsPaused ());
         }
      }

      public static function SetTimerPaused (valueSource:Parameter, valueTarget:Parameter):void
      {
         var timer:EntityEventHandler_Timer = valueSource.EvaluateValueObject () as EntityEventHandler_Timer;
         if (timer == null)
            return;

         valueSource = valueSource.mNextParameter;
         var paused:Boolean = Boolean (valueSource.EvaluateValueObject ());

         timer.SetPaused (paused);
      }

      public static function GetTimerInterval (valueSource:Parameter, valueTarget:Parameter):void
      {
         var timer:EntityEventHandler_Timer = valueSource.EvaluateValueObject () as EntityEventHandler_Timer;
         if (timer == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (timer.GetRunningInterval ());
         }
      }

      public static function SetTimerInterval (valueSource:Parameter, valueTarget:Parameter):void
      {
         var timer:EntityEventHandler_Timer = valueSource.EvaluateValueObject () as EntityEventHandler_Timer;
         if (timer == null)
            return;

         valueSource = valueSource.mNextParameter;
         var interval:Number = Number (valueSource.EvaluateValueObject ());

         timer.SetRunningInterval (interval);
      }

   }
}
