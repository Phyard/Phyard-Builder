
package editor.trigger.entity {
   
   import editor.entity.Scene;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.trigger.TriggerEngine;
   import editor.trigger.FunctionDeclaration_EventHandler;
   import editor.trigger.FunctionDefinition;
   import editor.trigger.VariableDefinition;
   import editor.trigger.VariableDefinitionEntity;
   import editor.trigger.CodeSnippet;
   
   import editor.Resource;
   
   import common.Define;
   
   import common.trigger.ValueDefine;
   
   public class EntityEventHandler_Timer extends EntityEventHandler 
   {
      protected var mRunningInterval:Number = 120.0; // steps or seconds
      protected var mOnlyRunOnce:Boolean = true;
      
      public function EntityEventHandler_Timer (container:Scene, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (container, defaultEventId, potientialEventIds);
      }
      
      public function SetRunningInterval (interval:Number):void
      {
         mRunningInterval = interval;
      }
      
      public function GetRunningInterval ():Number
      {
         return mRunningInterval;
      }
      
      public function SetOnlyRunOnce (once:Boolean):void
      {
         mOnlyRunOnce = once;
      }
      
      public function IsOnlyRunOnce ():Boolean
      {
         return mOnlyRunOnce;
      }
      
      override public function GetInfoText ():String
      {
         return super.GetInfoText () + ", Run Once: " + mOnlyRunOnce + ", Interval: " + mRunningInterval;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityEventHandler_Timer (mEntityContainer, mEventId);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var timerHandler:EntityEventHandler_Timer = entity as EntityEventHandler_Timer;
         
         timerHandler.SetRunningInterval (GetRunningInterval ());
         timerHandler.SetOnlyRunOnce (IsOnlyRunOnce ());
      }
      
   }
}
