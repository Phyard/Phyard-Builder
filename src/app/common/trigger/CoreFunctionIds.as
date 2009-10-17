
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
      
      public static const ID_Void:int                        = -1; // 
      public static const ID_ForDebug:int                    = 0; // 
      
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
      
   // math
      
      public static const ID_Math_Assign:int                      = 300; // 
      public static const ID_Math_Add:int                         = 301; // 
      public static const ID_Math_Subtract:int                    = 302; // 
      public static const ID_Math_Multiply:int                    = 303; // 
      public static const ID_Math_Divide:int                      = 304; // 
      
      public static const ID_Math_Random:int                      = 315; // 
      public static const ID_Math_RandomRange:int                 = 316; // 
      public static const ID_Math_RandomIntRange:int              = 317; // 
      
      public static const ID_Math_Max:int                         = 330; // 
      public static const ID_Math_Min:int                         = 331; // 
      
      public static const ID_Math_Inverse:int                     = 350; // 
      public static const ID_Math_Negative:int                    = 351; // 
      public static const ID_Math_Abs:int                         = 352; // 
      public static const ID_Math_Sqrt:int                        = 353; // 
      public static const ID_Math_Ceil:int                        = 354; // 
      public static const ID_Math_Floor:int                       = 355; // 
      public static const ID_Math_Round:int                       = 356; // 
      public static const ID_Math_Log:int                         = 357; // 
      public static const ID_Math_Exp:int                         = 358; // 
      public static const ID_Math_Power:int                       = 359; // 
      
      public static const ID_Math_DegreesToRadians:int            = 380; // 
      public static const ID_Math_RadiansToDegrees:int            = 381; // 
      
      public static const ID_Math_SinRadians:int                  = 390; // 
      public static const ID_Math_CosRadians:int                  = 391; // 
      public static const ID_Math_TanRadians:int                  = 392; // 
      public static const ID_Math_ArcSinRadians:int               = 393; // 
      public static const ID_Math_ArcCosRadians:int               = 394; // 
      public static const ID_Math_ArcTanRadians:int               = 395; // 
      public static const ID_Math_ArcTan2Radians:int              = 396; // 
      
   // math / bitwise 
      
      public static const ID_Bitwise_ShiftLeft :int               = 430; // 
      public static const ID_Bitwise_ShiftRight :int              = 431; // 
      public static const ID_Bitwise_ShiftRightUnsigned :int      = 432; // 
      public static const ID_Bitwise_And :int                     = 433; // 
      public static const ID_Bitwise_Or :int                      = 434; // 
      public static const ID_Bitwise_Not :int                     = 435; // 
      public static const ID_Bitwise_Xor :int                     = 436; // 
      
      
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
      
      public static const ID_Entity_IsVisible:int                      = 950; // entity 
      public static const ID_Entity_SetVisible:int                     = 951; // entity 
      public static const ID_Entity_GetAlpha:int                       = 952; // entity 
      public static const ID_Entity_SetAlpha:int                       = 953; // entity 
      public static const ID_Entity_GetPosition:int                    = 954; // entity 
      //public static const ID_Entity_SetPosition:int                  = 955; // entity 
      public static const ID_Entity_GetRotationByRadians:int           = 956; // entity 
      //public static const ID_Entity_SetRotationByRadians:int         = 957; // entity 
      public static const ID_Entity_GetRotationByDegrees:int           = 958; // entity 
      //public static const ID_Entity_SetRotationByDegrees:int         = 959; // entity 
      
   // game / entity / shape
      
      public static const ID_EntityShape_GetFilledColor:int            = 1000; // entity.shape
      public static const ID_EntityShape_SetFilledColor:int            = 1001; // entity.shape
      
      public static const ID_EntityShape_IsPhysicsEnabled:int          = 1050; // entity.shape
      public static const ID_EntityShape_IsSensor:int                  = 1051; // entity.shape
      public static const ID_EntityShape_SetAsSensor:int               = 1052; // entity.shape
      public static const ID_EntityShape_GetDensity:int                = 1053; // entity.shape
      public static const ID_EntityShape_SetDensity:int                = 1054; // entity.shape
      
   // game /entity / joint
      
      // from 1200
      
   // game / entity / utils
      
      public static const ID_EntityText_GetText:int                   = 1300; // entity.text
      public static const ID_EntityText_SetText:int                   = 1301; // entity.text
      public static const ID_EntityText_AppendText:int                = 1302; // entity.text
      public static const ID_EntityText_AppendNewLine:int             = 1303; // entity.text
      
   // game / entity / field
      
      // from 1500
      
   //=============================================================
      
      public static const NumPlayerFunctions:int = 2000;
   }
}
