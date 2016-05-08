
package editor.trigger.entity {
   
   import editor.entity.Scene;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.trigger.FunctionDeclaration_EventHandler;
   import editor.trigger.FunctionDefinition;
   import editor.trigger.VariableDefinition;
   import editor.trigger.VariableDefinitionEntity;
   import editor.trigger.CodeSnippet;
   
   import editor.Resource;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityEventHandler_Contact extends EntityEventHandler 
   {
      public function EntityEventHandler_Contact (container:Scene, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (container, defaultEventId, potientialEventIds);
         
      }
      
      // ChangeToIsomorphicEventId
      //public function ChangeContactEventId (eventId:int):void
      //{
      //   if (mEventId != eventId)
      //   {
      //      mEventId = eventId;
      //      
      //      mEventHandlerDefinition = new FunctionDefinition (mEntityContainer.GetTriggerEngine (), TriggerEngine.GetEventDeclarationById (mEventId), false, mEventHandlerDefinition);
      //      
      //      mCodeSnippet = mCodeSnippet.Clone (mEntityContainer, mEventHandlerDefinition);
      //      
      //      mIconBitmap = Resource.EventId2IconBitmap (mEventId);
      //   }
      //}
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityEventHandler_Contact (mEntityContainer, mEventId);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var contactHandler:EntityEventHandler_Contact = entity as EntityEventHandler_Contact;
      }
      
   }
}
