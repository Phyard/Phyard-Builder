
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
      
      public static const sGlobalPackage:FunctionPackage = new FunctionPackage ("Global", sToppestPackage);
      public static const sWorldPackage:FunctionPackage = new FunctionPackage ("World", sToppestPackage);
      public static const sEntityPackage:FunctionPackage = new FunctionPackage ("Entity", sToppestPackage);
      
      public static var sMenuBarDataProvider:XML = null;
      
      public static function Initialize ():void
      {
         
      //================================================
      // packages
      //================================================
         
         var system_package:FunctionPackage = new FunctionPackage ("System", sGlobalPackage);
         var basic_package:FunctionPackage = new FunctionPackage ("Basic", sGlobalPackage);
         var math_package:FunctionPackage   = new FunctionPackage ("Math", sGlobalPackage);
            var usual_math_package:FunctionPackage         = new FunctionPackage ("Usual", math_package);
            var trigonometry_package:FunctionPackage = new FunctionPackage ("Trigonometry", math_package);
            var random_package:FunctionPackage             = new FunctionPackage ("Random", math_package);
            var bitwise_package:FunctionPackage            = new FunctionPackage ("Bitwise", math_package);
            var convert_package:FunctionPackage            = new FunctionPackage ("Number Convert", math_package);
            var interpolation_package:FunctionPackage      = new FunctionPackage ("Interpolation", math_package);
         var string_package:FunctionPackage = new FunctionPackage ("String", sGlobalPackage);
         var bool_package:FunctionPackage   = new FunctionPackage ("Logic", sGlobalPackage);
         
         var world_general_package:FunctionPackage  = new FunctionPackage ("General", sWorldPackage);
         var ccat_package:FunctionPackage    = new FunctionPackage ("CCat", sWorldPackage);
         var level_package:FunctionPackage  = new FunctionPackage ("Level Status", sWorldPackage);
         var world_physics_package:FunctionPackage    = new FunctionPackage ("Physics", sWorldPackage);
         //var world_appearance_package:FunctionPackage    = new FunctionPackage ("Appearance", sWorldPackage);
         var world_camera_package:FunctionPackage    = new FunctionPackage ("Camera", sWorldPackage);
         var world_script_package:FunctionPackage    = new FunctionPackage ("Script", sWorldPackage);
         
         var entity_package:FunctionPackage = new FunctionPackage ("Common", sEntityPackage);
                var entity_as_task_package:FunctionPackage    = new FunctionPackage ("- Task Status", sEntityPackage);
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
            RegisterFunctionDeclaration (CoreFunctionIds.ID_ForDebug, basic_package, "ForDevDebug", "ForDevDebug", 
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
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Void, null, "Action", "Action",
                     null,
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool, null, "Condition", "Condition",
                     null,
                     [
                              new VariableDefinitionBoolean ("Bool Value"), 
                     ]
                  );
       
      // global
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Return, basic_package, "Return", "Return", 
                     null,
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_ReturnIfTrue, basic_package, "ReturnIfTrue", "ReturnIfTrue", 
                     [
                             new VariableDefinitionBoolean ("Bool Value"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_ReturnIfFalse, basic_package, "ReturnIfFalse", "ReturnIfFalse", 
                     [
                             new VariableDefinitionBoolean ("Bool Value"), 
                     ],
                     null
                  );
         
      // system / time
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_GetProgramMilliseconds, system_package, "GetProgramMilliseconds", "GetProgramMilliseconds", 
                     null,
                     [
                             new VariableDefinitionNumber ("Milliseconds"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_GetCurrentDateTime, system_package, "GetCurrentDateTime", "GetCurrentDateTime", 
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_IsKeyHold, system_package, "IsKeyHold", "IsKeyHold", 
                     [
                             new VariableDefinitionNumber ("The Key", null, {mValueLists: Lists.mKeyCodeList}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Hold?"),
                     ]
                  );
         
      // string
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_Assign, string_package, "= (Assign String)", "AssignedWith", 
                     [
                             new VariableDefinitionString ("Source String"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_ConditionAssign, string_package, "?= (Condition Assign String)", "ConditionAssignedWith", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionString ("Source String 1"), 
                             new VariableDefinitionString ("Source String 2"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_Add, string_package, "String + String", "ConcatenateStrings", 
                     [
                             new VariableDefinitionString ("Source String 1"), 
                             new VariableDefinitionString ("Source String 2"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_NumberToString, string_package, "Number -> String", "Number2String", 
                     [
                             new VariableDefinitionNumber ("The Number"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_BooleanToString, string_package, "Bool -> String", "Bool2String", 
                     [
                             new VariableDefinitionBoolean ("The Bool"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_EntityToString, string_package, "Entity -> String", "Entity2String", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_CollisionCategoryToString, string_package, "CCat -> String", "CCat2String", 
                     [
                             new VariableDefinitionCollisionCategory ("The CCat"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         
       // bool
          
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Assign, bool_package, "= (Assign Boolean)", "AssignedWith", 
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Target Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_ConditionAssign, bool_package, "=? (Condition Assign Boolean)", "ConditionAssignedWith", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionBoolean ("Source Boolean 1"), 
                             new VariableDefinitionBoolean ("Source Boolean 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Target Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Invert, bool_package, "! (Invert)", "Invert", 
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_IsTrue, bool_package, "IsTrue?", "IsTrue", 
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_IsFalse, bool_package, "IsFalse?", "IsFalse", 
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsNumber, bool_package, "Number == Number?", "Equals", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsBoolean, bool_package, "Boolean == Boolean?",  "Equals", 
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsString, bool_package, "String == String?", "Equals", 
                     [
                             new VariableDefinitionString ("String 1"), 
                             new VariableDefinitionString ("String 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsEntity, bool_package, "Entity == Entity?",  "Equals", 
                     [
                             new VariableDefinitionEntity ("Entity 1"), 
                             new VariableDefinitionEntity ("Entity 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsCCat, bool_package, "CCat == CCat?",  "Equals", 
                     [
                             new VariableDefinitionCollisionCategory ("CCat 1"), 
                             new VariableDefinitionCollisionCategory ("CCat 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Larger, bool_package, "Number > Number?", "LargerThan", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Less, bool_package, "Number < Number?", "LessThan", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_And, bool_package, "x && y (Bool And)", "And", 
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Or, bool_package, "x || y (Bool Or)", "Or", 
                     [
                             new VariableDefinitionBoolean ("Boolean 1"), 
                             new VariableDefinitionBoolean ("Boolean 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Not, bool_package, "! x (Bool Not)", "Not", 
                     [
                             new VariableDefinitionBoolean ("Input Boolean Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Xor, bool_package, "^ (Bool Xor)", "Xor", 
                     [
                             new VariableDefinitionBoolean ("Boolean 1"), 
                             new VariableDefinitionBoolean ("Boolean 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
          
       // math basic ops
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Assign, math_package, "= (Number Assign)", "Assign", 
                     [
                             new VariableDefinitionNumber ("Source"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Target"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ConditionAssign, math_package, "=? (Condition Assign)", "CondtionAssign", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionNumber ("True Source"), 
                             new VariableDefinitionNumber ("False Source"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Target"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Negative, math_package, "- x (Negative)", "Negative", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Inverse, math_package, "1.0 / x (Inverse)", "Inverse", 
                     [
                             new VariableDefinitionNumber ("Number", null, {mDefaultValue: 1.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Add, math_package, "x + y", "Add", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Subtract, math_package, "x - y", "Subtract", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Multiply, math_package, "x * y (Multiply)", "Multiply", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Divide, math_package, "x / y (Divide)", "Divide", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Modulo, math_package, "x % y (Modulo)", "Modulo", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         
      // math / bitwise
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftLeft, bitwise_package, "<< (ShiftLeft)", "<<", 
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRight, bitwise_package, ">> (ShiftRight)", ">>", 
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned, bitwise_package, ">>> (ShiftRightUnsignedly)",  ">>>", 
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_And, bitwise_package, "x & y (Bitwise And)", "BitwiseAnd", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Or, bitwise_package, "x | y (Bitwise Or)", "BitwiseOr", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Not, bitwise_package, "~ x (Bitwise Not)", "BitwiseMot", 
                     [
                             new VariableDefinitionNumber ("Inout Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Xor, bitwise_package, "x ^ y (Bitwise Xor)", "BitwiseXor", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         
      // math / number trinomogetry
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_SinRadians, trigonometry_package, "Sin", "Sin", 
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Sin (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_CosRadians, trigonometry_package, "Cos", "Cos", 
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Cos (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_TanRadians, trigonometry_package, "Tan", "Tan", 
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Tan (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ArcSinRadians, trigonometry_package, "ArcSin_Radians", "ArcSin", 
                     [
                             new VariableDefinitionNumber ("Sin (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ArcCosRadians, trigonometry_package, "ArcCos_Radians", "ArcCos", 
                     [
                             new VariableDefinitionNumber ("Cos (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ArcTanRadians, trigonometry_package, "ArcTan_Radians", "ArcTan", 
                     [
                             new VariableDefinitionNumber ("Tan (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_ArcTan2Radians, trigonometry_package, "ArcTan2_Radians", "ArcTan2", 
                     [
                             new VariableDefinitionNumber ("y"), 
                             new VariableDefinitionNumber ("x"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         
      // math / random
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Random, random_package, "Random", "Random", 
                     null,
                     [
                             new VariableDefinitionNumber ("Random Number"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_RandomRange, random_package, "RandomBetween", "RandomBetween", 
                     [
                             new VariableDefinitionNumber ("Min Number"), 
                             new VariableDefinitionNumber ("Max Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Random Number"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_RandomIntRange, random_package, "IntegerRandomBetween", "IntegerRandomBetween", 
                     [
                             new VariableDefinitionNumber ("Min Integer Number"), 
                             new VariableDefinitionNumber ("Max Integer Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Random Ingeter Number"), 
                     ]
                  );
          
       // math / number convert
          
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Degrees2Radians, convert_package, "Degrees -> Radians", "Degrees2Radians", 
                     [
                             new VariableDefinitionNumber ("Degrees"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Radians2Degrees, convert_package, "Radians -> Degrees", "Radians2Degrees", 
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Degrees"), 
                     ]
                  );
          RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Number2RGB, convert_package, "Color -> RGB", "Color2RGB", 
                     [
                             new VariableDefinitionNumber ("Number", null, {mIsColorValue: true}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_RGB2Number, convert_package, "RGB -> Color", "RGB2olor", 
                     [
                             new VariableDefinitionNumber ("Red (0-255)"), 
                             new VariableDefinitionNumber ("Green (0-255)"), 
                             new VariableDefinitionNumber ("Blue (0-255)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Number", null, {mIsColorValue: true}), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds, convert_package, "Milliseconds -> Minutes : Seconds", "Milliseconds2MinutesAndSeconds", 
                     [
                             new VariableDefinitionNumber ("Milliseconds", null, {mMinValue: 0.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Minitues"), 
                             new VariableDefinitionNumber ("Seconds"), 
                             new VariableDefinitionNumber ("Milliseconds"), 
                     ]
                  );
         
     // math / usual
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Abs, usual_math_package, "Abs", "Abs", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Max, usual_math_package, "Max", "Max", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Min, usual_math_package, "Min", "Min", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Clamp, usual_math_package, "Clamp", "Clamp", 
                     [
                             new VariableDefinitionNumber ("Number to Clamp"), 
                             new VariableDefinitionNumber ("Lower Limit"), 
                             new VariableDefinitionNumber ("Upper Limit"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Sqrt, usual_math_package, "Sqrt", "Sqrt", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Ceil, usual_math_package, "Ceil", "Ceil", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Floor, usual_math_package, "Floor", "Floor", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Round, usual_math_package, "Round", "Round", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Log, usual_math_package, "Log", "Log", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Exp, usual_math_package, "Exp", "Exp", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Power, usual_math_package, "Power", "Power", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                             new VariableDefinitionNumber ("Power"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.Id_Math_LinearInterpolation, interpolation_package, "Linear Interpolation", "LinearInterpolation", 
                     [
                             new VariableDefinitionNumber ("Number x1"), 
                             new VariableDefinitionNumber ("Number x2"), 
                             new VariableDefinitionNumber ("Factor t"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result (x1 * t + (1.0 - t) * x2)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.Id_Math_LinearInterpolationColor, interpolation_package, "Color Linear Interpolation", "ColorLinearInterpolation", 
                     [
                             new VariableDefinitionNumber ("Color c1", null, {mIsColorValue: true}), 
                             new VariableDefinitionNumber ("Color c2", null, {mIsColorValue: true}), 
                             new VariableDefinitionNumber ("Factor t (0-1)", null, {mMinValue: 0.0, mMaxValue:1.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result (c1 * t + (1.0 - t) * c2)", null, {mIsColorValue: true}), 
                     ]
                  );
         
      // game / design
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelMilliseconds, world_general_package, "GetLevelRunningMilliseconds", "GetLevelRunningMilliseconds", 
                     null,
                     [
                        new VariableDefinitionNumber ("Running Milliseconds"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelSteps, world_general_package, "GetLevelSimulationSteps", "GetLevelSimulationSteps", 
                     null,
                     [
                        new VariableDefinitionNumber ("Simulation Steps"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_GetMousePosition, world_general_package, "GetMousePosition", "GetMousePosition", 
                     null,
                     [
                        new VariableDefinitionNumber ("Mouse X"), 
                        new VariableDefinitionNumber ("Mouee Y"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsMouseButtonHold, world_general_package, "IsMouseButtonHold", "IsMouseButtonHold", 
                     null,
                     [
                        new VariableDefinitionBoolean ("Hold?"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_SetLevelStatus, level_package, "SetLevelStatus", "SetLevelStatus", 
                     [
                        new VariableDefinitionNumber ("Status", null, {mValueLists: Lists.mLevelStatusList}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelSuccessed, level_package, "IsLevelSuccessed", "IsLevelSuccessed", 
                     null,
                     [
                        new VariableDefinitionBoolean ("Finshied?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelFailed, level_package, "IsLevelFailed", "IsLevelFailed", 
                     null,
                     [
                        new VariableDefinitionBoolean ("Failed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelUnfinished, level_package, "IsLevelUnfinished", "IsLevelUnfinished", 
                     null,
                     [
                        new VariableDefinitionBoolean ("Unfinished?"), 
                     ]
                  );
         
      // game / world
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians, world_physics_package, "SetGravityAcceleration_ByRadians", "SetGravityAcceleration_ByRadians", 
                     [
                             new VariableDefinitionNumber ("Magnitude"), 
                             new VariableDefinitionNumber ("Angle Radians"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees, world_physics_package, "SetGravityAcceleration_ByDegrees", "SetGravityAcceleration_ByDegrees", 
                     [
                             new VariableDefinitionNumber ("Magnitude"), 
                             new VariableDefinitionNumber ("Angle Degrees"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector, world_physics_package, "SetGravityAcceleration_ByVector", "SetGravityAcceleration_ByVector", 
                     [
                             new VariableDefinitionNumber ("gX"), 
                             new VariableDefinitionNumber ("gY"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraWithShape, world_camera_package, "FollowCameraWithShape", "FollowCameraWithShape", 
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, {mDefaultValue: true}), 
                             //new VariableDefinitionBoolean ("Follow Rotation?"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape, world_camera_package, "FollowCameraCenterXWithShape", "FollowCameraCenterXWithShape", 
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape, world_camera_package, "FollowCameraCenterYWithShape", "FollowCameraCenterYWithShape", 
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraRotationWithShape, world_camera_package, "FollowCameraRotationWithShape", "FollowCameraRotationWithShape", 
         //            [
         //                    new VariableDefinitionEntity ("The Followed Shape"), 
         //                    new VariableDefinitionBoolean ("Smooth Following?", null, {mDefaultValue: true}), 
         //            ],
         //            null
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn, world_camera_package, "FadeOutThenFadeIn", "FadeOutThenFadeIn", 
                     [
                             new VariableDefinitionNumber ("Fade Color", null, {mIsColorValue: true}), 
                             new VariableDefinitionNumber ("Fade Out Steps", null, {mMinValue: 0}), 
                             new VariableDefinitionNumber ("Fade Staying Steps", null, {mMinValue: 1}), 
                             new VariableDefinitionNumber ("Fade In Steps", null, {mMinValue: 0}), 
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallScript, world_script_package, "CallScript", "CallScript", 
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_ConditionCallScript, world_script_package, "Condition CallScript", "ConditionCallScript", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Script 1 to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                             new VariableDefinitionEntity ("Script 2 to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallBoolFunction, world_script_package, "CallBooleanFunction", "CallBooleanFunction", 
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Return Boolean Result"),
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_ConditionCallBoolFunction, world_script_package, "Condition CallBooleanFunction", "ConditionCallBooleanFunction", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Script 1 to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}), 
                             new VariableDefinitionEntity ("Script 2 to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Return Bool Result"),
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallScriptMultiTimes, world_script_package, "CallScriptMultiTimes", "CallScriptMultiTimes", 
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                             new VariableDefinitionNumber ("Calling Times", null, {mMinValue: 0}),  // dengerous
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes, world_script_package, "CallBoolFunctionMultiTimes", "CallBoolFunctionMultiTimes", 
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}), 
                     ],
                     null
                  );
         
     // game / collision category
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_Assign, ccat_package, "= (Assign CCat)", "Assign", 
                     [
                             new VariableDefinitionCollisionCategory ("Source Collision Category"), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Target Collision Category"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_ConditionAssign, ccat_package, "?= (Condition Assign CCat)", "ConditionAssign", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionCollisionCategory ("Collision Category 1"), 
                             new VariableDefinitionCollisionCategory ("Collision Category 2"), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Target Collision Category"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_SetCollideInternally, ccat_package, "SetCollisionCategoryCollideInternally", "SetCollisionCategoryCollideInternally", 
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category"), 
                             new VariableDefinitionBoolean ("Collide Internally?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_SetAsFriends, ccat_package, "SetCollisionCategoriesAsFriends", "SetCollisionCategoriesAsFriends", 
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category 1"), 
                             new VariableDefinitionCollisionCategory ("Collision Category 2"), 
                             new VariableDefinitionBoolean ("Friends?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         
     // game /entity
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Assign, entity_package, "= (Assign Entity)", "Assign", 
                     [
                             new VariableDefinitionEntity ("Source Entity"), 
                     ],
                     [
                             new VariableDefinitionEntity ("Terget"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_ConditionAssign, entity_package, "?= (Condition Assign Entity)", "ConditionAssign", 
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Source Entity 1"), 
                             new VariableDefinitionEntity ("Source Entity 2"), 
                     ],
                     [
                             new VariableDefinitionEntity ("Terget"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetTaskStatus,  entity_as_task_package, "SetTaskStatus", "SetTaskStatus", 
                     [
                        new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}), 
                        new VariableDefinitionNumber ("Task Status", null, {mValueLists: Lists.mEntityTaskStatusList}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskFailed, entity_as_task_package, "IsTaskFailed", "IsTaskFailed", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Failed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskSuccessed, entity_as_task_package, "IsTaskSuccessed", "IsTaskSuccessed", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Successed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskUnfinished, entity_as_task_package, "IsTaskUnfinished", "IsTaskUnfinished", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Unfinished?"), 
                     ]
                  );
         
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsShapeEntity, entity_is_subtype_package, "IsShape", "IsShape", 
         //            [
         //                    new VariableDefinitionEntity ("The Entity"), 
         //            ],
         //            [
         //                    new VariableDefinitionBoolean ("Visible?"), 
         //            ]
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsVisible, entity_package, "IsVisible", "IsVisible", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Visible?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetVisible, entity_package, "SetVisible", "SetVisible", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}), 
                             new VariableDefinitionBoolean ("Visible?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetAlpha, entity_package, "GetAlpha", "GetAlpha", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Alpha"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetAlpha, entity_package, "SetAlpha", "SetAlpha", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}), 
                             new VariableDefinitionNumber ("Alpha (0-1)", null, {mMinValue: 0.0, mMaxValue:1.0}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsEnabled, entity_trigger_package, "IsEventHandlerEnabled", "IsEventHandlerEnabled", 
                     [
                             new VariableDefinitionEntity ("The Event Handler", null, {mValidClasses: Filters.sCanBeDisabledEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Enabled?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetEnabled, entity_trigger_package, "SetEventHandlerEnabled", "SetEventHandlerEnabled", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sCanBeDisabledEntityClasses}), 
                             new VariableDefinitionBoolean ("Enabled?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetPosition, entity_package, "GetPosition", "GetPosition", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("x"), 
                             new VariableDefinitionNumber ("y"), 
                     ]
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetPosition, entity_package, "SetPosition", "SetPosition", 
         //            [
         //                    new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
         //                    new VariableDefinitionNumber ("x"), 
         //                    new VariableDefinitionNumber ("y"), 
         //            ],
         //            null
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians, entity_package, "GetRotationByRadians", "GetRotationByRadians", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees, entity_package, "GetRotationByDegrees", "GetRotationByDegrees", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (degrees)"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint, entity_shape_package, "WorldPoint2LocalPoint", "WorldPoint2LocalPoint", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), // currently, only for shapes
                             new VariableDefinitionNumber ("World Point X"), 
                             new VariableDefinitionNumber ("World Point Y"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Local Point X"), 
                             new VariableDefinitionNumber ("Local Point Y"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint, entity_shape_package, "LocalPoint2WorldPoint", "LocalPoint2WorldPoint", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), // currently, only for shapes
                             new VariableDefinitionNumber ("Local Point X"), 
                             new VariableDefinitionNumber ("Local Point Y"), 
                     ],
                     [
                             new VariableDefinitionNumber ("World Point X"), 
                             new VariableDefinitionNumber ("World Point Y"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsDestroyed, entity_package, "IsDestroyed", "IsDestroyed", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mExceptClasses: Filters.sLogicEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Already Destroyed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Destroy, entity_package, "Destroy", "Destroy", 
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mExceptClasses: Filters.sLogicEntityClasses}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Overlapped, entity_package, "Two Entities Superimposed?", "AreTwoEntitiesSuperimposed", 
                     [
                        new VariableDefinitionEntity ("The Entity 1", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
                        new VariableDefinitionEntity ("The Entity 2", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
                        new VariableDefinitionNumber ("Tolerance Delta X", null, {mMinValue:0.0, mDefaultValue:0.8}), 
                        new VariableDefinitionNumber ("Tolerance Delta Y", null, {mMinValue:0.0, mDefaultValue:0.8}), 
                        new VariableDefinitionNumber ("Tolerance Delta Angle (degrees)", null, {mMinValue:0.0, mDefaultValue:6}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Superimposed?"), 
                     ]
                  );
         
      // game / entity / shape
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsCircleShapeEntity, shape_is_subtype_package, "Is a Circle Shape?", "IsCircleShape", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Circle?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsRectangleShapeEntity, shape_is_subtype_package, "Is a Rectangle Shape?", "IsRectangleShape", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Rectangle?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsPolygonShapeEntity, shape_is_subtype_package, "Is a Polygon Shape?", "IsPolygonShape", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Polygon?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsPolylineShapeEntity, shape_is_subtype_package, "Is a Polyline Shape?", "IsPolylineShape", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Polyline?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsBombShapeEntitiy, shape_is_subtype_package, "Is a Bomb Shape?", "IsBombShape?", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Bomb?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntitiy, shape_is_subtype_package, "Is a World Border?", "IsWorldBorder?", 
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is World Border?"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCIType, shape_appearance_package, "Get C.I. Type", "GetCIType", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("CI Type"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCIType, shape_appearance_package, "Set C.I. Type", "SetCIType", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("CI Type", null, {mValueLists: Lists.mAiTypeList}), 
                     ],
                     null
                  );
         
          RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor, shape_appearance_package, "GetBackgroundColor", "GetBackgroundColor", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses, mGroundSelectable:true}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Filled Color", null, {mIsColorValue: true}), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor, shape_appearance_package, "SetBackgroundColor", "SetBackgroundColor", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses, mGroundSelectable:true}), 
                             new VariableDefinitionNumber ("Filled Color", null, {mIsColorValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB, shape_appearance_package, "GetBackgroundColorRGB", "GetBackgroundColorRGB", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses, mGroundSelectable:true}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB, shape_appearance_package, "SetBackgroundColorRGB", "SetBackgroundColorRGB", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses, mGroundSelectable:true}), 
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled, shape_physics_package, "IsPhysicsEnabled", "IsPhysicsEnabled", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Physics Enabled?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCollisionCategory, shape_physics_package, "GetCollisionCategory", "GetCollisionCategory", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category (ccat)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCollisionCategory, shape_physics_package, "SetCollisionCategory", "SetCollisionCategory", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionCollisionCategory ("Collision Category (ccat)"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsSensor, shape_physics_package, "IsSensor", "IsSensor", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Sensor?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetAsSensor, shape_physics_package, "SetSensor", "SetSensor", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionBoolean ("Is Sensor?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity, entity_shape_package, "GetDensity", "GetDensity", 
         //            [
         //                    new VariableDefinitionEntity ("The Shape"), 
         //            ],
         //            [
         //                    new VariableDefinitionNumber ("Density"), 
         //            ]
         //         );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity, entity_shape_package, "SetDensity", "SetDensity", 
         //            [
         //                    new VariableDefinitionEntity ("The Shape"), 
         //                    new VariableDefinitionNumber ("Density", null, {mMinValue: 0.0}), 
         //            ],
         //            null
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsSleeping, shape_physics_package, "IsSleeping", "IsSleeping", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Sleeping?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetSleeping, shape_physics_package, "SetSleeping", "SetSleeping", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionBoolean ("Sleeping?", null, {mDefaultValue: false}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForce, shape_physics_package, "ApplyStepForce", "ApplyStepForce", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Force X"), 
                             new VariableDefinitionNumber ("Force Y"), 
                             new VariableDefinitionBoolean ("Is Local Force?", null, {mDefaultValue: true}), 
                             new VariableDefinitionBoolean ("Apply on Center of Brothers?", null, {mDefaultValue: false}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint, shape_physics_package, "ApplyStepForceAtLocalPoint", "ApplyStepForceAtLocalPoint", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Force X"), 
                             new VariableDefinitionNumber ("Force Y"), 
                             new VariableDefinitionBoolean ("Is Local Force?", null, {mDefaultValue: true}), 
                             new VariableDefinitionNumber ("Local Point X"), 
                             new VariableDefinitionNumber ("Local Point Y"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtWorldPoint, shape_physics_package, "ApplyStepForceAtWorldPoint", "ApplyStepForceAtWorldPoint", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Force X"), 
                             new VariableDefinitionNumber ("Force Y"), 
                             new VariableDefinitionBoolean ("Is Local Force?", null, {mDefaultValue: true}), 
                             new VariableDefinitionNumber ("World Point X"), 
                             new VariableDefinitionNumber ("World Point Y"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepTorque, shape_physics_package, "ApplyStepTorque", "ApplyStepTorque", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Torque"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Teleport, entity_shape_package, "TeleportShape", "TeleportShape", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Target Position X"), 
                             new VariableDefinitionNumber ("Target Position Y"), 
                             new VariableDefinitionNumber ("Target Angle (degrees)"), 
                             new VariableDefinitionBoolean ("Teleport Connected Movables?", null, {mDefaultValue: true}), 
                             new VariableDefinitionBoolean ("Teleport Connected Statics?", null, {mDefaultValue: false}), 
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_TeleportOffsets, entity_shape_package, "TeleportShape_Offsets", "TeleportShape_Offsets", 
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Offset X"), 
                             new VariableDefinitionNumber ("Offset Y"), 
                             new VariableDefinitionNumber ("Delta Angle (degrees)"), 
                             new VariableDefinitionBoolean ("Teleport Connected Movables?", null, {mDefaultValue: true}), 
                             new VariableDefinitionBoolean ("Teleport Connected Statics?", null, {mDefaultValue: false}), 
                             new VariableDefinitionBoolean ("Break Embarrassed Joints?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Clone, entity_shape_package, "CloneShape", "CloneShape", 
         //            [
         //                    new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
         //                    new VariableDefinitionNumber ("Target PositionX"), 
         //                    new VariableDefinitionNumber ("Target PositionY"), 
         //                    new VariableDefinitionNumber ("Delta Rotation"), 
         //                    new VariableDefinitionBoolean ("Teleport Connected Movables?", null, {mDefaultValue: true}), 
         //                    new VariableDefinitionBoolean ("Teleport Connected Statics?", null, {mDefaultValue: true}), 
         //            ],
         //            null
         //         );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Detach, entity_shape_package, "DetachShape", "DetachShape", 
                     [
                             new VariableDefinitionEntity ("The Shape to Be Detached", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_AttachWith, entity_shape_package, "AttachShapes", "AttachShapes", 
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_DetachThenAttachWith, entity_shape_package, "DetachThenAttach", "DetachThenAttach", 
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_BreakupBrothers, entity_shape_package, "BreakupBrothers", "BreakupBrothers", 
                     [
                             new VariableDefinitionEntity ("One Borther Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     null
                  );
	     
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_BreakAllJoints, entity_shape_package, "BreakAllJoints", "BreakAllJoints",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),  
                     ],
                     null
                  );


         
      // game / entity / shape / text
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetText, shape_text_package, "GetText", "GetText", 
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionString ("The Text String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetText, shape_text_package, "SetText", "SetText", 
                     [
                             new VariableDefinitionEntity ("The Text Component", null, {mValidClasses: Filters.sTextEntityClasses}), 
                             new VariableDefinitionString ("New Text String"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendText, shape_text_package, "AppendText", "AppendText", 
                     [
                             new VariableDefinitionEntity ("The Text Component", null, {mValidClasses: Filters.sTextEntityClasses}), 
                             new VariableDefinitionString ("Text to Append"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendNewLine, shape_text_package, "AppendNewLine", "AppendNewLine", 
                     [
                             new VariableDefinitionEntity ("The Text Component", null, {mValidClasses: Filters.sTextEntityClasses}), 
                     ],
                     null
                  );
         
       // game / entity / joint
         
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees, entity_joint_package, "GetHingeLimits (By Degrees)", "GetHingeLimits_Degrees", 
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Lower Angle (degrees)"), 
                        new VariableDefinitionNumber ("Upper Angle (degrees)"), 
                     ]
                  );
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees, entity_joint_package, "SetHingeLimits (By Degrees)", "SetHingeLimits_Degrees", 
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                        new VariableDefinitionNumber ("Lower Angle (degrees)"), 
                        new VariableDefinitionNumber ("Upper Angle (degrees)"), 
                     ],
                     null
                  );
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeMotorSpeed, entity_joint_package, "GetHingeMotorSpeed (By Degrees)", "GetHingeMotorSpeed_Degrees", 
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Motor Speed (degrees/s)"), 
                     ]
                  );
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeMotorSpeed, entity_joint_package, "SetHingeMotorSpeed (By Degrees)", "SetHingeMotorSpeed_Degrees", 
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                        new VariableDefinitionNumber ("Motor Speed (degrees/s)"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderLimits, entity_joint_package, "GetSliderLimits", "GetSliderLimits", 
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Lower Translation"), 
                        new VariableDefinitionNumber ("Upper Translation"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderLimits, entity_joint_package, "SetSliderLimits", "SetSliderLimits", 
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                        new VariableDefinitionNumber ("Lower Translation"), 
                        new VariableDefinitionNumber ("Upper Translation"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderMotorSpeed, entity_joint_package, "GetSliderMotorSpeed", "GetSliderMotorSpeed", 
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Motor Speed (m/s)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderMotorSpeed, entity_joint_package, "SetSliderMotorSpeed", "SetSliderMotorSpeed", 
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                        new VariableDefinitionNumber ("Motor Speed (m/s)"), 
                     ],
                     null
                  );
         
      // trigger
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_ResetTimer, entity_trigger_package, "ResetTimer", "ResetTimer", 
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerPaused, entity_trigger_package, "SetTimerPaused", "SetTimerPaused", 
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}), 
                        new VariableDefinitionBoolean ("Paused?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerInterval, entity_trigger_package, "SetTimerInterval", "SetTimerInterval", 
         //            [
         //               new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}), 
         //               new VariableDefinitionNumber ("Interval", null, {mMinValue: 0.0}),
         //            ],
         //            null
         //         );

         
      // ...
         
         sMenuBarDataProvider = AddPackageToXML (sToppestPackage, null)
     }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterFunctionDeclaration (function_id:int, functionPackage:FunctionPackage, function_name:String, code_name:String, param_defines:Array, return_defines:Array):void
      {
         if (function_id < 0)
            return;
         
         sFunctionDeclarations [function_id] = new FunctionDeclaration_Core (function_id, function_name, code_name, param_defines, return_defines, null);
         
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
