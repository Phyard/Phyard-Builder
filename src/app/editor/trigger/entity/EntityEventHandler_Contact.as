
package editor.trigger.entity {
   
   import editor.world.World;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.trigger.TriggerEngine;
   import editor.trigger.FunctionDeclaration_EventHandler;
   import editor.trigger.FunctionDefinition;
   import editor.trigger.VariableDefinition;
   import editor.trigger.VariableDefinitionEntity;
   import editor.trigger.CodeSnippet;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityEventHandler_Contact extends EntityEventHandler 
   {
      public function EntityEventHandler_Contact (world:World, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (world, defaultEventId, potientialEventIds);
         
      }
      
      public function ChangeContactEventId (eventId:int):void
      {
         if (mEventId != eventId)
         {
            mEventId = eventId;
            
            mEventHandlerDefinition = new FunctionDefinition (TriggerEngine.GetEventDeclarationById (mEventId));
            
            mCodeSnippet = mCodeSnippet.Clone (mEventHandlerDefinition);
         }
      }
   }
}
