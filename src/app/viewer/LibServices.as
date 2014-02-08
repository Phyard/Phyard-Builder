
//   private function SubmitHighScore (value:Number):void
//   {
////trace ("SubmitHighScore> " + value);
//      if (mParamsFromContainer.ExternalSubmitKeyValue != null)
//      {
//         mParamsFromContainer.ExternalSubmitKeyValue ("HighScore", value);
//               // please see GamePackaer.OnlineAPI for detail.
//      }
//   }
   
   // the api name for designer should be changed to "SubmitKeyValueToHostWebsite"
   private function SubmitKeyValue (key:String, value:Number):void
   {
//trace ("SubmitKeyValue> " + key + " = " + value);
      if (mParamsFromContainer.ExternalSubmitKeyValue != null)
      {
         mParamsFromContainer.ExternalSubmitKeyValue (key, value);
               // please see GamePackager.OnlineAPI for detail.
      }
   }
   
   private function SendGlobalSocketMessage (message:String):void
   {
      EmbedCallContainer ("SendGlobalSocketMessage", {message: message});
   }
   
   
   