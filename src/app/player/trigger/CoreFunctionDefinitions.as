
package player.trigger {
   import flash.utils.getTimer;
   
   import player.design.Global;
   import player.design.Design;
   
   import player.world.World;
   import player.world.CollisionCategory;
   
   import player.entity.*;
   
   import player.physics.PhysicsEngine;
   
   import player.trigger.FunctionDefinition_Core;
   import player.trigger.ValueSource;
   import player.trigger.ValueTarget;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.CoreFunctionIds;
   import common.trigger.FunctionDeclaration;
   import common.trigger.CoreFunctionDeclarations;
   
   import common.Define;
   
   public class CoreFunctionDefinitions
   {
      public static var sCoreFunctionDefinitions:Array = new Array (CoreFunctionIds.NumPlayerFunctions);
      
      public static function Initialize ():void
      {
         if (Compile::Is_Debugging)
         {
            RegisterCoreFunction (CoreFunctionIds.ID_ForDebug,                     ForDebug);
         }
         
      // some specail
         
         // 
         
      // global
         
         RegisterCoreFunction (CoreFunctionIds.ID_Return,                           ReturnVoid);
         RegisterCoreFunction (CoreFunctionIds.ID_ReturnIfTrue,                     ReturnIfTrue);
         RegisterCoreFunction (CoreFunctionIds.ID_ReturnIfFalse,                    ReturnIfFalse);
         
      // system / time
         
         RegisterCoreFunction (CoreFunctionIds.ID_GetProgramMilliseconds,           GetProgramMilliseconds);
         RegisterCoreFunction (CoreFunctionIds.ID_GetCurrentDateTime,               GetCurrentDateTime);
         
      // string
         
         RegisterCoreFunction (CoreFunctionIds.ID_String_Assign,                      AssignString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_Add,                         AddTwoStrings);
         
         RegisterCoreFunction (CoreFunctionIds.ID_String_NumberToString,              NumberToString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_BooleanToString,             BooleanToString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_EntityToString,              EntityToString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_CollisionCategoryToString,   CollisionCategoryToString);
         
      // bool
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Assign,            AssignBoolean);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Invert,            BooleanInvert);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_IsTrue,            IsTrue);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_IsFalse,           IsFalse);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_EqualsNumber,      EqualsWith_Numbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_EqualsBoolean,     EqualsWith_Booleans);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_EqualsEntity,      EqualsWith_Entities);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Larger,            LargerThan);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Less,              LessThan);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_And,               BoolAnd);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Or,                BoolOr);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Not,               BoolNot);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Xor,               BoolXor);
         
         // math ops
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Assign,                     AssignNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ConditionAssign,            ConditionAssignNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Negative,                   NegativeNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Add,                        AddTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Subtract,                   SubtractTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Multiply,                   MultiplyTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Divide,                     DivideTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Modulo,                     ModuloTwoNumbers);
         
         // math / bitwise
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftLeft,             ShiftLeft);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftRight,            ShiftRight);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned,    ShiftRightUnsigned);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_And,                   BitwiseAnd);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Or,                    BitwiseOr);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Not,                   BitwiseNot);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Xor,                   BitwiseXor);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_SinRadians,                SinRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_CosRadians,                CosRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_TanRadians,                TanRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ArcSinRadians,             AsinRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ArcCosRadians,             AcosRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ArcTanRadians,             AtanRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ArcTan2Radians,            AtanRadianTwoNumbers);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Random,                     RandomNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_RandomRange,                RandomNumberRange);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_RandomIntRange,             RandomIntegerRange);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Degrees2Radians,             Degrees2Radians);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Radians2Degrees,             Radians2Degrees);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Number2RGB,                  Number2RGB);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_RGB2Number,                  RGB2Number);
         RegisterCoreFunction (CoreFunctionIds.ID_MillisecondsToMinutesSeconds,     MillisecondsToMinutesSeconds);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Inverse,                   InverseNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Max,                        MaxOfTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Min,                        MinOfTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Abs,                       AbsNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Sqrt,                      SqrtNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Ceil,                      CeilNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Floor,                     FloorNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Round,                     RoundNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Log,                       LogNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Exp,                       ExpNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Power,                     Power);
         
         RegisterCoreFunction (CoreFunctionIds.Id_Math_LinearInterpolation,               LinearInterpolation);
         RegisterCoreFunction (CoreFunctionIds.Id_Math_LinearInterpolationColor,          LinearInterpolationColor);
         
      // game / design
         
         RegisterCoreFunction (CoreFunctionIds.ID_Design_GetLevelMilliseconds,             GetLevelMilliseconds);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_GetLevelSteps,                    GetLevelSteps);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_IsLevelSuccessed,                 IsLevelSuccessed);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_SetLevelSuccessed,                SetLevelSuccessed);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_IsLevelFailed,                    IsLevelFailed);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_SetLevelFailed,                   SetLevelFailed);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_IsLevelUnfinished,                IsLevelUnfinished);
         RegisterCoreFunction (CoreFunctionIds.ID_Design_SetLevelUnfinished,               SetLevelUnfinished);
         
      // game / world
         
         RegisterCoreFunction (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians,     SetWorldGravityAcceleration_Radians);
         RegisterCoreFunction (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees,     SetWorldGravityAcceleration_Degrees);
         RegisterCoreFunction (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector,      SetWorldGravityAcceleration_Vector);
         
         RegisterCoreFunction (CoreFunctionIds.ID_World_FollowCameraWithShape,                       FollowCameraWithShape);
         RegisterCoreFunction (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape,                FollowCameraCenterXWithShape);
         RegisterCoreFunction (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape,                FollowCameraCenterYWithShape);
         //RegisterCoreFunction (CoreFunctionIds.ID_World_FollowCameraRotationWithShape,               FollowCameraRotationWithShape);
         
      // game / collision category
         
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_Assign,                                       AssignCollisionCategory);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_SetCollideInternally,                         SetCollisionCategoryCollideInternally);
         RegisterCoreFunction (CoreFunctionIds.ID_CCat_SetAsFriends,                                 SetCollisionCategoriesAsFriends);
         
      // game / entity
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_Assign,                      AssignEntity);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsTaskSuccessed,                       IsEntityTaskSuccessed);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetTaskSuccessed,                      SetEntityTaskSuccessed);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsTaskFailed,                          IsEntityTaskFailed);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetTaskFailed,                         SetEntityTaskFailed);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsTaskUnfinished,                      IsEntityTaskUnfinished);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetTaskUnfinished,                     SetEntityTaskUnfinished);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetTaskStatus,                         SetEntityTaskStatus);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsShapeEntity,                    IsShapeEntity);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsVisible,                   IsEntityVisible);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetVisible,                  SetEntityVisible);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetAlpha,                    GetEntityAlpha);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetAlpha,                    SetEntityAlpha);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetPosition,                 GetEntityPosition);
         //RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetPosition,                 SetEntityPosition);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetRotationByDegrees,        GetEntityRotationByDegrees);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetRotationByRadians,        GetEntityRotationByRadians);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_Destroy,        DestroyEntity);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_Overlapped,        AreTwoEntitiesOverlppped);
         
      // game / entity / shape
         
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
         //RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetDensity,                  GetShapeDensity);
         //RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetDensity,                  SetShapeDensity);
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_Teleport,                    TeleportShape);
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
         
      // game / entity / joint
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_SetHingeLimits,                  SetHingeLimits);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityJoint_SetSliderLimits,                 SetSliderLimits);
         
      // game / entity / field
         
      }
      
      private static function RegisterCoreFunction (functionId:int, callback:Function):void
      {
         if (functionId < 0 || functionId >= CoreFunctionIds.NumPlayerFunctions)
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
         
      public static function ReturnVoid (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         // do nothing, shouldn't run into here
      }
      
      public static function ReturnIfTrue (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = (valueSource.EvalateValueObject () as Boolean);
         
         valueTarget.AssignValueObject (value);
      }
      
      public static function ReturnIfFalse (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = (valueSource.EvalateValueObject () as Boolean);
         
         valueTarget.AssignValueObject (! value);
      }
      
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
         valueTarget.AssignValueObject (date.getMonth ());
         
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
      
   //*******************************************************************
   // string
   //*******************************************************************
      
      public static function AssignString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (value);
      }
      
      public static function AddTwoStrings (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:String = valueSource.EvalateValueObject () as String;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (value1 + value2);
      }
      
      public static function NumberToString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject ("" + value);
         
         //throw new Error ();
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
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject ("CollisionCategory#" + value);
      }
      
   //************************************************
   // bool
   //************************************************
      
      public static function AssignBoolean (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         valueTarget.AssignValueObject (value);
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
         var value1:Number = Math.round (valueSource.EvalateValueObject () as Number);
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:Number = Math.round (valueSource.EvalateValueObject () as Number);
         
         valueTarget.AssignValueObject (Math.floor (value1 + (value2 - value1) * Math.random ()));
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
      
      public static function GetLevelMilliseconds (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().GetLevelMilliseconds ());
      }
      
      public static function GetLevelSteps (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().GetLevelSteps ());
      }
      
      public static function IsLevelSuccessed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().IsLevelSuccessed ());
      }
      
      public static function SetLevelSuccessed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         Global.GetCurrentDesign ().SetLevelSuccessed ();
      }
      
      public static function IsLevelFailed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().IsLevelFailed ());
      }
      
      public static function SetLevelFailed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         Global.GetCurrentDesign ().SetLevelFailed ();
      }
      
      public static function IsLevelUnfinished (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         valueTarget.AssignValueObject (Global.GetCurrentDesign ().IsLevelUnfinished ());
      }
      
      public static function SetLevelUnfinished (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         Global.GetCurrentDesign ().SetLevelUnfinished ();
      }
      
   //*******************************************************************
   // game / world
   //*******************************************************************
      
      public static function SetWorldGravityAcceleration_Radians (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var magnitude:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var radians:Number = (valueSource.EvalateValueObject () as Number) % 360.0;
         
         var physics_engine:PhysicsEngine = Global.GetCurrentWorld ().GetPhysicsEngine ();
         physics_engine.SetGravity (magnitude, radians);
      }
      
      public static function SetWorldGravityAcceleration_Degrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var magnitude:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var radians:Number = ((valueSource.EvalateValueObject () as Number) % 360.0) * Define.kDegrees2Radians;
         
         var physics_engine:PhysicsEngine = Global.GetCurrentWorld ().GetPhysicsEngine ();
         physics_engine.SetGravity (magnitude, radians);
      }
      
      public static function SetWorldGravityAcceleration_Vector (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var gaX:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var gaY:Number = valueSource.EvalateValueObject () as Number;
         
         var physics_engine:PhysicsEngine = Global.GetCurrentWorld ().GetPhysicsEngine ();
         physics_engine.SetGravityByVector (gaX, gaY);
      }
      
      public static function FollowCameraWithShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
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
         if (shape == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var isSmooth:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         Global.GetCurrentWorld ().FollowCameraCenterXWithEntity (shape, isSmooth);
      }
      
      public static function FollowCameraCenterYWithShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
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
      
      // game / collision category
         
   //*******************************************************************
   // game collision category
   //*******************************************************************
      
      public static function AssignCollisionCategory (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var cat:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         
         valueTarget.AssignValueObject (cat);
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
      
      public static function IsEntityTaskSuccessed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var successed:Boolean = entity == null ? false : entity.IsTaskSuccessed ();
         
         valueTarget.AssignValueObject (successed);
      }
      
      public static function SetEntityTaskSuccessed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         
         entity.SetTaskSuccessed ();
      }
      
      public static function IsEntityTaskFailed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var failed:Boolean = entity == null ? false : entity.IsTaskFailed ();
         
         valueTarget.AssignValueObject (failed);
      }
      
      public static function SetEntityTaskFailed (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         
         entity.SetTaskFailed ();
      }
      
      public static function IsEntityTaskUnfinished (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         
         var unfinished:Boolean = entity == null ? true : entity.IsTaskUnfinished ();
         
         valueTarget.AssignValueObject (unfinished);
      }
      
      public static function SetEntityTaskUnfinished (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         entity.SetTaskUnfinished ();
      }
      
      public static function SetEntityTaskStatus (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var status:int = int (valueSource.EvalateValueObject ());
         
         if (status > 0)
            entity.SetTaskSuccessed ();
         else if (status < 0)
            entity.SetTaskFailed ();
         else
            entity.SetTaskUnfinished ();
      }
      
      public static function IsShapeEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         valueTarget.AssignValueObject (shape != null);
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
      
      public static function SetEntityPosition (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var pos_x:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var pos_y:Number = valueSource.EvalateValueObject () as Number;
         
         shape.MoveTo (pos_x, pos_y);
      }
      
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
      
      public static function DestroyEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
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
      
      public static function AreTwoEntitiesOverlppped(valueSource:ValueSource, valueTarget:ValueTarget):void
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
         if (dr > 180) dr = 360 - dr;
         
         var overlapped:Boolean = dx < toleranceDx && dy < toleranceDy && dr < toleranceDr;
         
         valueTarget.AssignValueObject (overlapped);
      }
      
   //*******************************************************************
   // entity / shape
   //*******************************************************************
      
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
         
         if (! shape.IsAiTypeChangeable ())
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var ciType:int = uint (valueSource.EvalateValueObject ());
         
         shape.SetShapeAiType (ciType);
      }
      
      public static function GetShapeFilledColor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var filledColor:uint = shape == null ? 0 : shape.GetFilledColor ();
         valueTarget.AssignValueObject (filledColor);
      }
      
      public static function SetShapeFilledColor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var color:uint = uint (valueSource.EvalateValueObject ());
         
         shape.SetFilledColor (color);
      }
      
      public static function GetShapeFilledColorRGB (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var color:uint = shape == null ? 0x0 : shape.GetFilledColor ();
         
         valueTarget.AssignValueObject ((color >> 16) & 0xFF);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject ((color >> 8) & 0xFF);
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject ((color >> 0) & 0xFF);
      }
      
      public static function SetShapeFilledColorRGB (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         if (shape == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var red:int =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var green:int =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var blue:int =  valueSource.EvalateValueObject () as Number;
         
         shape.SetFilledColor ((red << 16) | (green << 8) | (blue));
      }
      
      public static function IsShapePhysicsEnabled (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         var enabled:Boolean = shape == null ? false : shape.IsPhysicsShape ();
         valueTarget.AssignValueObject (enabled);
      }
      
      //public static function SetShapePhysicsEnabled (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
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
         
         valueSource = valueSource.mNextValueSourceInList;
         var ccat:CollisionCategory = valueSource.EvalateValueObject () as CollisionCategory;
         if (ccat == null)
            return;
         
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
         
         valueSource = valueSource.mNextValueSourceInList;
         var sensor:Boolean = valueSource.EvalateValueObject () as Boolean;
         
         shape.SetAsSensor (sensor);
      }
      
      //public static function GetShapeDensity (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //}
      
      //public static function SetShapeDensity (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //}
      
      //public static function AttachShapes (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //}
      
      public static function TeleportShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var targetX:Number =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var targetY:Number =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var deltaRotation:Number =  valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bTeleportConnectedMovables:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bTeleprotConnectedStatics:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         valueSource = valueSource.mNextValueSourceInList;
         var bBreakEmbarrassedJoints:Boolean =  valueSource.EvalateValueObject () as Boolean;
         
         shape.Teleport (targetX, targetY, deltaRotation, bTeleportConnectedMovables, bTeleprotConnectedStatics, bBreakEmbarrassedJoints);
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
         if (shape1 == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var shape2:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape2 == null)
            return;

		 shape1.AttachWith (shape2);
      }
	  
	  public static function DetachShapeThenAttachWithAnother (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape1:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape1 == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var shape2:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape2 == null)
            return;

		 shape1.DetachThenAttachWith (shape2);
      }
	  
      public static function BreakupShapeBrothers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
		 shape.BreakupBrothers ();
      }
	  
	  public static function BreakShapeJoints (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
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
         
         valueSource = valueSource.mNextValueSourceInList;
         var text:String = valueSource.EvalateValueObject () as String;
         
         entity_text.SetText (text);
      }
      
      public static function AppendTextToTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShape_Text = valueSource.EvalateValueObject () as EntityShape_Text;
         if (entity_text == null)
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
         
         entity_text.SetText (entity_text.GetText () + "\n");
      }
      
   //*******************************************************************
   // entity / joint
   //*******************************************************************
      
      public static function SetHingeLimits (valueSource:ValueSource, valueTarget:ValueTarget):void
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
   }
}
