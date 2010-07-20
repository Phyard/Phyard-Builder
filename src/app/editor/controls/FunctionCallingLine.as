
package editor.controls {
   
   import flash.events.Event;
   
   import mx.events.FlexEvent;
   
   import mx.controls.Label;
   
   public class FunctionCallingLine extends Label 
   {
      public function FunctionCallingLine ()
      {
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
      private function OnAddedToStage (event:Event):void 
      {
         addEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         addEventListener (FlexEvent.DATA_CHANGE , OnDataChanged);
      }
      
      private function OnRemovedFromStage (event:Event):void 
      {
         removeEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         removeEventListener (Event.REMOVED_FROM_STAGE , OnRemovedFromStage);
         removeEventListener (FlexEvent.DATA_CHANGE , OnDataChanged);
      }
      
      private function OnDataChanged (event:FlexEvent):void
      {
         if (data != null)
         {
            setStyle ("paddingLeft", 16 * data.mIndentLevel);
            //htmlText = "<font color='#FF0000'>" + data.mName + "</font>";
         }
      }
   }
}
