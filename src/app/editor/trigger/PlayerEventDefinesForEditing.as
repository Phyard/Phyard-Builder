
package editor.trigger {
   
   import editor.entity.*;
   import editor.trigger.entity.*;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.CoreEventIds;
   
   public class PlayerEventDefinesForEditing
   {
      //public static const 
      
      public static var sEventDeclarations:Array = new Array (128);
      
      public static var sEventSettings:Array = new Array (128);
      
      public static function Initialize ():void
      {
      // functions
         
      // ...
         
      // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldBeforeInitializing, "OnLevelBeginInitialize", "",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldAfterInitialized, "OnLevelEndInitialize", "",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLWorldBeforeUpdating, "OnLevelBeginUpdate", "",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldAfterUpdated, "OnLevelEndUpdate", "",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldTimer, "OnWorldTimer", "OnWorldTimer",
                    [
                     new VariableDefinitionNumber ("Calling Times"), 
                    ]);
         
      // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityInitialized, "OnEntityInitialized", "OnEntityInitialized",
                    [
                       new VariableDefinitionEntity ("Entity"), 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityUpdated, "OnEntityUpdate", "OnEntityUpdate",
                    [
                       new VariableDefinitionEntity ("Entity"), 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityDestroyed, "OnEntityDestroyed", "OnEntityDestroyed",
                    [
                       new VariableDefinitionEntity ("Entity"), 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTimer, "OnEntityTimer", "OnEntityTimer",
                    [
                       new VariableDefinitionNumber ("Calling Times"), 
                       new VariableDefinitionEntity ("Entity"), 
                    ]);
         
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachLowerLimit, "OnJointReachLowerLimit", "OnJointReachLowerLimit",
                    [
                       new VariableDefinitionEntity ("Joint", null, {mValidClasses: Filters.sJointEntityClasses}), 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachUpperLimit, "OnJointReachUpperLimit", "OnJointReachUpperLimit",
                    [
                       new VariableDefinitionEntity ("Joint", null, {mValidClasses: Filters.sJointEntityClasses}), 
                    ]);
         
      // ...
         
         //RegisterEventDeclatation (CoreEventIds.ID_OnSensorContainsPhysicsShape, "OnSensorContainsPhysicsShape", "When shape 1 containing the center of shape 2",
         //           [
         //              new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}), 
         //              new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}), 
         //              new VariableDefinitionNumber ("Seconds") 
         //           ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, "OnTwoPhysicsShapesStartContacting", "When 2 physics shapes start contacting",
                    [
                       new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                       new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses})
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting, "OnTwoPhysicsShapesKeepContacting", "When 2 physics shapes are contacting with each other",
                    [
                       new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                       new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                       new VariableDefinitionNumber ("Seconds") 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesEndContacting, "OnTwoPhysicsShapesStopContacting", "When 2 physics shapes stop contacting",
                    [
                       new VariableDefinitionEntity ("Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}), 
                       new VariableDefinitionEntity ("Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses})
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityPairTimer, "OnEntityPairTimer", "OnEntityPairTimer",
                    [
                        new VariableDefinitionNumber ("Calling Times"),
                        new VariableDefinitionEntity ("Entity 1"), 
                        new VariableDefinitionEntity ("Entity 2"), 
                    ]);
         
      // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseDown, "OnPhysicsShapeMouseDown", "Presss mouse on a physics shape",
                    [
                        new VariableDefinitionEntity ("The Physics Shape", null, EntityShape.prototype), 
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseUp, "OnPhysicsShapeMouseUp", "Release mouse on a physics shape",
                    [
                        new VariableDefinitionEntity ("The Physics Shape", null, EntityShape.prototype), 
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseClick, "OnShapeMouseClick", "Click mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, EntityShape.prototype), 
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseDown, "OnShapeMouseDown", "Press mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, EntityShape.prototype), 
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseUp, "OnShapeMouseUp", "Release mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, EntityShape.prototype), 
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseMove, "OnShapeMouseMove", "Move mouse in an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, EntityShape.prototype), 
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseEnter, "OnShapeMouseEnter", "Mouse enters an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, EntityShape.prototype), 
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseOut, "OnShapeMouseOut", "Move mouse out of an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, EntityShape.prototype), 
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         
      // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseClick, "OnWorldMouseClick", "When world is clicked",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseDown, "OnWorldMouseDown", "Press mouse in world",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseUp, "OnWorldMouseUp", "Release mouse in world",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseMove, "OnWorldMouseMove", "Move moust in world",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         
      // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyDown, "OnKeyDown", "When a key is pressed",
                    [
                        new VariableDefinitionNumber ("Key Code"),
                        new VariableDefinitionNumber ("Char Code"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionNumber ("Holding Ticks"),
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyUp, "OnKeyUp", "When a key is released",
                    [
                        new VariableDefinitionNumber ("Key Code"),
                        new VariableDefinitionNumber ("Char Code"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionNumber ("Holding Ticks"),
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyHold, "OnKeyHold", "When a key is hold",
                    [
                        new VariableDefinitionNumber ("Key Code"),
                        new VariableDefinitionNumber ("Char Code"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionNumber ("Holding Ticks"),
                    ]);
         
      // event settings
         
         //Max Allowed Instances
         //ReplaceableEventIds:
         //EntityParamsCount: 0/1/2
         //ValidEntityLimiterTypes: 1-1, M-M, A-A, A1M, A2M / 1, M, A
         //DefaultLimiterType:
         
      }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterEventDeclatation (event_id:int, event_name:String, event_description:String, param_definitions:Array):void
      {
         if (event_id < 0)
            return;
         
         sEventDeclarations [event_id] = new FunctionDeclaration_EventHandler (event_id, event_name, param_definitions, event_description);
      }
      
      public static function GetEventDeclarationById (event_id:int):FunctionDeclaration_EventHandler
      {
         if (event_id < 0 || event_id >= sEventDeclarations.length)
            return null;
         
         return sEventDeclarations [event_id];
      }
      
      public static function GetEventSettingById (event_id:int):FunctionDeclaration_EventHandler
      {
         if (event_id < 0 || event_id >= sEventDeclarations.length)
            return null;
         
         return sEventDeclarations [event_id];
      }
      
   }
}
