
package common.trigger {
   
   public class CoreFunctionIds
   {
   // the id < 8196 will be reserved for officeial core apis
      
      public static const ID_Void:int                        = -1; // 
      public static const ID_ForDebug:int                    = 0; // 
      
   // system
      
      public static const ID_GetProgramMilliseconds:int            = 20; //
      public static const ID_GetCurrentDateTime:int               = 21; //
      public static const ID_MillisecondsToMinutesSeconds:int     = 22; //
      
   // bool
      
      public static const ID_Bool_IsTrue :int                    = 100; // 
      public static const ID_Bool_IsFalse:int                    = 101; // 
      public static const ID_Bool_Larger:int                     = 102; // 
      public static const ID_Bool_Less:int                       = 103; // 
      public static const ID_Bool_EqualsNumber:int               = 104; // 
      public static const ID_Bool_EqualsBoolean:int              = 105; // 
      public static const ID_Bool_And:int                        = 106; // 
      public static const ID_Bool_Or:int                         = 107; // 
      public static const ID_Bool_Not:int                        = 108; // 
      public static const ID_Bool_Xor:int                        = 109; // 
      
   // bitwise 
      
      public static const ID_Bitwise_ShiftLeft :int               = 130; // 
      public static const ID_Bitwise_ShiftRight :int              = 131; // 
      public static const ID_Bitwise_ShiftRightUnsigned :int      = 132; // 
      public static const ID_Bitwise_And :int                     = 133; // 
      public static const ID_Bitwise_Or :int                      = 134; // 
      public static const ID_Bitwise_Not :int                     = 135; // 
      public static const ID_Bitwise_Xor :int                     = 136; // 
      
   // string
      
      public static const ID_String_NumberToString:int            = 150; // 
      public static const ID_String_BooleanToString:int           = 151; // 
      public static const ID_String_EntityToString:int            = 152; // 
      public static const ID_String_CollisionCategoryToString:int = 153; // 
      
      public static const ID_String_Add:int                       = 170; // 
      
   // math
      
      public static const ID_Math_Add:int                         = 200; // 
      public static const ID_Math_Subtract:int                    = 201; // 
      public static const ID_Math_Multiply:int                    = 202; // 
      public static const ID_Math_Divide:int                      = 203; // 
      
      public static const ID_Math_Random:int                      = 215; // 
      public static const ID_Math_RandomRange:int                 = 216; // 
      public static const ID_Math_RandomIntRange:int              = 217; // 
      
      public static const ID_Math_Max:int                         = 230; // 
      public static const ID_Math_Min:int                         = 231; // 
      
      public static const ID_Math_Inverse:int                     = 250; // 
      public static const ID_Math_Negative:int                    = 251; // 
      public static const ID_Math_Abs:int                         = 252; // 
      public static const ID_Math_Sqrt:int                        = 253; // 
      public static const ID_Math_Ceil:int                        = 254; // 
      public static const ID_Math_Floor:int                       = 255; // 
      public static const ID_Math_Round:int                       = 256; // 
      public static const ID_Math_Log:int                         = 257; // 
      public static const ID_Math_Exp:int                         = 258; // 
      public static const ID_Math_Power:int                       = 259; // 
      
      public static const ID_Math_DegreesToRadians:int            = 280; // 
      public static const ID_Math_RadiansToDegrees:int            = 281; // 
      public static const ID_Math_SinRadians:int                  = 290; // 
      public static const ID_Math_CosRadians:int                  = 291; // 
      public static const ID_Math_TanRadians:int                  = 292; // 
      public static const ID_Math_ArcSinRadians:int               = 293; // 
      public static const ID_Math_ArcCosRadians:int               = 294; // 
      public static const ID_Math_ArcTanRadians:int               = 295; // 
      public static const ID_Math_ArcTan2Radians:int              = 296; // 
      
   // game / world
      
      //public static const ID_World_GetLevelMilliseconds:int            = 500; // world
      public static const ID_World_SetGravityAcceleration_Radians:int          = 501; // world
      public static const ID_World_SetGravityAcceleration_Degrees:int          = 502; // world
      //public static const ID_World_SetGravityAcceleration_Vector:int          = 503; // world
      public static const ID_World_AttachCameraToShape:int             = 510; // world
      
      // VirtualClickOnEntityCenter (entity)
      
   // game / entity
      
      public static const ID_Entity_IsShapeEntity:int                  = 600; // entity.shape
      
      public static const ID_Entity_IsVisible:int                      = 650; // entity 
      public static const ID_Entity_SetVisible:int                     = 651; // entity 
      public static const ID_Entity_GetAlpha:int                       = 652; // entity 
      public static const ID_Entity_SetAlpha:int                       = 653; // entity 
      public static const ID_Entity_GetPosition:int                    = 654; // entity 
      //public static const ID_Entity_SetPosition:int                  = 655; // entity 
      public static const ID_Entity_GetRotationByRadians:int           = 656; // entity 
      //public static const ID_Entity_SetRotationByRadians:int         = 657; // entity 
      public static const ID_Entity_GetRotationByDegrees:int           = 658; // entity 
      //public static const ID_Entity_SetRotationByDegrees:int         = 659; // entity 
      
   // game / entity / shape
      
      public static const ID_EntityShape_GetFilledColor:int            = 700; // entity.shape
      public static const ID_EntityShape_SetFilledColor:int            = 701; // entity.shape
      public static const ID_EntityShape_IsPhysicsEnabled:int          = 750; // entity.shape
      public static const ID_EntityShape_IsSensor:int                  = 751; // entity.shape
      public static const ID_EntityShape_SetAsSensor:int               = 752; // entity.shape
      public static const ID_EntityShape_GetDensity:int                = 753; // entity.shape
      public static const ID_EntityShape_SetDensity:int                = 754; // entity.shape
      
   // game /entity / joint
      
      // from 900
      
   // game / entity / utils
      
      public static const ID_EntityText_GetText:int                   = 1000; // entity.text
      public static const ID_EntityText_SetText:int                   = 1001; // entity.text
      public static const ID_EntityText_AppendText:int                = 1002; // entity.text
      public static const ID_EntityText_AppendNewLine:int             = 1003; // entity.text
      
   // game / entity / field
      
      // from 1200
      
   //=============================================================
      
      public static const NumPlayerFunctions:int = 2000;
   }
}
