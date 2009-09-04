
package common.trigger {
   
   public class CoreEventDeclarations
   {
      //public static const 
      
      public static var sEventHandlerDeclarations:Array = new Array (CoreEventIds.NumEventTypes);
      
      public static function Initialize ():void
      {
      // functions
         
         RegisterEventDeclatation (CoreEventIds.ID_OnTrigger,
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
      
   }
}
