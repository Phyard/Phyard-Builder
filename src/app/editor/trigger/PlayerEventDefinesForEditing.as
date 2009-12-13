
package editor.trigger {
   
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
         
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelBeginInitialize, "OnLevelBeginInitialize", "Initialize Leel",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelEndInitialize, "OnLevelEndInitialize", "Initialize Leel",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelBeginUpdate, "OnLevelBeginUpdate", "Trigger",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelEndUpdate, "OnLevelEndUpdate", "Trigger",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelFinished, "OnLevelFinished", "Trigger",
                    null
                    );
         RegisterEventDeclatation (CoreEventIds.ID_OnLevelFailed, "OnLevelFailed", "Trigger",
                    null
                    );
         
         RegisterEventDeclatation (CoreEventIds.ID_OnSensorContainsPhysicsShape, "OnSensorContainsPhysicsShape", "When shape 1 containing the center of shape 2",
                    [
                       new VariableDefinitionEntity ("Shape 1"), 
                       new VariableDefinitionEntity ("Shape 2"), 
                       new VariableDefinitionNumber ("Seconds") 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, "OnTwoPhysicsShapesBeginContacting", "When 2 physics shapes start contacting",
                    [
                       new VariableDefinitionEntity ("Shape 1"), 
                       new VariableDefinitionEntity ("Shape 2")
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting, "OnTwoPhysicsShapesKeepContacting", "When 2 physics shapes are contacting with each other",
                    [
                       new VariableDefinitionEntity ("Shape 1"), 
                       new VariableDefinitionEntity ("Shape 2"), 
                       new VariableDefinitionNumber ("Seconds") 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnTwoPhysicsShapesEndContacting, "OnTwoPhysicsShapesEndContacting", "When 2 physics shapes end contacting",
                    [
                       new VariableDefinitionEntity ("Shape 1"), 
                       new VariableDefinitionEntity ("Shape 2")
                    ]);
         
         RegisterEventDeclatation (CoreEventIds.ID_OnTimer, "OnTimer", "Timer",
                    null
                    );
         
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
         
         RegisterEventDeclatation (CoreEventIds.ID_OnJointBroken, "OnJointBroken", "OnJointBroken",
                    [
                       new VariableDefinitionEntity ("Joint"), 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachLowerLimit, "OnJointReachLowerLimit", "OnJointReachLowerLimit",
                    [
                       new VariableDefinitionEntity ("Joint"), 
                    ]);
         RegisterEventDeclatation (CoreEventIds.ID_OnJointReachUpperLimit, "OnJointReachUpperLimit", "OnJointReachUpperLimit",
                    [
                       new VariableDefinitionEntity ("Joint"), 
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
