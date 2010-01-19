
package editor.trigger {
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   import editor.entity.EntityJoint;
   import editor.entity.EntityShapeText;
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.ValueTypeDefine;
   import editor.trigger.Lists;
   
   public class PlayerFunctionDefinesForEditing
   {
      
      private static var sFunctionDeclarations:Array = new Array (CoreFunctionIds.NumPlayerFunctions);
      
      public static const sToppestPackage:FunctionPackage = new FunctionPackage ("");
      
      public static const sBasicPackage:FunctionPackage = new FunctionPackage ("Basic", sToppestPackage);
      public static const sWorldPackage:FunctionPackage = new FunctionPackage ("World", sToppestPackage);
      public static const sEntityPackage:FunctionPackage = new FunctionPackage ("Entity", sToppestPackage);
      
      public static var sMenuBarDataProvider:XML = null;
      
      public static function Initialize ():void
      {
         
      //================================================
      // packages
      //================================================
         
         var system_package:FunctionPackage = new FunctionPackage ("System", sBasicPackage);
         var global_package:FunctionPackage = new FunctionPackage ("Global", sBasicPackage);
         var math_package:FunctionPackage   = new FunctionPackage ("Math", sBasicPackage);
            var usual_math_package:FunctionPackage         = new FunctionPackage ("Usual", math_package);
            var trigonometry_package:FunctionPackage = new FunctionPackage ("Trigonometry", math_package);
            var random_package:FunctionPackage             = new FunctionPackage ("Random", math_package);
            var bitwise_package:FunctionPackage            = new FunctionPackage ("Bitwise", math_package);
            var convert_package:FunctionPackage            = new FunctionPackage ("Number Convert", math_package);
            var interpolation_package:FunctionPackage      = new FunctionPackage ("Interpolation", math_package);
         var string_package:FunctionPackage = new FunctionPackage ("String", sBasicPackage);
         var bool_package:FunctionPackage   = new FunctionPackage ("Logic", sBasicPackage);
         
         var world_package:FunctionPackage  = new FunctionPackage ("General", sWorldPackage);
         var design_package:FunctionPackage  = new FunctionPackage ("As a Level", sWorldPackage);
         var cat_package:FunctionPackage    = new FunctionPackage ("CCat", sWorldPackage);
         
         var entity_package:FunctionPackage = new FunctionPackage ("Common", sEntityPackage);
             var entity_as_task_package:FunctionPackage    = new FunctionPackage ("As a Task", entity_package);
            var entity_shape_package:FunctionPackage = new FunctionPackage ("Shape", sEntityPackage);
                var shape_is_subtype_package:FunctionPackage    = new FunctionPackage ("Is a *?", entity_shape_package);
                var shape_appearance_package:FunctionPackage = new FunctionPackage ("Appearance", entity_shape_package);
                var shape_physics_package:FunctionPackage = new FunctionPackage ("Physics", entity_shape_package);
               var shape_text_package:FunctionPackage  = new FunctionPackage (" - Text", sEntityPackage);
            var entity_joint_package:FunctionPackage  = new FunctionPackage ("Joint", sEntityPackage);
            var entity_trigger_package:FunctionPackage  = new FunctionPackage ("Trigger", sEntityPackage);
         
      //================================================
      // functions
      //================================================
         
         if (Compile::Is_Debugging)
         {
            RegisterFunctionDeclaration (CoreFunctionIds.ID_ForDebug, global_package, "ForDevDebug", 
                          [
                             new VariableDefinitionEntity ("Shape"), 
                             new VariableDefinitionNumber ("Gravity Angle"), 
                             new VariableDefinitionBoolean ("Is Sensor"), 
                             new VariableDefinitionString ("Text"), 
                             new VariableDefinitionCollisionCategory ("Collision Category"),
                          ],
                          [
                             new VariableDefinitionEntity ("Shape"), 
                             new VariableDefinitionNumber ("Gravity Angle"), 
                             new VariableDefinitionBoolean ("Is Sensor"), 
                             new VariableDefinitionString ("Text"), 
                             new VariableDefinitionCollisionCategory ("Collision Category"),
                          ]
                       );
         }
         
      // special
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Void, null, "Action", 
                     null,
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool, null, "Condition",
                     null,
                     [
                              new VariableDefinitionBoolean ("Bool Value"), 
                     ]
                  );
       
      // global
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Return, global_package, "Return", 
                     null,
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_ReturnIfTrue, global_package, "ReturnIfTrue", 
                     [
                             new VariableDefinitionBoolean ("Bool Value"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_ReturnIfFalse, global_package, "ReturnIfFalse", 
                     [
                             new VariableDefinitionBoolean ("Bool Value"), 
                     ],
                     null
                  );
         
      // system / time
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_GetProgramMilliseconds, system_package, "GetProgramMilliseconds", 
                     null,
                     [
                             new VariableDefinitionNumber ("Milliseconds"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_GetCurrentDateTime, system_package, "GetCurrentDateTime", 
                     null,
                     [
                             new VariableDefinitionNumber ("Year"), 
                             new VariableDefinitionNumber ("Month"), 
                             new VariableDefinitionNumber ("Day"), 
                             new VariableDefinitionNumber ("Hours"), 
                             new VariableDefinitionNumber ("Minutes"), 
                             new VariableDefinitionNumber ("Seconds"), 
                             new VariableDefinitionNumber ("Milliseconds"), 
                     ]
                  );
         
      // string
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_Assign, string_package, "= (Assign String)", 
                     [
                             new VariableDefinitionString ("Source String"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_ConditionAssign, string_package, "?= (Condition Assign String)", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionString ("Source String 1"), 
                             new VariableDefinitionString ("Source String 2"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_Add, string_package, "String + String", 
                     [
                             new VariableDefinitionString ("Source String 1"), 
                             new VariableDefinitionString ("Source String 2"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_NumberToString, string_package, "Number -> String", 
                     [
                             new VariableDefinitionNumber ("The Number"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_BooleanToString, string_package, "Bool -> String", 
                     [
                             new VariableDefinitionBoolean ("The Bool"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_EntityToString, string_package, "Entity -> String", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_CollisionCategoryToString, string_package, "CCat -> String", 
                     [
                             new VariableDefinitionCollisionCategory ("The CCat"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         
       // bool
          
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Assign, bool_package, "= (Assign Boolean)", 
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Target Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_ConditionAssign, bool_package, "=? (Condition Assign Boolean)", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionBoolean ("Source Boolean 1"), 
                             new VariableDefinitionBoolean ("Source Boolean 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Target Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Invert, bool_package, "! (Invert)", 
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_IsTrue, bool_package, "IsTrue?", 
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_IsFalse, bool_package, "IsFalse?", 
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsNumber, bool_package, "Number == Number?", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsBoolean, bool_package, "Boolean == Boolean?", 
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsEntity, bool_package, "Entity == Entity?", 
                     [
                             new VariableDefinitionEntity ("Entity 1"), 
                             new VariableDefinitionEntity ("Entity 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Larger, bool_package, "Number > Number?", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Less, bool_package, "Number < Number?", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_And, bool_package, "x && y (Bool And)", 
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Or, bool_package, "x || y (Bool Or)", 
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Not, bool_package, "! x (Bool Not)", 
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Xor, bool_package, "x != y (Bool Xor)", 
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
          
       // math basic ops
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Assign, math_package, "= (Number Assign)", 
                     [
                             new VariableDefinitionNumber ("Source"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Target"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ConditionAssign, math_package, "=? (Condition Number Assign)", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionNumber ("True Source"), 
                             new VariableDefinitionNumber ("False Source"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Target"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Negative, math_package, "- x (Negative)", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Inverse, math_package, "1.0 / x (Inverse)", 
                     [
                             new VariableDefinitionNumber ("Number", null, null, {mDefaultValue: 1.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Add, math_package, "x + y", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Subtract, math_package, "x - y", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Multiply, math_package, "x * y (Multiply)", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Divide, math_package, "x / y (Divide)", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Modulo, math_package, "x % y (Modulo)", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         
      // math / bitwise
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftLeft, bitwise_package, "<< (ShiftLeft)", 
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRight, bitwise_package, ">> (ShiftRight)", 
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned, bitwise_package, ">>> (ShiftRightUnsignedly)", 
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_And, bitwise_package, "x & y (Bitwise And)", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Or, bitwise_package, "x | y (Bitwise Or)", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Not, bitwise_package, "~ x (Bitwise Not)", 
                     [
                             new VariableDefinitionNumber ("Inout Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Xor, bitwise_package, "x ^ y (Bitwise Xor)", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         
      // math / number trinomogetry
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_SinRadians, trigonometry_package, "Sin", 
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Sin (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_CosRadians, trigonometry_package, "Cos", 
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Cos (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_TanRadians, trigonometry_package, "Tan", 
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Tan (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ArcSinRadians, trigonometry_package, "ArcSin_Radians", 
                     [
                             new VariableDefinitionNumber ("Sin (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ArcCosRadians, trigonometry_package, "ArcCos_Radians", 
                     [
                             new VariableDefinitionNumber ("Cos (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ArcTanRadians, trigonometry_package, "ArcTan_Radians", 
                     [
                             new VariableDefinitionNumber ("Tan (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ArcTan2Radians, trigonometry_package, "ArcTan2_Radians", 
                     [
                             new VariableDefinitionNumber ("y"), 
                             new VariableDefinitionNumber ("x"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         
      // math / random
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Random, random_package, "Random", 
                     null,
                     [
                             new VariableDefinitionNumber ("Random Number"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_RandomRange, random_package, "RandomBetween", 
                     [
                             new VariableDefinitionNumber ("Min Number"), 
                             new VariableDefinitionNumber ("Max Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Random Number"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_RandomIntRange, random_package, "IntegerRandomBetween", 
                     [
                             new VariableDefinitionNumber ("Min Integer Number"), 
                             new VariableDefinitionNumber ("Max Integer Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Random Ingeter Number"), 
                     ]
                  );
          
       // math / number convert
          
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Degrees2Radians, convert_package, "Degrees -> Radians", 
                     [
                             new VariableDefinitionNumber ("Degrees"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Radians2Degrees, convert_package, "Radians -> Degrees", 
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Degrees"), 
                     ]
                  );
          RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Number2RGB, convert_package, "Number -> RGB", 
                     [
                             new VariableDefinitionNumber ("Number", null, null, {mIsColorValue: true}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_RGB2Number, convert_package, "RGB -> Number", 
                     [
                             new VariableDefinitionNumber ("Red (0-255)"), 
                             new VariableDefinitionNumber ("Green (0-255)"), 
                             new VariableDefinitionNumber ("Blue (0-255)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Number", null, null, {mIsColorValue: true}), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds, convert_package, "Milliseconds -> Minutes : Seconds", 
                     [
                             new VariableDefinitionNumber ("Milliseconds", null, null, {mMinValue: 0.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Minitues"), 
                             new VariableDefinitionNumber ("Seconds"), 
                             new VariableDefinitionNumber ("Milliseconds"), 
                     ]
                  );
         
     // math / usual
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Max, usual_math_package, "Max", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Min, usual_math_package, "Min", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Abs, usual_math_package, "Abs", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Sqrt, usual_math_package, "Sqrt", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Ceil, usual_math_package, "Ceil", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Floor, usual_math_package, "Floor", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Round, usual_math_package, "Round", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Log, usual_math_package, "Log", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Exp, usual_math_package, "Exp", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Power, usual_math_package, "Power", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                             new VariableDefinitionNumber ("Power"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.Id_Math_LinearInterpolation, interpolation_package, "Linear Interpolation", 
                     [
                             new VariableDefinitionNumber ("Number x"), 
                             new VariableDefinitionNumber ("Number y"), 
                             new VariableDefinitionNumber ("Factor t"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result (x * t + (1.0 - t) * y)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.Id_Math_LinearInterpolationColor, interpolation_package, "Color Linear Interpolation", 
                     [
                             new VariableDefinitionNumber ("Color x", null, null, {mIsColorValue: true}), 
                             new VariableDefinitionNumber ("Color y", null, null, {mIsColorValue: true}), 
                             new VariableDefinitionNumber ("Factor t (0-1)", null, null, {mMinValue: 0.0, mMaxValue:1.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result (x * t + (1.0 - t) * y)", null, null, {mIsColorValue: true}), 
                     ]
                  );
         
      // game / design
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelMilliseconds, design_package, "GetLevelRunningMilliseconds", 
                     null,
                     [
                        new VariableDefinitionNumber ("Running Milliseconds"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelSteps, design_package, "GetLevelSimulationSteps", 
                     null,
                     [
                        new VariableDefinitionNumber ("Simulation Steps"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_SetLevelStatus, design_package, "SetLevelStatus", 
                     [
                        new VariableDefinitionNumber ("Status", null, null, {mValueLists: Lists.mLevelStatusList}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelSuccessed, design_package, "IsLevelSuccessed", 
                     null,
                     [
                        new VariableDefinitionBoolean ("Finshied?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelFailed, design_package, "IsLevelFailed", 
                     null,
                     [
                        new VariableDefinitionBoolean ("Failed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelUnfinished, design_package, "IsLevelUnfinished", 
                     null,
                     [
                        new VariableDefinitionBoolean ("Failed?"), 
                     ]
                  );
         
      // game / world
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians, world_package, "SetGravityAcceleration_ByRadians", 
                     [
                             new VariableDefinitionNumber ("Magnitude"), 
                             new VariableDefinitionNumber ("Angle Radians"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees, world_package, "SetGravityAcceleration_ByDegrees", 
                     [
                             new VariableDefinitionNumber ("Magnitude"), 
                             new VariableDefinitionNumber ("Angle Degrees"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector, world_package, "SetGravityAcceleration_ByVector", 
                     [
                             new VariableDefinitionNumber ("X"), 
                             new VariableDefinitionNumber ("Y"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraWithShape, world_package, "FollowCameraWithShape", 
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, null, {mDefaultValue: true}), 
                             //new VariableDefinitionBoolean ("Follow Rotation?"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape, world_package, "FollowCameraCenterXWithShape", 
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape, world_package, "FollowCameraCenterYWithShape", 
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraRotationWithShape, world_package, "FollowCameraRotationWithShape", 
         //            [
         //                    new VariableDefinitionEntity ("The Followed Shape"), 
         //                    new VariableDefinitionBoolean ("Smooth Following?", null, null, {mDefaultValue: true}), 
         //            ],
         //            null
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn, world_package, "FadeOutThenFadeIn", 
                     [
                             new VariableDefinitionNumber ("Fade Color", null, null, {mIsColorValue: true}), 
                             new VariableDefinitionNumber ("Fade Out Steps", null, null, {mMinValue: 0}), 
                             new VariableDefinitionNumber ("Fade Staying Steps", null, null, {mMinValue: 1}), 
                             new VariableDefinitionNumber ("Fade In Steps", null, null, {mMinValue: 0}), 
                             new VariableDefinitionEntity ("Script to Call", null, null, {mFilter: Filters.IsScriptHolderEntity}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallScript, world_package, "CallScript", 
                     [
                             new VariableDefinitionEntity ("Script to Call", null, null, {mFilter: Filters.IsScriptHolderEntity}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_ConditionCallScript, world_package, "Condition CallScript", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Script1 to Call", null, null, {mFilter: Filters.IsScriptHolderEntity}), 
                             new VariableDefinitionEntity ("Script2 to Call", null, null, {mFilter: Filters.IsScriptHolderEntity}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallBoolFunction, world_package, "CallBoolFunction", 
                     [
                             new VariableDefinitionEntity ("Script to Call", null, null, {mFilter: Filters.IsBasicConditionEntity}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Return Bool Result"),
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_ConditionCallBoolFunction, world_package, "Condition CallBoolFunction", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Script1 to Call", null, null, {mFilter: Filters.IsBasicConditionEntity}), 
                             new VariableDefinitionEntity ("Script2 to Call", null, null, {mFilter: Filters.IsBasicConditionEntity}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Return Bool Result"),
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallScriptMultiTimes, world_package, "CallScriptMultiTimes", 
                     [
                             new VariableDefinitionEntity ("Script to Call", null, null, {mFilter: Filters.IsScriptHolderEntity}), 
                             new VariableDefinitionNumber ("Calling Times", null, null, {mMinValue: 0}),  // dengerous
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes, world_package, "CallBoolFunctionMultiTimes", 
                     [
                             new VariableDefinitionEntity ("Script to Call", null, null, {mFilter: Filters.IsBasicConditionEntity}), 
                     ],
                     null
                  );
         
     // game / collision category
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_Assign, cat_package, "= (Assign CCat)", 
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category"), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Target"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_ConditionAssign, cat_package, "?= (Condition Assign CCat)", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionCollisionCategory ("Collision Category 1"), 
                             new VariableDefinitionCollisionCategory ("Collision Category 2"), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Assign To"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_SetCollideInternally, cat_package, "SetCollisionCategoryCollideInternally", 
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category"), 
                             new VariableDefinitionBoolean ("Collide Internally?", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_SetAsFriends, cat_package, "SetCollisionCategoriesAsFriends", 
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category 1"), 
                             new VariableDefinitionCollisionCategory ("Collision Category 2"), 
                             new VariableDefinitionBoolean ("Friends?", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         
     // game /entity
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Assign, entity_package, "= (Assign Entity)", 
                     [
                             new VariableDefinitionEntity ("Source Entity"), 
                     ],
                     [
                             new VariableDefinitionEntity ("Terget"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_ConditionAssign, entity_package, "?= (Condition Assign Entity)", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Source Entity 1"), 
                             new VariableDefinitionEntity ("Source Entity 2"), 
                     ],
                     [
                             new VariableDefinitionEntity ("Terget"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetTaskStatus,  entity_as_task_package, "SetTaskStatus", 
                     [
                        new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.IsTaskEntity}), 
                        new VariableDefinitionNumber ("Task Status (-1/0/1)", null, null, {mValueLists: Lists.mEntityTaskStatusList}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskSuccessed, entity_as_task_package, "IsTaskSuccessed", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.IsTaskEntity}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Successed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskFailed, entity_as_task_package, "IsTaskFailed", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.IsTaskEntity}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Failed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskUnfinished, entity_as_task_package, "IsTaskUnfinished", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.IsTaskEntity}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Unfinished?"), 
                     ]
                  );
         
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsShapeEntity, entity_is_subtype_package, "IsShape", 
         //            [
         //                    new VariableDefinitionEntity ("The Entity"), 
         //            ],
         //            [
         //                    new VariableDefinitionBoolean ("Visible?"), 
         //            ]
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsVisible, entity_package, "IsVisible", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.IsVisualEntity}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Visible?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetVisible, entity_package, "SetVisible", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.IsVisualEntity}), 
                             new VariableDefinitionBoolean ("Visible?", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetAlpha, entity_package, "GetAlpha", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.IsVisualEntity}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Alpha"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetAlpha, entity_package, "SetAlpha", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.IsVisualEntity}), 
                             new VariableDefinitionNumber ("Alpha (0-1)", null, null, {mMinValue: 0.0, mMaxValue:1.0}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsEnabled, entity_trigger_package, "IsEventHandlerEnabled", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.CanBeDisabled}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Enabled?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetEnabled, entity_trigger_package, "SetEventHandlerEnabled", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.CanBeDisabled}), 
                             new VariableDefinitionBoolean ("Enabled?", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetPosition, entity_package, "GetPosition", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.DoesEntityHasPosition}), 
                     ],
                     [
                             new VariableDefinitionNumber ("x"), 
                             new VariableDefinitionNumber ("y"), 
                     ]
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetPosition, entity_package, "SetPosition", 
         //            [
         //                    new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.DoesEntityHasPosition}), 
         //                    new VariableDefinitionNumber ("x"), 
         //                    new VariableDefinitionNumber ("y"), 
         //            ],
         //            null
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians, entity_package, "GetRotationByRadians", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.DoesEntityHasPosition}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees, entity_package, "GetRotationByDegrees", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.DoesEntityHasPosition}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (degrees)"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint, entity_shape_package, "WorldPoint2LocalPoint", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), // currently, only for shapes
                             new VariableDefinitionNumber ("World Point X"), 
                             new VariableDefinitionNumber ("World Point Y"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Local Point X"), 
                             new VariableDefinitionNumber ("Local Point Y"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint, entity_shape_package, "LocalPoint2WorldPoint", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), // currently, only for shapes
                             new VariableDefinitionNumber ("Local Point X"), 
                             new VariableDefinitionNumber ("Local Point Y"), 
                     ],
                     [
                             new VariableDefinitionNumber ("World Point X"), 
                             new VariableDefinitionNumber ("World Point Y"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Destroy, entity_package, "Destroy", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.CanEntityBeDestroyedManually}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Overlapped, entity_package, "Two Entities Overlapped?", 
                     [
                        new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.DoesEntityHasPosition}), 
                        new VariableDefinitionEntity ("The Entity", null, null, {mFilter: Filters.DoesEntityHasPosition}), 
                        new VariableDefinitionNumber ("Tolerance Delta X", null, null, {mMinValue:0.0, mDefaultValue:0.8}), 
                        new VariableDefinitionNumber ("Tolerance Delta Y", null, null, {mMinValue:0.0, mDefaultValue:0.8}), 
                        new VariableDefinitionNumber ("Tolerance Delta Angle (degrees)", null, null, {mMinValue:0.0, mDefaultValue:6}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Overlapped?"), 
                     ]
                  );
         
      // game / entity / shape
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsCircleShapeEntity, shape_is_subtype_package, "Is a Circle Shape?", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Circle?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsRectangleShapeEntity, shape_is_subtype_package, "Is a Rectangle Shape?", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Rectangle?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsPolygonShapeEntity, shape_is_subtype_package, "Is a Polygon Shape?", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Polygon?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsPolylineShapeEntity, shape_is_subtype_package, "Is a Polyline Shape?", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Polyline?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsBombShapeEntitiy, shape_is_subtype_package, "Is a Bomb Shape?", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Bomb?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntitiy, shape_is_subtype_package, "Is a World Border?", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is World Border?"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCIType, shape_appearance_package, "Get C.I. Type", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                             new VariableDefinitionNumber ("CI Type"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCIType, shape_appearance_package, "Set C.I. Type", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionNumber ("CI Type", null, null, {mValueLists: Lists.mAiTypeList}), 
                     ],
                     null
                  );
         
          RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor, shape_appearance_package, "GetFilledColor", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Filled Color", null, null, {mIsColorValue: true}), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor, shape_appearance_package, "SetFilledColor", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionNumber ("Filled Color", null, null, {mIsColorValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB, shape_appearance_package, "GetFilledColorRGB", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB, shape_appearance_package, "SetFilledColorRGB", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled, shape_physics_package, "IsPhysicsEnabled", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Physics Enabled?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCollisionCategory, shape_physics_package, "GetCollisionCategory", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category (ccat)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCollisionCategory, shape_physics_package, "SetCollisionCategory", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionCollisionCategory ("Collision Category (ccat)"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsSensor, shape_physics_package, "IsSensor", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Sensor"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetAsSensor, shape_physics_package, "SetAsSensor", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionBoolean ("Is Sensor", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity, entity_shape_package, "GetDensity", 
         //            [
         //                    new VariableDefinitionEntity ("The Shape"), 
         //            ],
         //            [
         //                    new VariableDefinitionNumber ("Density"), 
         //            ]
         //         );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity, entity_shape_package, "SetDensity", 
         //            [
         //                    new VariableDefinitionEntity ("The Shape"), 
         //                    new VariableDefinitionNumber ("Density", null, null, {mMinValue: 0.0}), 
         //            ],
         //            null
         //         );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Teleport, entity_shape_package, "TeleportShape", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionNumber ("Target PositionX"), 
                             new VariableDefinitionNumber ("Target PositionY"), 
                             new VariableDefinitionNumber ("Target Angle (degrees)"), 
                             new VariableDefinitionBoolean ("Teleport Connected Movables?", null, null, {mDefaultValue: true}), 
                             new VariableDefinitionBoolean ("Teleport Connected Statics?", null, null, {mDefaultValue: false}), 
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_TeleportOffsets, entity_shape_package, "TeleportShape_Offsets", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionNumber ("Offset PositionX"), 
                             new VariableDefinitionNumber ("Offset PositionY"), 
                             new VariableDefinitionNumber ("Delta Angle (degrees)"), 
                             new VariableDefinitionBoolean ("Teleport Connected Movables?", null, null, {mDefaultValue: true}), 
                             new VariableDefinitionBoolean ("Teleport Connected Statics?", null, null, {mDefaultValue: false}), 
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Clone, entity_shape_package, "CloneShape", 
         //            [
         //                    new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
         //                    new VariableDefinitionNumber ("Target PositionX"), 
         //                    new VariableDefinitionNumber ("Target PositionY"), 
         //                    new VariableDefinitionNumber ("Delta Rotation"), 
         //                    new VariableDefinitionBoolean ("Teleport Connected Movables?", null, null, {mDefaultValue: true}), 
         //                    new VariableDefinitionBoolean ("Teleport Connected Statics?", null, null, {mDefaultValue: true}), 
         //            ],
         //            null
         //         );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Detach, entity_shape_package, "DetachShape", 
                     [
                             new VariableDefinitionEntity ("The Shape to Be Detached", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_AttachWith, entity_shape_package, "AttachShapes", 
                     [
                             new VariableDefinitionEntity ("Shape 1", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionEntity ("Shape 2", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_DetachThenAttachWith, entity_shape_package, "DetachThenAttach", 
                     [
                             new VariableDefinitionEntity ("Shape 1", null, null, {mFilter: Filters.IsShapeEntity}), 
                             new VariableDefinitionEntity ("Shape 2", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_BreakupBrothers, entity_shape_package, "BreakupBrothers", 
                     [
                             new VariableDefinitionEntity ("One Borther Shape", null, null, {mFilter: Filters.IsShapeEntity}), 
                     ],
                     null
                  );
	     
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_BreakAllJoints, entity_shape_package, "BreakAllJoints",
                     [
                        new VariableDefinitionEntity ("The Shape", null, null, {mFilter: Filters.IsShapeEntity}),  
                     ],
                     null
                  );


         
      // game / entity / shape / text
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetText, shape_text_package, "GetText", 
                     [
                             new VariableDefinitionEntity ("Text Component", null, null, {mFilter: Filters.IsTextEntity}), 
                     ],
                     [
                             new VariableDefinitionString ("New Text"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetText, shape_text_package, "SetText", 
                     [
                             new VariableDefinitionEntity ("Text Component", null, null, {mFilter: Filters.IsTextEntity}), 
                             new VariableDefinitionString ("New Text"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendText, shape_text_package, "AppendText", 
                     [
                             new VariableDefinitionEntity ("Text Component", null, null, {mFilter: Filters.IsTextEntity}), 
                             new VariableDefinitionString ("Text to Append"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendNewLine, shape_text_package, "AppendNewLine", 
                     [
                             new VariableDefinitionEntity ("Text Component", null, null, {mFilter: Filters.IsTextEntity}), 
                     ],
                     null
                  );
         
       // game / entity / joint
         
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees, entity_joint_package, "GetHingeLimits", 
                     [
                        new VariableDefinitionEntity ("The Hinge", null, null, {mFilter: Filters.IsHingeEntity}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Lower Angle (degrees)"), 
                        new VariableDefinitionNumber ("Upper Angle (degrees)"), 
                     ]
                  );
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees, entity_joint_package, "SetHingeLimits", 
                     [
                        new VariableDefinitionEntity ("The Hinge", null, null, {mFilter: Filters.IsHingeEntity}), 
                        new VariableDefinitionNumber ("Lower Angle (degrees)"), 
                        new VariableDefinitionNumber ("Upper Angle (degrees)"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderLimits, entity_joint_package, "GetSliderLimits", 
                     [
                        new VariableDefinitionEntity ("The Slider", null, null, {mFilter: Filters.IsSliderEntity}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Lower Translation"), 
                        new VariableDefinitionNumber ("Upper Translation"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderLimits, entity_joint_package, "SetSliderLimits", 
                     [
                        new VariableDefinitionEntity ("The Slider", null, null, {mFilter: Filters.IsSliderEntity}), 
                        new VariableDefinitionNumber ("Lower Translation"), 
                        new VariableDefinitionNumber ("Upper Translation"), 
                     ],
                     null
                  );
         
      // trigger
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_ResetTimer, entity_trigger_package, "ResetTimer", 
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, null, {mFilter: Filters.IsTimerEventHandlerEntity}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerPaused, entity_trigger_package, "SetTimerPaused", 
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, null, {mFilter: Filters.IsTimerEventHandlerEntity}), 
                        new VariableDefinitionBoolean ("Paused", null, null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerInterval, entity_trigger_package, "SetTimerInterval", 
         //            [
         //               new VariableDefinitionEntity ("The Timer Event Handler", null, null, {mFilter: Filters.IsTimerEventHandlerEntity}), 
         //               new VariableDefinitionNumber ("Interval", null, null, {mMinValue: 0.0}),
         //            ],
         //            null
         //         );

         
      // ...
         
         sMenuBarDataProvider = AddPackageToXML (sToppestPackage, null)
     }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterFunctionDeclaration (function_id:int, functionPackage:FunctionPackage, function_name:String, param_defines:Array, return_defines:Array):void
      {
         if (function_id < 0)
            return;
         
         sFunctionDeclarations [function_id] = new FunctionDeclaration_Core (function_id, function_name, param_defines, return_defines, null);
         
         if (functionPackage != null)
            functionPackage.AddFunctionDeclaration (sFunctionDeclarations [function_id]);
      }
      
      public static function GetFunctionDeclarationById (function_id:int):FunctionDeclaration_Core
      {
         if (function_id < 0 || function_id >= sFunctionDeclarations.length)
            return null;
         
         return sFunctionDeclarations [function_id];
      }
      
      private static function AddPackageToXML (functionPackage:FunctionPackage, xml:XML):XML
      {
         var package_element:XML;
         
         if (xml == null)
         {
            package_element = <root />;
            xml = package_element;
         }
         else
         {
            package_element = <menuitem />;
            package_element.@name = functionPackage.GetName ();
            xml.appendChild (package_element);
         }
         
         var num_items:int = 0;
         
         var child_packages:Array = functionPackage.GetChildPackages ();
         for (var i:int = 0; i < child_packages.length; ++ i)
         {
            AddPackageToXML (child_packages [i] as FunctionPackage, package_element);
            
            ++ num_items;
         }
         
         var declarations:Array = functionPackage.GetFunctionDeclarations ();
         var declaration:FunctionDeclaration_Core;
         var function_element:XML;
         for (var j:int = 0; j < declarations.length; ++ j)
         {
            declaration = declarations [j] as FunctionDeclaration_Core;
            
            function_element = <menuitem />;
            function_element.@name = declaration.GetName ();
            function_element.@id = declaration.GetID ();
            
            package_element.appendChild (function_element);
            
            ++ num_items;
         }
         
         if (num_items == 0)
         {
            function_element = <menuitem />;
            function_element.@name = "[nothing]";
            function_element.@id = -1;
            
            package_element.appendChild (function_element);
         }
         
         return xml;
      }
   }
}
