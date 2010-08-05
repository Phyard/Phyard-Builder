
package player.trigger {
   import flash.utils.getTimer;
   import flash.geom.Point;
   
   import player.design.Global;
   import player.design.Design;
   
   import player.world.*;
   import player.entity.*;
   import player.trigger.entity.*;
   
   import player.physics.PhysicsEngine;
   
   import player.trigger.FunctionDefinition_Core;
   import player.trigger.ValueSource;
   import player.trigger.ValueTarget;
   
   import actionscript.util.RandomNumberGenerator;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.CoreFunctionIds;
   import common.trigger.FunctionDeclaration;
   import common.trigger.CoreFunctionDeclarations;
   
   import common.Define;
   import common.ValueAdjuster;
   
   import common.trigger.ValueDefine;
   import common.trigger.IdPool;
   
   public class CoreFunctionDefinitions
   {
//=============================
// to avoid create objects frequently
//=============================
      
      private static var sPoint :Point = new Point ();
      private static var sVector:Point = new Point ();
      
//=============================
      
      public static var sCoreFunctionDefinitions:Array = new Array (IdPool.NumPlayerFunctions);
      
      public static function Initialize ():void
      {
         if (Compile::Is_Debugging)
         {
            RegisterCoreFunction (CoreFunctionIds.ID_ForDebug,                     ForDebug);
         }
         
      // some specail
         
         // 
         
      // global
         
         //RegisterCoreFunction (CoreFunctionIds.ID_Return,                           ReturnVoid);
         //RegisterCoreFunction (CoreFunctionIds.ID_ReturnIfTrue,                     ReturnIfTrue);
         //RegisterCoreFunction (CoreFunctionIds.ID_ReturnIfFalse,                    ReturnIfFalse);
         //RegisterCoreFunction (CoreFunctionIds.ID_Break,                            BreakVoid);
         
      // system / time
         
         RegisterCoreFunction (CoreFunctionIds.ID_GetProgramMilliseconds,           GetProgramMilliseconds);
         RegisterCoreFunction (CoreFunctionIds.ID_GetCurrentDateTime,               GetCurrentDateTime);
         RegisterCoreFunction (CoreFunctionIds.ID_IsKeyHold,                        IsKeyHold);
         
      // string
         
         RegisterCoreFunction (CoreFunctionIds.ID_String_Assign,                      AssignString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_ConditionAssign,             ConditionAssignString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_SwapValues,                  SwapStringValues);
         RegisterCoreFunction (CoreFunctionIds.ID_String_IsNull,                      IsNullString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_Equals,                      EqualsWith_Strings);
         RegisterCoreFunction (CoreFunctionIds.ID_String_Add,                         AddTwoStrings);
         RegisterCoreFunction (CoreFunctionIds.ID_String_GetLength,                   GetStringLength);
         RegisterCoreFunction (CoreFunctionIds.ID_String_GetCharAt,                   StringCharAt);
         RegisterCoreFunction (CoreFunctionIds.ID_String_GetCharCodeAt,               StringCharCodeAt);
         RegisterCoreFunction (CoreFunctionIds.ID_String_CharCode2Char,               CharCode2Char);
         RegisterCoreFunction (CoreFunctionIds.ID_String_ToLowerCase,                 ToLowerCase);
         RegisterCoreFunction (CoreFunctionIds.ID_String_ToUpperCase,                 ToUpperCase);
         
      // bool
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Assign,                AssignBoolean);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_ConditionAssign,       ConditionAssignBoolean);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_SwapValues,    SwapBooleanValues);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_EqualsBoolean,         EqualsWith_Booleans);
         RegisterCoreFunction (CoreFunctionIds.ID_Boolean_ToString,           BooleanToString);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Invert,                BooleanInvert);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_IsTrue,                IsTrue);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_IsFalse,               IsFalse);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_LargerThan,            LargerThan);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_LessThan,              LessThan);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_And,               BoolAnd);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Or,                BoolOr);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Not,               BoolNot);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Xor,               BoolXor);
         
         // math ops
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Assign,                     AssignNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ConditionAssign,            ConditionAssignNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_SwapValues,           SwapNumberValues);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Equals,      EqualsWith_Numbers);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_IsNaN,               IsNaN);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_IsInfinity,          IsInfinity);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ToString,             NumberToString);
         //RegisterCoreFunction (CoreFunctionIds.ID_Number_ToExponential,      NumberToExponentialString);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ToFixed,              NumberToFixedString);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ToPrecision,          NumberToPrecisionString);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ToStringByRadix,      NumberToStringByRadix);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ParseFloat,           ParseFloat);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ParseInteger,         ParseInteger);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Negative,                   NegativeNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Add,                        AddTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Subtract,                   SubtractTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Multiply,                   MultiplyTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Divide,                     DivideTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Modulo,                     ModuloTwoNumbers);
         
         // math / bitwise
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftLeft,             ShiftLeft);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftRight,            ShiftRight);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned,    ShiftRightUnsigned);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_And,                   BitwiseAnd);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Or,                    BitwiseOr);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Not,                   BitwiseNot);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Xor,                   BitwiseXor);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_SinRadians,                SinRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_CosRadians,                CosRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_TanRadians,                TanRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ArcSinRadians,             AsinRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ArcCosRadians,             AcosRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ArcTanRadians,             AtanRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_ArcTan2Radians,            AtanRadianTwoNumbers);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Random,                     RandomNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_RandomRange,                RandomNumberRange);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_RandomIntRange,             RandomIntegerRange);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_RngCreate,                  RngCreate);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_RngSetSeed,                 RngSetSeed);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_RngRandom,                  RngRandom);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_RngRandomRange,             RngRandomNumberRange);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_RngRandomIntRange,          RngRandomIntegerRange);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Degrees2Radians,             Degrees2Radians);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Radians2Degrees,             Radians2Degrees);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Number2RGB,                  Number2RGB);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_RGB2Number,                  RGB2Number);
         RegisterCoreFunction (CoreFunctionIds.ID_MillisecondsToMinutesSeconds,     MillisecondsToMinutesSeconds);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Inverse,                   InverseNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Max,                        MaxOfTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Min,                        MinOfTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Abs,                       AbsNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Sqrt,                      SqrtNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Ceil,                      CeilNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Floor,                     FloorNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Round,                     RoundNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Log,                       LogNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Exp,                       ExpNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Power,                     Power);
         RegisterCoreFunction (CoreFunctionIds.ID_Number_Clamp,                     Clamp);
         
         RegisterCoreFunction (CoreFunctionIds.Id_Math_LinearInterpolation,               LinearInterpolation);
         RegisterCoreFunction (CoreFunctionIds.Id_Math_LinearInterpolationColor,          LinearInterpolationColor);
         
      // game / design
         
         RegisterCoreFunction (CoreFunctionIds.ID_Design_RestartLevel,              RestartLevel);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_IsLevelPaused,             IsLevelPaused);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_SetLevelPaused,            SetLevelPaused);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_GetPlaySpeedX,             GetPlaySpeedX);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_SetPlaySpeedX,             SetPlaySpeedX);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_GetWorldScale,             GetWorldScale);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_SetWorldScale,             SetWorldScale);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Design_GetLevelMilliseconds,             GetLevelMilliseconds);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_GetLevelSteps,                    GetLevelSteps);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_GetMousePosition,                 GetWorldMousePosition);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_IsMouseButtonHold,                IsMouseButtonHold);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Design_SetLevelStatus,                   SetLevelStatus);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_IsLevelSuccessed,                 IsLevelSuccessed);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_IsLevelFailed,                    IsLevelFailed);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_IsLevelUnfinished,                IsLevelUnfinished);
         
      // game / world
         
         RegisterCoreFunction (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians,     SetWorldGravityAcceleration_Radians);
         RegisterCoreFunction (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees,     SetWorldGravityAcceleration_Degrees);
         RegisterCoreFunction (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector,      SetWorldGravityAcceleration_Vector);
         
         RegisterCoreFunction (CoreFunctionIds.ID_World_GetCameraCenter,                           GetCameraCenter);
         RegisterCoreFunction (CoreFunctionIds.ID_World_FollowCameraWithShape,                       FollowCameraWithShape);
         RegisterCoreFunction (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape,                FollowCameraCenterXWithShape);
         RegisterCoreFunction (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape,                FollowCameraCenterYWithShape);
         //RegisterCoreFunction (CoreFunctionIds.ID_World_FollowCameraRotationWithShape,               FollowCameraRotationWithShape);
         
         RegisterCoreFunction (CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn,                CameraFadeOutThenFadeIn);
         
         RegisterCoreFunction (CoreFunctionIds.ID_World_CallScript,                          CallScript);
         RegisterCoreFunction (CoreFunctionIds.ID_World_ConditionCallScript,                 ConditionCallScript);
         RegisterCoreFunction (CoreFunctionIds.ID_World_CallBoolFunction,                          CallBoolFunction);
         RegisterCoreFunction (CoreFunctionIds.ID_World_ConditionCallBoolFunction,                 ConditionCallBoolFunction);
         RegisterCoreFunction (CoreFunctionIds.ID_World_CallScriptMultiTimes,                    CallScriptMultiTimes);
         RegisterCoreFunction (CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes,              CallBoolFunctionMultiTimes);
         
      // game / world / create
         
         RegisterCoreFunction (CoreFunctionIds.ID_World_CreateExplosion,                            CreateExplosion);
         
      // game / collision category
         
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_Assign,                                       AssignCollisionCategory);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_ConditionAssign,                              ConditionAssignCollisionCategory);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_SwapValues,                                   SwapCCatValues);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_IsNull,                                       IsNullCCat);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_Equals,                                       EqualsWith_CollisiontCategories);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_ToString,                                     CollisionCategoryToString);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_SetCollideInternally,                         SetCollisionCategoryCollideInternally);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_SetAsFriends,                                 SetCollisionCategoriesAsFriends);
         
      // game / entity
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_Assign,                      AssignEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_ConditionAssign,             ConditionAssignEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SwapValues,                  SwapEntityValues);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsNull,                      IsNullEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_Equals,                      EqualsWith_Entities);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_ToString,                    EntityToString);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetEntityId,                 GetEntityId);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetEntityByIdOffset,         GetAnotherEntityByIdOffset);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetTaskStatus,                         SetEntityTaskStatus);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsTaskSuccessed,                       IsEntityTaskSuccessed);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsTaskFailed,                          IsEntityTaskFailed);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsTaskUnfinished,                      IsEntityTaskUnfinished);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsShapeEntity,                    IsShapeEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsJointEntity,                    IsJointEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsTriggerEntity,                  IsTriggerEntity);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsVisible,                   IsEntityVisible);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetVisible,                  SetEntityVisible);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetAlpha,                    GetEntityAlpha);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetAlpha,                    SetEntityAlpha);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsEnabled,                   IsEntityEnabled);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetEnabled,                  SetEntityEnabled);
         
         
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetPosition,                 GetEntityPosition);
         //RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetPosition,                 SetEntityPosition);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetRotationByDegrees,        GetEntityRotationByDegrees);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetRotationByRadians,        GetEntityRotationByRadians);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint,        WorldPoint2EntityLocalPoint);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint,        EntityLocalPoint2WorldPoint);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsDestroyed,        IsEntityDestroyed);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_Destroy,        DestroyEntity);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_Coincided,        AreTwoEntitiesCoincided);
         
      // game / entity / shape
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsCircleShapeEntity,              IsCircleShapeEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsRectangleShapeEntity,           IsRectangleShapeEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsPolygonShapeEntity,             IsPolygonShapeEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsPolylineShapeEntity,            IsPolylineShapeEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsBombShapeEntitiy,               IsBombShapeEntitiy);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntitiy,        IsWorldBorderEntitiy);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetOriginalCIType,           GetShapeOriginalCIType);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetOriginalCIType,           SetShapeOriginalCIType);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetCIType,                   GetShapeCIType);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetCIType,                   SetShapeCIType);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetFilledColor,              GetShapeFilledColor);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetFilledColor,              SetShapeFilledColor);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB,           GetShapeFilledColorRGB);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB,           SetShapeFilledColorRGB);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled,            IsShapePhysicsEnabled);
         //RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetPhysicsEnabled,         SetShapePhysicsEnabled);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetCollisionCategory,        GetShapeCollisionCategory);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetCollisionCategory,        SetShapeCollisionCategory);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_IsSensor,                    IsSensorShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetAsSensor,                 SetShapeAsSensor);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_IsSleeping,                  IsShapeSleeping);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetSleeping,                 SetShapeSleeping);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetMass,                        GetShapeMass);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetInertia,                     GetShapeInertia);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetDensity,                     GetShapeDensity);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetLinearVelocity,                        SetShapeLinearVelocity);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetLinearVelocity,                        GetShapeLinearVelocity);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseByVelocityVector,       AddLinearImpulseByVelocityVector);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyStepForce,                        ApplyStepForceOnShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint,            ApplyStepForceAtLocalPointOnShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtWorldPoint,            ApplyStepForceAtWorldPointOnShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyStepTorque,                       ApplyStepTorque);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulse,                        ApplyLinearImpulseOnShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtLocalPoint,            ApplyLinearImpulseAtLocalPointOnShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtWorldPoint,            ApplyLinearImpulseAtWorldPointOnShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_ApplyAngularImpulse,                       ApplyAngularImpulse);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_Teleport,                      TeleportShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_TeleportOffsets,               TeleportShape_Offsets);
         //RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_Clone,                       CloneShape);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_Detach,                      DetachShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_AttachWith,                  AttachTwoShapes);
		   RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_DetachThenAttachWith,        DetachShapeThenAttachWithAnother);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_BreakupBrothers,             BreakupShapeBrothers);

         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_BreakAllJoints,             BreakShapeJoints);

      // game / entity / shape / text
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityText_GetText,                  GetTextFromTextComponent);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityText_SetText,                  SetTextForTextComponent);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityText_AppendText,               AppendTextToTextComponent);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityText_AppendNewLine,            AppendNewLineToTextComponent);
         
      // game / entity / shape / circle
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShapeCircle_GetRadius,            GetShapeCircleRadius);
         
      // game / entity / shape / rectangle
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShapeRectangle_GetSize,            GetShapeRectangleSize);
         
      // game / entity / shape / poly shapes
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShapePoly_GetVertexCount,                    GetVertexCount);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShapePoly_GetVertexLocalPosition,            GetVertexLocalPosition);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShapePoly_GetVertexWorldPosition,            GetVertexWorldPosition);
         
      // game / entity / joint
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_SetJointMotorEnabled,                      SetJointMotorEnabled);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_SetJointLimitsEnabled,                     SetJointLimitsEnabled);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_GetHingeAngleByDegrees,                      GetHingeAngleByDegrees);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees,                      GetHingeLimitsByDegrees);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees,                      SetHingeLimitsByDegrees);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_GetHingeMotorSpeed,                      GetHingeMotorSpeed);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_SetHingeMotorSpeed,                      SetHingeMotorSpeed);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_GetSliderTranslation,                     GetSliderTranslation);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_GetSliderLimits,                     GetSliderLimits);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_SetSliderLimits,                     SetSliderLimits);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_GetSliderMotorSpeed,                     GetSliderMotorSpeed);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_SetSliderMotorSpeed,                     SetSliderMotorSpeed);
         
      // game / entity / field
         
         
         
      // game / entity / event handler
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityTrigger_ResetTimer,                           ResetTimer);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityTrigger_SetTimerPaused,                       SetTimerPaused);
         //RegisterCoreFunction (CoreFunctionIds.ID_EntityTrigger_SetTimerInterval,                     SetTimerInterval);
         
      }
      
      private static function RegisterCoreFunction (functionId:int, callback:Function):void
      {
         if (functionId < 0 || functionId >= IdPool.NumPlayerFunctions)
            return;
         
         var func_decl:FunctionDeclaration = CoreFunctionDeclarations.GetCoreFunctionDeclaration (functionId);
         
         sCoreFunctionDefinitions [functionId] = new FunctionDefinition_Core (func_decl, callback);
      }
      
//===========================================================
// core function definitions
//===========================================================
      
   // for debug
      
      public static function ForDebug (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
   //*******************************************************************
   // global
   //*******************************************************************
         
      //public static function ReturnVoid (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   // do nothing, shouldn't run into here.
      //   // for CodeSnippet will return directly.
      //}
      
      //public static function ReturnIfTrue (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var value:Boolean = (valueSource.EvalateValueObject () as Boolean);
      //   
      //   valueTarget.AssignValueObject (value);
      //}
      
      //public static function ReturnIfFalse (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var value:Boolean = (valueSource.EvalateValueObject () as Boolean);
      //   
      //   valueTarget.AssignValueObject (! value);
      //}
      
      //public static function BreakVoid (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   // do nothing, shouldn't run into here
      //}
      
   //*******************************************************************
   // system / time
   //*******************************************************************
      
      public static function GetProgramMilliseconds (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (getTimer ());
      }
      
      public static function GetCurrentDateTime (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var date:Date = new Date ();
         
         valueTarget.AssignValueObject (date.getFullYear ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (date.getMonth () + 1);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (date.getDate ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (date.getHours ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (date.getMinutes ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (date.getSeconds ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (date.getMilliseconds ());
      }
      
      public static function IsKeyHold (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var keyCode:int = int (valueSource.EvalateValueObject ());
         
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().IsKeyHold (keyCode));
      }
      
   //*******************************************************************
   // string
   //*******************************************************************
      
      public static function AssignString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (value);
      }
      
      public static function ConditionAssignString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var condtion:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var string1:String = valueSource.EvalateValueObject () as String;
         
         valueSource = valueSource.mNextValueSourceInList;
         var string2:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (condtion ? string1 : string2);
      }
      
      public static function SwapStringValues (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var text1:String = valueSource.EvalateValueObject () as String;
         
         var source1:ValueSource = valueSource;
         
         valueSource = valueSource.mNextValueSourceInList;
         var text2:String = valueSource.EvalateValueObject () as String;
         
         if (source1 is ValueSource_Variable)
            (source1 as ValueSource_Variable).GetVariableInstance ().SetValueObject (text2);
         
         if (valueSource is ValueSource_Variable)
            (valueSource as ValueSource_Variable).GetVariableInstance ().SetValueObject (text1);
      }
      
      public static function IsNullString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var text:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (text == null);
      }
      
      public static function AddTwoStrings (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:String = valueSource.EvalateValueObject () as String;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (value1 + value2);
      }
      
      public static function GetStringLength (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (value == null ? 0 : value.length);
      }
      
      public static function StringCharAt (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var text:String = valueSource.EvalateValueObject () as String;
         
         valueSource = valueSource.mNextValueSourceInList;
         var index:int = int (valueSource.EvalateValueObject ());
         
         if (text == null || index < 0 || index >= text.length)
         {
            valueTarget.AssignValueObject (null);
            return;
         }
         
         valueTarget.AssignValueObject (text.charAt (index));
      }
      
      public static function StringCharCodeAt (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var text:String = valueSource.EvalateValueObject () as String;
         
         valueSource = valueSource.mNextValueSourceInList;
         var index:int = int (valueSource.EvalateValueObject ());
         
         if (text == null || index < 0 || index >= text.length)
         {
            valueTarget.AssignValueObject (0);
            return;
         }
         
         valueTarget.AssignValueObject (text.charCodeAt (index));
      }
      
      public static function CharCode2Char (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var char_code:int = int (valueSource.EvalateValueObject ());
         
         valueTarget.AssignValueObject (char_code == 0 ? "" : String.fromCharCode (char_code));
      }
      
      public static function ToLowerCase (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var text:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (text == null ? null : text.toLowerCase ());
      }
      
      public static function ToUpperCase (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var text:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (text == null ? null : text.toUpperCase ());
      }
      
      public static function NumberToString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value.toString (10));
      }
      
      //public static function NumberToExponentialString (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var value:Number = valueSource.EvalateValueObject () as Number;
      //   
      //   valueSource = valueSource.mNextValueSourceInList;
      //   var fractionDigits:int = int (valueSource.EvalateValueObject ());
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
      
      public static function NumberToFixedString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var fractionDigits:int = int (valueSource.EvalateValueObject ());
         
         if (fractionDigits < 0 || fractionDigits > 20)
            valueTarget.AssignValueObject (null);
         else
         {
            //valueTarget.AssignValueObject (value.toFixed (fractionDigits));
            valueTarget.AssignValueObject (ValueAdjuster.Number2FixedString (value, fractionDigits));
         }
      }
      
      public static function NumberToPrecisionString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var precision:int = int (valueSource.EvalateValueObject ());
         
         if (precision < 1 || precision > 21)
            valueTarget.AssignValueObject (null);
         else
         {
            //valueTarget.AssignValueObject (value.toPrecision (precision));
            valueTarget.AssignValueObject (ValueAdjuster.Number2PrecisionString (value, precision));
         }
      }
      
      public static function NumberToStringByRadix (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var radix:int = int (valueSource.EvalateValueObject ());
         
         if (radix < 2 || radix > 36)
            valueTarget.AssignValueObject (null);
         else
            valueTarget.AssignValueObject (value.toString (radix));
      }
      
      public static function ParseFloat (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var text:String = String (valueSource.EvalateValueObject ());
         
         valueTarget.AssignValueObject (parseFloat (text));
      }
      
      public static function ParseInteger (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var text:String = String (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var radix:int = int (valueSource.EvalateValueObject ());
         
         if (radix < 2 || radix > 36)
            valueTarget.AssignValueObject (NaN);
         else
            valueTarget.AssignValueObject (parseInt (text, radix));
      }
      
      public static function BooleanToString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (String (value));
      }
      
      public static function EntityToString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         valueTarget.AssignValueObject (entity == null ? "null" : "Entity#" + entity.GetCreationId ());
      }
      
      public static function CollisionCategoryToString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var ccat:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueTarget.AssignValueObject ("CollisionCategory#" + (ccat == null ? -1 : ccat.GetIndexInEditor ()));
      }
      
   //************************************************
   // bool
   //************************************************
      
      public static function AssignBoolean (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (value);
      }
      
      public static function ConditionAssignBoolean (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var condtion:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var bool1:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bool2:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (condtion ? bool1 : bool2);
      }
      
      public static function SwapBooleanValues (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var bool1:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         var source1:ValueSource = valueSource;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bool2:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         if (source1 is ValueSource_Variable)
            (source1 as ValueSource_Variable).GetVariableInstance ().SetValueObject (bool2);
         
         if (valueSource is ValueSource_Variable)
            (valueSource as ValueSource_Variable).GetVariableInstance ().SetValueObject (bool1);
      }
      
      public static function BooleanInvert (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (! value);
      }
      
      public static function IsTrue (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (value);
      }
      
      public static function IsFalse (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (! value);
      }
      
      public static function EqualsWith_Numbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         var dv:Number = value1 - value2;
         
         valueTarget.AssignValueObject (- Number.MIN_VALUE < dv && dv < Number.MIN_VALUE);
      }
      
      public static function EqualsWith_Booleans (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (value1 == value2);
      }
      
      public static function EqualsWith_Entities (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Entity = valueSource.EvalateValueObject () as Entity;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Entity = valueSource.EvalateValueObject () as Entity;
         
         valueTarget.AssignValueObject (value1 == value2);
      }
      
      public static function EqualsWith_Strings (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:String = valueSource.EvalateValueObject () as String;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (value1 == value2);
      }
      
      public static function EqualsWith_CollisiontCategories (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueTarget.AssignValueObject (value1 == value2);
      }
      
      public static function LargerThan (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         var dv:Number = value1 - value2;
         
         valueTarget.AssignValueObject (dv >= Number.MIN_VALUE);
      }
      
      public static function LessThan (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         var dv:Number = value1 - value2;
         
         valueTarget.AssignValueObject (dv <= - Number.MIN_VALUE);
      }
      
      public static function BoolAnd (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (value1 && value2);
      }
      
      public static function BoolOr (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (value1 || value2);
      }
      
      public static function BoolNot (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (! value);
      }
      
      public static function BoolXor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (value1 != value2);
      }
      
   //************************************************
   // math
   //************************************************
      
      // + - * / x=y -x 
      
      public static function AssignNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value);
      }
      
      public static function ConditionAssignNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var contionResult:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var trueValue:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var falseValue:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (contionResult ? trueValue : falseValue);
      }
      
      public static function SwapNumberValues (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var number1:Number = Number (valueSource.EvalateValueObject ());
         
         var source1:ValueSource = valueSource;
         
         valueSource = valueSource.mNextValueSourceInList;
         var number2:Number = Number (valueSource.EvalateValueObject ());
         
         if (source1 is ValueSource_Variable)
            (source1 as ValueSource_Variable).GetVariableInstance ().SetValueObject (number2);
         
         if (valueSource is ValueSource_Variable)
            (valueSource as ValueSource_Variable).GetVariableInstance ().SetValueObject (number1);
      }
      
      public static function IsNaN (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (isNaN (value));
      }
      
      public static function IsInfinity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (! isFinite (value));
      }
      
      public static function NegativeNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (-value);
      }
      
      public static function AddTwoNumbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value1 + value2);
      }
      
      public static function SubtractTwoNumbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value1 - value2);
      }
      
      public static function MultiplyTwoNumbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value1 * value2);
      }
      
      public static function DivideTwoNumbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value1 / value2);
      }
      
      public static function ModuloTwoNumbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value1 % value2);
      }
      
      // bitwise
      
      public static function ShiftLeft (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var numBitsToShift:int = int (valueSource.EvalateValueObject () as Number);
         
         value <<= numBitsToShift;
         valueTarget.AssignValueObject (value);
      }
      
      public static function ShiftRight (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var numBitsToShift:int = int (valueSource.EvalateValueObject () as Number);
         
         value >>= numBitsToShift;
         valueTarget.AssignValueObject (value);
      }
      
      public static function ShiftRightUnsigned (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var numBitsToShift:int = int (valueSource.EvalateValueObject () as Number);
         
         value >>>= numBitsToShift;
         valueTarget.AssignValueObject (value);
      }
      
      public static function BitwiseAnd (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Number(value1 & value2));
      }
      
      public static function BitwiseOr (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Number(value1 | value2));
      }
      
      public static function BitwiseNot (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Number(~value));
      }
      
      public static function BitwiseXor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Number(value1 ^ value2));
      }
      
      // sin, cos, tan, asin, acos, atan, atan2
      
      public static function SinRadian (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.sin (value));
      }
      
      public static function CosRadian (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.cos (value));
      }
      
      public static function TanRadian (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.tan (value));
      }
      
      public static function AsinRadian (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.asin (value));
      }
      
      public static function AcosRadian (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.acos (value));
      }
      
      public static function AtanRadian (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.atan (value));
      }
      
      public static function AtanRadianTwoNumbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.atan2 (value1, value2));
      }
      
      // random
      
      public static function RandomNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Math.random ());
      }
      
      public static function RandomNumberRange (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value1 + (value2 - value1) * Math.random ());
      }
      
      public static function RandomIntegerRange (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:int = Math.round (valueSource.EvalateValueObject () as Number);
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:int = Math.round (valueSource.EvalateValueObject () as Number);
         
         var r:Number = value1 + (value2 - value1) * Math.random ();
         valueTarget.AssignValueObject (value1 < value2 ? Math.floor (r) : Math.ceil (r));
      }
      
      public static function RngCreate (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var rngSlot:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var rngMethod:int = int (valueSource.EvalateValueObject ());
         
         Global.CreateRandomNumberGenerator (rngSlot, rngMethod);
      }
      
      public static function RngSetSeed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var rngSlot:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var seedId:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var seed:uint = uint (valueSource.EvalateValueObject ());
         
         Global.GetRandomNumberGenerator (rngSlot).SetSeed (seedId, seed);
      }
      
      public static function RngRandom (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var rngSlot:int = int (valueSource.EvalateValueObject ());
         
         valueTarget.AssignValueObject (Global.GetRandomNumberGenerator (rngSlot).NextFloat ());
      }
      
      public static function RngRandomNumberRange (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var rngSlot:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value1 + (value2 - value1) * Global.GetRandomNumberGenerator (rngSlot).NextFloat ());
      }
      
      public static function RngRandomIntegerRange (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var rngSlot:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var value1:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:int = int (valueSource.EvalateValueObject ());
         
         valueTarget.AssignValueObject (Global.GetRandomNumberGenerator (rngSlot).NextIntegerBetween (value1, value2));
      }
      
      // degree <-> radian
      
      public static function Degrees2Radians (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value * Define.kDegrees2Radians);
      }
      
      public static function Radians2Degrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value * Define.kRadians2Degrees);
      }
      
      public static function Number2RGB (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var color:int = (valueSource.EvalateValueObject () as Number) & 0xFFFFFFFF;
         
         valueTarget.AssignValueObject ((color >> 16) & 0xFF);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject ((color >> 8) & 0xFF);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject ((color >> 0) & 0xFF);
      }
      
      public static function RGB2Number (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var red:int = (valueSource.EvalateValueObject () as Number) & 0xFF;
         
         valueSource = valueSource.mNextValueSourceInList;
         var green:int = (valueSource.EvalateValueObject () as Number) & 0xFF;
         
         valueSource = valueSource.mNextValueSourceInList;
         var blue:Number = (valueSource.EvalateValueObject () as Number) & 0xFF;
         
         valueTarget.AssignValueObject ((red << 16) | (green << 8) | (blue));
      }
      
      public static function MillisecondsToMinutesSeconds (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var millseconds:int = valueSource.EvalateValueObject () as Number;
         
         var minutes:int = millseconds / 60000;
         millseconds -= minutes * 60000;
         var seconds:int = millseconds / 1000;
         millseconds -= seconds * 1000;
         
         valueTarget.AssignValueObject (Number (minutes));
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (Number (seconds));
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (Number (millseconds));
      }
      
      // invert 
      
      public static function InverseNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (1.0 / value);
      }
      
      // max, min
      
      public static function MaxOfTwoNumbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.max (value1, value2));
      }
      
      public static function MinOfTwoNumbers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.min (value1, value2));
      }
      
      // abs, sqrt, ceil, floor, round, log, exp
      
      public static function AbsNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.abs (value));
      }
      
      public static function SqrtNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.sqrt (value));
      }
      
      public static function CeilNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.ceil (value));
      }
      
      public static function FloorNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.floor (value));
      }
      
      public static function RoundNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.round (value));
      }
      
      public static function LogNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.log (value));
      }
      
      public static function ExpNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.exp (value));
      }
      
      public static function Power (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (Math.pow (value1, value2));
      }
      
      public static function Clamp (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var limit1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var limit2:Number = valueSource.EvalateValueObject () as Number;
         
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
      
      public static function LinearInterpolation (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var factor:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value1 * factor + (1.0 - factor) * value2);
      }
      
      public static function LinearInterpolationColor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var factor:Number = valueSource.EvalateValueObject () as Number;
         var factor2:Number = 1.0 - factor;
         
         var red  :int = ((value1 >> 16) & 0xFF) * factor + ((value2 >> 16) & 0xFF) * factor2;
         var green:int = ((value1 >>  8) & 0xFF) * factor + ((value2 >>  8) & 0xFF) * factor2;
         var blue :int = ((value1 >>  0) & 0xFF) * factor + ((value2 >>  0) & 0xFF) * factor2;
         
         valueTarget.AssignValueObject ((red << 16) | (green << 8) | (blue));
      }
      
      
   //*******************************************************************
   // game / design
   //*******************************************************************
      
      public static function RestartLevel (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         Global.RestartPlay ();
      }
      
      public static function IsLevelPaused (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (! Global.IsPlaying ());
      }
      
      public static function SetLevelPaused (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var paused:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         Global.SetPlaying (! paused);
      }
      
      public static function GetPlaySpeedX (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetSpeedX ());
      }
      
      public static function SetPlaySpeedX (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var speedX:int = int (valueSource.EvalateValueObject ());
         if (speedX < 0)
            speedX = 0;
         else if (speedX > 9)
            speedX = 9;
         
         Global.SetSpeedX (speedX);
      }
      
      public static function GetWorldScale (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetScale());
      }
      
      public static function SetWorldScale (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var scale:Number = Number (valueSource.EvalateValueObject ());
         if (scale < 0.0625)
            scale = 0.0625;
         else if (scale > 16.0)
            scale = 16.0;
         
         Global.SetScale (scale);
      }
      
      public static function GetLevelMilliseconds (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().GetLevelMilliseconds ());
      }
      
      public static function GetLevelSteps (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().GetLevelSteps ());
      }
      
      public static function GetWorldMousePosition (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCurrentMouseX ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCurrentMouseY ());
      }
      
      public static function IsMouseButtonHold (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().IsMouseButtonDown ());
      }
      
      public static function SetLevelStatus (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         switch (int (valueSource.EvalateValueObject ()))
         {
            case ValueDefine.LevelStatus_Failed:
               Global.GetCurrentDesign ().SetLevelFailed ();
               break;
            case ValueDefine.LevelStatus_Successed:
               Global.GetCurrentDesign ().SetLevelSuccessed ();
               break;
            case ValueDefine.LevelStatus_Unfinished:
               Global.GetCurrentDesign ().SetLevelUnfinished ();
               break;
            default:
               break;
         }
      }
      
      public static function IsLevelSuccessed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().IsLevelSuccessed ());
      }
      
      public static function IsLevelFailed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().IsLevelFailed ());
      }
      
      public static function IsLevelUnfinished (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().IsLevelUnfinished ());
      }
      
   //*******************************************************************
   // game / world
   //*******************************************************************
      
      public static function SetWorldGravityAcceleration_Radians (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var magnitude:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var radians:Number = (valueSource.EvalateValueObject () as Number) % 360.0;
         
         Global.GetCurrentWorld ().SetCurrentGravityAcceleration (magnitude * Math.cos (radians), magnitude * Math.sin (radians));
      }
      
      public static function SetWorldGravityAcceleration_Degrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var magnitude:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var radians:Number = ((valueSource.EvalateValueObject () as Number) % 360.0) * Define.kDegrees2Radians;
         
         Global.GetCurrentWorld ().SetCurrentGravityAcceleration (magnitude * Math.cos (radians), magnitude * Math.sin (radians));
      }
      
      public static function SetWorldGravityAcceleration_Vector (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var gaX:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var gaY:Number = valueSource.EvalateValueObject () as Number;
         
         Global.GetCurrentWorld ().SetCurrentGravityAcceleration (gaX, gaY);
      }
      
      public static function GetCameraCenter (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCameraCenterPhysicsX ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetCameraCenterPhysicsY ());
      }
      
      public static function FollowCameraWithShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         //if (shape == null)
         //   return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var isSmooth:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         //valueSource = valueSource.mNextValueSourceInList;
         //var folowRotation:Boolean = valueSource.EvalateValueObject () as Boolean;
         var folowRotation:Boolean = false;
         
         Global.GetCurrentWorld ().FollowCameraWithEntity (shape, isSmooth, folowRotation);
      }
      
      public static function FollowCameraCenterXWithShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         //if (shape == null)
         //   return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var isSmooth:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         Global.GetCurrentWorld ().FollowCameraCenterXWithEntity (shape, isSmooth);
      }
      
      public static function FollowCameraCenterYWithShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         //if (shape == null)
         //   return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var isSmooth:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         Global.GetCurrentWorld ().FollowCameraCenterYWithEntity (shape, isSmooth);
      }
      
      //public static function FollowCameraRotationRotationWithShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
      //   if (shape == null)
      //      return;
      //   
      //   valueSource = valueSource.mNextValueSourceInList;
      //   var isSmooth:Boolean = valueSource.EvalateValueObject () as Boolean;
      //   
      //   Global.GetCurrentWorld ().FollowCameraRotationWithEntity (shape, isSmooth);
      //}
      
      public static function CameraFadeOutThenFadeIn (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var fadeColor:uint = uint (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var stepsFadeOut:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var stepsFadeStaying:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var stepsFadeIn:int = int (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var scriptToRun:ScriptHolder = valueSource.EvalateValueObject () as ScriptHolder;
         
         Global.GetCurrentWorld ().CameraFadeOutThenFadeIn (fadeColor, stepsFadeOut, stepsFadeIn, stepsFadeStaying, scriptToRun);
      }
      
      public static function CallScript (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var scriptToRun:ScriptHolder = valueSource.EvalateValueObject () as ScriptHolder;
         
         if (scriptToRun != null)
            scriptToRun.RunScript ();
      }
      
      public static function ConditionCallScript (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var condtion:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var script1:ScriptHolder = valueSource.EvalateValueObject () as ScriptHolder;
         
         valueSource = valueSource.mNextValueSourceInList;
         var script2:ScriptHolder = valueSource.EvalateValueObject () as ScriptHolder;
         
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
      
      public static function CallBoolFunction (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var boolFunction:EntityBasicCondition = valueSource.EvalateValueObject () as EntityBasicCondition;
         
         valueTarget.AssignValueObject (boolFunction == null ? false : boolFunction.RunBoolFunction ());
      }
      
      public static function ConditionCallBoolFunction  (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var condtion:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var boolFunction1:EntityBasicCondition = valueSource.EvalateValueObject () as EntityBasicCondition;
         
         valueSource = valueSource.mNextValueSourceInList;
         var boolFunction2:EntityBasicCondition = valueSource.EvalateValueObject () as EntityBasicCondition;
         
         if (condtion)
            valueTarget.AssignValueObject (boolFunction1 == null ? false : boolFunction1.RunBoolFunction ());
         else
            valueTarget.AssignValueObject (boolFunction2 == null ? false : boolFunction2.RunBoolFunction ());
      }
      
      public static function CallScriptMultiTimes (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var scriptToRun:ScriptHolder = valueSource.EvalateValueObject () as ScriptHolder;
         
         valueSource = valueSource.mNextValueSourceInList;
         var times:int = int (valueSource.EvalateValueObject ());
         
         while (-- times >= 0)
            scriptToRun.RunScript ();
      }
      
      public static function CallBoolFunctionMultiTimes (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var boolFunction:EntityBasicCondition = valueSource.EvalateValueObject () as EntityBasicCondition;
         
         if (boolFunction != null)
         {
            while (boolFunction.RunBoolFunction ());
         }
      }
      
   //*******************************************************************
   // game / world / create
   //*******************************************************************
      
      public static function CreateExplosion (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var worldX:Number = Number (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var worldY:Number = Number (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var numParticles:int = int (valueSource.EvalateValueObject ());
         if (numParticles > Define.MaxNumParticls_CreateExplosion)
            numParticles = Define.MaxNumParticls_CreateExplosion;
         else if (numParticles < Define.MinNumParticls_CreateExplosion)
            numParticles = Define.MinNumParticls_CreateExplosion;
         
         valueSource = valueSource.mNextValueSourceInList;
         var lifeSteps:int = int (valueSource.EvalateValueObject ());
         if (lifeSteps < 0)
            lifeSteps = 0;
         
         valueSource = valueSource.mNextValueSourceInList;
         var density:Number = Number (valueSource.EvalateValueObject ());
         if (density < 0.0)
            density = 0.0;
         
         valueSource = valueSource.mNextValueSourceInList;
         var restitution:Number = Number (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var speed:Number = Number (valueSource.EvalateValueObject ());
         if (speed < 0.0)
            speed = - speed;
         
         valueSource = valueSource.mNextValueSourceInList;
         var color:uint = uint (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var visible:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var cat:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         numParticles = Global.GetCurrentWorld ().CreateExplosion (worldX, worldY, cat, numParticles, lifeSteps * Define.WorldStepTimeInterval_SpeedX1, density, restitution, speed, 1.0, color, visible);
         
         valueTarget.AssignValueObject (numParticles);
      }
      
   //*******************************************************************
   // game collision category
   //*******************************************************************
      
      public static function AssignCollisionCategory (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var cat:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueTarget.AssignValueObject (cat);
      }
      
      public static function ConditionAssignCollisionCategory (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var condtion:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var cat1:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueSource = valueSource.mNextValueSourceInList;
         var cat2:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueTarget.AssignValueObject (condtion ? cat1 : cat2);
      }
      
      public static function SwapCCatValues (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var ccat1:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         var source1:ValueSource = valueSource;
         
         valueSource = valueSource.mNextValueSourceInList;
         var ccat2:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         if (source1 is ValueSource_Variable)
            (source1 as ValueSource_Variable).GetVariableInstance ().SetValueObject (ccat2);
         
         if (valueSource is ValueSource_Variable)
            (valueSource as ValueSource_Variable).GetVariableInstance ().SetValueObject (ccat1);
      }
      
      public static function IsNullCCat (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var ccat:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueTarget.AssignValueObject (ccat == null);
      }
      
      public static function SetCollisionCategoryCollideInternally (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var cat:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueSource = valueSource.mNextValueSourceInList;
         var collideInternally:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         Global.GetCurrentWorld ().BreakOrCreateCollisionCategoryFriendLink (cat, cat, collideInternally);
      }
      
      public static function SetCollisionCategoriesAsFriends (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var cat1:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueSource = valueSource.mNextValueSourceInList;
         var cat2:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueSource = valueSource.mNextValueSourceInList;
         var asFriends:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         Global.GetCurrentWorld ().BreakOrCreateCollisionCategoryFriendLink (cat1, cat2, ! asFriends);
      }
      
   //*******************************************************************
   // game entity
   //*******************************************************************
      
      public static function AssignEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         valueTarget.AssignValueObject (entity);
      }
      
      public static function ConditionAssignEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var condition:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var entity1:Entity = valueSource.EvalateValueObject () as Entity;
         
         valueSource = valueSource.mNextValueSourceInList;
         var entity2:Entity = valueSource.EvalateValueObject () as Entity;
         
         valueTarget.AssignValueObject (condition ? entity1 : entity2);
      }
      
      public static function SwapEntityValues(valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity1:Entity = valueSource.EvalateValueObject () as Entity;
         
         var source1:ValueSource = valueSource;
         
         valueSource = valueSource.mNextValueSourceInList;
         var entity2:Entity = valueSource.EvalateValueObject () as Entity;
         
         if (source1 is ValueSource_Variable)
            (source1 as ValueSource_Variable).GetVariableInstance ().SetValueObject (entity2);
         
         if (valueSource is ValueSource_Variable)
            (valueSource as ValueSource_Variable).GetVariableInstance ().SetValueObject (entity1);
      }
      
      public static function IsNullEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         valueTarget.AssignValueObject (entity == null);
      }
      
      public static function GetEntityId (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (Define.EntityId_None);
         }
         else
         {
            valueTarget.AssignValueObject (entity.GetCreationId ());
         }
      }
      
      public static function GetAnotherEntityByIdOffset (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var baseEntity:Entity = valueSource.EvalateValueObject () as Entity;
         if (baseEntity == null || baseEntity.GetCreationId () < 0)
         {
            valueTarget.AssignValueObject (null);
         }
         else
         {
            valueSource = valueSource.mNextValueSourceInList;
            var idOffset:int = int (valueSource.EvalateValueObject ());
            
            valueTarget.AssignValueObject (Global.GetCurrentWorld ().GetEntityByCreationId (baseEntity.GetCreationId () + idOffset));
         }
      }
      
      public static function SetEntityTaskStatus (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         switch (int (valueSource.EvalateValueObject ()))
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
      
      public static function IsEntityTaskSuccessed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var succeeded:Boolean = entity == null ? false : entity.IsTaskSuccessed ();
         
         valueTarget.AssignValueObject (succeeded);
      }
      
      public static function IsEntityTaskFailed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var failed:Boolean = entity == null ? false : entity.IsTaskFailed ();
         
         valueTarget.AssignValueObject (failed);
      }
      
      public static function IsEntityTaskUnfinished (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var unfinished:Boolean = entity == null ? true : entity.IsTaskUnfinished ();
         
         valueTarget.AssignValueObject (unfinished);
      }
      
      public static function IsShapeEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         valueTarget.AssignValueObject (shape != null);
      }
      
      public static function IsJointEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var joint:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         valueTarget.AssignValueObject (joint != null);
      }
      
      public static function IsTriggerEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var trigger:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         valueTarget.AssignValueObject (trigger != null);
      }
      
      public static function IsEntityVisible (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var visible:Boolean = entity == null ? false : entity.IsVisible ();
         valueTarget.AssignValueObject (visible);
      }
      
      public static function SetEntityVisible (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var visible:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         entity.SetVisible (visible);
      }
      
      public static function GetEntityAlpha (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var alpha:Number = entity == null ? 1.0 : entity.GetAlpha ();
         
         valueTarget.AssignValueObject (alpha);
      }
      
      public static function SetEntityAlpha (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var alpha:Number = valueSource.EvalateValueObject () as Number;
         
         entity.SetAlpha (alpha);
      }
      
      public static function IsEntityEnabled (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var enabled:Boolean = entity == null ? false : entity.IsEnabled ();
         valueTarget.AssignValueObject (enabled);
      }
      
      public static function SetEntityEnabled (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null || entity.IsDestroyedAlready ())
            return;
         
         // move into SetEnabled
         // if (! entity.CanBeDisabled ())
         //    return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var enabled:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         entity.SetEnabled (enabled);
      }
      
      public static function GetEntityPosition (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
         {
            // error 
            
            valueTarget.AssignValueObject (0.0);
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (0.0);
            
            return;
         }
         
         valueTarget.AssignValueObject (entity.GetPositionX ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (entity.GetPositionY ());
      }
      
      //public static function SetEntityPosition (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
      //   if (shape == null)
      //      return;
      //   
      //   if (entity.IsDestroyedAlready ())
      //      return;
      //   
      //   valueSource = valueSource.mNextValueSourceInList;
      //   var pos_x:Number = valueSource.EvalateValueObject () as Number;
      //   
      //   valueSource = valueSource.mNextValueSourceInList;
      //   var pos_y:Number = valueSource.EvalateValueObject () as Number;
      //   
      //   shape.MoveTo (pos_x, pos_y);
      //}
      
      public static function GetEntityRotationByRadians (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (0.0);
            
            return;
         }
         
         valueTarget.AssignValueObject (entity.GetRotation ());
      }
      
      //public static function SetEntityRotationByRadians (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var entity:Entity = valueSource.EvalateValueObject () as Entity;
      //   if (entity == null)
      //      return;
      //   
      //   valueTarget.AssignValueObject (entity.GetRotation ());
      //}
      
      public static function GetEntityRotationByDegrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (0.0);
            
            return;
         }
         
         valueTarget.AssignValueObject (entity.GetRotation () * Define.kRadians2Degrees);
      }
      
      //public static function SetEntityRotationByDegrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var entity:Entity = valueSource.EvalateValueObject () as Entity;
      //   if (entity == null)
      //      return;
      //   
      //   valueSource = valueSource.mNextValueSourceInList;
      //   var degrees:Number = valueSource.EvalateValueObject () as Number;
      //   
      //   entity.SetRotation (degrees * Define.kDegrees2Radians);
      //}
      
      public static function WorldPoint2EntityLocalPoint (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var localPoint:Point = sPoint;
         
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
         {
            localPoint.x = 0.0;
            localPoint.y = 0.0;
         }
         else
         {
            valueSource = valueSource.mNextValueSourceInList;
            var world_x:Number = valueSource.EvalateValueObject () as Number;
            
            valueSource = valueSource.mNextValueSourceInList;
            var world_y:Number = valueSource.EvalateValueObject () as Number;
            
            shape.WorldPoint2LocalPoint (world_x, world_y, localPoint);
         }
         
         // ...
         
         valueTarget.AssignValueObject (localPoint.x);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (localPoint.y);
      }
      
      public static function EntityLocalPoint2WorldPoint (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var worldPoint:Point = sPoint;
         
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
         {
            worldPoint.x = 0.0;
            worldPoint.y = 0.0;
         }
         else
         {
            valueSource = valueSource.mNextValueSourceInList;
            var local_x:Number = valueSource.EvalateValueObject () as Number;
            
            valueSource = valueSource.mNextValueSourceInList;
            var local_y:Number = valueSource.EvalateValueObject () as Number;
            
            shape.LocalPoint2WorldPoint (local_x, local_y, worldPoint);
         }
         
         // ...
         
         valueTarget.AssignValueObject (worldPoint.x);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (worldPoint.y);
      }
      
      public static function IsEntityDestroyed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
         {
            valueTarget.AssignValueObject (false);
         }
         else
         {
            valueTarget.AssignValueObject (entity.IsDestroyedAlready ());
         }
      }
      
      public static function DestroyEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         if (entity.IsDestroyedAlready ())
            return;
         
         var body:EntityBody = null;
         if (entity is EntityShape)
         {
            var shape:EntityShape = entity as EntityShape;
            if (shape.IsPhysicsShape ())
               body = shape.GetBody ();
         }
         
         entity.DestroyEntity ();
         
         if (body != null)
         {
            body.OnPhysicsShapeListChanged ();
         }
      }
      
      public static function AreTwoEntitiesCoincided (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity1:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity1 == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var entity2:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity2 == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var toleranceDx:Number = Number (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var toleranceDy:Number = Number (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var toleranceDr:Number = Number (valueSource.EvalateValueObject ());
         
         var dx:Number = entity1.GetPositionX () - entity2.GetPositionX ();
         var dy:Number = entity1.GetPositionY () - entity2.GetPositionY ();
         var dr:Number = ((entity1.GetRotation () - entity2.GetRotation ()) * Define.kRadians2Degrees) % 360;
         if (dx < 0) dx = -dx;
         if (dy < 0) dy = -dy;
         if (dr < 0) dr = -dr;
         if (dr < 0) dr = -dr;
         if (dr > 180) dr = 360 - dr;
         
         var coincided:Boolean = dx < toleranceDx && dy < toleranceDy && dr < toleranceDr;
         
         valueTarget.AssignValueObject (coincided);
      }
      
   //*******************************************************************
   // entity / shape
   //*******************************************************************
      
      public static function IsCircleShapeEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShapeCircle = valueSource.EvalateValueObject () as EntityShapeCircle;
         
         valueTarget.AssignValueObject (shape != null); 
      }
      
      public static function IsRectangleShapeEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShapeRectangle = valueSource.EvalateValueObject () as EntityShapeRectangle;
         
         valueTarget.AssignValueObject (shape != null); 
      }
      
      public static function IsPolygonShapeEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShapePolygon = valueSource.EvalateValueObject () as EntityShapePolygon;
         
         valueTarget.AssignValueObject (shape != null); 
      }
      
      public static function IsPolylineShapeEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShapePolyline = valueSource.EvalateValueObject () as EntityShapePolyline;
         
         valueTarget.AssignValueObject (shape != null); 
      }
      
      public static function IsBombShapeEntitiy (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape
         
         valueTarget.AssignValueObject (shape is EntityShape_CircleBomb || shape is EntityShape_RectangleBomb); 
      }
      
      public static function IsWorldBorderEntitiy (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape_WorldBorder = valueSource.EvalateValueObject () as EntityShape_WorldBorder;
         
         valueTarget.AssignValueObject (shape != null); 
      }
      
      // ...
      
      public static function GetShapeOriginalCIType (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var aiType:int = shape == null ? Define.ShapeAiType_Unknown : shape.GetOriginalShapeAiType ();
         valueTarget.AssignValueObject (aiType);
      }
      
      public static function SetShapeOriginalCIType (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         if (! shape.IsAiTypeChangeable ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var ciType:int = uint (valueSource.EvalateValueObject ());
         
         shape.SetOriginalShapeAiType (ciType);
      }
      
      public static function GetShapeCIType (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var aiType:int = shape == null ? Define.ShapeAiType_Unknown : shape.GetShapeAiType ();
         valueTarget.AssignValueObject (aiType);
      }
      
      public static function SetShapeCIType (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         if (! shape.IsAiTypeChangeable ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var ciType:int = uint (valueSource.EvalateValueObject ());
         
         shape.SetShapeAiType (ciType);
      }
      
      public static function GetShapeFilledColor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var filledColor:uint;
         
         if (shape == null)
         {
            var world:World = valueSource.EvalateValueObject () as World;
            if (world != null)
               filledColor = world.GetBackgroundColor ();
         }
         else
         {
            filledColor = shape.GetFilledColor ();
         }
         
         valueTarget.AssignValueObject (filledColor);
      }
      
      public static function SetShapeFilledColor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var world:World;
         if (shape == null)
         {
            world = valueSource.EvalateValueObject () as World;
            if (world == null)
               return;
         }
         
         valueSource = valueSource.mNextValueSourceInList;
         var color:uint = uint (valueSource.EvalateValueObject ());
         
         if (shape == null)
         {
            world.SetBackgroundColor (color);
         }
         else
         {
            shape.SetFilledColor (color);
         }
      }
      
      public static function GetShapeFilledColorRGB (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var filledColor:uint;
         
         if (shape == null)
         {
            var world:World = valueSource.EvalateValueObject () as World;
            if (world != null)
               filledColor = world.GetBackgroundColor ();
         }
         else
         {
            filledColor = shape.GetFilledColor ();
         }
         
         valueTarget.AssignValueObject ((filledColor >> 16) & 0xFF);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject ((filledColor >> 8) & 0xFF);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject ((filledColor >> 0) & 0xFF);
      }
      
      public static function SetShapeFilledColorRGB (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var world:World;
         if (shape == null)
         {
            world = valueSource.EvalateValueObject () as World;
            if (world == null)
               return;
         }
         
         valueSource = valueSource.mNextValueSourceInList;
         var red:int =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var green:int =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var blue:int =  valueSource.EvalateValueObject () as Number;
         
         if (shape == null)
         {
            world.SetBackgroundColor ((red << 16) | (green << 8) | (blue));
         }
         else
         {
            shape.SetFilledColor ((red << 16) | (green << 8) | (blue));
         }
      }
      
      public static function IsShapePhysicsEnabled (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var enabled:Boolean = shape == null ? false : shape.IsPhysicsShape ();
         valueTarget.AssignValueObject (enabled);
      }
      
      //public static function SetShapePhysicsEnabled (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
         //if (shape.IsDestroyedAlready ())
         //   return;
         //
      //}
      
      public static function GetShapeCollisionCategory (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var ccat:CollisionCategory = shape == null ? null : shape.GetCollisionCategory ();
         valueTarget.AssignValueObject (ccat);
      }
      
      public static function SetShapeCollisionCategory (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         //if (shape.IsDestroyedAlready ())
         //   return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var ccat:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         //if (ccat == null)
         //   return;
         
         shape.SetCollisionCategory (ccat);
      }
      
      public static function IsSensorShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var sensor:Boolean = shape == null ? false : shape.IsSensor ();
         valueTarget.AssignValueObject (sensor);
      }
      
      public static function SetShapeAsSensor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var sensor:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         shape.SetAsSensor (sensor);
      }
      
      public static function IsShapeSleeping (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         if (shape == null || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (false);
         else
         {
            var body:EntityBody = shape.GetBody ();
            
            valueTarget.AssignValueObject (body.IsSleeping ());
         }
      }
      
      public static function SetShapeSleeping (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var sleeping:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         shape.GetBody ().SetSleeping (sleeping);
      }
      
      public static function GetShapeMass (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         if (shape == null || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (0.0);
         else
         {
            valueSource = valueSource.mNextValueSourceInList;
            var isBodyValue:Boolean = valueSource.EvalateValueObject () as Boolean;
            
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
      
      public static function GetShapeInertia (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         if (shape == null || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (0.0);
         else
         {
            valueSource = valueSource.mNextValueSourceInList;
            var isBodyValue:Boolean = valueSource.EvalateValueObject () as Boolean;
            
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
      
      public static function GetShapeDensity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         if (shape == null) // || shape.IsDestroyedAlready ())
            valueTarget.AssignValueObject (0.0);
         else
         {
            valueTarget.AssignValueObject (shape.GetDensity ());
         }
      }
      
      public static function SetShapeLinearVelocity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var velocityX:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var velocityY:Number = valueSource.EvalateValueObject () as Number;
         
         shape.AddLinearMomentum (velocityX - shape.GetLinearVelocityX (), velocityY - shape.GetLinearVelocityY (), true, false);
      }
      
      public static function GetShapeLinearVelocity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null || shape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (shape.GetLinearVelocityX ());
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (shape.GetLinearVelocityY ());
         }
      }
      
      public static function AddLinearImpulseByVelocityVector (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var velocityX:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var velocityY:Number = valueSource.EvalateValueObject () as Number;
         
         shape.AddLinearMomentum (velocityX, velocityY, true, false);
      }
      
      public static function ApplyLinearImpulseOnShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         _ApplyLinearImpulseOnShape (valueSource, valueTarget);
      }
      
      public static function ApplyLinearImpulseAtLocalPointOnShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         _ApplyLinearImpulseOnShape (valueSource, valueTarget, true);
      }
      
      public static function ApplyLinearImpulseAtWorldPointOnShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         _ApplyLinearImpulseOnShape (valueSource, valueTarget, false);
      }
      
      public static function _ApplyLinearImpulseOnShape (valueSource:ValueSource, valueTarget:ValueTarget, isLocalPoint:Boolean = false):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var impulseX:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var impulseY:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var isLocalImpulse:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         if (isLocalImpulse)
         {
            shape.LocalVector2WorldVector (impulseX, impulseY, sVector);
            impulseX = sVector.x;
            impulseY = sVector.y;
         }
         
         var body:EntityBody = shape.GetBody ();
         
         valueSource = valueSource.mNextValueSourceInList;
         
         if (valueSource.mNextValueSourceInList == null)
         {
            var onBodyCenter:Boolean = valueSource.EvalateValueObject () as Boolean;
            
            if (onBodyCenter)
               body.ApplyLinearImpulse (impulseX, impulseY, body.GetPositionX (), body.GetPositionY ());
            else
               body.ApplyLinearImpulse (impulseX, impulseY, shape.GetWorldCentroidX (), shape.GetWorldCentroidY ());
         }
         else
         {
            var pointX:Number = valueSource.EvalateValueObject () as Number;
            
            valueSource = valueSource.mNextValueSourceInList;
            var pointY:Number = valueSource.EvalateValueObject () as Number;
            
            if (isLocalPoint)
            {
               shape.LocalPoint2WorldPoint (pointX, pointY, sPoint);
               pointX = sPoint.x;
               pointY = sPoint.y;
            }
            
            body.ApplyLinearImpulse (impulseX, impulseY, pointX, pointY);
         }
      }
      
      public static function ApplyAngularImpulse (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var angularImpulse:Number = valueSource.EvalateValueObject () as Number;
         
         shape.GetBody ().ApplyAngularImpulse (angularImpulse);
      }
      
      public static function ApplyStepForceOnShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         _ApplyStepForceOnShape (valueSource, valueTarget);
      }
      
      public static function ApplyStepForceAtLocalPointOnShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         _ApplyStepForceOnShape (valueSource, valueTarget, true);
      }
      
      public static function ApplyStepForceAtWorldPointOnShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         _ApplyStepForceOnShape (valueSource, valueTarget, false);
      }
      
      public static function _ApplyStepForceOnShape (valueSource:ValueSource, valueTarget:ValueTarget, isLocalPoint:Boolean = false):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var forceX:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var forceY:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var isLocalForce:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         if (isLocalForce)
         {
            shape.LocalVector2WorldVector (forceX, forceY, sVector);
            forceX = sVector.x;
            forceY = sVector.y;
         }
         
         var body:EntityBody = shape.GetBody ();
         
         valueSource = valueSource.mNextValueSourceInList;
         
         if (valueSource.mNextValueSourceInList == null)
         {
            var onBodyCenter:Boolean = valueSource.EvalateValueObject () as Boolean;
            
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
            var pointX:Number = valueSource.EvalateValueObject () as Number;
            
            valueSource = valueSource.mNextValueSourceInList;
            var pointY:Number = valueSource.EvalateValueObject () as Number;
            
            if (isLocalPoint)
            {
               shape.LocalPoint2WorldPoint (pointX, pointY, sPoint);
               pointX = sPoint.x;
               pointY = sPoint.y;
            }
            
            body.ApplyForceAtPoint (forceX, forceY, pointX, pointY);
         }
      }
      
      public static function ApplyStepTorque (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var torque:Number = valueSource.EvalateValueObject () as Number;
         
         shape.GetBody ().ApplyTorque (torque);
      }
      
      public static function TeleportShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var targetX:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var targetY:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var targetRotation:Number = (valueSource.EvalateValueObject () as Number) * Define.kDegrees2Radians;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         shape.Teleport (targetX, targetY, targetRotation - shape.GetRotation (), bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);
      }
      
      public static function TeleportShape_Offsets (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var deltaX:Number =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var deltaY:Number =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var deltaRotation:Number = (valueSource.EvalateValueObject () as Number) * Define.kDegrees2Radians;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         shape.Teleport (shape.GetPositionX () + deltaX, shape.GetPositionY () + deltaY, deltaRotation, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);
      }
      
      //public static function CloneShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
      //   if (shape == null)
      //      return;
      //   
      //}
      
      public static function DetachShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         shape.Detach ();
      }
      
	  public static function AttachTwoShapes (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape1:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape1 == null || shape1.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var shape2:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape2 == null || shape2.IsDestroyedAlready ())
            return;

         shape1.AttachWith (shape2);
      }
	  
	  public static function DetachShapeThenAttachWithAnother (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape1:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape1 == null)
            return;
         
         if (shape1.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var shape2:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         if (shape2 == null || shape2.IsDestroyedAlready ())
            shape1.Detach ();
         else
            shape1.DetachThenAttachWith (shape2);
      }
	  
      public static function BreakupShapeBrothers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         shape.BreakupBrothers ();
      }
	  
	  public static function BreakShapeJoints (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         if (shape.IsDestroyedAlready ())
            return;
         
         shape.BreakAllJoints ();
      }

   //*******************************************************************
   // entity / shape / text
   //*******************************************************************
      
      public static function GetTextFromTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShape_Text = valueSource.EvalateValueObject () as EntityShape_Text;
         
         var text:String = entity_text == null ? "" : entity_text.GetText ();
         valueTarget.AssignValueObject (text);
      }
      
      public static function SetTextForTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShape_Text = valueSource.EvalateValueObject () as EntityShape_Text;
         if (entity_text == null)
            return;
         
         if (entity_text.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var text:String = valueSource.EvalateValueObject () as String;
         
         entity_text.SetText (text);
      }
      
      public static function AppendTextToTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShape_Text = valueSource.EvalateValueObject () as EntityShape_Text;
         if (entity_text == null)
            return;
         
         if (entity_text.IsDestroyedAlready ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var text:String = valueSource.EvalateValueObject () as String;
         
         entity_text.SetText (entity_text.GetText () + text);
      }
      
      public static function AppendNewLineToTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShape_Text = valueSource.EvalateValueObject () as EntityShape_Text;
         if (entity_text == null)
            return;
         
         if (entity_text.IsDestroyedAlready ())
            return;
         
         entity_text.SetText (entity_text.GetText () + "\n");
      }
      
   //*******************************************************************
   // entity / shape / circle
   //*******************************************************************
      
      public static function GetShapeCircleRadius (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var circle:EntityShapeCircle = valueSource.EvalateValueObject () as EntityShapeCircle;
         if (circle == null)// || circle.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (circle.GetRadius ());
         }
      }
      
   //*******************************************************************
   // entity / shape / rectangle
   //*******************************************************************
      
      public static function GetShapeRectangleSize (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var rect:EntityShapeRectangle = valueSource.EvalateValueObject () as EntityShapeRectangle;
         if (rect == null)// || rect.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (2.0 * rect.GetHalfWidth ());
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (2.0 * rect.GetHalfHeight ());
         }
      }
      
   //*******************************************************************
   // entity / shape / poly shape
   //*******************************************************************
      
      public static function GetVertexCount (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var polyShape:EntityShapePolyShape = valueSource.EvalateValueObject () as EntityShapePolyShape;
         
         if (polyShape == null)// || polyShape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0);
         }
         else
         {
            valueTarget.AssignValueObject (polyShape.GetVertexPointsCount ());
         }
      }
      
      public static function GetVertexLocalPosition (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         GetVertexPosition (valueSource, valueTarget, false);
      }
      
      public static function GetVertexWorldPosition (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         GetVertexPosition (valueSource, valueTarget, true);
      }
      
      public static function GetVertexPosition (valueSource:ValueSource, valueTarget:ValueTarget, isWorldPoint:Boolean):void
      {
         var polyShape:EntityShapePolyShape = valueSource.EvalateValueObject () as EntityShapePolyShape;
         
         if (polyShape == null)// || polyShape.IsDestroyedAlready ())
         {
            valueTarget.AssignValueObject (0.0);
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueSource = valueSource.mNextValueSourceInList;
            var vertexIndex:int = int (valueSource.EvalateValueObject ());
            
            var point:Point = polyShape.GetLocalVertex (vertexIndex);
            if (isWorldPoint)
            {
               polyShape.LocalPoint2WorldPoint (point.x, point.y, point);
            }
            
            valueTarget.AssignValueObject (point.x);
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (point.y);
         }
      }
      
   //*******************************************************************
   // entity / joint
   //*******************************************************************
      
      public static function SetJointMotorEnabled (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var joint:EntityJoint = valueSource.EvalateValueObject () as EntityJoint;
         
         if (joint == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var enabled:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         joint.SetEnableMotor (enabled);
      }
      
      public static function SetJointLimitsEnabled (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var joint:EntityJoint = valueSource.EvalateValueObject () as EntityJoint;
         
         if (joint == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var enabled:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         joint.SetEnableLimits (enabled);
      }
      
      public static function GetHingeAngleByDegrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var hinge:EntityJointHinge = valueSource.EvalateValueObject () as EntityJointHinge;
         
         if (hinge == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (hinge.GetCurrentAngle () * Define.kRadians2Degrees);
         }
      }
      
      public static function GetHingeLimitsByDegrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var hinge:EntityJointHinge = valueSource.EvalateValueObject () as EntityJointHinge;
         
         if (hinge == null)
         {
            valueTarget.AssignValueObject (0.0);
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (hinge.GetLowerAngle () * Define.kRadians2Degrees);
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (hinge.GetUpperAngle () * Define.kRadians2Degrees);
         }
      }
      
      public static function SetHingeLimitsByDegrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var hinge:EntityJointHinge = valueSource.EvalateValueObject () as EntityJointHinge;
         if (hinge == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var lowerLimit:Number = Number (valueSource.EvalateValueObject ()) * Define.kDegrees2Radians;
         
         valueSource = valueSource.mNextValueSourceInList;
         var upperLimit:Number = Number (valueSource.EvalateValueObject ()) * Define.kDegrees2Radians;
         
         hinge.SetAngleLimits (lowerLimit, upperLimit);
      }
      
     public static function GetHingeMotorSpeed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var hinge:EntityJointHinge = valueSource.EvalateValueObject () as EntityJointHinge;
         
         if (hinge == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (hinge.GetMotorSpeed () * Define.kRadians2Degrees);
         }
      }
      
      public static function SetHingeMotorSpeed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var hinge:EntityJointHinge = valueSource.EvalateValueObject () as EntityJointHinge;
         if (hinge == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var motorSpeed:Number = Number (valueSource.EvalateValueObject ()) * Define.kDegrees2Radians;
         
         hinge.SetMotorSpeed (motorSpeed);
      }
      
      public static function GetSliderTranslation (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var slider:EntityJointSlider = valueSource.EvalateValueObject () as EntityJointSlider;
         
         if (slider == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (slider.GetCurrentTranslation ());
         }
      }
      
      public static function GetSliderLimits (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var slider:EntityJointSlider = valueSource.EvalateValueObject () as EntityJointSlider;
         
         if (slider == null)
         {
            valueTarget.AssignValueObject (0.0);
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (slider.GetLowerTranslation ());
            
            valueTarget = valueTarget.mNextValueTargetInList;
            valueTarget.AssignValueObject (slider.GetUpperTranslation ());
         }
      }
      
      public static function SetSliderLimits (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var slider:EntityJointSlider = valueSource.EvalateValueObject () as EntityJointSlider;
         if (slider == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var lowerLimit:Number = Number (valueSource.EvalateValueObject ());
         
         valueSource = valueSource.mNextValueSourceInList;
         var upperLimit:Number = Number (valueSource.EvalateValueObject ());
         
         slider.SetTranslationLimits (lowerLimit, upperLimit);
      }
      
      public static function GetSliderMotorSpeed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var slider:EntityJointSlider = valueSource.EvalateValueObject () as EntityJointSlider;
         
         if (slider == null)
         {
            valueTarget.AssignValueObject (0.0);
         }
         else
         {
            valueTarget.AssignValueObject (slider.GetMotorSpeed ());
         }
      }
      
      public static function SetSliderMotorSpeed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var slider:EntityJointSlider = valueSource.EvalateValueObject () as EntityJointSlider;
         if (slider == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var motorSpeed:Number = Number (valueSource.EvalateValueObject ());
         
         slider.SetMotorSpeed (motorSpeed);
      }
      
      // game / entity / event handler
         
      public static function ResetTimer (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var timer:EntityEventHandler_Timer = valueSource.EvalateValueObject () as EntityEventHandler_Timer;
         if (timer == null)
            return;
         
         timer.Reset ();
      }
      
      public static function SetTimerPaused (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var timer:EntityEventHandler_Timer = valueSource.EvalateValueObject () as EntityEventHandler_Timer;
         if (timer == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var paused:Boolean = Boolean (valueSource.EvalateValueObject ());
         
         timer.SetPaused (paused);
      }
      
      //public static function SetTimerInterval (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var timer:EntityEventHandler_Timer = valueSource.EvalateValueObject () as EntityEventHandler_Timer;
      //   if (timer == null)
      //      return;
      //   
      //   valueSource = valueSource.mNextValueSourceInList;
      //   var interval:Number = Number (valueSource.EvalateValueObject ());
      //   
      //   timer.SetRunningInterval (interval);
      //}
      
   }
}
