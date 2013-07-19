
package editor.display.control {
   
   import flash.events.Event;
   
   import flash.system.Capabilities;
   
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
            
            //setStyle ("paddingLeft", 16 * callingData.mIndentLevel);
            //
            //if (Capabilities.isDebugger)
            //{
            //   htmlText = callingData.mLineNumber + ": " + callingData.mHtmlText;
            //}
            //else
            //{
            //   htmlText = callingData.mHtmlText;
            //}
            
            if (sIntentStrings == null)
               CreateIntentStrings ();
            
            htmlText = callingData.mLineNumber + sIntentStrings [callingData.mIndentLevel] + callingData.mHtmlText;

            if (callingData.mLineNumber < 10)
               htmlText = "   " + htmlText;
            else if (callingData.mLineNumber < 100)
               htmlText = "  " + htmlText;
            else if (callingData.mLineNumber < 1000)
               htmlText = " " + htmlText;
         }
      }
      
      private static var sIntentStrings:Array = null;
      
      private static function CreateIntentStrings ():void
      {
         if (sIntentStrings == null)
         {
            sIntentStrings = new Array (100);
            sIntentStrings [0] = ": ";
            for (var i:int = 1; i < 100; ++ i)
            {
               sIntentStrings [i] = sIntentStrings [i - 1] + "   ";
            }
         }
      }
   }
}
