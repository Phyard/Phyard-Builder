
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
      
      public static const ID_ForDebug:int                    = 0; // 
      
   // some specail
      
      public static const ID_Void:int                        = 10; // 
      public static const ID_Bool:int                        = 11; // 
      
   // global
      
      public static const ID_Return:int                       = 20; //
      public static const ID_ReturnIfTrue:int                 = 21; //
      public static const ID_ReturnIfFalse:int                = 22; //
      
      public static const ID_AssignBoolenRegister0:int        = 30; //
      
   // system
      
      public static const ID_GetProgramMilliseconds:int           = 70; //
      public static const ID_GetCurrentDateTime:int               = 71; //
      public static const ID_MillisecondsToMinutesSeconds:int     = 72; //
      
   // string
      
      public static const ID_String_Assign:int                    = 120; // 
      public static const ID_String_Add:int                       = 121; // 
      
      public static const ID_String_NumberToString:int            = 150; // 
      public static const ID_String_BooleanToString:int           = 151; // 
      public static const ID_String_EntityToString:int            = 152; // 
      public static const ID_String_CollisionCategoryToString:int = 153; // 
      
   // bool
      
      public static const ID_Bool_Assign :int                    = 170; // 
      public static const ID_Bool_Invert :int                    = 171; // 
      public static const ID_Bool_IsTrue :int                    = 172; // 
      public static const ID_Bool_IsFalse:int                    = 173; // 
      
      public static const ID_Bool_EqualsNumber:int               = 180; // 
      public static const ID_Bool_EqualsBoolean:int              = 181; // 
      public static const ID_Bool_EqualsEntity:int               = 182; // 
      
      public static const ID_Bool_Larger:int                     = 210; // 
      public static const ID_Bool_Less:int                       = 211; // 
      
      public static const ID_Bool_And:int                        = 230; // 
      public static const ID_Bool_Or:int                         = 231; // 
      public static const ID_Bool_Not:int                        = 232; // 
      public static const ID_Bool_Xor:int                        = 233; // 
      
   // math basic op 
      
      public static const ID_Math_Add:int                         = 300; // 
      public static const ID_Math_Subtract:int                    = 301; // 
      public static const ID_Math_Multiply:int                    = 302; // 
      public static const ID_Math_Divide:int                      = 303; // 
      
      public static const ID_Math_Assign:int                      = 310; // 
      public static const ID_Math_Negative:int                    = 311; // 
      
   // math / bitwise 
      
      public static const ID_Bitwise_ShiftLeft :int               = 315; // 
      public static const ID_Bitwise_ShiftRight :int              = 316; // 
      public static const ID_Bitwise_ShiftRightUnsigned :int      = 317; // 
      public static const ID_Bitwise_And :int                     = 318; // 
      public static const ID_Bitwise_Or :int                      = 319; // 
      public static const ID_Bitwise_Not :int                     = 320; // 
      public static const ID_Bitwise_Xor :int                     = 321; // 
      
  // math / trigonometry
      
      public static const ID_Math_SinRadians:int                  = 350; // 
      public static const ID_Math_CosRadians:int                  = 351; // 
      public static const ID_Math_TanRadians:int                  = 352; // 
      public static const ID_Math_ArcSinRadians:int               = 353; // 
      public static const ID_Math_ArcCosRadians:int               = 354; // 
      public static const ID_Math_ArcTanRadians:int               = 355; // 
      public static const ID_Math_ArcTan2Radians:int              = 356; // 
      
  // math / random
      
      public static const ID_Math_Random:int                      = 380; // 
      public static const ID_Math_RandomRange:int                 = 381; // 
      public static const ID_Math_RandomIntRange:int              = 382; // 
      
   // math number convert
      
      public static const ID_Math_Degrees2Radians:int            = 400; // 
      public static const ID_Math_Radians2Degrees:int            = 401; // 
      public static const ID_Math_Number2RGB:int                 = 402; // 
      public static const ID_Math_RGB2Number:int                 = 403; // 
      
   // math more ...
      
      public static const ID_Math_Max:int                         = 500; // 
      public static const ID_Math_Min:int                         = 501; // 
      
      public static const ID_Math_Inverse:int                     = 510; // 
      public static const ID_Math_Abs:int                         = 511; // 
      public static const ID_Math_Sqrt:int                        = 512; // 
      public static const ID_Math_Ceil:int                        = 513; // 
      public static const ID_Math_Floor:int                       = 514; // 
      public static const ID_Math_Round:int                       = 515; // 
      public static const ID_Math_Log:int                         = 516; // 
      public static const ID_Math_Exp:int                         = 517; // 
      public static const ID_Math_Power:int                       = 518; // 
      
      public static const Id_Math_LinearInterpolation:int                  = 530; //
      public static const Id_Math_LinearInterpolationColor:int             = 531; //
      
   // game / world
      
      //public static const ID_World_GetLevelMilliseconds:int               = 600; // world
      
      public static const ID_World_SetGravityAcceleration_Radians:int       = 610; // world
      public static const ID_World_SetGravityAcceleration_Degrees:int       = 611; // world
      //public static const ID_World_SetGravityAcceleration_Vector:int      = 612; // world
      
      public static const ID_World_AttachCameraToShape:int                  = 620; // world
      
      // VirtualClickOnEntityCenter (entity)
      
   // game / collision category
      
      public static const ID_Cat_Assign:int                          = 850; // world
      
   // game / entity
      
      public static const ID_Entity_Assign:int                         = 900; // entity.shape
      
      public static const ID_Entity_IsShapeEntity:int                  = 910; // entity.shape
      public static const ID_Entity_IsCircleShapeEntity:int            = 910; // entity.shape
      public static const ID_Entity_IsRectangleShapeEntity:int         = 910; // entity.shape
      public static const ID_Entity_IsPolygonShapeEntity:int           = 910; // entity.shape
      public static const ID_Entity_IsPolygonLineEntity:int            = 910; // entity.shape
      
      public static const ID_Entity_IsJointEntity:int                  = 930; // entity.shape
      
      
      public static const ID_Entity_IsVisible:int                      = 950; // entity 
      public static const ID_Entity_SetVisible:int                     = 951; // entity 
      public static const ID_Entity_GetAlpha:int                       = 952; // entity 
      public static const ID_Entity_SetAlpha:int                       = 953; // entity 
      
      public static const ID_Entity_GetPosition:int                    = 954; // entity 
      public static const ID_Entity_SetPosition:int                    = 955; // entity 
      public static const ID_Entity_GetLocalPosition:int               = 956; // entity 
      //public static const ID_Entity_SetLocalPosition:int             = 957; // entity 
      public static const ID_Entity_GetRotationByRadians:int           = 960; // entity 
      //public static const ID_Entity_SetRotationByRadians:int         = 961; // entity 
      public static const ID_Entity_GetRotationByDegrees:int           = 962; // entity 
      //public static const ID_Entity_SetRotationByDegrees:int         = 963; // entity 
      
   // game / entity / shape
      
      public static const ID_EntityShape_GetShapeCIType:int            = 1100; // entity.shape
      //public static const ID_EntityShape_SetShapeCIType:int          = 1101; // entity.shape
      
      public static const ID_EntityShape_GetFilledColor:int            = 1110; // entity.shape
      public static const ID_EntityShape_SetFilledColor:int            = 1111; // entity.shape
      public static const ID_EntityShape_GetFilledColorRGB:int         = 1112; // entity.shape
      public static const ID_EntityShape_SetFilledColorRGB:int         = 1113; // entity.shape
      public static const ID_EntityShape_GetFilledOpacity:int          = 1114; // entity.shape
      public static const ID_EntityShape_SetFilledOpacity:int          = 1115; // entity.shape
      public static const ID_EntityShape_IsShowBorder:int              = 1116; // entity.shape
      public static const ID_EntityShape_SetShowBorder:int             = 1117; // entity.shape
      public static const ID_EntityShape_GetBorderThickness:int        = 1118; // entity.shape
      public static const ID_EntityShape_SetBorderThickness:int        = 1119; // entity.shape
      public static const ID_EntityShape_GetBorderColor:int            = 1120; // entity.shape
      public static const ID_EntityShape_SetBorderColor:int            = 1121; // entity.shape
      public static const ID_EntityShape_GetBorderColorRGB:int         = 1122; // entity.shape
      public static const ID_EntityShape_SetBorderColorRGB:int         = 1123; // entity.shape
      public static const ID_EntityShape_GetBorderOpacity:int          = 1124; // entity.shape
      public static const ID_EntityShape_SetBorderOpacity:int          = 1125; // entity.shape
      
      
      
      public static const ID_EntityShape_IsPhysicsEnabled:int          = 1150; // entity.shape physics
      //public static const ID_EntityShape_SetPhysicsEnabled:int       = 1151; // entity.shape physics
      public static const ID_EntityShape_IsStatic:int                  = 1152; // entity.shape physics
      //public static const ID_EntityShape_SetStatic:int               = 1153; // entity.shape physics
      public static const ID_EntityShape_IsSensor:int                  = 1154; // entity.shape physics
      public static const ID_EntityShape_SetAsSensor:int               = 1155; // entity.shape physics
      public static const ID_EntityShape_IsBullet:int                  = 1156; // entity.shape physics
      public static const ID_EntityShape_SetAsBullet:int               = 1157; // entity.shape physics
      
      public static const ID_EntityShape_GetCollisionCategory:int      = 1170; // entity.shape physics
      public static const ID_EntityShape_SetCollisionCategory:int      = 1171; // entity.shape physics
      public static const ID_EntityShape_GetLocalCentroid:int          = 1072; // entity.shape physics
      public static const ID_EntityShape_GetWorldCentroid:int          = 1072; // entity.shape physics
      public static const ID_EntityShape_AutoSetMassInertia:int        = 1072; // entity.shape physics
      public static const ID_EntityShape_GetMass:int                   = 1072; // entity.shape physics
      public static const ID_EntityShape_SetMass:int                   = 1072; // entity.shape physics
      public static const ID_EntityShape_GetInertia:int                = 1072; // entity.shape physics
      public static const ID_EntityShape_SetInertia:int                = 1072; // entity.shape physics
      public static const ID_EntityShape_GetDensity:int                = 1073; // entity.shape physics
      public static const ID_EntityShape_SetDensity:int                = 1074; // entity.shape physics
      public static const ID_EntityShape_GetFriction:int               = 1075; // entity.shape physics
      public static const ID_EntityShape_SetFriction:int               = 1076; // entity.shape physics
      public static const ID_EntityShape_GetRestitution:int            = 1078; // entity.shape physics
      public static const ID_EntityShape_SetRestitution:int            = 1079; // entity.shape physics
      
      public static const ID_EntityShape_GetLinearVelocity:int         = 1100; // entity.shape physics
      public static const ID_EntityShape_SetLinearVelocity:int         = 1101; // entity.shape physics
      public static const ID_EntityShape_GetAngularVelocity:int        = 1102; // entity.shape physics
      public static const ID_EntityShape_SetAngularVelocity:int        = 1103; // entity.shape physics
      public static const ID_EntityShape_ApplyStepForce:int            = 1102; // entity.shape physics
      public static const ID_EntityShape_ApplyStepForceAtPoint:int                      = 1102; // entity.shape physics
      public static const ID_EntityShape_ApplyStepForceAtLocalPoint:int                 = 1102; // entity.shape physics
      public static const ID_EntityShape_ApplyStepLocalForce:int                        = 1102; // entity.shape physics
      public static const ID_EntityShape_ApplyStepLocalForceAtPoint:int                 = 1102; // entity.shape physics
      public static const ID_EntityShape_ApplyStepLocalForceAtLocalPoint:int            = 1102; // entity.shape physics
      public static const ID_EntityShape_ApplyPermanentForce:int                   = 1103; // entity.shape physics
      public static const ID_EntityShape_ApplyPermanentForceAtPoint:int                   = 1103; // entity.shape physics
      public static const ID_EntityShape_ApplyPermanentForceAtLocalPoint:int                   = 1103; // entity.shape physics
      public static const ID_EntityShape_ApplyPermanentLocalForce:int                   = 1103; // entity.shape physics
      public static const ID_EntityShape_ApplyPermanentLocalForceAtPoint:int                   = 1103; // entity.shape physics
      public static const ID_EntityShape_ApplyPermanentLocalForceAtLocalPoint:int                   = 1103; // entity.shape physics
      public static const ID_EntityShape_ApplyStepTorque:int            = 1102; // entity.shape physics
      public static const ID_EntityShape_ApplyPermanentTorque:int                   = 1103; // entity.shape physics
      //impulse and angular impulse
      
      
      
      public static const ID_EntityShape_Attach:int                         = 1250;
      public static const ID_EntityShape_Detach:int                         = 1251;
      public static const ID_EntityShape_Breakup:int                         = 1252;
      public static const ID_EntityShape_Teleport:int                       = 1253;
      public static const ID_EntityShape_Clone:int                          = 1254;
      
      
      
   // game /entity / joint
      
      // from 1300
      
   // game / entity / utils
      
      public static const ID_EntityText_GetText:int                   = 1550; // entity.text
      public static const ID_EntityText_SetText:int                   = 1551; // entity.text
      public static const ID_EntityText_AppendText:int                = 1552; // entity.text
      public static const ID_EntityText_AppendNewLine:int             = 1553; // entity.text
      
   // game / entity / field
      
      // from 1800
      
   //=============================================================
      
      public static const NumPlayerFunctions:int = 2000;
   }
}
