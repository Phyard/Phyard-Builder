
      public static function ClearCookie (filename:String):void
      {
         try
         {
            var so:SharedObject = SharedObject.getLocal (filename);

            so.clear ();
         }
         catch ( e:Error ) 
         {
         }
      }
      
      public static function LoadCookie (filename:String):ByteArray
      {
         try
         {
            var so:SharedObject = SharedObject.getLocal (filename);
            
            //trace ("so.data.mSavedData = " + so.data.mSavedData);
            
            return so == null ? null : so.data.mSavedData as ByteArray;
         }
         catch ( e:Error ) 
         {
            trace ("LoadGameSaveData error: " + e);
         }
         
         return null;
      }
      
      private static function WriteCookie (filename:String, savedData:ByteArray):void
      {
         try 
         {
            var so:SharedObject = SharedObject.getLocal (filename);
            so.data.mSavedData = savedData;
            so.data.mInt = 5;
         
            var flushResult:String = so.flush (100 * 1000); // 100k

            //trace ("so.data.mSavedData = " + so.data.mSavedData + ", flushResult = " + flushResult);
            
            if (flushResult == SharedObjectFlushStatus.PENDING)
            {
               // an inquery dialog will show up
               
               // todo: add an OnGameSaveSucceed event handler in phyard builder
               
            //   so.addEventListener( NetStatusEvent.NET_STATUS, OnFlushStatus );
            } 
            else if (flushResult == SharedObjectFlushStatus.FLUSHED) 
            {
               // Saved successfully. Place any code here that you want to
               // execute after the data was successfully saved.
            }
         } 
         catch ( e:Error ) 
         {
            trace ("SaveGame error: " + e);
            
            // This means the user has the local storage settings to 'Never.'
            // If it is important to save your data, you may want to alert the
            // user here. Also, if you want to make it easy for the user to change
            // his settings, you can open the local storage tab of the Player
            // Settings dialog box with the following code:
            // Security.showSettings( SecurityPanel.LOCAL_STORAGE );.
         }
      }
      
      //private function OnFlushStatus( event:NetStatusEvent ):void 
      //{
      //   if ( event.info.code == "SharedObject.Flush.Success" ) 
      //   {
      //      // If the event.info.code property is "SharedObject.Flush.Success",
      //      // it means the user granted access. Place any code here that
      //      // you want to execute when the user grants access.
      //   } 
      //   else if ( event.info.code == "SharedObject.Flush.Failed" ) 
      //   {
      //      // If the event.info.code property is "SharedObject.Flush.Failed", it
      //      // means the user denied access. Place any code here that you
      //      // want to execute when the user denies access.
      //   }
      //   
      //   // Remove the event listener now since we only needed to listen once
      //   SharedObject.getLocal (k_GameDataName).removeEventListener( NetStatusEvent.NET_STATUS, OnFlushStatus );
      //}