
package common.trigger {
   
   public class CoreFunctionIds
   {
      public static function IsReturnCalling (id:int):Boolean
      {
         return  id == ID_Return
              || id == ID_ReturnIfTrue
              || id == ID_ReturnIfFalse
            ;
      }
      
      
   // the id < 8196 will be reserved for officeial core apis
      
      public static const ID_ForDebug:int                    = IdPool.CoreApiId_0; // 
      
   // some specail
      
      public static const ID_Void:int                        = IdPool.CoreApiId_10; // 
      public static const ID_Bool:int                        = IdPool.CoreApiId_11; // 
      
   // global
      
      public static const ID_Return:int                       = IdPool.CoreApiId_20; //
      public static const ID_ReturnIfTrue:int                 = IdPool.CoreApiId_21; //
      public static const ID_ReturnIfFalse:int                = IdPool.CoreApiId_22; //
      
   // system
      
      public static const ID_GetProgramMilliseconds:int           = IdPool.CoreApiId_70; //
      public static const ID_GetCurrentDateTime:int               = IdPool.CoreApiId_71; //
      public static const ID_IsKeyHold:int                        = IdPool.CoreApiId_72; //
      
   // string
      
      public static const ID_String_Assign:int                    = IdPool.CoreApiId_120; // 
      public static const ID_String_Add:int                       = IdPool.CoreApiId_121; // to exchange with 122
      public static const ID_String_ConditionAssign:int           = IdPool.CoreApiId_122; //
      
      public static const ID_String_NumberToString:int            = IdPool.CoreApiId_150; // 
      public static const ID_String_BooleanToString:int           = IdPool.CoreApiId_151; // 
      public static const ID_String_EntityToString:int            = IdPool.CoreApiId_152; // 
      public static const ID_String_CollisionCategoryToString:int = IdPool.CoreApiId_153; // 
      
   // bool
      
      public static const ID_Bool_Assign :int                    = IdPool.CoreApiId_170; // 
      public static const ID_Bool_Invert :int                    = IdPool.CoreApiId_171; // 
      public static const ID_Bool_IsTrue :int                    = IdPool.CoreApiId_172; // 
      public static const ID_Bool_IsFalse:int                    = IdPool.CoreApiId_173; // 
      public static const ID_Bool_ConditionAssign:int            = IdPool.CoreApiId_174; // // to put after ID_Bool_Assign
      
      public static const ID_Bool_EqualsNumber:int               = IdPool.CoreApiId_180; // 
      public static const ID_Bool_EqualsBoolean:int              = IdPool.CoreApiId_181; // 
      public static const ID_Bool_EqualsEntity:int               = IdPool.CoreApiId_182; // 
      public static const ID_Bool_EqualsString:int               = IdPool.CoreApiId_183; // 
      public static const ID_Bool_EqualsCCat:int                 = IdPool.CoreApiId_184; // 
      
      public static const ID_Bool_Larger:int                     = IdPool.CoreApiId_210; // 
      public static const ID_Bool_Less:int                       = IdPool.CoreApiId_211; // 
      
      public static const ID_Bool_And:int                        = IdPool.CoreApiId_230; // 
      public static const ID_Bool_Or:int                         = IdPool.CoreApiId_231; // 
      public static const ID_Bool_Not:int                        = IdPool.CoreApiId_232; // 
      public static const ID_Bool_Xor:int                        = IdPool.CoreApiId_233; // 
      
   // math basic op 
      
      public static const ID_Math_Assign:int                      = IdPool.CoreApiId_300; // 
      public static const ID_Math_Negative:int                    = IdPool.CoreApiId_301; // 
      public static const ID_Math_ConditionAssign:int             = IdPool.CoreApiId_302; //
      
      
      public static const ID_Math_Add:int                         = IdPool.CoreApiId_306; // 
      public static const ID_Math_Subtract:int                    = IdPool.CoreApiId_307; // 
      public static const ID_Math_Multiply:int                    = IdPool.CoreApiId_308; // 
      public static const ID_Math_Divide:int                      = IdPool.CoreApiId_309; // 
      public static const ID_Math_Modulo:int                      = IdPool.CoreApiId_310; // 
      
   // math / bitwise 
      
      public static const ID_Bitwise_ShiftLeft :int               = IdPool.CoreApiId_315; // 
      public static const ID_Bitwise_ShiftRight :int              = IdPool.CoreApiId_316; // 
      public static const ID_Bitwise_ShiftRightUnsigned :int      = IdPool.CoreApiId_317; // 
      public static const ID_Bitwise_And :int                     = IdPool.CoreApiId_318; // 
      public static const ID_Bitwise_Or :int                      = IdPool.CoreApiId_319; // 
      public static const ID_Bitwise_Not :int                     = IdPool.CoreApiId_320; // 
      public static const ID_Bitwise_Xor :int                     = IdPool.CoreApiId_321; // 
      
  // math / trigonometry
      
      public static const ID_Math_SinRadians:int                  = IdPool.CoreApiId_350; // 
      public static const ID_Math_CosRadians:int                  = IdPool.CoreApiId_351; // 
      public static const ID_Math_TanRadians:int                  = IdPool.CoreApiId_352; // 
      public static const ID_Math_ArcSinRadians:int               = IdPool.CoreApiId_353; // 
      public static const ID_Math_ArcCosRadians:int               = IdPool.CoreApiId_354; // 
      public static const ID_Math_ArcTanRadians:int               = IdPool.CoreApiId_355; // 
      public static const ID_Math_ArcTan2Radians:int              = IdPool.CoreApiId_356; // 
      
  // math / random
      
      public static const ID_Math_Random:int                      = IdPool.CoreApiId_380; // 
      public static const ID_Math_RandomRange:int                 = IdPool.CoreApiId_381; // 
      public static const ID_Math_RandomIntRange:int              = IdPool.CoreApiId_382; // 
      
   // math number convert
      
      public static const ID_Math_Degrees2Radians:int            = IdPool.CoreApiId_400; // 
      public static const ID_Math_Radians2Degrees:int            = IdPool.CoreApiId_401; // 
      public static const ID_Math_Number2RGB:int                 = IdPool.CoreApiId_402; // 
      public static const ID_Math_RGB2Number:int                 = IdPool.CoreApiId_403; // 
      public static const ID_MillisecondsToMinutesSeconds:int    = IdPool.CoreApiId_404; //
      //public static const ID_MillisecondsToMinutesSeconds:int    = IdPool.CoreApiId_405; //
      
   // math more ...
      
      public static const ID_Math_Max:int                         = IdPool.CoreApiId_500; // 
      public static const ID_Math_Min:int                         = IdPool.CoreApiId_501; // 
      
      public static const ID_Math_Inverse:int                     = IdPool.CoreApiId_510; // 
      public static const ID_Math_Abs:int                         = IdPool.CoreApiId_511; // 
      public static const ID_Math_Sqrt:int                        = IdPool.CoreApiId_512; // 
      public static const ID_Math_Ceil:int                        = IdPool.CoreApiId_513; // 
      public static const ID_Math_Floor:int                       = IdPool.CoreApiId_514; // 
      public static const ID_Math_Round:int                       = IdPool.CoreApiId_515; // 
      public static const ID_Math_Log:int                         = IdPool.CoreApiId_516; // 
      public static const ID_Math_Exp:int                         = IdPool.CoreApiId_517; // 
      public static const ID_Math_Power:int                       = IdPool.CoreApiId_518; // 
      public static const ID_Math_Clamp:int                       = IdPool.CoreApiId_519; // 
      
      public static const Id_Math_LinearInterpolation:int                  = IdPool.CoreApiId_530; //
      public static const Id_Math_LinearInterpolationColor:int             = IdPool.CoreApiId_531; //
      
      
   // game / design
      
      public static const ID_Design_GetLevelMilliseconds:int                    = IdPool.CoreApiId_600; // design
      public static const ID_Design_GetLevelSteps:int                           = IdPool.CoreApiId_601; // design
      public static const ID_Design_GetMousePosition:int                        = IdPool.CoreApiId_602; // design
      public static const ID_Design_IsMouseButtonHold:int                       = IdPool.CoreApiId_603; // design
      
      public static const ID_Design_SetLevelStatus:int                           = IdPool.CoreApiId_609; // design
      public static const ID_Design_IsLevelSuccessed:int                         = IdPool.CoreApiId_610; // design
      public static const ID_Design_IsLevelFailed:int                            = IdPool.CoreApiId_612; // design
      public static const ID_Design_IsLevelUnfinished:int                        = IdPool.CoreApiId_614; // design
      
   // game / world
      
      //public static const ID_World_GetLevelMilliseconds:int               = IdPool.CoreApiId_700; // world
      
      public static const ID_World_SetGravityAcceleration_Radians:int       = IdPool.CoreApiId_710; // world
      public static const ID_World_SetGravityAcceleration_Degrees:int       = IdPool.CoreApiId_711; // world
      public static const ID_World_SetGravityAcceleration_Vector:int        = IdPool.CoreApiId_712; // world
      
      public static const ID_World_FollowCameraWithShape:int                         = IdPool.CoreApiId_720; // world
      public static const ID_World_FollowCameraCenterXWithShape:int                  = IdPool.CoreApiId_721; // world
      public static const ID_World_FollowCameraCenterYWithShape:int                  = IdPool.CoreApiId_722; // world
      //public static const ID_World_FollowCameraRotationWithShape:int               = IdPool.CoreApiId_723; // world
      public static const ID_World_CameraFadeOutThenFadeIn:int                       = IdPool.CoreApiId_725; // world
      //public static const ID_World_CameraFadeOut:int
      //public static const ID_World_CameraFadeIn:int
      //public static const ID_World_CameraCloseThenOpen:int
      
      public static const ID_World_CallScript:int                               = IdPool.CoreApiId_750; // world
      public static const ID_World_ConditionCallScript:int                      = IdPool.CoreApiId_751; // world
      public static const ID_World_CallBoolFunction:int                         = IdPool.CoreApiId_752; // world
      public static const ID_World_ConditionCallBoolFunction:int                = IdPool.CoreApiId_753; // world
      public static const ID_World_CallScriptMultiTimes:int                   = IdPool.CoreApiId_754; // world      
      public static const ID_World_CallBoolFunctionMultiTimes:int             = IdPool.CoreApiId_755; // world      
      
      // VirtualClickOnEntityCenter (entity)
      
   // game / collision category
      
      public static const ID_CCat_Assign:int                              = IdPool.CoreApiId_850; // CCat
      public static const ID_CCat_SetCollideInternally:int                = IdPool.CoreApiId_851; // CCat
      public static const ID_CCat_SetAsFriends:int                        = IdPool.CoreApiId_852; // CCat
      public static const ID_CCat_ConditionAssign:int                     = IdPool.CoreApiId_853; // CCat, to ptu after ID_CCat_Assign
      
   // game / entity
      
      public static const ID_Entity_Assign:int                         = IdPool.CoreApiId_900; // entity.shape
      public static const ID_Entity_ConditionAssign:int                = IdPool.CoreApiId_901; // entity.shape
      
      public static const ID_Entity_IsTaskSuccessed:int                = IdPool.CoreApiId_910; // entity.shape
      public static const ID_Entity_SetTaskSuccessed:int               = IdPool.CoreApiId_911; // entity.shape
      public static const ID_Entity_IsTaskFailed:int                   = IdPool.CoreApiId_912; // entity.shape
      public static const ID_Entity_SetTaskFailed:int                  = IdPool.CoreApiId_913; // entity.shape
      public static const ID_Entity_IsTaskUnfinished:int               = IdPool.CoreApiId_914; // entity.shape
      public static const ID_Entity_SetTaskUnfinished:int              = IdPool.CoreApiId_915; // entity.shape
      public static const ID_Entity_SetTaskStatus:int                  = IdPool.CoreApiId_916; // entity.shape
      
      //public static const ID_Entity_IsShapeEntity:int
      //public static const ID_Entity_IsJointEntity:int
      
      
      public static const ID_Entity_IsVisible:int                      = IdPool.CoreApiId_980; // entity 
      public static const ID_Entity_SetVisible:int                     = IdPool.CoreApiId_981; // entity 
      public static const ID_Entity_GetAlpha:int                       = IdPool.CoreApiId_982; // entity 
      public static const ID_Entity_SetAlpha:int                       = IdPool.CoreApiId_983; // entity 
      public static const ID_Entity_IsEnabled:int                      = IdPool.CoreApiId_984; // entity 
      public static const ID_Entity_SetEnabled:int                     = IdPool.CoreApiId_985; // entity 
      
      public static const ID_Entity_GetPosition:int                    = IdPool.CoreApiId_1001; // entity 
      //public static const ID_Entity_SetPosition:int                    = IdPool.CoreApiId_1002; // entity 
      //public static const ID_Entity_GetLocalPosition:int               = IdPool.CoreApiId_1003; // entity 
      //public static const ID_Entity_SetLocalPosition:int             = IdPool.CoreApiId_1004; // entity 
      public static const ID_Entity_GetRotationByRadians:int           = IdPool.CoreApiId_1005; // entity 
      //public static const ID_Entity_SetRotationByRadians:int         = IdPool.CoreApiId_1006; // entity 
      public static const ID_Entity_GetRotationByDegrees:int           = IdPool.CoreApiId_1007; // entity 
      //public static const ID_Entity_SetRotationByDegrees:int         = IdPool.CoreApiId_1008; // entity 
      public static const ID_Entity_WorldPoint2LocalPoint:int          = IdPool.CoreApiId_1010; // entity 
      public static const ID_Entity_LocalPoint2WorldPoint:int          = IdPool.CoreApiId_1011; // entity 
      
      public static const ID_Entity_IsDestroyed:int                    = IdPool.CoreApiId_1049; // entity 
      public static const ID_Entity_Destroy:int                        = IdPool.CoreApiId_1050; // entity 
      
      public static const ID_Entity_Overlapped:int                     = IdPool.CoreApiId_1060; // entity 
      
   // game / entity / shape
      
      public static const ID_EntityShape_GetCIType:int            = IdPool.CoreApiId_1100; // entity.shape
      public static const ID_EntityShape_SetCIType:int            = IdPool.CoreApiId_1101; // entity.shape
      
      public static const ID_EntityShape_GetFilledColor:int            = IdPool.CoreApiId_1110; // entity.shape
      public static const ID_EntityShape_SetFilledColor:int            = IdPool.CoreApiId_1111; // entity.shape
      public static const ID_EntityShape_GetFilledColorRGB:int         = IdPool.CoreApiId_1112; // entity.shape
      public static const ID_EntityShape_SetFilledColorRGB:int         = IdPool.CoreApiId_1113; // entity.shape
      //public static const ID_EntityShape_GetFilledOpacity:int          = IdPool.CoreApiId_1114; // entity.shape
      //public static const ID_EntityShape_SetFilledOpacity:int          = IdPool.CoreApiId_1115; // entity.shape
      //public static const ID_EntityShape_IsShowBorder:int              = IdPool.CoreApiId_1116; // entity.shape
      //public static const ID_EntityShape_SetShowBorder:int             = IdPool.CoreApiId_1117; // entity.shape
      //public static const ID_EntityShape_GetBorderThickness:int        = IdPool.CoreApiId_1118; // entity.shape
      //public static const ID_EntityShape_SetBorderThickness:int        = IdPool.CoreApiId_1119; // entity.shape
      //public static const ID_EntityShape_GetBorderColor:int            = IdPool.CoreApiId_1120; // entity.shape
      //public static const ID_EntityShape_SetBorderColor:int            = IdPool.CoreApiId_1121; // entity.shape
      //public static const ID_EntityShape_GetBorderColorRGB:int         = IdPool.CoreApiId_1122; // entity.shape
      //public static const ID_EntityShape_SetBorderColorRGB:int         = IdPool.CoreApiId_1123; // entity.shape
      //public static const ID_EntityShape_GetBorderOpacity:int          = IdPool.CoreApiId_1124; // entity.shape
      //public static const ID_EntityShape_SetBorderOpacity:int          = IdPool.CoreApiId_1125; // entity.shape
      
      
      
      public static const ID_EntityShape_IsPhysicsEnabled:int          = IdPool.CoreApiId_1150; // entity.shape physics
      //public static const ID_EntityShape_SetPhysicsEnabled:int       = IdPool.CoreApiId_1151; // entity.shape physics
      public static const ID_EntityShape_GetCollisionCategory:int      = IdPool.CoreApiId_1152; // entity.shape physics
      public static const ID_EntityShape_SetCollisionCategory:int      = IdPool.CoreApiId_1153; // entity.shape physics
      //public static const ID_EntityShape_SetPhysicsEnabled:int       = IdPool.CoreApiId_1154; // entity.shape physics
      public static const ID_EntityShape_IsStatic:int                  = IdPool.CoreApiId_1155; // entity.shape physics
      public static const ID_EntityShape_SetStatic:int                 = IdPool.CoreApiId_1156; // entity.shape physics
      public static const ID_EntityShape_IsSensor:int                  = IdPool.CoreApiId_1157; // entity.shape physics
      public static const ID_EntityShape_SetAsSensor:int               = IdPool.CoreApiId_1158; // entity.shape physics
      //public static const ID_EntityShape_IsBullet:int                  = IdPool.CoreApiId_1159; // entity.shape physics
      //public static const ID_EntityShape_SetAsBullet:int               = IdPool.CoreApiId_1160; // entity.shape physics
      public static const ID_EntityShape_IsSleeping:int                  = IdPool.CoreApiId_1161; // entity.shape physics
      public static const ID_EntityShape_SetSleeping:int                 = IdPool.CoreApiId_1162; // entity.shape physics
      
      //public static const ID_EntityShape_GetLocalCentroid:int          = IdPool.CoreApiId_1070; // entity.shape physics
      //public static const ID_EntityShape_GetWorldCentroid:int          = IdPool.CoreApiId_1071; // entity.shape physics
      //public static const ID_EntityShape_AutoSetMassInertia:int        = IdPool.CoreApiId_1072; // entity.shape physics
      
      public static const ID_EntityShape_GetMass:int                     = IdPool.CoreApiId_1130; // entity.shape physics
      //public static const ID_EntityShape_SetMass:int                     = IdPool.CoreApiId_1131; // entity.shape physics
      public static const ID_EntityShape_GetInertia:int                  = IdPool.CoreApiId_1132; // entity.shape physics
      //public static const ID_EntityShape_SetInertia:int                  = IdPool.CoreApiId_1133; // entity.shape physics
      //public static const ID_EntityShape_GetDensity:int                  = IdPool.CoreApiId_1134; // entity.shape physics
      //public static const ID_EntityShape_SetDensity:int                  = IdPool.CoreApiId_1135; // entity.shape physics
      //public static const ID_EntityShape_GetFriction:int                 = IdPool.CoreApiId_1136; // entity.shape physics
      //public static const ID_EntityShape_SetFriction:int                 = IdPool.CoreApiId_1137; // entity.shape physics
      //public static const ID_EntityShape_GetRestitution:int              = IdPool.CoreApiId_1138; // entity.shape physics
      //public static const ID_EntityShape_SetRestitution:int              = IdPool.CoreApiId_1139; // entity.shape physics
      
      public static const ID_EntityShape_SetLinearVelocity:int                          = IdPool.CoreApiId_1095; // entity.shape physics
      public static const ID_EntityShape_GetLinearVelocity:int                          = IdPool.CoreApiId_1096; // entity.shape physics
      public static const ID_EntityShape_ApplyLinearImpulseByVelocityVector:int         = IdPool.CoreApiId_1097; // entity.shape physics
      //public static const ID_EntityShape_SetLinearVelocityByRadians:int
      //public static const ID_EntityShape_SetLinearVelocityByDegrees:int
      //public static const ID_EntityShape_GetAngularVelocityByRadians:int
      //public static const ID_EntityShape_SetAngularVelocityByRadians:int
      //public static const ID_EntityShape_GetAngularVelocityByDegrees:int
      //public static const ID_EntityShape_SetAngularVelocityByDegrees:int
      
      public static const ID_EntityShape_ApplyStepForce:int                                   = IdPool.CoreApiId_1104; // entity.shape physics
      public static const ID_EntityShape_ApplyStepForceAtLocalPoint:int                       = IdPool.CoreApiId_1105; // entity.shape physics
      public static const ID_EntityShape_ApplyStepForceAtWorldPoint:int                       = IdPool.CoreApiId_1106; // entity.shape physics
      public static const ID_EntityShape_ApplyStepTorque:int                                  = IdPool.CoreApiId_1107; // entity.shape physics
      
      public static const ID_EntityShape_ApplyLinearImpulse:int                               = IdPool.CoreApiId_1102; // entity.shape physics
      public static const ID_EntityShape_ApplyLinearImpulseAtLocalPoint:int                   = IdPool.CoreApiId_1103; // entity.shape physics
      public static const ID_EntityShape_ApplyLinearImpulseAtWorldPoint:int                   = IdPool.CoreApiId_1108; // entity.shape physics
      public static const ID_EntityShape_ApplyAngularImpulse:int                              = IdPool.CoreApiId_1109; // entity.shape physics
      
      public static const ID_EntityShape_Teleport:int                         = IdPool.CoreApiId_1252;
      public static const ID_EntityShape_TeleportOffsets:int                  = IdPool.CoreApiId_1253;
      //public static const ID_EntityShape_Clone:int;
      
      public static const ID_EntityShape_Detach:int                         = IdPool.CoreApiId_1260;
      public static const ID_EntityShape_AttachWith:int                     = IdPool.CoreApiId_1261;
      public static const ID_EntityShape_DetachThenAttachWith:int           = IdPool.CoreApiId_1262;
      public static const ID_EntityShape_BreakupBrothers:int                = IdPool.CoreApiId_1263;
      
      public static const ID_EntityShape_BreakAllJoints:int                 = IdPool.CoreApiId_1280;
      
   // game / shape / is a 
      
      public static const ID_Entity_IsCircleShapeEntity:int            = IdPool.CoreApiId_1400; // entity.shape
      public static const ID_Entity_IsRectangleShapeEntity:int         = IdPool.CoreApiId_1401; // entity.shape
      public static const ID_Entity_IsPolygonShapeEntity:int           = IdPool.CoreApiId_1402; // entity.shape
      public static const ID_Entity_IsPolylineShapeEntity:int          = IdPool.CoreApiId_1403; // entity.shape
      public static const ID_Entity_IsBombShapeEntitiy:int             = IdPool.CoreApiId_1404; // entity.shape
      public static const ID_Entity_IsWorldBorderShapeEntitiy:int      = IdPool.CoreApiId_1405; // entity.shape

      
   // game / entity / shape / text
      
      public static const ID_EntityText_GetText:int                   = IdPool.CoreApiId_1550; // entity.text
      public static const ID_EntityText_SetText:int                   = IdPool.CoreApiId_1551; // entity.text
      public static const ID_EntityText_AppendText:int                = IdPool.CoreApiId_1552; // entity.text
      public static const ID_EntityText_AppendNewLine:int             = IdPool.CoreApiId_1553; // entity.text
      
   // game / entity / joint
      
      // from 2000
      
      public static const ID_EntityJoint_SetJointMotorEnabled:int                   = IdPool.CoreApiId_1990; // joint.slider
      public static const ID_EntityJoint_SetJointLimitsEnabled:int                  = IdPool.CoreApiId_1991; // joint.slider
      
      public static const ID_EntityJoint_GetHingeLimitsByDegrees:int                 = IdPool.CoreApiId_2000; // joint.hinge
      //public static const ID_EntityJoint_GetHingeLimitsByRadians:int                 = IdPool.CoreApiId_2001; // joint.hinge
      public static const ID_EntityJoint_SetHingeLimitsByDegrees:int                 = IdPool.CoreApiId_2004; // joint.hinge
      //public static const ID_EntityJoint_SetHingeAngleLimitsByRadians:int            = IdPool.CoreApiId_2005; // joint.hinge
      public static const ID_EntityJoint_GetHingeMotorSpeed:int                      = IdPool.CoreApiId_2006; // joint.slider
      public static const ID_EntityJoint_SetHingeMotorSpeed:int                      = IdPool.CoreApiId_2007; // joint.slider
      
      public static const ID_EntityJoint_GetSliderLimits:int                      = IdPool.CoreApiId_2030; // joint.slider
      public static const ID_EntityJoint_GetSliderMotorSpeed:int                  = IdPool.CoreApiId_2031; // joint.slider
      public static const ID_EntityJoint_SetSliderLimits:int                      = IdPool.CoreApiId_2032; // joint.slider
      public static const ID_EntityJoint_SetSliderMotorSpeed:int                  = IdPool.CoreApiId_2033; // joint.slider
      
   // game / entity / field
      
      // from 2200
      
   // game / entity / event handler
      
      //public static const ID_EntityTrigger_GetTimerTicks:int                       = IdPool.CoreApiId_2500; // trigger.timer
      public static const ID_EntityTrigger_ResetTimer:int                          = IdPool.CoreApiId_2501; // trigger.timer
      //public static const ID_EntityTrigger_IsTimerPaused:int                       = IdPool.CoreApiId_2502; // trigger.timer
      public static const ID_EntityTrigger_SetTimerPaused:int                      = IdPool.CoreApiId_2503; // trigger.timer
      //public static const ID_EntityTrigger_GetTimerInterval:int                    = IdPool.CoreApiId_2504; // trigger.timer
      //public static const ID_EntityTrigger_SetTimerInterval:int                    = IdPool.CoreApiId_2505; // trigger.timer
      
   }
}
