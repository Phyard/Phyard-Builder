
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
   import common.KeyCodes;
   
   import common.trigger.ValueDefine;
   
   public class EntityEventHandler_Keyboard extends EntityEventHandler 
   {
      protected var mKeyCodes:Array = new Array ();
      
      public function EntityEventHandler_Keyboard (container:Scene, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (container, defaultEventId, potientialEventIds);
         
      }
      
      //ChangeToIsomorphicEventId
      //public function ChangeKeyboardEventId (eventId:int):void
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
      
      public function SetKeyCodes (keyCodes:Array):void
      {
         mKeyCodes.splice (0, mKeyCodes.length);
         
         if (keyCodes == null)
            return;
         
         var keyCode:int;
         for (var i:int = 0; i < keyCodes.length; ++ i)
         {
            keyCode = keyCodes [i];
            if (keyCode >= 0 && keyCode < KeyCodes.kNumKeys && mKeyCodes.indexOf (keyCode) < 0)
            {
               mKeyCodes.push (keyCode);
            }
         }
      }
      
      public function GetKeyCodes ():Array
      {
         return mKeyCodes.concat ();
      }
      
      override public function GetInfoText ():String
      {
         return super.GetInfoText () + ", " + mKeyCodes.toString (); // todo: used key names instead
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityEventHandler_Keyboard (mEntityContainer, mEventId);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var keyboardHandler:EntityEventHandler_Keyboard = entity as EntityEventHandler_Keyboard;
         
         keyboardHandler.SetKeyCodes (GetKeyCodes ());
      }
      
   }
}
