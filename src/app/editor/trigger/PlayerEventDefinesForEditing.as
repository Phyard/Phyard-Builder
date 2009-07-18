
package editor.trigger {
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.PlayerEventIds;
   
   public class PlayerEventDefinesForEditing
   {
      //public static const 
      
      public static var sEventDeclarations:Array = new Array (128);
      
      public static var sEventSettings:Array = new Array (128);
      
      public static function Initialize ():void
      {
      // functions
         
         RegisterEventDeclatation (PlayerEventIds.ID_OnTrigger, "Trigger", "Trigger",
                    null
                    );
         RegisterEventDeclatation (PlayerEventIds.ID_OnShapeContainingShape, "OnShapeContainingShape", "When shape 1 containing the center of shape 2",
                    [
                       new VariableDefinitionEntity ("Shape 1"), 
                       new VariableDefinitionEntity ("Shape 2"), 
                       new VariableDefinitionNumber ("Seconds") 
                    ]);
         RegisterEventDeclatation (PlayerEventIds.ID_OnShapeBeginsContactingShape, "OnShapeBeginsContactingShape", "When 2 physics shapes start contacting",
                    [
                       new VariableDefinitionEntity ("Shape 1"), 
                       new VariableDefinitionEntity ("Shape 2")
                    ]);
         RegisterEventDeclatation (PlayerEventIds.ID_OnShapeContactingShape, "OnShapeContactingShape", "When 2 physics shapes are contacting with each other",
                    [
                       new VariableDefinitionEntity ("Shape 1"), 
                       new VariableDefinitionEntity ("Shape 2"), 
                       new VariableDefinitionNumber ("Seconds") 
                    ]);
         RegisterEventDeclatation (PlayerEventIds.ID_OnShapeEndsContactingShape, "OnShapeEndsContactingShape", "When 2 physics shapes end contacting",
                    [
                       new VariableDefinitionEntity ("Shape 1"), 
                       new VariableDefinitionEntity ("Shape 2")
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
         
         sEventDeclarations [event_id] = new EventDeclaration (event_id, event_name, param_definitions, event_description);
      }
      
      public static function GetEventDeclarationById (event_id:int):EventDeclaration
      {
         if (event_id < 0 || event_id >= sEventDeclarations.length)
            return null;
         
         return sEventDeclarations [event_id];
      }
      
      public static function GetEventSettingById (event_id:int):EventDeclaration
      {
         if (event_id < 0 || event_id >= sEventDeclarations.length)
            return null;
         
         return sEventDeclarations [event_id];
      }
      
   }
}
