
package common.trigger {
   
   public class CoreEventDeclarations
   {
      //public static const 
      
      public static var sEventHandlerDeclarations:Array = new Array (CoreEventIds.NumEventTypes);
      
      private static var mInitialized:Boolean = false;
      
      public static function Initialize ():void
      {
         if (mInitialized)
            return;
         
         mInitialized = true;
         
      // functions
         
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelBeginInitialize,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelEndInitialize,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelBeginUpdate,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelEndUpdate,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelFinished,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelFailed,
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnSensorContainsPhysicsShape,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Number, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                        ValueTypeDefine.ValueType_Entity, 
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
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTimer,
                    null
                    );
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
         RegisterEventDeclatation (CoreEventIds.ID_OnJointBroken,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachLowerLimit,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachUpperLimit,
                    [
                        ValueTypeDefine.ValueType_Entity, 
                    ]);
      }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterEventDeclatation (eventId:int, paramValueTypes:Array):void
      {
         if (eventId < 0 || eventId >= CoreEventIds.NumEventTypes)
            return;
         
         var func_decl:FunctionDeclaration = new FunctionDeclaration (eventId, paramValueTypes);
         
         sEventHandlerDeclarations [eventId] = func_decl;
      }
      
      public static function GetCoreEventHandlerDeclarationById (eventId:int):FunctionDeclaration
      {
         if (eventId < 0 || eventId >= CoreEventIds.NumEventTypes)
            return null;
         
         if (! mInitialized)
            Initialize ();
         
         return sEventHandlerDeclarations [eventId];
      }
      
   }
}
