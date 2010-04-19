
package editor.trigger {
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   import editor.entity.EntityJoint;
   import editor.entity.EntityShapeText;
   import editor.trigger.Lists;
   
   import common.trigger.CoreFunctionIds;
   import common.trigger.ValueTypeDefine;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.IdPool;
   import common.Define;
   
   public class PlayerFunctionDefinesForEditing
   {
      
      private static var sFunctionDeclarations:Array = new Array (IdPool.NumPlayerFunctions);
      
      public static const sGlobalPackage:FunctionPackage = new FunctionPackage ("Global");
      public static const sWorldPackage:FunctionPackage = new FunctionPackage ("World");
      public static const sEntityPackage:FunctionPackage = new FunctionPackage ("Entity");
      
      public static var sMenuBarDataProvider_Shorter:XML = null;
      public static var sMenuBarDataProvider_Longer:XML = null;
      
      public static function Initialize ():void
      {
         
      //================================================
      // packages
      //================================================
         
         var system_package:FunctionPackage = new FunctionPackage ("System", sGlobalPackage);
         var basic_package:FunctionPackage = new FunctionPackage ("Basic", sGlobalPackage);
         var number_package:FunctionPackage   = new FunctionPackage ("Number", sGlobalPackage);
            var numbe_general_package:FunctionPackage         = new FunctionPackage ("General", number_package);
            var to_string_package:FunctionPackage      = new FunctionPackage ("To String", number_package);
            var usual_number_package:FunctionPackage         = new FunctionPackage ("Usual", number_package);
            var interpolation_package:FunctionPackage      = new FunctionPackage ("Interpolation", number_package);
            var trigonometry_package:FunctionPackage = new FunctionPackage ("Trigonometry", number_package);
            var random_package:FunctionPackage             = new FunctionPackage ("Random", number_package);
            var bitwise_package:FunctionPackage            = new FunctionPackage ("Bitwise", number_package);
            var convert_package:FunctionPackage            = new FunctionPackage ("Conversion", number_package);
         var string_package:FunctionPackage = new FunctionPackage ("String", sGlobalPackage);
         var bool_package:FunctionPackage   = new FunctionPackage ("Boolean", sGlobalPackage);
         
         var world_general_package:FunctionPackage  = new FunctionPackage ("General", sWorldPackage);
         var ccat_package:FunctionPackage    = new FunctionPackage ("CCat", sWorldPackage);
         var level_package:FunctionPackage  = new FunctionPackage ("Level Status", sWorldPackage);
         var world_physics_package:FunctionPackage    = new FunctionPackage ("Physics", sWorldPackage);
         //var world_appearance_package:FunctionPackage    = new FunctionPackage ("Appearance", sWorldPackage);
         var world_camera_package:FunctionPackage    = new FunctionPackage ("Camera", sWorldPackage);
         var world_script_package:FunctionPackage    = new FunctionPackage ("Script", sWorldPackage);
         var world_create_entity_package:FunctionPackage    = new FunctionPackage ("Create", sWorldPackage);
         
         var entity_is_subtype_package:FunctionPackage    = new FunctionPackage ("Is a *?", sEntityPackage);
         var entity_general_package:FunctionPackage    = new FunctionPackage ("General", sEntityPackage);
         var entity_common_package:FunctionPackage    = new FunctionPackage ("Common", sEntityPackage);
         var entity_as_task_package:FunctionPackage    = new FunctionPackage ("Task Status", sEntityPackage);
         var entity_shape_package:FunctionPackage = new FunctionPackage ("Shape", sEntityPackage);
             var shape_is_subtype_package:FunctionPackage    = new FunctionPackage ("Is a *?", entity_shape_package);
             var shape_general_package:FunctionPackage    = new FunctionPackage ("General", entity_shape_package);
             var shape_appearance_package:FunctionPackage = new FunctionPackage ("Appearance", entity_shape_package);
             var shape_physics_properties_package:FunctionPackage = new FunctionPackage ("Physics Properties", entity_shape_package);
             var shape_physics_dynamics_package:FunctionPackage = new FunctionPackage ("Physics Dynamics", entity_shape_package);
             var entity_shape_brothers_package:FunctionPackage = new FunctionPackage ("Brothers", entity_shape_package);
             var entity_shape_connections_package:FunctionPackage = new FunctionPackage ("Connections", entity_shape_package);
             var shape_text_package:FunctionPackage  = new FunctionPackage ("Text", entity_shape_package);
             var shape_circle_package:FunctionPackage  = new FunctionPackage ("Circle", entity_shape_package);
             var shape_rectangle_package:FunctionPackage  = new FunctionPackage ("Rectangle", entity_shape_package);
             //var shape_polygon_package:FunctionPackage  = new FunctionPackage ("Polygon", entity_shape_package);
             //var shape_polyline_package:FunctionPackage  = new FunctionPackage ("Polyline", entity_shape_package);
         var entity_joint_package:FunctionPackage  = new FunctionPackage ("Joint", sEntityPackage);
         var entity_trigger_package:FunctionPackage  = new FunctionPackage ("Trigger", sEntityPackage);
         
      //================================================
      // functions
      //================================================
         
         if (Compile::Is_Debugging)
         {
            RegisterFunctionDeclaration (CoreFunctionIds.ID_ForDebug, basic_package, "ForDevDebug", "@(&0, &1, &2, &3, &4) = ForDevDebug ($0, $1, $2, $3, $4)", null,
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
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Void, null, "Action", "Action", null,
                     null,
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool, null, "Condition", "Condition", null,
                     null,
                     [
                              new VariableDefinitionBoolean ("Evaluation Result"), 
                     ]
                  );
       
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityFilter, null, "Entity Filter", "Entity Filter", null,
                     [
                              new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                              new VariableDefinitionBoolean ("Filter Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityPairFilter, null, "Entity Pair Filter", "Entity Pair Filter", null,
                     [
                              new VariableDefinitionEntity ("Entity 1"), 
                              new VariableDefinitionEntity ("Entity 2"), 
                     ],
                     [
                              new VariableDefinitionBoolean ("Filter Result"), 
                     ]
                  );
       
      // global
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Return, basic_package, "Return", "Return", null,
                     null,
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_ReturnIfTrue, basic_package, "Return If True", "@Return if $0 is true", null,
                     [
                             new VariableDefinitionBoolean ("Bool Value"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_ReturnIfFalse, basic_package, "Return If False", "@Return if $0 is false", null,
                     [
                             new VariableDefinitionBoolean ("Bool Value"), 
                     ],
                     null
                  );
         
      // system / time
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_GetProgramMilliseconds, system_package, "Get Program Milliseconds", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Milliseconds"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_GetCurrentDateTime, system_package, "Get Current Date Time", null, null,
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_IsKeyHold, system_package, "Is Key Held", "@&0 = Is the key (key code is $0) held?", null,
                     [
                             new VariableDefinitionNumber ("The Key", null, {mValueLists: Lists.mKeyCodeList}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Hold?"),
                     ]
                  );
         
      // string
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_Assign, string_package, "= (Assign String)", "@&0 = $0", "@&0 = $0",
                     [
                             new VariableDefinitionString ("Source String"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_ConditionAssign, string_package, "?= (Condition Assign String)", "@&0 = ($0 is true) ? $1 : $2", "@&0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionString ("Source String 1"), 
                             new VariableDefinitionString ("Source String 2"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_SwapValues, string_package, "Swap String Values", "@$0 <-> $1", null,
                     [
                             new VariableDefinitionString ("String 1", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                             new VariableDefinitionString ("String 2", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_IsNull, string_package, "Is Null?", "@&0 = String ($0) is Null?", "IsNullString",
                     [
                             new VariableDefinitionString ("The String"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Null"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_Equals, string_package, "String == String?", "@&0 = ($0 == $1)", "@&0 = ($0 == $1)",
                     [
                             new VariableDefinitionString ("String 1"), 
                             new VariableDefinitionString ("String 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_Add, string_package, "String + String", "@&0 = $0 + $1", "@&0 = $0 + $1",
                     [
                             new VariableDefinitionString ("Source String 1"), 
                             new VariableDefinitionString ("Source String 2"), 
                     ],
                     [
                             new VariableDefinitionString ("Target String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_GetLength, string_package, "Get Length", "@&0 = GetStringLength ($0)", "@&0 = GetStringLength ($0)",
                     [
                             new VariableDefinitionString ("The String"), 
                     ],
                     [
                             new VariableDefinitionNumber ("String Length"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_GetCharAt, string_package, "Get Char At", "@&0 = The ($1)th Char in String($0)", "@&0 = StringCharAt ($0)",
                     [
                             new VariableDefinitionString ("The String"), 
                             new VariableDefinitionNumber ("Char Index", null, {mMinValue: 0}), 
                     ],
                     [
                             new VariableDefinitionString ("The Char"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_GetCharCodeAt, string_package, "Get Char Code At", "@&0 = The Code of ($1)th Char in String($0)", "@&0 = StringCharCodeAt ($0)",
                     [
                             new VariableDefinitionString ("The String"), 
                             new VariableDefinitionNumber ("Char Index", null, {mMinValue: 0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Char Code"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_String_CharCode2Char, string_package, "Char Code -> Char", "@Char (&0) = From Char Code($0)", "@&0 = CharCode2Char ($0)",
                     [
                             new VariableDefinitionNumber ("Char Code"), 
                     ],
                     [
                             new VariableDefinitionString ("The String"), 
                     ]
                  );
         
       // bool
          
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Assign, bool_package, "= (Assign Boolean)", "@&0 = $0", "@&0 = $0",
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Target Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_ConditionAssign, bool_package, "=? (Condition Assign Boolean)", "@&0 = ($0 is true) ? $1 : $2", "@&0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionBoolean ("Source Boolean 1"), 
                             new VariableDefinitionBoolean ("Source Boolean 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Target Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_SwapValues, bool_package, "Swap Values", "@$0 <-> $1", "SwapBooleanValues",
                     [
                             new VariableDefinitionBoolean ("Boolean 1", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                             new VariableDefinitionBoolean ("Boolean 2", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Boolean_ToString, bool_package, "Bool -> String", "@$0 -> &0", "BoolToString",
                     [
                             new VariableDefinitionBoolean ("The Bool"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_EqualsBoolean, bool_package, "Boolean == Boolean?",  "@&0 = ($0 == $1)", "@&0 = ($0 == $1)",
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Invert, bool_package, "! (Invert)", "@&0 = ! $0", "@&0 = ! $0",
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Source Boolean"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_IsTrue, bool_package, "IsTrue?", "@&0 = ($0 == true)", null,
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_IsFalse, bool_package, "IsFalse?", "@&0 = ($0 == false)", null,
                     [
                             new VariableDefinitionBoolean ("Input Bool Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_And, bool_package, "x && y (Bool And)", "@&0 = ($0 && $1)", "@&0 = ($0 && $1)",
                     [
                             new VariableDefinitionBoolean ("Bool 1"), 
                             new VariableDefinitionBoolean ("Bool 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Or, bool_package, "x || y (Bool Or)", "@&0 = ($0 || $1)", "@&0 = ($0 || $1)",
                     [
                             new VariableDefinitionBoolean ("Boolean 1"), 
                             new VariableDefinitionBoolean ("Boolean 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Not, bool_package, "! (Bool Not)", "@&0 = (! $0)", "@&0 = (! $0)",
                     [
                             new VariableDefinitionBoolean ("Input Boolean Value"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bool_Xor, bool_package, "!= (Bool Xor)", "@&0 = ($0 != $1)", "@&0 = ($0 != $1)",
                     [
                             new VariableDefinitionBoolean ("Boolean 1"), 
                             new VariableDefinitionBoolean ("Boolean 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
          
       // math basic ops
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Assign, numbe_general_package, "= (Number Assign)", "@&0 = $0", "@&0 = $0",
                     [
                             new VariableDefinitionNumber ("Source"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Target"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ConditionAssign, numbe_general_package, "=? (Condition Assign)", "@&0 = ($0 is true) ? $1 : $2", "@&0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result"), 
                             new VariableDefinitionNumber ("True Source"), 
                             new VariableDefinitionNumber ("False Source"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Target"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_SwapValues, numbe_general_package, "Swap Values", "@$0 <-> $1", "SwapNumberValues",
                     [
                             new VariableDefinitionNumber ("Number 1", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                             new VariableDefinitionNumber ("Number 2", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Equals, numbe_general_package, "Number == Number?", "@&0 = ($0 == $1)", "@&0 = ($0 == $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_LargerThan, numbe_general_package, "Number > Number?", "@&0 = ($0 > $1)", "@&0 = ($0 > $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_LessThan, numbe_general_package, "Number < Number?", "@&0 = ($0 < $1)", "@&0 = ($0 < $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_IsNaN, numbe_general_package, "Is Not a Number?", null, "IsNaN",
                     [
                             new VariableDefinitionNumber ("The Number"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_IsInfinity, numbe_general_package, "Is a Infinity Number?", null, "IsInfinity",
                     [
                             new VariableDefinitionNumber ("The Number"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Negative, numbe_general_package, "- x (Negative)", "@&0 = (- $0)", "@&0 = (- $0)",
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Inverse, numbe_general_package, "1.0 / x (Inverse)", "@&0 = (1.0 / $0)", "@&0 = (1.0 / $0)",
                     [
                             new VariableDefinitionNumber ("Number", null, {mDefaultValue: 1.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Add, numbe_general_package, "x + y", "@&0 = $0 + $1", "@&0 = $0 + $1",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Subtract, numbe_general_package, "x - y", "@&0 = $0 - $1", "@&0 = $0 - $1",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Multiply, numbe_general_package, "x * y (Multiply)", "@&0 = $0 * $1", "@&0 = $0 * $1",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Divide, numbe_general_package, "x / y (Divide)", "@&0 = $0 / $1", "@&0 = $0 / $1",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2", null, {mDefaultValue: 1.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Modulo, numbe_general_package, "x % y (Modulo)", "@&0 = $0 % $1", "@&0 = $0 % $1",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2", null, {mDefaultValue: 1.0}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         
      // math / toString
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ToString, to_string_package, "Number -> String", "@$0 -> &0", "NumberToString",
                     [
                             new VariableDefinitionNumber ("The Number"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ToExponential, to_string_package, "To Exponential", null, null,
         //            [
         //                    new VariableDefinitionNumber ("The Number"), 
         //                    new VariableDefinitionNumber ("Number of Fraction Digits", null, {mDefaultValue: 2}), 
         //            ],
         //            [
         //                    new VariableDefinitionString ("Result"), 
         //            ]
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ToFixed, to_string_package, "To Fixed", null, null,
                     [
                             new VariableDefinitionNumber ("The Number"), 
                             new VariableDefinitionNumber ("Number of Fraction Digits", null, {mDefaultValue: 2}), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ToPrecision, to_string_package, "To Precision", null, null,
                     [
                             new VariableDefinitionNumber ("The Number"), 
                             new VariableDefinitionNumber ("Number of Precision Digits", null, {mDefaultValue: 6}), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ToStringByRadix, to_string_package, "Number -> String (By Radix)", "@$0 -> &0 by radix $1", "ToStringByRadix",
                     [
                             new VariableDefinitionNumber ("The Number"), 
                             new VariableDefinitionNumber ("The Radix", null, {mDefaultValue: 10}), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         
      // math / bitwise
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftLeft, bitwise_package, "<< (ShiftLeft)", "@&0 = ($0 << $1)", "@&0 = ($0 << $1)",
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRight, bitwise_package, ">> (ShiftRight)", "@&0 = ($0 >> $1)", "@&0 = ($0 >> $1)",
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_ShiftRightUnsigned, bitwise_package, ">>> (ShiftRightUnsignedly)", "@&0 = ($0 >>> $1)", "@&0 = ($0 >>> $1)",
                     [
                             new VariableDefinitionNumber ("Number to Shift"), 
                             new VariableDefinitionNumber ("Shift Bits Count"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_And, bitwise_package, "x & y (Bitwise And)", "@&0 = ($0 & $1)", "@&0 = ($0 & $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Or, bitwise_package, "x | y (Bitwise Or)", "@&0 = ($0 | $1)", "@&0 = ($0 | $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Not, bitwise_package, "~ x (Bitwise Not)", "@&0 = (~ $0)", "@&0 = (~ $0)",
                     [
                             new VariableDefinitionNumber ("Inout Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Bitwise_Xor, bitwise_package, "x ^ y (Bitwise Xor)", "@&0 = ($0 ^ $1)", "@&0 = ($0 ^ $1)",
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         
      // math / number trinomogetry
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_SinRadians, trigonometry_package, "Sin", "@&0 = Sin (Radians ($0))", "@&0 = Sin (Radians ($0))",
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Sin (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_CosRadians, trigonometry_package, "Cos", "@&0 = Cos (Radians ($0))", "@&0 = Cos (Radians ($0))",
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Cos (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_TanRadians, trigonometry_package, "Tan", "@&0 = Tan (Radians ($0))", "@&0 = Tan (Radians ($0))",
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Tan (Radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ArcSinRadians, trigonometry_package, "ArcSin_Radians", "@Radians (&0) = ArcSin ($0)", "@Radians (&0) = ArcSin ($0)",
                     [
                             new VariableDefinitionNumber ("Sin (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ArcCosRadians, trigonometry_package, "ArcCos_Radians", "@Radians (&0) = ArcCos ($0)", "@Radians (&0) = ArcCos ($0)",
                     [
                             new VariableDefinitionNumber ("Cos (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ArcTanRadians, trigonometry_package, "ArcTan_Radians", "@Radians (&0) = ArcTan ($0)", "@Radians (&0) = ArcTan ($0)",
                     [
                             new VariableDefinitionNumber ("Tan (Radians)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_ArcTan2Radians, trigonometry_package, "ArcTan2_Radians", "@Radians (&0) = ArcTan2 ($0, $1)", "@Radians (&0) = ArcTan2 ($0, $1)",
                     [
                             new VariableDefinitionNumber ("y"), 
                             new VariableDefinitionNumber ("x"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         
      // math / random
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Random, random_package, "Random", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Random Number"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_RandomRange, random_package, "Random Between", null, null,
                     [
                             new VariableDefinitionNumber ("Min Number"), 
                             new VariableDefinitionNumber ("Max Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Random Number"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_RandomIntRange, random_package, "Integer Random Between", null, null,
                     [
                             new VariableDefinitionNumber ("Min Integer Number"), 
                             new VariableDefinitionNumber ("Max Integer Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Random Ingeter Number"), 
                     ]
                  );
          
       // math / number convert
          
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Degrees2Radians, convert_package, "Degrees -> Radians", "@Degrees ($0) -> Radians (&0)", "DegreesToRadians",
                     [
                             new VariableDefinitionNumber ("Degrees"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Radians2Degrees, convert_package, "Radians -> Degrees", "@Radians ($0) -> Degrees (&0)", "RadiansToDegrees",
                     [
                             new VariableDefinitionNumber ("Radians"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Degrees"), 
                     ]
                  );
          RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Number2RGB, convert_package, "Color -> RGB", "@Color ($0) -> RGB (&0, &1, &2)", "Color2Rgb",
                     [
                             new VariableDefinitionNumber ("Number", null, {mIsColorValue: true}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_RGB2Number, convert_package, "RGB -> Color", "@RGB ($0, $1, $2) -> Color (&0)", "RgbToColor",
                     [
                             new VariableDefinitionNumber ("Red (0-255)"), 
                             new VariableDefinitionNumber ("Green (0-255)"), 
                             new VariableDefinitionNumber ("Blue (0-255)"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Number", null, {mIsColorValue: true}), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_MillisecondsToMinutesSeconds, convert_package, "Milliseconds -> Minutes : Seconds", "@Milliseconds ($0) -> Minutes (&0) : Seconds (&1) : Milliseconds (&2)", "MillisecondsToMinutesAndSeconds",
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
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Abs, usual_number_package, "Abs", "Abs", null,
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Max, usual_number_package, "Max", "Max", null,
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Min, usual_number_package, "Min", "Min", null,
                     [
                             new VariableDefinitionNumber ("Number 1"), 
                             new VariableDefinitionNumber ("Number 2"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result 1"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Clamp, usual_number_package, "Clamp", "@Clamp $0 Between $1 and $2", null,
                     [
                             new VariableDefinitionNumber ("Number to Clamp"), 
                             new VariableDefinitionNumber ("Lower Limit"), 
                             new VariableDefinitionNumber ("Upper Limit"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Sqrt, usual_number_package, "Sqrt", "Sqrt", null,
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Ceil, usual_number_package, "Ceil", "Ceil", null,
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Floor, usual_number_package, "Floor", "Floor", null,
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Round, usual_number_package, "Round", "Round", null,
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Log, usual_number_package, "Log", "Log", null,
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Exp, usual_number_package, "Exp", "Exp", null,
                     [
                             new VariableDefinitionNumber ("Number"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Number_Power, usual_number_package, "Power", "Power", null,
                     [
                             new VariableDefinitionNumber ("Number"), 
                             new VariableDefinitionNumber ("Power"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.Id_Math_LinearInterpolation, interpolation_package, "Linear Interpolation", null, null,
                     [
                             new VariableDefinitionNumber ("Number x1"), 
                             new VariableDefinitionNumber ("Number x2"), 
                             new VariableDefinitionNumber ("Factor t"), 
                     ],
                     [
                             new VariableDefinitionNumber ("Result (x1 * t + (1.0 - t) * x2)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.Id_Math_LinearInterpolationColor, interpolation_package, "Color Linear Interpolation", null, null,
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
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelMilliseconds, world_general_package, "Get Level Running Milliseconds", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Running Milliseconds"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_GetLevelSteps, world_general_package, "Get Level Simulation Steps", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Simulation Steps"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_GetMousePosition, world_general_package, "Get Mouse Position", null, null,
                     null,
                     [
                        new VariableDefinitionNumber ("Mouse X"), 
                        new VariableDefinitionNumber ("Mouee Y"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsMouseButtonHold, world_general_package, "Is Mouse Button Hold?", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Hold?"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_SetLevelStatus, level_package, "Set Level Status", null, null,
                     [
                        new VariableDefinitionNumber ("Status", null, {mValueLists: Lists.mLevelStatusList}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelSuccessed, level_package, "Is Level Successed?", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Finshied?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelFailed, level_package, "Is Level Failed", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Failed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Design_IsLevelUnfinished, level_package, "Is Level Unfinished", null, null,
                     null,
                     [
                        new VariableDefinitionBoolean ("Unfinished?"), 
                     ]
                  );
         
      // game / world
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Radians, world_physics_package, "Set Gravity Acceleration by Radians", "@&0 = SetGravityAcceleration (Radians($0))", null,
                     [
                             new VariableDefinitionNumber ("Magnitude"), 
                             new VariableDefinitionNumber ("Angle Radians"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Degrees, world_physics_package, "Set Gravity Acceleration by Degrees", "@&0 = SetGravityAcceleration (Degrees($0))", null,
                     [
                             new VariableDefinitionNumber ("Magnitude"), 
                             new VariableDefinitionNumber ("Angle Degrees"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_SetGravityAcceleration_Vector, world_physics_package, "Set Gravity Acceleration by Vector", "@SetGravityAcceleration (Vector($0, $1))", null,
                     [
                             new VariableDefinitionNumber ("gX"), 
                             new VariableDefinitionNumber ("gY"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_GetCameraCenter, world_camera_package, "Get Cemera Center", null, null,
                     null,
                     [
                             new VariableDefinitionNumber ("Camera Center X"), 
                             new VariableDefinitionNumber ("Camera Center Y"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraWithShape, world_camera_package, "Follow Camera With Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, {mDefaultValue: true}), 
                             //new VariableDefinitionBoolean ("Follow Rotation?"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterXWithShape, world_camera_package, "Follow Camera Center X With Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraCenterYWithShape, world_camera_package, "Follow Camera Center Y With Shape", null, null,
                     [
                             new VariableDefinitionEntity ("The Followed Shape"), 
                             new VariableDefinitionBoolean ("Smooth Following?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_World_FollowCameraRotationWithShape, world_camera_package, "Follow Camera Rotation With Shape", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Followed Shape"), 
         //                    new VariableDefinitionBoolean ("Smooth Following?", null, {mDefaultValue: true}), 
         //            ],
         //            null
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CameraFadeOutThenFadeIn, world_camera_package, "Fade Out Then Fade In", null, null,
                     [
                             new VariableDefinitionNumber ("Fade Color", null, {mIsColorValue: true}), 
                             new VariableDefinitionNumber ("Fade Out Steps", null, {mMinValue: 0}), 
                             new VariableDefinitionNumber ("Fade Staying Steps", null, {mMinValue: 1}), 
                             new VariableDefinitionNumber ("Fade In Steps", null, {mMinValue: 0}), 
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallScript, world_script_package, "Call Script", null, null,
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_ConditionCallScript, world_script_package, "Condition Call Script", "@If $0 is true, call $1, otherwise, call $2", null,
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Script 1 to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                             new VariableDefinitionEntity ("Script 2 to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallScriptMultiTimes, world_script_package, "Call Script Multi Times", "@Call Script ($0) $1 Times", null,
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sScriptHolderEntityClasses}), 
                             new VariableDefinitionNumber ("Calling Times", null, {mMinValue: 0}),  // dengerous
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallBoolFunction, world_script_package, "Call Boolean Function", null, null,
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Return Boolean Result"),
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_ConditionCallBoolFunction, world_script_package, "Condition Call Boolean Function", "@&0 = If $0 is true, call $1, otherwise, call $2", null,
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Script 1 to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}), 
                             new VariableDefinitionEntity ("Script 2 to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Return Bool Result"),
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CallBoolFunctionMultiTimes, world_script_package, "Call Bool Function Multi Times", "@Call Bool Function ($0) Multi Times", null,
                     [
                             new VariableDefinitionEntity ("Script to Call", null, {mValidClasses: Filters.sBasicConditionEntityClasses}), 
                     ],
                     null
                  );
         
     // game / world / create ...
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_World_CreateExplosion, world_create_entity_package, "Create Explosion", null, null,
                     [
                              new VariableDefinitionNumber ("Explosion World X", null, {mDefaultValue: 0}), 
                              new VariableDefinitionNumber ("Explosion World Y", null, {mDefaultValue: 0}), 
                              new VariableDefinitionNumber ("Number of Particles (4-100)", null, {mDefaultValue: 64, mMinValue: Define.MinNumParticls_CreateExplosion, mMaxValue: Define.MaxNumParticls_CreateExplosion}), 
                              new VariableDefinitionNumber ("Life (steps)", null, {mDefaultValue: 60, mMinValue:0}), 
                              new VariableDefinitionNumber ("Particle Density", null, {mDefaultValue: 25.0, mMinValue: 0.0}), 
                              new VariableDefinitionNumber ("Particle Restitution", null, {mDefaultValue: 0.8, mMinValue: 0.0, mMaxValue:1.0}), 
                              new VariableDefinitionNumber ("Particle Speed", null, {mDefaultValue: 50.0, mMinValue: 0.0}), 
                              new VariableDefinitionNumber ("Particle Color", null, {mDefaultValue: 0x0, mIsColorValue: true}), 
                              new VariableDefinitionBoolean ("Is Particle Visible?", null, {mDefaultValue: true}),
                              new VariableDefinitionCollisionCategory ("Particle Collision Category"), 
                     ],
                     [
                              new VariableDefinitionNumber ("Number of Created Particles"), 
                     ]
                  );
         
         
     // game / collision category
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_Assign, ccat_package, "= (Assign CCat)", "@&0 = $0", "@&0 = $0",
                     [
                             new VariableDefinitionCollisionCategory ("Source Collision Category"), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Target Collision Category"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_ConditionAssign, ccat_package, "?= (Condition Assign CCat)", "@&0 = ($0 is true) ? $1 : $2", "@&0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionCollisionCategory ("Collision Category 1"), 
                             new VariableDefinitionCollisionCategory ("Collision Category 2"), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Target Collision Category"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_SwapValues, ccat_package, "Swap Values", "@$0 <-> $1", "SwapCCatValues",
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category 1", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                             new VariableDefinitionCollisionCategory ("Collision Category 2", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_IsNull, ccat_package, "Is Null?", "@&0 = CCat($0) is Null?", "IsNullCCat",
                     [
                             new VariableDefinitionCollisionCategory ("The CCat"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Null"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_ToString, ccat_package, "CCat -> String", "@$0 -> &0", "CCatToString",
                     [
                             new VariableDefinitionCollisionCategory ("The CCat"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_Equals, ccat_package, "CCat == CCat?",  "@&0 = ($0 == $1)", "@&0 = ($0 == $1)",
                     [
                             new VariableDefinitionCollisionCategory ("CCat 1"), 
                             new VariableDefinitionCollisionCategory ("CCat 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_SetCollideInternally, ccat_package, "Set Collision Category Collide Internally", "@Set Collision Category ($0) Collide Internally ($1)", null,
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category"), 
                             new VariableDefinitionBoolean ("Collide Internally?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_CCat_SetAsFriends, ccat_package, "Set Collision Categories As Friends or Not", "@Set Collision Categories ($0, $1) As Friends ($2)", null,
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category 1"), 
                             new VariableDefinitionCollisionCategory ("Collision Category 2"), 
                             new VariableDefinitionBoolean ("Friends?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         
     // game /entity
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Assign, entity_general_package, "= (Assign Entity)", "@&0 = $0", "@&0 = $0",
                     [
                             new VariableDefinitionEntity ("Source Entity"), 
                     ],
                     [
                             new VariableDefinitionEntity ("Target"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_ConditionAssign, entity_general_package, "?= (Condition Assign Entity)", "@&0 = ($0 is true) ? $1 : $2", "@&0 = ($0 is true) ? $1 : $2",
                     [
                             new VariableDefinitionBoolean ("Condition Result"),
                             new VariableDefinitionEntity ("Source Entity 1"), 
                             new VariableDefinitionEntity ("Source Entity 2"), 
                     ],
                     [
                             new VariableDefinitionEntity ("Terget"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SwapValues, entity_general_package, "Swap Values", "@$0 <-> $1", "SwapEntityValues",
                     [
                             new VariableDefinitionEntity ("Entity 1", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                             new VariableDefinitionEntity ("Entity 2", null, {mDefaultSourceType: ValueSourceTypeDefine.ValueSource_Variable}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsNull, entity_general_package, "Is Null?", "@&0 = Entity($0) is Null?", "IsNullEntity",
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Null?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetEntityByIdOffset, entity_common_package, "Get Another Entity by Id Offset", null, null,
                     [
                             new VariableDefinitionEntity ("Base Entity"), 
                             new VariableDefinitionNumber ("Id Offset"), 
                     ],
                     [
                             new VariableDefinitionEntity ("Another Entity"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_ToString, entity_general_package, "Entity -> String", "@$0 -> &0", "EntityToString",
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionString ("Result"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Equals, entity_general_package, "Entity == Entity?",  "@&0 = ($0 == $1)", "@&0 = ($0 == $1)",
                     [
                             new VariableDefinitionEntity ("Entity 1"), 
                             new VariableDefinitionEntity ("Entity 2"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Result"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetTaskStatus,  entity_as_task_package, "Set Entity Task Status", "@Set Entity ($0) Task Status ($1)", null,
                     [
                        new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}), 
                        new VariableDefinitionNumber ("Task Status", null, {mValueLists: Lists.mEntityTaskStatusList}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskFailed, entity_as_task_package, "Is Entity Task Failed?", "@&0 = Is Entity ($0) Task Failed?", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Failed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskSuccessed, entity_as_task_package, "Is Entity Task Successed", "@&0 = Is Entity ($0) Task Successed?", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Successed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTaskUnfinished, entity_as_task_package, "Is Entity Task Unfinished", "@&0 = Is Entity ($0) Task Unfinished?", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sTaskEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Unfinished?"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsShapeEntity, entity_is_subtype_package, "Is a Shape?", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Shape?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsJointEntity, entity_is_subtype_package, "Is a Joint?", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Joint?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsTriggerEntity, entity_is_subtype_package, "Is a Trigger Component?", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity"), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Trigger Component?"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsVisible, entity_common_package, "Is Visible", "@&0 = Is $0 Visible?", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Visible?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetVisible, entity_common_package, "Set Visible", "@Set Visibility ($1) of $0", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}), 
                             new VariableDefinitionBoolean ("Visible?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetAlpha, entity_common_package, "Get Alpha", "@&0 = Get Alpha of $0", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Alpha"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetAlpha, entity_common_package, "Set Alpha", "@Set Alpha ($1) of $0", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sVisualEntityClasses}), 
                             new VariableDefinitionNumber ("Alpha (0-1)", null, {mMinValue: 0.0, mMaxValue:1.0}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsEnabled, entity_common_package, "Is Entity Enabled",  "@&0 = Is Entity ($0) Enabled?", null,
                     [
                             new VariableDefinitionEntity ("The Event Handler", null, {mValidClasses: Filters.sCanBeDisabledEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Enabled?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetEnabled, entity_common_package, "Set Entity Enabled", "@Set Entity ($0) Enabled ($1)", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sCanBeDisabledEntityClasses}), 
                             new VariableDefinitionBoolean ("Enabled?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetPosition, entity_common_package, "Get Position", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("x"), 
                             new VariableDefinitionNumber ("y"), 
                     ]
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_SetPosition, entity_common_package, "Set Position", null, null,
         //            [
         //                    new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
         //                    new VariableDefinitionNumber ("x"), 
         //                    new VariableDefinitionNumber ("y"), 
         //            ],
         //            null
         //         );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByRadians, entity_common_package, "Get Rotation by Radians", "@Radians (&0) = Get Rotation ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (radians)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_GetRotationByDegrees, entity_common_package, "Get Rotation by Degrees", "@Degrees (&0) = Get Rotation ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mValidClasses: Filters.sMoveableEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Rotation (degrees)"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_WorldPoint2LocalPoint, shape_general_package, "World Point -> Local Point", "@World Point ($0, $1) -> Local Point (&0, &1)", null,
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_LocalPoint2WorldPoint, shape_general_package, "Local Point -> World Point", "@Local Point ($0, $1) -> World Point (&0, &1)", null,
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
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsDestroyed, entity_common_package, "Is Destroyed", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mExceptClasses: Filters.sLogicEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Already Destroyed?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Destroy, entity_common_package, "Destroy", null, null,
                     [
                             new VariableDefinitionEntity ("The Entity", null, {mExceptClasses: Filters.sLogicEntityClasses}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_Coincided, entity_common_package, "Are Two Entities Coincided?", "@Are Two Entities ($0, $1) Superimposed with Tolerances ($2, $3, $4)", null,
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
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsCircleShapeEntity, shape_is_subtype_package, "Is a Circle Shape?", null, "IsCircleShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Circle?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsRectangleShapeEntity, shape_is_subtype_package, "Is a Rectangle Shape?", null, "IsRectangleShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Rectangle?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsPolygonShapeEntity, shape_is_subtype_package, "Is a Polygon Shape?", null, "IsPolygonShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Polygon?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsPolylineShapeEntity, shape_is_subtype_package, "Is a Polyline Shape?", null, "IsPolylineShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Polyline?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsBombShapeEntitiy, shape_is_subtype_package, "Is a Bomb Shape?", null, "IsBombShape",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is Bomb?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_Entity_IsWorldBorderShapeEntitiy, shape_is_subtype_package, "Is a World Border?", null, "IsWorldBorder",
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionBoolean ("Is World Border?"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetOriginalCIType, shape_appearance_package, "Get Original C.I. Type", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Original CI Type"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetOriginalCIType, shape_appearance_package, "Set Original C.I. Type", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("New Original CI Type", null, {mValueLists: Lists.mAiTypeList}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCIType, shape_appearance_package, "Get C.I. Type", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("CI Type"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCIType, shape_appearance_package, "Set C.I. Type", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("CI Type", null, {mValueLists: Lists.mAiTypeList}), 
                     ],
                     null
                  );
         
          RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColor, shape_appearance_package, "Get Background Color", "@Color (&0) = Get Background Color ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses, mGroundSelectable:true}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Filled Color", null, {mIsColorValue: true}), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColor, shape_appearance_package, "Set Background Color", "@Set Background Color ($0, Color ($1))", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses, mGroundSelectable:true}), 
                             new VariableDefinitionNumber ("Filled Color", null, {mIsColorValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetFilledColorRGB, shape_appearance_package, "Get Background Color RGB", "@RGB (&0, &1, &2) = Get Background Color ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses, mGroundSelectable:true}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetFilledColorRGB, shape_appearance_package, "Set Background Color RGB", "@Set Background Color ($0, RGB ($1, $2, $3))", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses, mGroundSelectable:true}), 
                             new VariableDefinitionNumber ("Red"), 
                             new VariableDefinitionNumber ("Green"), 
                             new VariableDefinitionNumber ("Blue"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsPhysicsEnabled, shape_physics_properties_package, "Is Physics Enabled", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Physics Enabled?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetCollisionCategory, shape_physics_properties_package, "Get Collision Category", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionCollisionCategory ("Collision Category (ccat)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetCollisionCategory, shape_physics_properties_package, "Set Collision Category", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionCollisionCategory ("Collision Category (ccat)"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsSensor, shape_physics_properties_package, "Is Sensor", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Sensor?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetAsSensor, shape_physics_properties_package, "Set Sensor", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionBoolean ("Is Sensor?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_IsSleeping, shape_physics_properties_package, "Is Sleeping", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionBoolean ("Is Sleeping?"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetSleeping, shape_physics_properties_package, "Set Sleeping", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionBoolean ("Sleeping?", null, {mDefaultValue: false}), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetMass, shape_physics_properties_package, "Get Mass", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionBoolean ("Mass of Brothers?", null, {mDefaultValue: false}), 
                     ],
                     [
                             new VariableDefinitionNumber ("The Mass"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetInertia, shape_physics_properties_package, "Get Inertia", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionBoolean ("Inertia of Brothers?", null, {mDefaultValue: false}), 
                     ],
                     [
                             new VariableDefinitionNumber ("The Mass"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetDensity, shape_physics_properties_package, "Get Density", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("The Density"), 
                     ]
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_SetLinearVelocity, shape_physics_dynamics_package, "Set Linear Velocity", "@Set Linear Velocity of $0 by Vector ($1, $2)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("New Velocity X"), 
                             new VariableDefinitionNumber ("New Velocity Y"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_GetLinearVelocity, shape_physics_dynamics_package, "Get Linear Velocity", "@Vector (&0, &1) = Get Linear Velocity ($0)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Velocity X"), 
                             new VariableDefinitionNumber ("Velocity Y"), 
                     ]
               );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseByVelocityVector, shape_physics_dynamics_package, "Change Linear Velocity by Vector", "@Change Linear Velocity of $0 by Vector ($1, $2)", null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Delta Velocity X"), 
                             new VariableDefinitionNumber ("Delta Velocity Y"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForce, shape_physics_dynamics_package, "Apply Step Force", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Force X"), 
                             new VariableDefinitionNumber ("Force Y"), 
                             new VariableDefinitionBoolean ("Is Local Force?", null, {mDefaultValue: false}), 
                             new VariableDefinitionBoolean ("Apply on Center of Brothers?", null, {mDefaultValue: false}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtLocalPoint, shape_physics_dynamics_package, "Apply Step Force At Local Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Force X"), 
                             new VariableDefinitionNumber ("Force Y"), 
                             new VariableDefinitionBoolean ("Is Local Force?", null, {mDefaultValue: false}), 
                             new VariableDefinitionNumber ("Local Point X"), 
                             new VariableDefinitionNumber ("Local Point Y"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepForceAtWorldPoint, shape_physics_dynamics_package, "Apply Step Force At World Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Force X"), 
                             new VariableDefinitionNumber ("Force Y"), 
                             new VariableDefinitionBoolean ("Is Local Force?", null, {mDefaultValue: false}), 
                             new VariableDefinitionNumber ("World Point X"), 
                             new VariableDefinitionNumber ("World Point Y"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyStepTorque, shape_physics_dynamics_package, "Apply Step Torque", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Torque"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulse, shape_physics_dynamics_package, "Apply Impulse", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Impulse X"), 
                             new VariableDefinitionNumber ("Impulse Y"), 
                             new VariableDefinitionBoolean ("Is Local Impulse?", null, {mDefaultValue: false}), 
                             new VariableDefinitionBoolean ("Apply on Center of Brothers?", null, {mDefaultValue: false}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtLocalPoint, shape_physics_dynamics_package, "Apply Impulse At Local Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Impulse X"), 
                             new VariableDefinitionNumber ("Impulse Y"), 
                             new VariableDefinitionBoolean ("Is Local Impulse?", null, {mDefaultValue: false}), 
                             new VariableDefinitionNumber ("Local Point X"), 
                             new VariableDefinitionNumber ("Local Point Y"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyLinearImpulseAtWorldPoint, shape_physics_dynamics_package, "Apply Impulse At World Point", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Impulse X"), 
                             new VariableDefinitionNumber ("Impulse Y"), 
                             new VariableDefinitionBoolean ("Is Local Impulse?", null, {mDefaultValue: false}), 
                             new VariableDefinitionNumber ("World Point X"), 
                             new VariableDefinitionNumber ("World Point Y"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_ApplyAngularImpulse, shape_physics_dynamics_package, "Apply Angular Impulse", null, null,
                     [
                             new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionNumber ("Angular Impulse"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Teleport, shape_general_package, "Teleport Shape", null, null,
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
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_TeleportOffsets, shape_general_package, "Teleport Shape by Offsets", null, null,
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
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Clone, shape_general_package, "Clone Shape", null, 
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
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_Detach, entity_shape_brothers_package, "Break Away From Brothers", null, null, 
                     [
                             new VariableDefinitionEntity ("The Shape to Be Detached", null, {mValidClasses: Filters.sShapeEntityClasses}),
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_AttachWith, entity_shape_brothers_package, "Make Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_DetachThenAttachWith, entity_shape_brothers_package, "Break Away Then Make Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                             new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_BreakupBrothers, entity_shape_brothers_package, "Breakup Brothers", null, null,
                     [
                             new VariableDefinitionEntity ("One Borther Shape", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                     ],
                     null
                  );
	     
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShape_BreakAllJoints, entity_shape_connections_package, "Break All Joints", null, null,
                     [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),  
                     ],
                     null
                  );


         
      // game / entity / shape / text
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_GetText, shape_text_package, "Get Text", "@&0 = Get Text of $0", null,
                     [
                             new VariableDefinitionEntity ("The Text Entity", null, {mValidClasses: Filters.sTextEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionString ("The Text String"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_SetText, shape_text_package, "Set Text", "@Set Text ($1) of $0", null,
                     [
                             new VariableDefinitionEntity ("The Text Component", null, {mValidClasses: Filters.sTextEntityClasses}), 
                             new VariableDefinitionString ("New Text String"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendText, shape_text_package, "Append Text", "@Append Text ($1) to $0", null,
                     [
                             new VariableDefinitionEntity ("The Text Component", null, {mValidClasses: Filters.sTextEntityClasses}), 
                             new VariableDefinitionString ("Text to Append"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityText_AppendNewLine, shape_text_package, "Append New Line", "@Append New Line to $0", null,
                     [
                             new VariableDefinitionEntity ("The Text Component", null, {mValidClasses: Filters.sTextEntityClasses}), 
                     ],
                     null
                  );
         
      // game / entity / shape / circle
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShapeCircle_GetRadius, shape_circle_package, "Get Radius", "@&0 = Get Radius of Circle $0", "GetCircleRadius",
                     [
                             new VariableDefinitionEntity ("The Circle", null, {mValidClasses: Filters.sCircleShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("The Radius"),
                     ]
                  );
         
      // game / entity / shape / rectangle
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityShapeRectangle_GetSize, shape_rectangle_package, "Get Size", "@(&0, &1) = Get Size of Retangle $0", "GetRectangleSize",
                     [
                             new VariableDefinitionEntity ("The Rectangle", null, {mValidClasses: Filters.sRectangleShapeEntityClasses}), 
                     ],
                     [
                             new VariableDefinitionNumber ("Width"),
                             new VariableDefinitionNumber ("Height"),
                     ]
                  );
         
      // game / entity / joint
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointLimitsEnabled, entity_joint_package, "Set Joint Limits Enabled", null, null,
                     [
                        new VariableDefinitionEntity ("The Joints", null, {mValidClasses: Filters.sLimitsConfigureableJointEntityClasses}), 
                        new VariableDefinitionBoolean ("Enabled?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetJointMotorEnabled, entity_joint_package, "Set Joint Motor Enabled", null, null,
                     [
                        new VariableDefinitionEntity ("The Joint", null, {mValidClasses: Filters.sMotorConfigureableJointEntityClasses}), 
                        new VariableDefinitionBoolean ("Enabled?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeAngleByDegrees, entity_joint_package, "Get Hinge Angle By Degrees", "@Degrees (&0) = Get Current Angle of Hinge ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Current Angle (degrees)"), 
                     ]
                  );
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeLimitsByDegrees, entity_joint_package, "Get Hinge Limits By Degrees", "@Degrees (&0, &1) = Get Limits of Hinge ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Lower Angle (degrees)"), 
                        new VariableDefinitionNumber ("Upper Angle (degrees)"), 
                     ]
                  );
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeLimitsByDegrees, entity_joint_package, "Set Hinge Limits by Degrees", "@Set Hinge ($0) Limits by Degrees ($1, $2)", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                        new VariableDefinitionNumber ("Lower Angle (degrees)"), 
                        new VariableDefinitionNumber ("Upper Angle (degrees)"), 
                     ],
                     null
                  );
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetHingeMotorSpeed, entity_joint_package, "Get Hinge Motor Speed by Degrees", "@Degrees/s (&0) = Get Motor Speed of Hinge ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Motor Speed (degrees/s)"), 
                     ]
                  );
        RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetHingeMotorSpeed, entity_joint_package, "Set Hinge Motor Speed by Degrees", "@Set Hinge ($0) Motor Speed by Degrees ($1) /s", null,
                     [
                        new VariableDefinitionEntity ("The Hinge", null, {mValidClasses: Filters.sJointHingeEntityClasses}), 
                        new VariableDefinitionNumber ("Motor Speed (degrees/s)"), 
                     ],
                     null
                  );
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderTranslation, entity_joint_package, "Get Slider Translation", "@&0 = Get Current Translation of Slider ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Current Translation"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderLimits, entity_joint_package, "Get Slider Limits", "@&0 = Get Limits of Slider ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Lower Translation"), 
                        new VariableDefinitionNumber ("Upper Translation"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderLimits, entity_joint_package, "Set Slider Limits", "@Set Slider ($0) Limits ($1)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                        new VariableDefinitionNumber ("Lower Translation"), 
                        new VariableDefinitionNumber ("Upper Translation"), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_GetSliderMotorSpeed, entity_joint_package, "Get Slider Motor Speed", "@&0 = Get Motor Speed of Slider ($0)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                     ],
                     [
                        new VariableDefinitionNumber ("Motor Speed (m/s)"), 
                     ]
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityJoint_SetSliderMotorSpeed, entity_joint_package, "Set Slider Motor Speed", "@Set Slider ($0) Motor Speed ($1)", null,
                     [
                        new VariableDefinitionEntity ("The Slider", null, {mValidClasses: Filters.sJointSliderEntityClasses}), 
                        new VariableDefinitionNumber ("Motor Speed (m/s)"), 
                     ],
                     null
                  );
         
      // trigger
         
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_ResetTimer, entity_trigger_package, "Reset Timer", null, null,
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}), 
                     ],
                     null
                  );
         RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerPaused, entity_trigger_package, "Set Timer Paused", null, null,
                     [
                        new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}), 
                        new VariableDefinitionBoolean ("Paused?", null, {mDefaultValue: true}), 
                     ],
                     null
                  );
         //RegisterFunctionDeclaration (CoreFunctionIds.ID_EntityTrigger_SetTimerInterval, entity_trigger_package, "Set Timer Interval", null, null,
         //            [
         //               new VariableDefinitionEntity ("The Timer Event Handler", null, {mValidClasses: Filters.sTimerEventHandlerEntityClasses}), 
         //               new VariableDefinitionNumber ("Interval", null, {mMinValue: 0.0}),
         //            ],
         //            null
         //         );

         
      // ...
         
         sMenuBarDataProvider_Shorter = CreateXmlFromPackages ([sGlobalPackage, sWorldPackage, sEntityPackage])
         sMenuBarDataProvider_Longer = CreateXmlFromPackages ([sGlobalPackage, number_package, sWorldPackage, sEntityPackage, entity_shape_package])
     }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterFunctionDeclaration (function_id:int, functionPackage:FunctionPackage, function_name:String, poemCallingFormat:String, traditionalCallingFormat:String, param_defines:Array, return_defines:Array):void
      {
         if (function_id < 0)
            return;
         
         sFunctionDeclarations [function_id] = new FunctionDeclaration_Core (function_id, function_name, poemCallingFormat, traditionalCallingFormat, param_defines, return_defines, null);
         
         if (functionPackage != null)
            functionPackage.AddFunctionDeclaration (sFunctionDeclarations [function_id]);
      }
      
      public static function GetFunctionDeclarationById (function_id:int):FunctionDeclaration_Core
      {
         if (function_id < 0 || function_id >= sFunctionDeclarations.length)
            return null;
         
         return sFunctionDeclarations [function_id];
      }
      
      // top leel
      private static function CreateXmlFromPackages (packages:Array):XML
      {
         var xml:XML = <root />;
         
         for each (var functionPackage:FunctionPackage in packages)
         {
            AddPackageToXML (functionPackage, xml, packages);
         }
         
         return xml;
      }
      
      private static function AddPackageToXML (functionPackage:FunctionPackage, parentXml:XML, topPackages:Array):void
      {
         var package_element:XML = <menuitem />;
         package_element.@name = functionPackage.GetName ();
         parentXml.appendChild (package_element);
         
         var num_items:int = 0;
         
         var child_packages:Array = functionPackage.GetChildPackages ();
         for (var i:int = 0; i < child_packages.length; ++ i)
         {
            if (topPackages.indexOf (child_packages [i]) < 0)
            {
               AddPackageToXML (child_packages [i] as FunctionPackage, package_element, topPackages);
               
               ++ num_items;
            }
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
      }
   }
}
