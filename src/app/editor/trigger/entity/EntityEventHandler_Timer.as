
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
   
   public class EntityEventHandler_Timer extends EntityEventHandler 
   {
      protected var mRunningInterval:Number = 1.0; // steps or seconds
      protected var mOnlyRunOnce:Boolean = true;
      
      public function EntityEventHandler_Timer (world:World, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (world, defaultEventId, potientialEventIds);
         
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
   }
}
