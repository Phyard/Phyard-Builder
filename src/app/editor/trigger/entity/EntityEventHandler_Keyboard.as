
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
   
   public class EntityEventHandler_Keyboard extends EntityEventHandler 
   {
      protected var mKeyCodes:Array = new Array ();
      
      public function EntityEventHandler_Keyboard (world:World, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (world, defaultEventId, potientialEventIds);
         
      }
      
      public function ChangeKeyboardEventId (eventId:int):void
      {
         if (mEventId != eventId)
         {
            mEventId = eventId;
            
            mEventHandlerDefinition = new FunctionDefinition (TriggerEngine.GetEventDeclarationById (mEventId));
            
            mCodeSnippet = mCodeSnippet.Clone (mEventHandlerDefinition);
         }
      }
      
      public function SetKeyCodes (keyCodes:Array):void
      {
         mKeyCodes.splice (0, mKeyCodes.length);
         
         if (keyCodes == null)
            return;
         
         var keyCode:int;
         for (var i:int = 0; i < keyCodes.length; ++ i)
         {
            keyCode = keyCodes [i];
            if (keyCode >= 0 && keyCode < 256 && mKeyCodes.indexOf (keyCode) < 0)
            {
               mKeyCodes.push (keyCode);
            }
         }
      }
      
      public function GetKeyCodes ():Array
      {
         return mKeyCodes.slice ();
      }
   }
}
