
package common.trigger {
   
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
         
      // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldBeforeInitializing,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldAfterInitialized,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLWorldBeforeUpdating,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldAfterUpdated,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldTimer,
                    [
                        ValueTypeDefine.ValueType_Number, 
                    ]);
         
      // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityInitialized,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityUpdated,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityDestroyed,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityTimer,
                    [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
         
      // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachLowerLimit,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachUpperLimit,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
      }
         
       // ...
         
         //RegisterEventDeclatation (CoreEventIds.ID_OnSensorContainsPhysicsShape,
         //           [
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Entity, 
         //               ValueTypeDefine.ValueType_Number, 
         //           ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesEndContacting,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityPairTimer,
                    [
                        ValueTypeDefine.ValueType_Number, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
         
     // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseDown,
                    [ 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnPhysicsShapeMouseUp,
                    [ 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseClick,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseDown,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseUp,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseMove,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseEnter,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnEntityMouseOut,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         
     // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseClick,
                    [ 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseDown,
                    [ 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseUp,
                    [ 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldMouseMove,
                    [ 
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                    ]);
         
     // ...
         
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyDown,
                    [
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Number,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyUp,
                    [
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Number,
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnWorldKeyHold,
                    [
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Number,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Boolean,
                        ValueTypeDefine.ValueType_Number,
                    ]);
         
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterEventDeclatation (eventId:int, paramValueTypes:Array):void
      {
         if (eventId < 0 || eventId >= IdPool.NumEventTypes)
            return;
         
         var func_decl:FunctionDeclaration = new FunctionDeclaration (eventId, paramValueTypes);
         
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
