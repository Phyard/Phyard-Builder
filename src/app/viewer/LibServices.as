
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
   
//==================================================================
// multiple player instance 
//==================================================================
   
   //private var mIsMultiplePlayerInstanceInfoShown:Boolean = false;
   //
   //private function SetMultiplePlayerInstanceInfoShown (show:Boolean):void
   //{
   //   if (mIsMultiplePlayerInstanceInfoShown != show)
   //   {
   //      mIsMultiplePlayerInstanceInfoShown = show;
   //      
   //      UpdateMultiplePlayerInstanceInfoText ();
   //   }
   //}
   //
   //private function UpdateMultiplePlayerInstanceInfoText ():void
   //{
   //   if (mIsMultiplePlayerInstanceInfoShown)
   //   {
   //      if (mWorldDesignProperties != null)
   //      { 
   //         //var mpInstance:Object = mWorldDesignProperties.GetCurrentMultiplePlayerInstance ();
   //      }
   //   }
   //}
   
   private function OnMultiplePlayerServerResponse (params:Object):void
   {
      if (mWorldDesignProperties != null)
      {
         if (mParamsFromEditor == null)
         {
            // parse params.mResponseString into params
         }
         
         var responseData:ByteArray = DataFormat3.DecodeString2ByteArray (params.mResponseString);
         
         // todo: responseData is a combination of many basic responses.
         
         mWorldDesignProperties.OnMultiplePlayerServerResponse ({mResponseData: responseData});
         
         //UpdateMultiplePlayerInstanceInfoText ();
      }
   }
   
   private function SendMultiplePlayerServerRequest (params:Object):void
   {
      // todo: cache to prevent sending too frequently.
      
      var requestString:String = DataFormat3.EncodeByteArray2String (params.mRequestData);
      
      EmbedCallContainer ("OnMultiplePlayerServerRequest", {mRequestString: requestString});
   }
   
   