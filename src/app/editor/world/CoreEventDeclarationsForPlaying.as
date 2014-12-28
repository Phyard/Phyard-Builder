
package editor.world {

   import editor.trigger.*;
   
   import common.trigger.CoreClassIds;
   import common.trigger.CoreEventIds;

   public class CoreEventDeclarationsForPlaying
   {
      //public static const

      public static var sEventDeclarations:Array = new Array (128);

      public static var sEventSettings:Array = new Array (128);

      public static function Initialize ():void
      {
      // functions

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnGameActivated, "OnGameActivated", "",
                    null
                    );
         RegisterEventDeclaration (CoreEventIds.ID_OnGameDeactivated, "OnGameDeactivated", "",
                    null
                    );

         RegisterEventDeclaration (CoreEventIds.ID_OnWorldBeforeRepainting, "OnLevelBeforeRepainting", "",
                    null
                    );

         RegisterEventDeclaration (CoreEventIds.ID_OnWorldViewportSizeChanged, "OnWorldViewportSizeChanged", "",
                    null
                    );

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnWorldBeforeInitializing, "OnLevelBeginInitialize", "",
                    null
                    );
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldAfterInitialized, "OnLevelEndInitialize", "",
                    null
                    );
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldBeforeUpdating, "OnLevelBeginUpdate", "",
                    null
                    );
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldAfterUpdated, "OnLevelEndUpdate", "",
                    null
                    );
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldBeforeExiting, "OnLevelBeforeExiting", "",
                    null
                    );
                    
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldTimer, "OnWorldTimer", "OnWorldTimer",
                    [
                     new VariableDefinitionNumber ("Calling Times"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldPreTimer, "OnWorldPreTimer", "OnWorldPreTimer",
                    [
                     new VariableDefinitionNumber ("Calling Times"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldPostTimer, "OnWorldPostTimer", "OnWorldPostTimer",
                    [
                     new VariableDefinitionNumber ("Calling Times"),
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnEntityCreated, "OnEntityCreated", "OnEntityCreated",
                    [
                       new VariableDefinitionEntity ("The Entity"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityInitialized, "OnEntityInitialized", "OnEntityInitialized",
                    [
                       new VariableDefinitionEntity ("The Entity"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityUpdated, "OnEntityUpdate", "OnEntityUpdate",
                    [
                       new VariableDefinitionEntity ("The Entity"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityDestroyed, "OnEntityDestroyed", "OnEntityDestroyed",
                    [
                       new VariableDefinitionEntity ("The Entity"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityTimer, "OnEntityTimer", "OnEntityTimer",
                    [
                       new VariableDefinitionNumber ("Calling Times"),
                       new VariableDefinitionEntity ("The Entity"),
                    ]);

         RegisterEventDeclaration (CoreEventIds.ID_OnJointReachLowerLimit, "OnJointReachLowerLimit", "OnJointReachLowerLimit",
                    [
                       new VariableDefinitionEntity ("The Joint", null, {mValidClasses: Filters.sLimitsConfigureableJointEntityClasses}),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnJointReachUpperLimit, "OnJointReachUpperLimit", "OnJointReachUpperLimit",
                    [
                       new VariableDefinitionEntity ("The Joint", null, {mValidClasses: Filters.sLimitsConfigureableJointEntityClasses}),
                    ]);

         RegisterEventDeclaration (CoreEventIds.ID_OnTextChanged, "OnTextChanged", "OnTextChanged",
                    [
                       new VariableDefinitionEntity ("The Text Shape", null, {mValidClasses: Filters.sTextEntityClasses}),
                    ]);

      // ...

         //RegisterEventDeclaration (CoreEventIds.ID_OnSensorContainsPhysicsShape, "OnSensorContainsPhysicsShape", "When shape 1 containing the center of shape 2",
         //           [
         //              new VariableDefinitionEntity ("Physics Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
         //              new VariableDefinitionEntity ("Physics Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
         //              new VariableDefinitionNumber ("Steps")
         //           ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, "OnTwoPhysicsShapesStartContacting", "When 2 physics shapes start contacting",
                    [
                       new VariableDefinitionEntity ("Physics Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionEntity ("Physics Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionNumber ("Steps")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting, "OnTwoPhysicsShapesKeepContacting", "When 2 physics shapes are contacting with each other",
                    [
                       new VariableDefinitionEntity ("Physics Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionEntity ("Physics Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionNumber ("Steps")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnTwoPhysicsShapesEndContacting, "OnTwoPhysicsShapesStopContacting", "When 2 physics shapes stop contacting",
                    [
                       new VariableDefinitionEntity ("Physics Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionEntity ("Physics Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionNumber ("Steps")
                    ]);
                    
         RegisterEventDeclaration (CoreEventIds.ID_OnTwoPhysicsShapesPreSolveContacting, "OnPreSolveTwoPhysicsShapesColldiing", "When to solve colliding of 2 physics shapes",
                    [
                       new VariableDefinitionEntity ("Physics Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionEntity ("Physics Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionNumber ("Number Of Points In This Contact"),
                       new VariableDefinitionNumber ("Index Of This Contact Point"),
                       new VariableDefinitionNumber ("Point X"),
                       new VariableDefinitionNumber ("Point Y"),
                       new VariableDefinitionNumber ("Normal X"),
                       new VariableDefinitionNumber ("Normal Y"),
                       //new VariableDefinitionNumber ("Depth"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnTwoPhysicsShapesPostSolveContacting, "OnPostSolveTwoPhysicsShapesColldiing", "When solved colliding of 2 physics shapes",
                    [
                       new VariableDefinitionEntity ("Physics Shape 1", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionEntity ("Physics Shape 2", null, {mValidClasses: Filters.sShapeEntityClasses}),
                       new VariableDefinitionNumber ("Number Of Points In This Contact"),
                       new VariableDefinitionNumber ("Index Of This Contact Point"),
                       new VariableDefinitionNumber ("Point X"),
                       new VariableDefinitionNumber ("Point Y"),
                       new VariableDefinitionNumber ("Normal X"),
                       new VariableDefinitionNumber ("Normal Y"),
                       new VariableDefinitionNumber ("Normal Pulse"),
                       new VariableDefinitionNumber ("Tangent Pulse")
                    ]);
                    
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityPairTimer, "OnEntityPairTimer", "OnEntityPairTimer",
                    [
                        new VariableDefinitionNumber ("Calling Times"),
                        new VariableDefinitionEntity ("Entity 1"),
                        new VariableDefinitionEntity ("Entity 2"),
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnEntityTouchTap, "On Shape Touch Tap", "Touch tap on a shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityTouchBegin, "On Shape Touch Begin", "Begin touching on a shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityTouchEnd, "On Shape Touch End", "End touching on a shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityTouchMove, "On Shape Touch Move", "Touch move on a shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityTouchEnter, "On Shape Touch Enter", "Touch enter a shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityTouchOut, "On Shape Touch Out", "Touch out a shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                    ]);


      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnPhysicsShapeMouseDown, "OnPhysicsShapeMouseDown", "Presss mouse on a physics shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnPhysicsShapeMouseUp, "OnPhysicsShapeMouseUp", "Release mouse on a physics shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnPhysicsShapeMouseRightDown, "OnPhysicsShapeMouseRightDown", "Right presss mouse on a physics shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnPhysicsShapeMouseRightUp, "OnPhysicsShapeMouseRightUp", "Right release mouse on a physics shape",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseClick, "OnShapeMouseClick", "Click mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseDown, "OnShapeMouseDown", "Press mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseUp, "OnShapeMouseUp", "Release mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseRightClick, "OnShapeMouseRightClick", "Right click mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseRightDown, "OnShapeMouseRightDown", "Right press mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseRightUp, "OnShapeMouseRightUp", "Right release mouse on an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseMove, "OnShapeMouseMove", "Move mouse in an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseEnter, "OnShapeMouseEnter", "Mouse enters an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnEntityMouseOut, "OnShapeMouseOut", "Move mouse out of an entity",
                    [
                        new VariableDefinitionEntity ("The Shape", null, {mValidClasses: Filters.sShapeEntityClasses}),
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down")
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnSequencedModuleLoopToEnd, "OnSequencedModuleLoopToEnd", "",
                    [
                        new VariableDefinitionEntity ("The Mobule Shape", null, {mValidClasses: Filters.sModuleShapeEntityClasses}),
                        new VariableDefinitionModule ("The Mobule"),
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnWorldTouchTap, "On World Touch Tap", "Touch tap on a shape",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldTouchBegin, "On World Touch Begin", "Begin touching a shape",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldTouchEnd, "On World Touch End", "End touching a shape",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldTouchMove, "On World Touch Move", "Touch move on a shape",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionNumber ("Touch Point ID"),
                        new VariableDefinitionBoolean ("Is Primary Touch Point"),
                        new VariableDefinitionNumber ("Pressure"),
                        new VariableDefinitionString ("Intent"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnWorldMouseRightClick, "OnWorldMouseRightClick", "When world is right mouse clicked",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"), 
                        new VariableDefinitionBoolean ("Is Left Button Down", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldMouseRightDown, "OnWorldMouseRightDown", "Right press mouse in world",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldMouseRightUp, "OnWorldMouseRightUp", "Right release mouse in world",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldMouseClick, "OnWorldMouseClick", "When world is clicked",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"), 
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldMouseDown, "OnWorldMouseDown", "Press mouse in world",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldMouseUp, "OnWorldMouseUp", "Release mouse in world",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldMouseMove, "OnWorldMouseMove", "Move moust in world",
                    [
                        new VariableDefinitionNumber ("World X"),
                        new VariableDefinitionNumber ("World Y"),
                        new VariableDefinitionBoolean ("Is Left Button Down"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionBoolean ("Is Alt Down"),
                        new VariableDefinitionBoolean ("Is Overlapped by Some Entities"),
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnWorldKeyDown, "OnKeyDown", "When a key is pressed",
                    [
                        new VariableDefinitionNumber ("Key Code"),
                        new VariableDefinitionNumber ("Char Code"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionNumber ("Holding Ticks"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldKeyUp, "OnKeyUp", "When a key is released",
                    [
                        new VariableDefinitionNumber ("Key Code"),
                        new VariableDefinitionNumber ("Char Code"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionNumber ("Holding Ticks"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnWorldKeyHold, "OnKeyHold", "When a key is hold",
                    [
                        new VariableDefinitionNumber ("Key Code"),
                        new VariableDefinitionNumber ("Char Code"),
                        new VariableDefinitionBoolean ("Is Ctrl Down"),
                        new VariableDefinitionBoolean ("Is Shift Down"),
                        new VariableDefinitionNumber ("Holding Ticks"),
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnMouseGesture, "OnMouseGestureDone", "When a mouse gesture is performed",
                    [
                        new VariableDefinitionNumber ("Gesture Type ID"),
                        new VariableDefinitionNumber ("Gesture Angle"),
                        new VariableDefinitionBoolean ("CW/CCW (true/false)"),
                        new VariableDefinitionString ("Gesture Name"),
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnSystemBack, "OnSystemBack", "When system BACK key is pressed",
                    null,
                    [
                        new VariableDefinitionBoolean ("Already Handled?"),
                    ]);

      // ...

         RegisterEventDeclaration (CoreEventIds.ID_OnMultiplePlayerInstanceInfoChanged, "OnMultiplePlayerInstanceInfoChanged", "When multiple player instance info changes",
                    [
                        new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstance, "Multiple Player Instance", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Instance Server Connection Status Changed? (Reserved Now)", null, {mIsVisible: false}),
                        new VariableDefinitionBoolean ("Player Status Changed?"),
                        new VariableDefinitionBoolean ("Instance Phase Changed?"),
                        new VariableDefinitionBoolean ("Instance Seats Info Changed?"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnMultiplePlayerInstanceChannelMessage, "OnMultiplePlayerInstanceChannelMessage", "When player sends a channel message",
                    [
                        new VariableDefinitionOthers (CoreClassIds.ValueType_MultiplePlayerInstance, "Multiple Player Instance", null, {mIsVisible: false}),
                        new VariableDefinitionNumber ("Channel Index"),
                        new VariableDefinitionNumber ("Seat Index"),
                        new VariableDefinitionOthers (CoreClassIds.ValueType_ByteArray, "Message Data"),
                    ]);
         RegisterEventDeclaration (CoreEventIds.ID_OnError, "OnError", "When error occurs",
                    [
                        new VariableDefinitionNumber ("Error ID"),
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

      private static function RegisterEventDeclaration (event_id:int, event_name:String, event_description:String, param_definitions:Array, return_definitions:Array = null):void
      {
         if (event_id < 0)
            return;

         sEventDeclarations [event_id] = new FunctionDeclaration_EventHandler (event_id, event_name, event_description, event_name, event_name, param_definitions, return_definitions);
      }

      public static function GetEventDeclarationById (event_id:int):FunctionDeclaration_EventHandler
      {
         if (event_id < 0 || event_id >= sEventDeclarations.length)
            return null;

         return sEventDeclarations [event_id];
      }

      //public static function GetEventSettingById (event_id:int):FunctionDeclaration_EventHandler
      //{
      //   if (event_id < 0 || event_id >= sEventDeclarations.length)
      //      return null;
      //
      //   return sEventDeclarations [event_id];
      //}

   }
}
