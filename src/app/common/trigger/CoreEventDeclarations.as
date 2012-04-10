
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
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldTimer,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldPreTimer,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldPostTimer,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);

      // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnEntityCreated,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityInitialized,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityUpdated,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityDestroyed,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTimer,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                    ]);

      // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachLowerLimit,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachUpperLimit,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                    ]);
      }

       // ...

         //RegisterEventDeclatation (CoreEventIds.ID_OnSensorContainsPhysicsShape,
         //           [
         //               [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
         //               [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
         //               [ValueTypeDefine.ValueType_Number,       0],
         //           ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesEndContacting,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityPairTimer,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseDown,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseUp,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseClick,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseDown,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseUp,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseMove,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseEnter,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseOut,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);

         RegisterEventDeclatation (CoreEventIds.ID_OnSequencedModuleLoopToEnd,
                    [
                        [ValueTypeDefine.ValueType_Entity,       Define.EntityId_None],
                        [ValueTypeDefine.ValueType_Module,       -1],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseClick,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseDown,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseUp,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseMove,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                    ]);

     // ...

         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyDown,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyUp,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyHold,
                    [
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Number,       0],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Boolean,      false],
                        [ValueTypeDefine.ValueType_Number,       0],
                    ]);

//===========================================================
// util functions
//===========================================================

      private static function RegisterEventDeclatation (eventId:int, inputParamDefines:Array):void
      {
         if (eventId < 0 || eventId >= IdPool.NumEventTypes)
            return;

         var func_decl:FunctionDeclaration = new FunctionDeclaration (eventId, inputParamDefines);

         sEventHandlerDeclarations [eventId] = func_decl;
      }

      public static function GetCoreEventHandlerDeclarationById (eventId:int):FunctionDeclaration
      {
         if (eventId < 0 || eventId >= IdPool.NumEventTypes)
            return null;

         if (! mInitialized)
            Initialize ();

         return sEventHandlerDeclarations [eventId];
      }

   }
}
