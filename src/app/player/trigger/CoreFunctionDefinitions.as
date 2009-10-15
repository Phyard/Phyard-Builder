
package player.trigger {
   import flash.utils.getTimer;
   
   import player.global.Global;
   
   import player.world.World;
   
   import player.entity.Entity;
   import player.entity.EntityShape;
   import player.entity.EntityUtilityCamera;
   import player.entity.EntityShapeText;
   
   import player.physics.PhysicsEngine;
   
   import player.trigger.FunctionDefinition_Core;
   import player.trigger.ValueSource;
   import player.trigger.ValueTarget;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.CoreFunctionIds;
   import common.trigger.FunctionDeclaration;
   
   public class CoreFunctionDefinitions
   {
      public static var sCoreFunctionDefinitions:Array = new Array (CoreFunctionIds.NumPlayerFunctions);
      
      public static function Initialize ():void
      {
         if (Compile::Is_Debugging)
         {
            RegisterCoreFunction (CoreFunctionIds.ID_ForDebug,                     ForDebug);
         }
         
      // system / time
         
         RegisterCoreFunction (CoreFunctionIds.ID_GetProgramMilliseconds,           GetProgramMilliseconds);
         RegisterCoreFunction (CoreFunctionIds.ID_GetCurrentDateTime,               GetCurrentDateTime);
         RegisterCoreFunction (CoreFunctionIds.ID_MillisecondsToMinutesSeconds,     MillisecondsToMinutesSeconds);
         
      // bool
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_IsTrue,            IsTrue);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_IsFalse,           IsFalse);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Larger,            LargerThan);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Less,              LessThan);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_EqualsNumber,      EqualsWith_Numbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_EqualsBoolean,     EqualsWith_Booleans);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_And,               BoolAnd);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Or,                BoolOr);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Not,               BoolNot);
         RegisterCoreFunction (CoreFunctionIds.ID_Bool_Xor,               BoolXor);
         
      // bitwise
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftLeft,             ShiftLeft);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftRight,            ShiftRight);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned,    ShiftRightUnsigned);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_And,                   BitwiseAnd);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Or,                    BitwiseOr);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Not,                   BitwiseNot);
         RegisterCoreFunction (CoreFunctionIds.ID_Bitwise_Xor,                   BitwiseXor);
         
      // string
         
         RegisterCoreFunction (CoreFunctionIds.ID_String_NumberToString,              NumberToString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_BooleanToString,             BooleanToString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_EntityToString,              EntityToString);
         RegisterCoreFunction (CoreFunctionIds.ID_String_CollisionCategoryToString,   CollisionCategoryToString);
         
         RegisterCoreFunction (CoreFunctionIds.ID_String_Add,                         AddTwoStrings);
         
      // math
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Add,                        AddTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Subtract,                   SubtractTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Multiply,                   MultiplyTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Divide,                     DivideTwoNumbers);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Random,                     RandomNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_RandomRange,                RandomNumberRange);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_RandomIntRange,             RandomIntegerRange);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Max,                        MaxOfTwoNumbers);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Min,                        MinOfTwoNumbers);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Inverse,                   InverseNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Negative,                  NegativeNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Abs,                       AbsNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Sqrt,                      SqrtNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Ceil,                      CeilNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Floor,                     FloorNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Round,                     RoundNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Log,                       LogNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Exp,                       ExpNumber);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_Power,                     Power);
         
         RegisterCoreFunction (CoreFunctionIds.ID_Math_DegreesToRadians,          DegreesToRadians);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_RadiansToDegrees,          RadiansToDegrees);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_SinRadians,                SinRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_CosRadians,                CosRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_TanRadians,                TanRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ArcSinRadians,             AsinRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ArcCosRadians,             AcosRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ArcTanRadians,             AtanRadian);
         RegisterCoreFunction (CoreFunctionIds.ID_Math_ArcTan2Radians,            AtanRadianTwoNumbers);
         
      // game / world
         
         RegisterCoreFunction (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians,     SetWorldGravityAcceleration_Radians);
         RegisterCoreFunction (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees,     SetWorldGravityAcceleration_Degrees);
         RegisterCoreFunction (CoreFunctionIds.ID_World_AttachCameraToShape,                AttachWorldCameraToShape);
         
      // game /entity
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsVisible,                   IsEntityVisible);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetVisible,                  SetEntityVisible);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetAlpha,                    GetEntityAlpha);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_SetAlpha,                    SetEntityAlpha);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetPosition,                 GetEntityPosition);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetRotationByDegrees,        GetEntityRotationByDegrees);
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_GetRotationByRadians,        GetEntityRotationByRadians);
         
      // game / entity / shape
         
         RegisterCoreFunction (CoreFunctionIds.ID_Entity_IsShapeEntity,                    IsShapeEntity);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetFilledColor,              GetShapeFilledColor);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetFilledColor,              SetShapeFilledColor);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled,                   IsPhysicsShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_IsSensor,                    IsSensorShape);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetAsSensor,                 SetShapeAsSensor);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_GetDensity,                  GetShapeDensity);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityShape_SetDensity,                  SetShapeDensity);
         
      // game / entity / joint
         
         
         
      // game / entity / util
         
         RegisterCoreFunction (CoreFunctionIds.ID_EntityText_GetText,                  GetTextFromTextComponent);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityText_SetText,                  SetTextForTextComponent);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityText_AppendText,               AppendTextToTextComponent);
         RegisterCoreFunction (CoreFunctionIds.ID_EntityText_AppendNewLine,            AppendNewLineToTextComponent);
         
      // game / entity / field
         
      }
      
      private static function RegisterCoreFunction (functionId:int, callback:Function):void
      {
         if (functionId < 0 || functionId >= CoreFunctionIds.NumPlayerFunctions)
            return;
         
         var func_decl:FunctionDeclaration = TriggerEngine.GetCoreFunctionDeclaration (functionId);
         
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
      
   //************************************************
   // bool
   //************************************************
      
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
   // bitwise
   //************************************************
      
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
      
   //*******************************************************************
   // string
   //*******************************************************************
      
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
         var value:Entity = valueSource.EvalateValueObject () as Entity;
         
         valueTarget.AssignValueObject (value == null ? "null" : "Entity#" + value.GetEntityIndexInEditor ());
      }
      
      public static function CollisionCategoryToString (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject ("CollisionCategory#" + value);
      }
      
      public static function AddTwoStrings (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value1:String = valueSource.EvalateValueObject () as String;
         
         valueSource = valueSource.mNextValueSourceInList;
         var value2:String = valueSource.EvalateValueObject () as String;
         
         valueTarget.AssignValueObject (value1 + value2);
      }
      
   //************************************************
   // math
   //************************************************
      
      // + - * /
      
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
      
      // inverse, negative, abs, sqrt, ceil, floor, round, log, exp
      
      public static function InverseNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (1.0 / value);
      }
      
      public static function NegativeNumber (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (-value);
      }
      
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
      
      // degree ,-> radian
      
      public static function DegreesToRadians (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value * Math.PI / 180.0);
      }
      
      public static function RadiansToDegrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var value:Number = valueSource.EvalateValueObject () as Number;
         
         valueTarget.AssignValueObject (value * 180.0 /  Math.PI);
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
      
   //*******************************************************************
   // game world
   //*******************************************************************
      
      //public static function GetLevelMilliseconds (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   valueTarget.AssignValueObject (0);
      //}
      
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
         var radians:Number = ((valueSource.EvalateValueObject () as Number) % 360.0) * Math.PI / 180.0;
         
         var physics_engine:PhysicsEngine = Global.GetCurrentWorld ().GetPhysicsEngine ();
         physics_engine.SetGravity (magnitude, radians);
      }
      
      public static function AttachWorldCameraToShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         Global.GetCurrentWorld ().AttatchCurrentCameraToEntity (shape);
      }
      
   //*******************************************************************
   // game entity
   //*******************************************************************
      
      public static function IsShapeEntity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
         {
            valueTarget.AssignValueObject (false);
         }
         else
         {
            valueTarget.AssignValueObject (true);
         }
      }
      
      public static function IsEntityVisible (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         valueTarget.AssignValueObject (entity.IsVisible ());
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
         if (entity == null)
            return;
         
         valueTarget.AssignValueObject (entity.GetPositionX ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (entity.GetPositionY ());
      }
      
      public static function SetEntityAlpha (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         valueTarget.AssignValueObject (entity.GetPositionX ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (entity.GetPositionY ());
      }
      
      public static function GetEntityPosition (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         valueTarget.AssignValueObject (entity.GetPositionX ());
         
         valueTarget = valueTarget.mNextValueTargetInList;
         valueTarget.AssignValueObject (entity.GetPositionY ());
      }
      
      //public static function SetEntityPosition (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var entity:Entity = valueSource.EvalateValueObject () as Entity;
      //   if (entity == null)
      //      return;
      //   
      //   valueTarget.AssignValueObject (entity.GetPositionX ());
      //   
      //   valueTarget = valueTarget.mNextValueTargetInList;
      //   valueTarget.AssignValueObject (entity.GetPositionY ());
      //}
      
      public static function GetEntityRotationByDegrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
         valueTarget.AssignValueObject (entity.GetRotation () * 180.0 / Math.PI);
      }
      
      //public static function SetEntityRotationByDegrees (valueSource:ValueSource, valueTarget:ValueTarget):void
      //{
      //   var entity:Entity = valueSource.EvalateValueObject () as Entity;
      //   if (entity == null)
      //      return;
      //   
      //   valueTarget.AssignValueObject (entity.GetRotation () * 180.0 / Math.PI);
      //}
      
      public static function GetEntityRotationByRadians (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity:Entity = valueSource.EvalateValueObject () as Entity;
         if (entity == null)
            return;
         
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
      
   //*******************************************************************
   // entity / shape
   //*******************************************************************
      
      public static function GetShapeFilledColor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
         {
            // error
            valueTarget.AssignValueObject (0);
         }
         else
         {
            valueTarget.AssignValueObject (shape.GetFilledColor ());
         }
      }
      
      public static function SetShapeFilledColor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var color:uint = uint (valueSource.EvalateValueObject ());
         
         shape.SetFilledColor (color);
         shape.RebuildAppearance ();
      }
      
      public static function IsPhysicsShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
         {
            valueTarget.AssignValueObject (false);
         }
         else
         {
            valueTarget.AssignValueObject (shape.IsPhysicsEnabled ());
         }
      }
      
      public static function IsSensorShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
         {
            valueTarget.AssignValueObject (false);
         }
         else
         {
            valueTarget.AssignValueObject (shape.IsSensor ());
         }
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
      
      public static function GetShapeDensity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
      public static function SetShapeDensity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
   //*******************************************************************
   // entity / shape
   //*******************************************************************
      
      public static function GetTextFromTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShapeText = valueSource.EvalateValueObject () as EntityShapeText;
         if (entity_text == null)
         {
            valueTarget.AssignValueObject ("");
         }
         else
         {
            valueTarget.AssignValueObject (entity_text.GetText ());
         }
      }
      
      public static function SetTextForTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShapeText = valueSource.EvalateValueObject () as EntityShapeText;
         if (entity_text == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var text:String = valueSource.EvalateValueObject () as String;
         
         entity_text.SetText (text);
         entity_text.RebuildAppearance ();
      }
      
      public static function AppendTextToTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShapeText = valueSource.EvalateValueObject () as EntityShapeText;
         if (entity_text == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         var text:String = valueSource.EvalateValueObject () as String;
         
         entity_text.SetText (entity_text.GetText () + text);
         entity_text.RebuildAppearance ();
      }
      
      public static function AppendNewLineToTextComponent (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var entity_text:EntityShapeText = valueSource.EvalateValueObject () as EntityShapeText;
         if (entity_text == null)
            return;
         
         entity_text.SetText (entity_text.GetText () + "\n");
         entity_text.RebuildAppearance ();
      }
      
   }
}
