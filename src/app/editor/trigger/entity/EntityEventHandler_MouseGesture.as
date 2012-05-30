
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
   import common.GestureIDs;
   
   import common.trigger.ValueDefine;
   
   public class EntityEventHandler_MouseGesture extends EntityEventHandler 
   {
      protected var mGestureIDs:Array = new Array ();
      
      public function EntityEventHandler_MouseGesture (container:Scene, defaultEventId:int, potientialEventIds:Array = null)
      {
         super (container, defaultEventId, potientialEventIds);
         
      }
      
      public function SetGestureIDs (gestureIDs:Array):void
      {
         mGestureIDs.splice (0, mGestureIDs.length);
         
         if (gestureIDs == null)
            return;
         
         var gestureId:int;
         for (var i:int = 0; i < gestureIDs.length; ++ i)
         {
            gestureId = gestureIDs [i];
            if (gestureId >= 0 && gestureId < GestureIDs.kNumGestures && mGestureIDs.indexOf (gestureId) < 0)
            {
               mGestureIDs.push (gestureId);
            }
         }
      }
      
      public function GetGestureIDs ():Array
      {
         return mGestureIDs.concat ();
      }
      
      override public function GetInfoText ():String
      {
         return super.GetInfoText () + ", " + mGestureIDs.toString (); // todo: used key names instead
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityEventHandler_MouseGesture (mEntityContainer, mEventId);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var gestureHandler:EntityEventHandler_MouseGesture = entity as EntityEventHandler_MouseGesture;
         
         gestureHandler.SetGestureIDs (GetGestureIDs ());
      }
      
   }
}
