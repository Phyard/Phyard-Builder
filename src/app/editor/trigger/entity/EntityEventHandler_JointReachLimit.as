
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
   
   public class EntityEventHandler_JointReachLimit extends EntityEventHandler 
   {
      public function EntityEventHandler_JointReachLimit (world:World, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (world, defaultEventId, potientialEventIds);
         
      }
      
      // ChangeToIsomorphicEventId
      //public function ChangeMouseEventId (eventId:int):void
      //{
      //   if (mEventId != eventId)
      //   {
      //      mEventId = eventId;
      //      
      //      mEventHandlerDefinition = new FunctionDefinition (mWorld.GetTriggerEngine (), TriggerEngine.GetEventDeclarationById (mEventId), false, mEventHandlerDefinition);
      //      
      //      mCodeSnippet = mCodeSnippet.Clone (mEventHandlerDefinition);
      //      
      //      mIconBitmap = Resource.EventId2IconBitmap (mEventId);
      //   }
      //}
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityEventHandler_JointReachLimit (mWorld, mEventId);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var jointReachLimitHandler:EntityEventHandler_JointReachLimit = entity as EntityEventHandler_JointReachLimit;
      }
      
   }
}