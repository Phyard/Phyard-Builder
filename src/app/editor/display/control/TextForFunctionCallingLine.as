
package editor.display.control {
   
   import flash.events.Event;
   
   import flash.system.Capabilities;
   
   import mx.events.FlexEvent;
   import mx.containers.HBox;
   import mx.core.ScrollPolicy;
   import mx.controls.Label;
   
   public class TextForFunctionCallingLine extends HBox 
   {
      private var mLineNumberLabel:Label;
      private var mCallingLabel:Label;
      
      public function TextForFunctionCallingLine ()
      {
         setStyle ("width", "100%");
         setStyle ("horizontalGap", 0);
         setStyle ("borderStyle", "none");
         setStyle ("borderThickness", 0);
         //setStyle ("horizontalScrollPolicy", "off");
         //setStyle ("verticalScrollPolicy", "off");
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         
         mLineNumberLabel = new Label ();
         mLineNumberLabel.width = 39;
         mLineNumberLabel.setStyle ("textAlign", "right");
         mLineNumberLabel.setStyle ("paddingRight", 6);
         mLineNumberLabel.setStyle ("paddingLeft", 0);
         mLineNumberLabel.setStyle ("marginRight", 0);
         mLineNumberLabel.setStyle ("marginLeft", 0);
         
         mCallingLabel = new Label ();
         mCallingLabel.setStyle ("width", "100%");
         //mCallingLabel.setStyle ("textAlign", "left");
         mCallingLabel.setStyle ("paddingRight", 0);
         mCallingLabel.setStyle ("paddingLeft", 0);
         mCallingLabel.setStyle ("marginRight", 0);
         mCallingLabel.setStyle ("marginLeft", 0);
         mCallingLabel.setStyle ("disabledColor", 0x888888);
         
         addChild (mLineNumberLabel);
         addChild (mCallingLabel);
         
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
            
            ////setStyle ("paddingLeft", 16 * callingData.mIndentLevel);
            ////
            ////if (Capabilities.isDebugger)
            ////{
            ////   htmlText = callingData.mLineNumber + ": " + callingData.mHtmlText;
            ////}
            ////else
            ////{
            ////   htmlText = callingData.mHtmlText;
            ////}
            //
            
            //labelText = callingData.mLineNumber + GetIntentString (callingData.mIndentLevel);
            var labelText:String = GetIntentString (callingData.mIndentLevel) + GetCommentString (callingData.mCommentDepth);
            
            labelText = labelText + callingData.mHtmlText;
            
            //if (callingData.mLineNumber < 10)
            //   labelText = "   " + labelText;
            //else if (callingData.mLineNumber < 100)
            //   labelText = "  " + labelText;
            //else if (callingData.mLineNumber < 1000)
            //   labelText = " " + labelText;
            
            
            //if (mInfo.mIsValid)
            //{
            //   mCallingLabel.mHtmlText = labelText;
            //}
            //else
            //{
            //   mCallingLabel.mHtmlText = "<font color='#A0A0A0'>" + labelText + "</font>";
            //}
            
            toolTip = labelText;
            
            mCallingLabel.text = labelText;
            mCallingLabel.enabled = callingData.mIsValid;// && callingData.mCommentDepth <= 0;
            
            mLineNumberLabel.text = callingData.mLineNumber + ":";
         }
      }
      
      private static var sCommentStrings:Array = null;
      
      private static function GetCommentString (commentDepth:int):String
      {
         if (sCommentStrings == null)
         {
            sCommentStrings = new Array (256);
            sCommentStrings [0] = "";
            for (var i:int = 1; i < 256; ++ i)
            {
               sCommentStrings [i] = sCommentStrings [i - 1] + "// ";
            }
         }
         
         return sCommentStrings [commentDepth];
      }
      
      private static var sIntentStrings:Array = null;
      
      private static function GetIntentString (intentLevel:int):String
      {
         if (sIntentStrings == null)
         {
            sIntentStrings = new Array (100);
            sIntentStrings [0] = "";
            for (var i:int = 1; i < 100; ++ i)
            {
               sIntentStrings [i] = sIntentStrings [i - 1] + "   ";
            }
         }
         
         return sIntentStrings [intentLevel];
      }
   }
}
