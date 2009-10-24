
package editor.trigger {
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   import editor.entity.EntityJoint;
   import editor.entity.EntityShapeText;
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.ValueTypeDefine;
   
   public class PlayerFunctionDefinesForEditing
   {
      
      private static var sFunctionDeclarations:Array = new Array (128);
      
      public static var sTopFuntionPackage:FunctionPackage = new FunctionPackage ("");
      public static var sCoreApiMenuItemXML:XML = null;
      
      public static function Initialize ():void
      {
         
      //================================================
      // packages
      //================================================
         
         var global_package:FunctionPackage = new FunctionPackage ("global", sTopFuntionPackage);
         var system_package:FunctionPackage = new FunctionPackage ("system", sTopFuntionPackage);
         var math_package:FunctionPackage   = new FunctionPackage ("math (Number)", sTopFuntionPackage);
            var trigonometry_package:FunctionPackage = new FunctionPackage ("trigonometry", math_package);
            var random_package:FunctionPackage             = new FunctionPackage ("random", math_package);
            var bitwise_package:FunctionPackage            = new FunctionPackage ("bitwise", math_package);
            var convert_package:FunctionPackage            = new FunctionPackage ("number convert", math_package);
            var interpolation_package:FunctionPackage      = new FunctionPackage ("interpolation", math_package);
         var string_package:FunctionPackage = new FunctionPackage ("string (Text)", sTopFuntionPackage);
         var bool_package:FunctionPackage   = new FunctionPackage ("logic (Boolean)", sTopFuntionPackage);
         
         var world_package:FunctionPackage  = new FunctionPackage ("world", sTopFuntionPackage);
         var cat_package:FunctionPackage    = new FunctionPackage ("ccat (Collision Category)", sTopFuntionPackage);
         var entity_package:FunctionPackage = new FunctionPackage ("entity (Shape, Joint, Text, ...)", sTopFuntionPackage);
            var entity_is_package:FunctionPackage    = new FunctionPackage ("Is a Subtype?", entity_package);
            var entity_shape_package:FunctionPackage = new FunctionPackage ("shape", entity_package);
            var entity_text_package:FunctionPackage  = new FunctionPackage ("text", entity_package);
         
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_AssignBoolenRegister0, global_package, "Assign Value to BoolenRegister_0", 
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds, system_package, "MillisecondsToMinutesSeconds", 
                     [
                             new VariableDefinitionNumber ("Milliseconds"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Minitues"), 
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_Add, string_package, "String + String", 
                     [
                             new VariableDefinitionString ("Source String"), 
                             new VariableDefinitionString ("Source String"), 
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsNumber, bool_package, "Equals (Number == Number?)", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsBoolean, bool_package, "Equals (Boolean == Boolean?)", 
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsEntity, bool_package, "Equals (Entity == Entity?)", 
                     [
                             new VariableDefinitionEntity ("Entity 1"), 
                             new VariableDefinitionEntity ("Entity 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Larger, bool_package, "LargerThan (Number > Number?)", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Less, bool_package, "LessThan (Number < Number?)", 
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Multiply, math_package, "x * y", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Divide, math_package, "x / y", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Assign, math_package, "= (Number Assign)", 
                     [
                             new VariableDefinitionNumber ("Source"), 
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
                             new VariableDefinitionNumber ("Number"), 
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
                             new VariableDefinitionNumber ("Number"), 
                     ]
                  );
         
     // math / more
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Max, math_package, "Max", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Min, math_package, "Min", 
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Inverse, math_package, "Inverse", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Abs, math_package, "Abs", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Sqrt, math_package, "Sqrt", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Ceil, math_package, "Ceil", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Floor, math_package, "Floor", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Round, math_package, "Round", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Log, math_package, "Log", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Exp, math_package, "Exp", 
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Math_Power, math_package, "Power", 
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
                             new VariableDefinitionNumber ("Color x"), 
                             new VariableDefinitionNumber ("Color y"), 
                             new VariableDefinitionNumber ("Factor t"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result (x * t + (1.0 - t) * y)"), 
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_AttachCameraToShape, world_package, "AttachCameraToShape", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                     ],
                     null
                  );
         
     // game / collision category
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Cat_Assign, cat_package, "= (Assign CCat)", 
                     [
                             new VariableDefinitionCollisionCategory ("Source Collision Category"), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Target Collision Category"), 
                     ]
                  );
         
     // game /entity
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Assign, entity_package, "= (Assign Entity)", 
                     [
                             new VariableDefinitionEntity ("Source Entity"), 
                     ],
                     [
                             new VariableDefinitionEntity ("Terget Entity"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsShapeEntity, entity_is_package, "IsShape", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Visible?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsVisible, entity_package, "IsVisible", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Visible?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetVisible, entity_package, "SetVisible", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                             new VariableDefinitionBoolean ("Visible"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetAlpha, entity_package, "GetAlpha", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Alpha"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetAlpha, entity_package, "SetAlpha", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                             new VariableDefinitionNumber ("Alpha"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetPosition, entity_package, "GetPosition", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionNumber ("x"), 
                             new VariableDefinitionNumber ("y"), 
                     ]
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetPosition, entity_package, "SetPosition", 
         //            [
         //                    new VariableDefinitionEntity ("The Entity"), 
         //                    new VariableDefinitionNumber ("x"), 
         //                    new VariableDefinitionNumber ("y"), 
         //            ],
         //            null
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians, entity_package, "GetRotationByRadians", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees, entity_package, "GetRotationByDegrees", 
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (degrees)"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_AttachWithEntity, entity_package, "GlueEntities", 
                     [
                             new VariableDefinitionEntity ("The Entity to Attach With"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Detach, entity_package, "DetachFromGlueds", 
                     null,
                     null
                  );
         
      // game / entity / shape
         
          RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor, entity_shape_package, "GetFilledColor", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Filled Color"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor, entity_shape_package, "SetFilledColor", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                             new VariableDefinitionNumber ("Filled Color"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB, entity_shape_package, "GetFilledColorRGB", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB, entity_shape_package, "SetFilledColorRGB", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled, entity_shape_package, "IsPhysicsEnabled", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Physics Enabled?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsSensor, entity_shape_package, "IsSensor", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Sensor"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetAsSensor, entity_shape_package, "SetAsSensor", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                             new VariableDefinitionBoolean ("Is Sensor"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity, entity_shape_package, "GetDensity", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Density"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetDensity, entity_shape_package, "SetDensity", 
                     [
                             new VariableDefinitionEntity ("The Shape"), 
                             new VariableDefinitionNumber ("Density"), 
                     ],
                     null
                  );
         
      // game / entity / joint
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetText, entity_text_package, "GetText", 
                     [
                             new VariableDefinitionEntity ("Text Component"), 
                     ],
                     [
                             new VariableDefinitionString ("New Text"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetText, entity_text_package, "SetText", 
                     [
                             new VariableDefinitionEntity ("Text Component"), 
                             new VariableDefinitionString ("New Text"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendText, entity_text_package, "AppendText", 
                     [
                             new VariableDefinitionEntity ("Text Component"), 
                             new VariableDefinitionString ("Text to Append"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendNewLine, entity_text_package, "AppendNewLine", 
                     [
                             new VariableDefinitionEntity ("Text Component"), 
                     ],
                     null
                  );
         
      // ...
         
         sCoreApiMenuItemXML = AddPackageToXML (sTopFuntionPackage, null);
      }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterFunctionDeclaration (function_id:int, functionPackage:FunctionPackage, function_name:String, param_defines:Array, return_defines:Array):void
      {
         if (function_id < 0)
            return;
         
         sFunctionDeclarations [function_id] = new FunctionDeclaration_Core (function_id, function_name, param_defines, return_defines, null);
         
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
