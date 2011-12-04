
package common.trigger {

   public class CoreFunctionIds
   {

   // the id < 8196 will be reserved for officeial core apis

      public static const ID_ForDebug:int                    = IdPool.CoreApiId_0; //

   // some specail

      public static const ID_Void:int                        = IdPool.CoreApiId_10; //
      public static const ID_Bool:int                        = IdPool.CoreApiId_11; //

      public static const ID_EntityFilter:int                = IdPool.CoreApiId_12; //
      public static const ID_EntityPairFilter:int            = IdPool.CoreApiId_13; //

   // global

      public static const ID_Return:int                       = IdPool.CoreApiId_20; //
      public static const ID_ReturnIfTrue:int                 = IdPool.CoreApiId_21; //
      public static const ID_ReturnIfFalse:int                = IdPool.CoreApiId_22; //
      public static const ID_Break:int                        = IdPool.CoreApiId_23; //
      public static const ID_Continue:int                     = IdPool.CoreApiId_28; // different with other breaks
      //public static const ID_GoTo:int                        = IdPool.CoreApiId_24; //
      public static const ID_Comment:int                     = IdPool.CoreApiId_25; //
      public static const ID_Blank:int                       = IdPool.CoreApiId_26; //
      public static const ID_Removed:int                       = IdPool.CoreApiId_27; //

      public static const ID_StartIf:int                      = IdPool.CoreApiId_30; //
      //public static const ID_ElseIf:int                     = IdPool.CoreApiId_31; //
      public static const ID_Else:int                       = IdPool.CoreApiId_32; //
      //public static const ID_BreakIf:int                       = IdPool.CoreApiId_; // different with other breaks
      public static const ID_EndIf:int                        = IdPool.CoreApiId_33; //
      public static const ID_StartSwitch:int                      = IdPool.CoreApiId_34; //
      //public static const ID_SwitchCase:int                     = IdPool.CoreApiId_35; //
      //public static const ID_SwitchDefault:int                  = IdPool.CoreApiId_36; //
      //public static const ID_BreakSwitch:int                        = IdPool.CoreApiId_; // different with other breaks
      public static const ID_EndSwitch:int                        = IdPool.CoreApiId_37; //
      public static const ID_StartWhile:int                   = IdPool.CoreApiId_38; //
      public static const ID_EndWhile:int                     = IdPool.CoreApiId_39; //
      //public static const ID_StartDoWhile:int                   = IdPool.CoreApiId_40; //
      //public static const ID_EndDoWhile:int                     = IdPool.CoreApiId_41; //

   // system

      public static const ID_GetProgramMilliseconds:int           = IdPool.CoreApiId_70; //
      public static const ID_GetCurrentDateTime:int               = IdPool.CoreApiId_71; //
      public static const ID_GetDay:int                           = IdPool.CoreApiId_73; //
      public static const ID_GetTimeZone:int                      = IdPool.CoreApiId_74; //
      public static const ID_IsKeyHold:int                        = IdPool.CoreApiId_72; //
      public static const ID_Design_IsMouseButtonHold:int                  = IdPool.CoreApiId_603;
      public static const ID_SetMouseVisible:int                        = IdPool.CoreApiId_75; // from v1.56

   // string

      public static const ID_String_Assign:int                    = IdPool.CoreApiId_120; //
      public static const ID_String_ConditionAssign:int           = IdPool.CoreApiId_122; //
      public static const ID_String_SwapValues:int                = IdPool.CoreApiId_126; //
      public static const ID_String_IsNull:int                    = IdPool.CoreApiId_127; //
      public static const ID_String_Equals:int                    = IdPool.CoreApiId_183; //
      public static const ID_String_Add:int                       = IdPool.CoreApiId_121; //
      public static const ID_String_GetLength:int                 = IdPool.CoreApiId_185; //
      public static const ID_String_GetCharAt:int                 = IdPool.CoreApiId_123; //
      public static const ID_String_GetCharCodeAt:int             = IdPool.CoreApiId_124; //
      public static const ID_String_CharCode2Char:int             = IdPool.CoreApiId_125; //
      public static const ID_String_ToLowerCase:int               = IdPool.CoreApiId_128; //
      public static const ID_String_ToUpperCase:int               = IdPool.CoreApiId_129; //
      public static const ID_String_IndexOf:int                   = IdPool.CoreApiId_130; // from v1.54
      public static const ID_String_LastIndexOf:int               = IdPool.CoreApiId_131; // from v1.54
      public static const ID_String_Substring:int                 = IdPool.CoreApiId_132; // from v1.54
      public static const ID_String_Split:int                     = IdPool.CoreApiId_133; // from v1.56

   // bool

      public static const ID_Bool_Assign :int                    = IdPool.CoreApiId_170; //
      public static const ID_Bool_ConditionAssign:int            = IdPool.CoreApiId_174; //
      public static const ID_Bool_SwapValues:int                 = IdPool.CoreApiId_175; //
      public static const ID_Boolean_ToString:int                = IdPool.CoreApiId_151; //
      public static const ID_Bool_EqualsBoolean:int              = IdPool.CoreApiId_181; //
      public static const ID_Bool_Invert :int                    = IdPool.CoreApiId_171; //
      public static const ID_Bool_IsTrue :int                    = IdPool.CoreApiId_172; //
      public static const ID_Bool_IsFalse:int                    = IdPool.CoreApiId_173; //

      public static const ID_Bool_And:int                        = IdPool.CoreApiId_230; //
      public static const ID_Bool_Or:int                         = IdPool.CoreApiId_231; //
      public static const ID_Bool_Not:int                        = IdPool.CoreApiId_232; //
      public static const ID_Bool_Xor:int                        = IdPool.CoreApiId_233; //

   // array

      public static const ID_Array_Assign:int                = IdPool.CoreApiId_80; // v1.54
      public static const ID_Array_ConditionAssign:int       = IdPool.CoreApiId_81; // v1.54
      public static const ID_Array_SwapValues:int            = IdPool.CoreApiId_82; // v1.54
      public static const ID_Array_Equals:int                = IdPool.CoreApiId_83; // v1.54
      public static const ID_Array_ToString:int                = IdPool.CoreApiId_101; // v1.56
      public static const ID_Array_Create:int                = IdPool.CoreApiId_84; // v1.54
      public static const ID_Array_IsNull:int                = IdPool.CoreApiId_85; // v1.54
      public static const ID_Array_GetLength:int                = IdPool.CoreApiId_86; // v1.54
      public static const ID_Array_SetLength:int                = IdPool.CoreApiId_99; // v1.54
      public static const ID_Array_RemoveElements:int                = IdPool.CoreApiId_100; // v1.54
      public static const ID_Array_InsertElements:int                = IdPool.CoreApiId_102; // v1.56
      public static const ID_Array_Concat:int                = IdPool.CoreApiId_79; // v1.57
      public static const ID_Array_SetElementWithBoolean:int     = IdPool.CoreApiId_87; // v1.54
      public static const ID_Array_GetElementAsBoolean:int       = IdPool.CoreApiId_88; // v1.54
      public static const ID_Array_SetElementWithNumber:int      = IdPool.CoreApiId_89; // v1.54
      public static const ID_Array_GetElementAsNumber:int        = IdPool.CoreApiId_90; // v1.54
      public static const ID_Array_SetElementWithString:int      = IdPool.CoreApiId_91; // v1.54
      public static const ID_Array_GetElementAsString:int        = IdPool.CoreApiId_92; // v1.54
      public static const ID_Array_SetElementWithCCat:int        = IdPool.CoreApiId_93; // v1.54
      public static const ID_Array_GetElementAsCCat:int          = IdPool.CoreApiId_94; // v1.54
      public static const ID_Array_SetElementWithEntity:int      = IdPool.CoreApiId_95; // v1.54
      public static const ID_Array_GetElementAsEntity:int        = IdPool.CoreApiId_96; // v1.54
      public static const ID_Array_SetElementWithArray:int       = IdPool.CoreApiId_97; // v1.54
      public static const ID_Array_GetElementAsArray:int         = IdPool.CoreApiId_98; // v1.54

   // math basic op

      public static const ID_Number_Assign:int                      = IdPool.CoreApiId_300; //
      public static const ID_Number_Negative:int                    = IdPool.CoreApiId_301; //
      public static const ID_Number_ConditionAssign:int             = IdPool.CoreApiId_302; //
      public static const ID_Number_SwapValues:int                  = IdPool.CoreApiId_299; //
      public static const ID_Number_Equals:int                      = IdPool.CoreApiId_180; //
      public static const ID_Number_LargerThan:int                  = IdPool.CoreApiId_210; //
      public static const ID_Number_LessThan:int                    = IdPool.CoreApiId_211; //
      public static const ID_Number_IsNaN:int                       = IdPool.CoreApiId_303; //
      public static const ID_Number_IsInfinity :int                   = IdPool.CoreApiId_304; //

      public static const ID_Number_Add:int                         = IdPool.CoreApiId_306; //
      public static const ID_Number_Subtract:int                    = IdPool.CoreApiId_307; //
      public static const ID_Number_Multiply:int                    = IdPool.CoreApiId_308; //
      public static const ID_Number_Divide:int                      = IdPool.CoreApiId_309; //
      public static const ID_Number_Modulo:int                      = IdPool.CoreApiId_310; //

   // math / toString

      public static const ID_Number_ToString:int                    = IdPool.CoreApiId_150; //
      public static const ID_Number_ToExponential:int               = IdPool.CoreApiId_311; //
      public static const ID_Number_ToFixed:int                     = IdPool.CoreApiId_312; //
      public static const ID_Number_ToPrecision:int                 = IdPool.CoreApiId_313; //
      public static const ID_Number_ToStringByRadix:int             = IdPool.CoreApiId_314; //
      public static const ID_Number_ParseFloat:int                  = IdPool.CoreApiId_297; //
      public static const ID_Number_ParseInteger:int                = IdPool.CoreApiId_298; //

   // math / bitwise

      public static const ID_Bitwise_ShiftLeft :int               = IdPool.CoreApiId_315; //
      public static const ID_Bitwise_ShiftRight :int              = IdPool.CoreApiId_316; //
      public static const ID_Bitwise_ShiftRightUnsigned :int      = IdPool.CoreApiId_317; //
      public static const ID_Bitwise_And :int                     = IdPool.CoreApiId_318; //
      public static const ID_Bitwise_Or :int                      = IdPool.CoreApiId_319; //
      public static const ID_Bitwise_Not :int                     = IdPool.CoreApiId_320; //
      public static const ID_Bitwise_Xor :int                     = IdPool.CoreApiId_321; //

  // math / trigonometry

      public static const ID_Number_SinRadians:int                  = IdPool.CoreApiId_350; //
      public static const ID_Number_CosRadians:int                  = IdPool.CoreApiId_351; //
      public static const ID_Number_TanRadians:int                  = IdPool.CoreApiId_352; //
      public static const ID_Number_ArcSinRadians:int               = IdPool.CoreApiId_353; //
      public static const ID_Number_ArcCosRadians:int               = IdPool.CoreApiId_354; //
      public static const ID_Number_ArcTanRadians:int               = IdPool.CoreApiId_355; //
      public static const ID_Number_ArcTan2Radians:int              = IdPool.CoreApiId_356; //

  // math / random

      public static const ID_Number_Random:int                      = IdPool.CoreApiId_380; //
      public static const ID_Number_RandomRange:int                 = IdPool.CoreApiId_381; //
      public static const ID_Number_RandomIntRange:int              = IdPool.CoreApiId_382; //

      public static const ID_Number_RngCreate:int                      = IdPool.CoreApiId_383; //
      public static const ID_Number_RngSetSeed:int                     = IdPool.CoreApiId_384; //
      public static const ID_Number_RngRandom:int                      = IdPool.CoreApiId_385; //
      public static const ID_Number_RngRandomRange:int                 = IdPool.CoreApiId_386; //
      public static const ID_Number_RngRandomIntRange:int              = IdPool.CoreApiId_387; //

   // math number convert

      public static const ID_Number_Degrees2Radians:int            = IdPool.CoreApiId_400; //
      public static const ID_Number_Radians2Degrees:int            = IdPool.CoreApiId_401; //
      public static const ID_Number_Number2RGB:int                 = IdPool.CoreApiId_402; //
      public static const ID_Number_RGB2Number:int                 = IdPool.CoreApiId_403; //
      public static const ID_MillisecondsToMinutesSeconds:int    = IdPool.CoreApiId_404; //
      //public static const ID_MillisecondsToMinutesSeconds:int    = IdPool.CoreApiId_405; //

   // math more ...

      public static const ID_Number_Max:int                         = IdPool.CoreApiId_500; //
      public static const ID_Number_Min:int                         = IdPool.CoreApiId_501; //

      public static const ID_Number_Inverse:int                     = IdPool.CoreApiId_510; //
      public static const ID_Number_Abs:int                         = IdPool.CoreApiId_511; //
      public static const ID_Number_Sqrt:int                        = IdPool.CoreApiId_512; //
      public static const ID_Number_Ceil:int                        = IdPool.CoreApiId_513; //
      public static const ID_Number_Floor:int                       = IdPool.CoreApiId_514; //
      public static const ID_Number_Round:int                       = IdPool.CoreApiId_515; //
      public static const ID_Number_Log:int                         = IdPool.CoreApiId_516; //
      public static const ID_Number_Exp:int                         = IdPool.CoreApiId_517; //
      public static const ID_Number_Power:int                       = IdPool.CoreApiId_518; //
      public static const ID_Number_Clamp:int                       = IdPool.CoreApiId_519; //

      public static const Id_Math_LinearInterpolation:int                  = IdPool.CoreApiId_530; //
      public static const Id_Math_LinearInterpolationColor:int             = IdPool.CoreApiId_531; //


   // game / design

      public static const ID_Design_RestartLevel:int                     = IdPool.CoreApiId_593;
      public static const ID_Design_IsLevelPaused:int                    = IdPool.CoreApiId_594;
      public static const ID_Design_SetLevelPaused:int                   = IdPool.CoreApiId_595;
      public static const ID_Design_GetPlaySpeedX:int                    = IdPool.CoreApiId_596;
      public static const ID_Design_SetPlaySpeedX:int                    = IdPool.CoreApiId_597;
      public static const ID_Design_GetWorldScale:int                    = IdPool.CoreApiId_598;
      public static const ID_Design_SetWorldScale:int                    = IdPool.CoreApiId_599;

      public static const ID_Design_GetLevelMilliseconds:int                    = IdPool.CoreApiId_600;
      public static const ID_Design_GetLevelSteps:int                           = IdPool.CoreApiId_601;
      public static const ID_Design_GetMousePosition:int                        = IdPool.CoreApiId_602;

      public static const ID_Design_SetLevelStatus:int                           = IdPool.CoreApiId_609;
      public static const ID_Design_IsLevelSuccessed:int                         = IdPool.CoreApiId_610;
      public static const ID_Design_IsLevelFailed:int                            = IdPool.CoreApiId_612;
      public static const ID_Design_IsLevelUnfinished:int                        = IdPool.CoreApiId_614;

   // game / world

      public static const ID_World_SetGravityAcceleration_Radians:int       = IdPool.CoreApiId_710;
      public static const ID_World_SetGravityAcceleration_Degrees:int       = IdPool.CoreApiId_711;
      public static const ID_World_SetGravityAcceleration_Vector:int        = IdPool.CoreApiId_712;
      public static const ID_World_GetGravityAcceleration_Vector:int        = IdPool.CoreApiId_713;

      public static const ID_World_SetCurrentCamera:int                               = IdPool.CoreApiId_717;
      public static const ID_World_GetCameraCenter:int                               = IdPool.CoreApiId_719;
      public static const ID_World_GetCameraRotationByDegrees:int                    = IdPool.CoreApiId_718;
      public static const ID_World_FollowCameraWithShape:int                         = IdPool.CoreApiId_720;
      public static const ID_World_FollowCameraCenterXWithShape:int                  = IdPool.CoreApiId_721;
      public static const ID_World_FollowCameraCenterYWithShape:int                  = IdPool.CoreApiId_722;
      public static const ID_World_FollowCameraRotationWithShape:int               = IdPool.CoreApiId_723;
      public static const ID_World_CameraFadeOutThenFadeIn:int                       = IdPool.CoreApiId_725;
      //public static const ID_World_CameraFadeOut:int
      //public static const ID_World_CameraFadeIn:int
      //public static const ID_World_CameraCloseThenOpen:int

      public static const ID_World_CallScript:int                               = IdPool.CoreApiId_750;
      public static const ID_World_ConditionCallScript:int                      = IdPool.CoreApiId_751;
      public static const ID_World_CallBoolFunction:int                         = IdPool.CoreApiId_752;
      public static const ID_World_ConditionCallBoolFunction:int                = IdPool.CoreApiId_753;
      public static const ID_World_CallScriptMultiTimes:int                   = IdPool.CoreApiId_754;
      public static const ID_World_CallBoolFunctionMultiTimes:int             = IdPool.CoreApiId_755;

      public static const ID_World_CreateExplosion:int                = IdPool.CoreApiId_770;

      public static const ID_World_StopAllSounds:int            = IdPool.CoreApiId_800;
      public static const ID_World_PlaySound:int                = IdPool.CoreApiId_801;

      // VirtualClickOnEntityCenter (entity)

   // game / collision category

      public static const ID_CCat_Assign:int                              = IdPool.CoreApiId_850; // CCat
      public static const ID_CCat_ConditionAssign:int                     = IdPool.CoreApiId_853; // CCat
      public static const ID_CCat_SwapValues:int                          = IdPool.CoreApiId_855;
      public static const ID_CCat_IsNull:int                              = IdPool.CoreApiId_856;
      public static const ID_CCat_Equals:int                              = IdPool.CoreApiId_184; //
      public static const ID_CCat_ToString:int                            = IdPool.CoreApiId_153; //
      public static const ID_CCat_SetCollideInternally:int                = IdPool.CoreApiId_851; // CCat
      public static const ID_CCat_SetAsFriends:int                        = IdPool.CoreApiId_852; // CCat

   // game / entity

      public static const ID_Entity_Assign:int                         = IdPool.CoreApiId_900;
      public static const ID_Entity_ConditionAssign:int                = IdPool.CoreApiId_901;
      public static const ID_Entity_SwapValues:int                     = IdPool.CoreApiId_903;
      public static const ID_Entity_IsNull:int                         = IdPool.CoreApiId_904;
      public static const ID_Entity_GetEntityId:int                    = IdPool.CoreApiId_905;
      public static const ID_Entity_GetEntityByIdOffset:int            = IdPool.CoreApiId_902;
      public static const ID_Entity_ToString:int                       = IdPool.CoreApiId_152; //
      public static const ID_Entity_Equals:int                         = IdPool.CoreApiId_182; //

      public static const ID_Entity_IsTaskSuccessed:int                = IdPool.CoreApiId_910;
      public static const ID_Entity_IsTaskFailed:int                   = IdPool.CoreApiId_912;
      public static const ID_Entity_IsTaskUnfinished:int               = IdPool.CoreApiId_914;
      public static const ID_Entity_SetTaskStatus:int                  = IdPool.CoreApiId_916;

      public static const ID_Entity_IsShapeEntity:int                  = IdPool.CoreApiId_960;
      public static const ID_Entity_IsJointEntity:int                  = IdPool.CoreApiId_961;
      public static const ID_Entity_IsTriggerEntity:int                = IdPool.CoreApiId_962;

      public static const ID_Entity_IsVisible:int                      = IdPool.CoreApiId_980;
      public static const ID_Entity_SetVisible:int                     = IdPool.CoreApiId_981;
      public static const ID_Entity_GetAlpha:int                       = IdPool.CoreApiId_982;
      public static const ID_Entity_SetAlpha:int                       = IdPool.CoreApiId_983;

      public static const ID_Entity_AdjustAppearanceOrder:int                       = IdPool.CoreApiId_986;
      public static const ID_Entity_AdjustAppearanceOrderRelativeTo:int             = IdPool.CoreApiId_987;

      public static const ID_Entity_IsEnabled:int                      = IdPool.CoreApiId_984;
      public static const ID_Entity_SetEnabled:int                     = IdPool.CoreApiId_985;

      public static const ID_Entity_GetPosition:int                    = IdPool.CoreApiId_1001;
      //public static const ID_Entity_SetPosition:int                    = IdPool.CoreApiId_1002;
      //public static const ID_Entity_GetLocalPosition:int               = IdPool.CoreApiId_1003;
      //public static const ID_Entity_SetLocalPosition:int              = IdPool.CoreApiId_1004;
      public static const ID_Entity_GetRotationByRadians:int            = IdPool.CoreApiId_1005;
      //public static const ID_Entity_SetRotationByRadians:int          = IdPool.CoreApiId_1006;
      public static const ID_Entity_GetRotationByDegrees:int            = IdPool.CoreApiId_1007;
      //public static const ID_Entity_SetRotationByDegrees:int          = IdPool.CoreApiId_1008;
      public static const ID_Entity_GetAccumulatedRotationByRadians:int = IdPool.CoreApiId_1009;
      public static const ID_Entity_WorldPoint2LocalPoint:int           = IdPool.CoreApiId_1010;
      public static const ID_Entity_LocalPoint2WorldPoint:int           = IdPool.CoreApiId_1011;
      public static const ID_Entity_WorldVector2LocalVector:int         = IdPool.CoreApiId_1012;
      public static const ID_Entity_LocalVector2WorldVector:int         = IdPool.CoreApiId_1013;
      public static const ID_Entity_IsFlipped:int         = IdPool.CoreApiId_1126;
      public static const ID_Entity_GetScale:int         = IdPool.CoreApiId_1127;

      public static const ID_Entity_IsDestroyed:int                    = IdPool.CoreApiId_1049;
      public static const ID_Entity_Destroy:int                        = IdPool.CoreApiId_1050;

      public static const ID_Entity_Coincided:int                     = IdPool.CoreApiId_1060;

   // game / entity / shape

      public static const ID_EntityShape_Clone:int                      = IdPool.CoreApiId_1070;

      public static const ID_EntityShape_GetOriginalCIType:int            = IdPool.CoreApiId_1098;
      public static const ID_EntityShape_SetOriginalCIType:int            = IdPool.CoreApiId_1099;
      public static const ID_EntityShape_GetCIType:int                    = IdPool.CoreApiId_1100;
      public static const ID_EntityShape_SetCIType:int                    = IdPool.CoreApiId_1101;

      public static const ID_EntityShape_GetFilledColor:int            = IdPool.CoreApiId_1110;
      public static const ID_EntityShape_SetFilledColor:int            = IdPool.CoreApiId_1111;
      public static const ID_EntityShape_GetFilledColorRGB:int         = IdPool.CoreApiId_1112;
      public static const ID_EntityShape_SetFilledColorRGB:int         = IdPool.CoreApiId_1113;
      public static const ID_EntityShape_GetFilledOpacity:int          = IdPool.CoreApiId_1114; // v1.54
      public static const ID_EntityShape_SetFilledOpacity:int          = IdPool.CoreApiId_1115; // v1.54
      //public static const ID_EntityShape_IsShowBorder:int              = IdPool.CoreApiId_1116;
      //public static const ID_EntityShape_SetShowBorder:int             = IdPool.CoreApiId_1117;
      //public static const ID_EntityShape_GetBorderThickness:int        = IdPool.CoreApiId_1118;
      //public static const ID_EntityShape_SetBorderThickness:int        = IdPool.CoreApiId_1119;
      public static const ID_EntityShape_GetBorderColor:int            = IdPool.CoreApiId_1120; // v1.54
      public static const ID_EntityShape_SetBorderColor:int            = IdPool.CoreApiId_1121; // v1.54
      public static const ID_EntityShape_GetBorderColorRGB:int         = IdPool.CoreApiId_1122; // v1.54
      public static const ID_EntityShape_SetBorderColorRGB:int         = IdPool.CoreApiId_1123; // v1.54
      public static const ID_EntityShape_GetBorderOpacity:int          = IdPool.CoreApiId_1124; // v1.54
      public static const ID_EntityShape_SetBorderOpacity:int          = IdPool.CoreApiId_1125; // v1.54



      public static const ID_EntityShape_IsPhysicsEnabled:int          = IdPool.CoreApiId_1150;
      //public static const ID_EntityShape_SetPhysicsEnabled:int       = IdPool.CoreApiId_1151;
      public static const ID_EntityShape_IsStatic:int                  = IdPool.CoreApiId_1155; // from v1.54
      //public static const ID_EntityShape_SetStatic:int                 = IdPool.CoreApiId_1156;
      public static const ID_EntityShape_GetCollisionCategory:int      = IdPool.CoreApiId_1152;
      public static const ID_EntityShape_SetCollisionCategory:int      = IdPool.CoreApiId_1153;
      //public static const ID_EntityShape_SetPhysicsEnabled:int       = IdPool.CoreApiId_1154;
      public static const ID_EntityShape_IsSensor:int                  = IdPool.CoreApiId_1157;
      public static const ID_EntityShape_SetAsSensor:int               = IdPool.CoreApiId_1158;
      public static const ID_EntityShape_IsRotationFixed:int                  = IdPool.CoreApiId_1163;
      public static const ID_EntityShape_SetRotationFixed:int               = IdPool.CoreApiId_1164;
      //public static const ID_EntityShape_IsBullet:int                  = IdPool.CoreApiId_1159;
      //public static const ID_EntityShape_SetAsBullet:int               = IdPool.CoreApiId_1160;
      public static const ID_EntityShape_IsSleeping:int                  = IdPool.CoreApiId_1161;
      public static const ID_EntityShape_SetSleeping:int                 = IdPool.CoreApiId_1162;

      public static const ID_EntityShape_GetLocalCentroid:int          = IdPool.CoreApiId_1071;
      public static const ID_EntityShape_GetWorldCentroid:int          = IdPool.CoreApiId_1072;
      //public static const ID_EntityShape_AutoSetMassInertia:int        = IdPool.CoreApiId_1073;

      public static const ID_EntityShape_GetMass:int                     = IdPool.CoreApiId_1130;
      //public static const ID_EntityShape_SetMass:int                     = IdPool.CoreApiId_1131;
      public static const ID_EntityShape_GetInertia:int                  = IdPool.CoreApiId_1132;
      //public static const ID_EntityShape_SetInertia:int                  = IdPool.CoreApiId_1133;
      public static const ID_EntityShape_GetDensity:int                  = IdPool.CoreApiId_1134;
      public static const ID_EntityShape_SetDensity:int                  = IdPool.CoreApiId_1135;
      //public static const ID_EntityShape_GetFriction:int                 = IdPool.CoreApiId_1136;
      //public static const ID_EntityShape_SetFriction:int                 = IdPool.CoreApiId_1137;
      //public static const ID_EntityShape_GetRestitution:int              = IdPool.CoreApiId_1138;
      //public static const ID_EntityShape_SetRestitution:int              = IdPool.CoreApiId_1139;

      public static const ID_EntityShape_SetLinearVelocity:int                          = IdPool.CoreApiId_1095;
      public static const ID_EntityShape_GetLinearVelocity:int                          = IdPool.CoreApiId_1096;
      public static const ID_EntityShape_ApplyLinearImpulseByVelocityVector:int         = IdPool.CoreApiId_1097;
      public static const ID_EntityShape_SetAngularVelocityByRadians:int               = IdPool.CoreApiId_1089; // from v1.54
      public static const ID_EntityShape_SetAngularVelocityByDegrees:int               = IdPool.CoreApiId_1090; // from v1.54
      public static const ID_EntityShape_GetAngularVelocityByRadians:int              = IdPool.CoreApiId_1091; // from v1.54
      public static const ID_EntityShape_GetAngularVelocityByDegrees:int              = IdPool.CoreApiId_1092; // from v1.54
      public static const ID_EntityShape_ChangeAngularVelocityByRadians:int           = IdPool.CoreApiId_1093; // from v1.54
      public static const ID_EntityShape_ChangeAngularVelocityByDegrees:int           = IdPool.CoreApiId_1094; // from v1.54

      public static const ID_EntityShape_ApplyStepForce:int                                   = IdPool.CoreApiId_1104;
      public static const ID_EntityShape_ApplyStepForceAtLocalPoint:int                       = IdPool.CoreApiId_1105;
      public static const ID_EntityShape_ApplyStepForceAtWorldPoint:int                       = IdPool.CoreApiId_1106;
      public static const ID_EntityShape_ApplyStepTorque:int                                  = IdPool.CoreApiId_1107;

      public static const ID_EntityShape_ApplyLinearImpulse:int                               = IdPool.CoreApiId_1102;
      public static const ID_EntityShape_ApplyLinearImpulseAtLocalPoint:int                   = IdPool.CoreApiId_1103;
      public static const ID_EntityShape_ApplyLinearImpulseAtWorldPoint:int                   = IdPool.CoreApiId_1108;
      public static const ID_EntityShape_ApplyAngularImpulse:int                              = IdPool.CoreApiId_1109;

      public static const ID_EntityShape_GetPhysicsOnesAtPoint:int            = IdPool.CoreApiId_1251;
      public static const ID_EntityShape_Teleport:int                         = IdPool.CoreApiId_1252;
      public static const ID_EntityShape_TeleportOffsets:int                  = IdPool.CoreApiId_1253;

      public static const ID_EntityShape_Translate:int                    = IdPool.CoreApiId_1220;
      public static const ID_EntityShape_TranslateTo:int                  = IdPool.CoreApiId_1221;
      //public static const ID_EntityShape_Rotate:int                    = IdPool.CoreApiId_1222;
      //public static const ID_EntityShape_RotateTo:int                  = IdPool.CoreApiId_1223;
      public static const ID_EntityShape_RotateAroundWorldPoint:int         = IdPool.CoreApiId_1224;
      public static const ID_EntityShape_RotateToAroundWorldPoint:int         = IdPool.CoreApiId_1225;
      //public static const ID_EntityShape_Scale:int                     = IdPool.CoreApiId_1226;
      public static const ID_EntityShape_ScaleWithFixedPoint:int                     = IdPool.CoreApiId_1227;
      //public static const ID_EntityShape_ScaleAlongAxis:int                     = IdPool.CoreApiId_1228;
      //public static const ID_EntityShape_FlipByLocalLinePoint:int           = IdPool.CoreApiId_1229;
      public static const ID_EntityShape_FlipByWorldLinePoint:int           = IdPool.CoreApiId_1230;
      public static const ID_EntityShape_FlipSelf:int           = IdPool.CoreApiId_1231;

      public static const ID_EntityShape_GetBrothers:int                    = IdPool.CoreApiId_1258;
      public static const ID_EntityShape_IsAttchedWith:int                  = IdPool.CoreApiId_1259;
      public static const ID_EntityShape_Detach:int                         = IdPool.CoreApiId_1260;
      public static const ID_EntityShape_AttachWith:int                     = IdPool.CoreApiId_1261;
      public static const ID_EntityShape_DetachThenAttachWith:int           = IdPool.CoreApiId_1262;
      public static const ID_EntityShape_BreakupBrothers:int                = IdPool.CoreApiId_1263;
      public static const ID_EntityShape_DestroyBrothers:int                = IdPool.CoreApiId_1264;

      //public static const ID_EntityShape_GetAllJoints:int                  = IdPool.CoreApiId_1281;
      public static const ID_EntityShape_BreakAllJoints:int                  = IdPool.CoreApiId_1280;
      public static const ID_EntityShape_GetAllSisters:int                   = IdPool.CoreApiId_1282;
      //public static const ID_EntityShape_BreakupSister:int                   = IdPool.CoreApiId_1283;
      public static const ID_EntityShape_IsConnectedWith:int                 = IdPool.CoreApiId_1284;
      public static const ID_EntityShape_IsConnectedWithGround:int           = IdPool.CoreApiId_1285;

      public static const ID_EntityShape_GetAllContactedShapes:int          = IdPool.CoreApiId_1290;
      public static const ID_EntityShape_IsContactedWith:int                = IdPool.CoreApiId_1291;

   // game / shape / is a

      public static const ID_Entity_IsCircleShapeEntity:int            = IdPool.CoreApiId_1400;
      public static const ID_Entity_IsRectangleShapeEntity:int         = IdPool.CoreApiId_1401;
      public static const ID_Entity_IsPolygonShapeEntity:int           = IdPool.CoreApiId_1402;
      public static const ID_Entity_IsPolylineShapeEntity:int          = IdPool.CoreApiId_1403;
      public static const ID_Entity_IsBombShapeEntity:int             = IdPool.CoreApiId_1404;
      public static const ID_Entity_IsWorldBorderShapeEntity:int      = IdPool.CoreApiId_1405;


   // game / entity / shape / text

      public static const ID_EntityText_GetText:int                   = IdPool.CoreApiId_1550;
      public static const ID_EntityText_SetText:int                   = IdPool.CoreApiId_1551;
      public static const ID_EntityText_AppendText:int                = IdPool.CoreApiId_1552;
      public static const ID_EntityText_AppendNewLine:int             = IdPool.CoreApiId_1553;
      public static const ID_EntityText_SetSize:int                   = IdPool.CoreApiId_1570;
      public static const ID_EntityText_SetColor:int                  = IdPool.CoreApiId_1571;
      public static const ID_EntityText_SetColorByRGB:int             = IdPool.CoreApiId_1572;

   // game / entity / shape / circle

      public static const ID_EntityShapeCircle_GetRadius:int                   = IdPool.CoreApiId_1554;
      public static const ID_EntityShapeCircle_SetRadius:int                   = IdPool.CoreApiId_1555;

   // game / entity / shape / rectangle

      public static const ID_EntityShapeRectangle_GetSize:int                   = IdPool.CoreApiId_1556;
      public static const ID_EntityShapeRectangle_SetSize:int                   = IdPool.CoreApiId_1557;

   // game /entity / shape / poly

      public static const ID_EntityShapePoly_GetVertexCount:int                          = IdPool.CoreApiId_1558;
      public static const ID_EntityShapePoly_GetVertexLocalPosition:int                  = IdPool.CoreApiId_1559;
      //public static const ID_EntityShapePoly_SetVertexLocalPosition:int                 = IdPool.CoreApiId_1560;
      public static const ID_EntityShapePoly_GetVertexWorldPosition:int                  = IdPool.CoreApiId_1561;
      //public static const ID_EntityShapePoly_SetVertexWorldPosition:int                 = IdPool.CoreApiId_1562;
      //public static const ID_EntityShapePoly_InsertVertexByLocalPosition:int                     = IdPool.CoreApiId_1563;
      //public static const ID_EntityShapePoly_InsertVertexByWorldPosition:int                     = IdPool.CoreApiId_1564;
      //public static const ID_EntityShapePoly_DeleteVertexAt:int                     = IdPool.CoreApiId_1565;
      public static const ID_EntityShapePoly_GetVertexLocalPositions:int                     = IdPool.CoreApiId_1566;
      public static const ID_EntityShapePoly_SetVertexLocalPositions:int                     = IdPool.CoreApiId_1567;
      public static const ID_EntityShapePoly_GetVertexWorldPositions:int                     = IdPool.CoreApiId_1568;
      public static const ID_EntityShapePoly_SetVertexWorldPositions:int                     = IdPool.CoreApiId_1569;

   // game /entity / shape / module

      public static const ID_EntityShapeModule_ChangeModule:int                          = IdPool.CoreApiId_1581;

   // game / entity / joint

      // from 2000

      public static const ID_EntityJoint_SetJointMotorEnabled:int                   = IdPool.CoreApiId_1990;
      public static const ID_EntityJoint_SetJointLimitsEnabled:int                  = IdPool.CoreApiId_1991;

      public static const ID_EntityJoint_GetHingeAngleByDegrees:int                 = IdPool.CoreApiId_2008;
      public static const ID_EntityJoint_GetHingeLimitsByDegrees:int                 = IdPool.CoreApiId_2000;
      public static const ID_EntityJoint_SetHingeLimitsByDegrees:int                 = IdPool.CoreApiId_2004;
      //public static const ID_EntityJoint_GetHingeAngleByRadians:int                 = IdPool.CoreApiId_2009;
      //public static const ID_EntityJoint_GetHingeLimitsByRadians:int                 = IdPool.CoreApiId_2001;
      //public static const ID_EntityJoint_SetHingeAngleLimitsByRadians:int            = IdPool.CoreApiId_2005;
      public static const ID_EntityJoint_GetHingeMotorSpeed:int                      = IdPool.CoreApiId_2006;
      public static const ID_EntityJoint_SetHingeMotorSpeed:int                      = IdPool.CoreApiId_2007;

      public static const ID_EntityJoint_GetSliderTranslation:int                 = IdPool.CoreApiId_2034;
      public static const ID_EntityJoint_GetSliderLimits:int                      = IdPool.CoreApiId_2030;
      public static const ID_EntityJoint_SetSliderLimits:int                      = IdPool.CoreApiId_2032;
      public static const ID_EntityJoint_GetSliderMotorSpeed:int                  = IdPool.CoreApiId_2031;
      public static const ID_EntityJoint_SetSliderMotorSpeed:int                  = IdPool.CoreApiId_2033;

   // game / entity / field

      // from 2200

   // game / entity / event handler

      //public static const ID_EntityTrigger_GetTimerTicks:int                       = IdPool.CoreApiId_2500;
      public static const ID_EntityTrigger_ResetTimer:int                          = IdPool.CoreApiId_2501;
      public static const ID_EntityTrigger_IsTimerPaused:int                       = IdPool.CoreApiId_2502;
      public static const ID_EntityTrigger_SetTimerPaused:int                      = IdPool.CoreApiId_2503;
      public static const ID_EntityTrigger_GetTimerInterval:int                    = IdPool.CoreApiId_2504; // v1.54
      public static const ID_EntityTrigger_SetTimerInterval:int                    = IdPool.CoreApiId_2505; // v1.54

   }
}
