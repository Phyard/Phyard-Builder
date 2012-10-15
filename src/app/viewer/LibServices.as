
   private function SubmitHighScore  (value:Number):void
   {
      if (mParamsFromContainer.ExternalSubmitKeyValue != null)
      {
         mParamsFromContainer.ExternalSubmitKeyValue ("HighScore_NormalMode", value);
               // please see GamePackaer.OnlineAPI for detail.
      }
   }