
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
   import common.trigger.CoreEventIds;
   
   public class EntityEventHandler_TimerWithPrePostHandling extends EntityEventHandler_Timer 
   {
      protected var mPreEventHandlerDefinition:FunctionDefinition;
      protected var mPreCodeSnippet:CodeSnippet;
      protected var mPostEventHandlerDefinition:FunctionDefinition;
      protected var mPostCodeSnippet:CodeSnippet;
      
      public function EntityEventHandler_TimerWithPrePostHandling (world:World, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (world, defaultEventId, potientialEventIds);
         
         mPreEventHandlerDefinition  = new FunctionDefinition (mWorld.GetTriggerEngine (), TriggerEngine.GetEventDeclarationById (CoreEventIds.ID_OnWorldPreTimer));
         mPreEventHandlerDefinition.SetLocalVariableSpace (mEventHandlerDefinition.GetLocalVariableSpace ());
         mPreCodeSnippet = new CodeSnippet (mPreEventHandlerDefinition);
         
         mPostEventHandlerDefinition = new FunctionDefinition (mWorld.GetTriggerEngine (), TriggerEngine.GetEventDeclarationById (CoreEventIds.ID_OnWorldPostTimer));
         mPostEventHandlerDefinition.SetLocalVariableSpace (mEventHandlerDefinition.GetLocalVariableSpace ());
         mPostCodeSnippet = new CodeSnippet (mPostEventHandlerDefinition);
      }
      
      public function GetPreCodeSnippet ():CodeSnippet
      {
         return mPreCodeSnippet;
      }
      
      public function GetPostCodeSnippet ():CodeSnippet
      {
         return mPostCodeSnippet;
      }
      
      override public function ValidateEntityLinks ():void
      {
         super.ValidateEntityLinks ();
         
         mPreCodeSnippet.ValidateValueSourcesAndTargets ();
         mPostCodeSnippet.ValidateValueSourcesAndTargets ();
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityEventHandler_TimerWithPrePostHandling (mWorld, mEventId);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var timerHandler:EntityEventHandler_TimerWithPrePostHandling = entity as EntityEventHandler_TimerWithPrePostHandling;
         
      }
      
   }
}
