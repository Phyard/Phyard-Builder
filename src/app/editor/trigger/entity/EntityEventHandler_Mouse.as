
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
   
   import editor.runtime.Resource;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityEventHandler_Mouse extends EntityEventHandler 
   {
      public function EntityEventHandler_Mouse (world:World, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (world, defaultEventId, potientialEventIds);
         
      }
      
      public function ChangeMouseEventId (eventId:int):void
      {
         if (mEventId != eventId)
         {
            mEventId = eventId;
            
            mEventHandlerDefinition = new FunctionDefinition (TriggerEngine.GetEventDeclarationById (mEventId));
            
            mCodeSnippet = mCodeSnippet.Clone (mEventHandlerDefinition);
            
            mEventIconBitmap = Resource.EventId2IconBitmap (mEventId);
         }
      }
   }
}
