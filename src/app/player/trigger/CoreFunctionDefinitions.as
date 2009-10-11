
package player.trigger {
   import player.global.Global;
   
   import player.world.World;
   
   import player.entity.Entity;
   import player.entity.EntityShape;
   import player.entity.EntityUtilityCamera;
   
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
         
         RegisterCoreFunction (CoreFunctionIds.ID_SetWorldGravityAcceleration,     SetWorldGravityAcceleration);
         RegisterCoreFunction (CoreFunctionIds.ID_AttachWorldCameraToShape,        AttachWorldCameraToShape);
         RegisterCoreFunction (CoreFunctionIds.ID_SetShapeDensity,                 SetShapeDensity);
         RegisterCoreFunction (CoreFunctionIds.ID_IsEntityVisible,                 IsEntityVisible);
         RegisterCoreFunction (CoreFunctionIds.ID_IsPhysicsShape,                  IsPhysicsShape);
         RegisterCoreFunction (CoreFunctionIds.ID_IsSensorShape,                   IsSensorShape);
         RegisterCoreFunction (CoreFunctionIds.ID_IsTrue,                          IsTrue);
         RegisterCoreFunction (CoreFunctionIds.ID_IsFalse,                         IsFalse);
         RegisterCoreFunction (CoreFunctionIds.ID_SetShapeFilledColor,             SetShapeFilledColor);
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
      
   // math
      
      public static function AddTwoFloats (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         //var 
      }
      
      public static function AddTwoIntegers (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         //var 
      }
      
      
   // game
      
      public static function SetWorldGravityAcceleration (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var magnitude:Number = valueSource.EvalateValueObject () as Number;
         
         valueSource = valueSource.mNextValueSourceInList;
         var angle:Number = (valueSource.EvalateValueObject () as Number) * Math.PI / 180.0;
         
         var physics_engine:PhysicsEngine = Global.GetCurrentWorld ().GetPhysicsEngine ();
         physics_engine.SetGravity (magnitude, angle);
      }
      
      public static function AttachWorldCameraToShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         
         Global.GetCurrentWorld ().AttatchCurrentCameraToEntity (shape);
      }
      
      public static function SetShapeDensity (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
      public static function IsEntityVisible (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
      public static function IsPhysicsShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
      public static function IsSensorShape (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
      public static function IsTrue (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
      public static function IsFalse (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
      }
      
      public static function SetShapeFilledColor (valueSource:ValueSource, valueTarget:ValueTarget):void
      {
         var shape:EntityShape = valueSource.EvalateValueObject () as EntityShape;
         if (shape == null)
            return;
         
         valueSource = valueSource.mNextValueSourceInList;
         shape.SetFilledColor (uint (valueSource.EvalateValueObject ()));
         shape.RebuildAppearance ();
      }
   }
}
