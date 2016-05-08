
package common.trigger {

   import common.Define;

   public class CoreEventDeclarations
   {
      //public static const

      public static var sEventHandlerDeclarations:Array = new Array (IdPool.NumEventTypes);

      private static var mInitialized:Boolean = false;

      public static function Initialize ():void
      {
         if (mInitialized)
            return;

         mInitialized = true;

      // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnGameActivated,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnGameDeactivated,
                    null
                    );
         
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldBeforeRepainting,
                    null
                    );
         
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldViewportSizeChanged,
                    null
                    );

      // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnWorldBeforeInitializing,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldAfterInitialized,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldBeforeUpdating,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldAfterUpdated,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldBeforeExiting,
                    null
                    );
                    
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldTimer,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldPreTimer,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldPostTimer,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                    ]);

      // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnEntityCreated,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityInitialized,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityUpdated,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityDestroyed,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTimer,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);

      // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachLowerLimit,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachUpperLimit,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);

      // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnTextChanged,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);

       // ...

         //RegisterEventDeclatation (CoreEventIds.ID_OnSensorContainsPhysicsShape,
         //           [
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
         //               [CoreClassIds.ValueType_Number,       0],
         //           ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesEndContacting,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
                    
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesPreSolveContacting,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       1],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesPostSolveContacting,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       1],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
                    
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityPairTimer,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTouchTap,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTouchBegin,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTouchEnd,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTouchMove,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTouchEnter,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTouchOut,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseRightDown,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseRightUp,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);

         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseDown,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseUp,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseClick,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseDown,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseUp,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseRightClick,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseRightDown,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseRightUp,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseMove,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseEnter,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseOut,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnSequencedModuleLoopToEnd,
                    [
                        [CoreClassIds.ValueType_Entity,       Define.EntityId_None],
                        [CoreClassIds.ValueType_Module,       -1],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnWorldTouchTap,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldTouchBegin,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldTouchEnd,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldTouchMove,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_String,       null],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
                    
     // ...
     
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseRightClick,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseRightDown,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseRightUp,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);

         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseClick,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseDown,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseUp,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseMove,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyDown,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyUp,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyHold,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Number,       0],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnMouseGesture,
                    [
                        [CoreClassIds.ValueType_Number,       -1],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Boolean,      true],
                        [CoreClassIds.ValueType_String,       null],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnSystemBack,
                    null,
                    [
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnMultiplePlayerInstanceInfoChanged,
                    [
                        [CoreClassIds.ValueType_MultiplePlayerInstance,       null],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                        [CoreClassIds.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnMultiplePlayerInstanceChannelMessage,
                    [
                        [CoreClassIds.ValueType_MultiplePlayerInstance,       null],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_Number,       0],
                        [CoreClassIds.ValueType_ByteArray,       null],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnError,
                    [
                        [CoreClassIds.ValueType_Number,       0],
                    ]);
         
      // ...
         
      }

//===========================================================
// util functions
//===========================================================

      private static function RegisterEventDeclatation (eventId:int, inputParamDefines:Array, outputParamDefines:Array = null):void
      {
         if (eventId < 0 || eventId >= IdPool.NumEventTypes)
            return;

         sEventHandlerDeclarations [eventId] = new FunctionCoreBasicDefine (eventId, inputParamDefines, outputParamDefines);
      }

      public static function GetCoreEventHandlerDeclarationById (eventId:int):FunctionCoreBasicDefine
      {
         if (eventId < 0 || eventId >= IdPool.NumEventTypes)
            return null;

         if (! mInitialized)
            Initialize ();

         return sEventHandlerDeclarations [eventId];
      }

   }
}
