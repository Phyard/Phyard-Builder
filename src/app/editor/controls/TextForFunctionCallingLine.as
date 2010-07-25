
package editor.controls {
   
   import flash.events.Event;
   
   import mx.events.FlexEvent;
   
   import mx.controls.Label;
   
   public class TextForFunctionCallingLine extends Label 
   {
      public function TextForFunctionCallingLine ()
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
            var callingData:FunctionCallingLineData = data as FunctionCallingLineData;
            
            setStyle ("paddingLeft", 16 * callingData.mIndentLevel);
            
            if (Compile::Is_Debugging)
            {
               htmlText = callingData.mLineNumber + ": " + callingData.mHtmlText;
            }
            else
            {
               htmlText = callingData.mHtmlText;
            }
         }
      }
   }
}
