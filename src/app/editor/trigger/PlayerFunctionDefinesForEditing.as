
package editor.trigger {
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   
   import common.trigger.PlayerFunctionIds;
   import common.trigger.ValueTypeDefine;
   
   public class PlayerFunctionDefinesForEditing
   {
      
      private static var sFunctionDeclarations:Array = new Array (128);
      
      public static var sTopFuntionPackage:FunctionPackage = new FunctionPackage ("");
      public static var sCommandFunctionsMenuItemXML:XML = null;
      public static var sConditionFunctionsMenuItemXML:XML = null;
      
      public static function Initialize ():void
      {
      // packages
         
         var global_package:FunctionPackage = new FunctionPackage ("global", sTopFuntionPackage);
         var world_package:FunctionPackage = new FunctionPackage ("world", sTopFuntionPackage);
         var entity_package:FunctionPackage = new FunctionPackage ("entity", sTopFuntionPackage);
            var shape_package:FunctionPackage = new FunctionPackage ("shape", entity_package);
            var joint_package:FunctionPackage = new FunctionPackage ("joint", entity_package);
         
      // functions
         
         RegisterFunctionDeclaration (world_package, PlayerFunctionIds.ID_SetWorldGravityAcceleration, "SetWorldGravityAcceleration", 
                    [
                       new VariableDefinitionNumber ("Gravity Acceleration"), 
                       new VariableDefinitionNumber ("Gravity Angle")
                    ]);
         RegisterFunctionDeclaration (world_package, PlayerFunctionIds.ID_SetWorldCameraFocusEntity, "SetWorldCameraFocusEntity", 
                    [
                       new VariableDefinitionEntity ("Focus Entity"), 
                    ]);
         RegisterFunctionDeclaration (shape_package, PlayerFunctionIds.ID_SetShapeDensity, "SetShapeDensity", 
                    [
                       new VariableDefinitionEntity ("Shape"), 
                       new VariableDefinitionNumber ("Density")
                       
                       , new VariableDefinitionBoolean ("Is Sensor")
                       , new VariableDefinitionString ("Text")
                       , new VariableDefinitionCollisionCategory ("Collision Category")
                    ]);
         RegisterFunctionDeclaration (entity_package, PlayerFunctionIds.ID_IsEntityVisible, "IsEntityVisible", 
                    [
                       new VariableDefinitionEntity ("Entity")
                    ],
                    ValueTypeDefine.ValueType_Boolean );
         RegisterFunctionDeclaration (shape_package, PlayerFunctionIds.ID_IsPhysicsShape, "IsPhysicsShape", 
                    [
                       new VariableDefinitionEntity ("Entity")
                    ],
                    ValueTypeDefine.ValueType_Boolean );
         RegisterFunctionDeclaration (shape_package, PlayerFunctionIds.ID_IsSensorShape, "IsSensorShape", 
                    [
                       new VariableDefinitionEntity ("Entity")
                    ],
                    ValueTypeDefine.ValueType_Boolean );
         RegisterFunctionDeclaration (global_package, PlayerFunctionIds.ID_IsTrue, "IsTrue", 
                    [
                       new VariableDefinitionBoolean ("Bool Value")
                    ],
                    ValueTypeDefine.ValueType_Boolean );
         RegisterFunctionDeclaration (global_package, PlayerFunctionIds.ID_IsFalse, "IsFalse", 
                    [
                       new VariableDefinitionBoolean ("Bool Value")
                    ],
                    ValueTypeDefine.ValueType_Boolean );
         
      // ...
         
         sCommandFunctionsMenuItemXML = AddPackageToXML (sTopFuntionPackage, null, ValueTypeDefine.ValueType_Void);
         sConditionFunctionsMenuItemXML = AddPackageToXML (sTopFuntionPackage, null, ValueTypeDefine.ValueType_Boolean);
      }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterFunctionDeclaration (functionPackage:FunctionPackage, function_id:int, function_name:String, param_defines:Array, returnValueType:int = ValueTypeDefine.ValueType_Void):void
      {
         if (function_id < 0)
            return;
         
         sFunctionDeclarations [function_id] = new FunctionDeclaration (function_id, function_name, param_defines, null, returnValueType);
         
         functionPackage.AddFunctionDeclaration (sFunctionDeclarations [function_id]);
      }
      
      public static function GetFunctionDeclarationById (function_id:int):FunctionDeclaration
      {
         if (function_id < 0 || function_id >= sFunctionDeclarations.length)
            return null;
         
         return sFunctionDeclarations [function_id];
      }
      
      private static function AddPackageToXML (functionPackage:FunctionPackage, xml:XML, returnValueType:int):XML
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
            AddPackageToXML (child_packages [i] as FunctionPackage, package_element, returnValueType);
            
            ++ num_items;
         }
         
         var declarations:Array = functionPackage.GetFunctionDeclarations ();
         var declaration:FunctionDeclaration;
         var function_element:XML;
         for (var j:int = 0; j < declarations.length; ++ j)
         {
            declaration = declarations [j] as FunctionDeclaration;
            
            if (declaration.GetReturnValueType () == returnValueType)
            {
               function_element = <menuitem />;
               function_element.@name = declaration.GetName ();
               function_element.@id = declaration.GetID ();
               
               package_element.appendChild (function_element);
               
               ++ num_items;
            }
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
