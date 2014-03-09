
//==========================================
// Data ...
//==========================================
   
   // to cache GlobalSocketMessage and GameInstanceChanged events in Viewer
   
   private function GetFullGameId (localGameId:String):String
   {
      var fullGameId:String = GetWorldKey ();
      if (localGameId != null)
      {
         localGameId = TextUtil.TrimString (localGameId);
         if (localGameId.length > 0)
         {
            fullGameId = fullGameId + "/" + localGameId;
         }
      }
      
      return fullGameId;
   }
   
   private function CreateMultiplePlayerInstanceObject ():Object
   {
      var mpInstance:Object = {
               mRequestId : UUID.BuildRandomKey (), 
                           // maybe not the best way to get a key. 
                           // The key is used to identify which instance is associated with a server message. 
               mInstanceId : null,
                           // set by server.
               mInstanceStatus : "invalid",
                           // invalid | pending | playing
                           
               mNumPositions : 0,
               mPlayerNames : null, // [mNumPositions]
               mPositionsEnabled : null, // [mNumPositions]
               mNumActionsNow : 0,
               mHistoryActions : null,
               mHistorySnapshots : null,
               
               mPlayerRole : "none",
                           // none | player | spectator
               mPlayerClientId : null,
                           // client id for current player.
                           // this one is set by server. If it is null, then the instance object is invalid.
               mPlayerPosition : -1,
                           // position of current player
               "" : null
            };
       
       return mpInstance;
   }
   
   private var mMultiplePlayerInstance:Object = null;

//==========================================
// Events ...
//==========================================
   
   private var mIsMultiplePlayerInstanceChanged:Boolean = false;
   
   private function HandleMultiplePlayerInstanceEvents ():void
   {
      if (mIsMultiplePlayerInstanceChanged)
      {
         mIsMultiplePlayerInstanceChanged = false;
         
         // ...
         
         //var valueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kNumberClassDefinition, 0, valueSource2);
         //var valueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.GetCoreClassDefinition (CoreClassIds.ValueType_MultiplePlayerInstance), mMultiplePlayerInstance); //, valueSource1);
         //var valueSourceList:Parameter = valueSource0;
         
         HandleEventById (CoreEventIds.ID_OnMultiplePlayerInstanceSeatsInfoChanged, null);
      }
   }
   
   public function OnMultiplePlayerServerResponse (params:Object):Boolean
   {
      var responseData:ByteArray = params.mResponseData;      
      responseData.position = 0;
      
      var formatVersion:int = responseData.readShort (); // should be == Define.MaxMutiplePlayerDataFormatVersion
      var eventType:int = responseData.readShort ();
      
      switch (eventType)
      {
         case Define.MutiplePlayerResponseType_Error:
            break;
         case Define.MutiplePlayerResponseType_InstanceInfo:
            break;
         case Define.MutiplePlayerResponseType_PlayAction:
            break;
         default:
         {
            return false;
         }
      }
      
      mIsMultiplePlayerInstanceChanged = true;
      
      return true;
   }

//==========================================
// APIs ...
//==========================================
   
   // Viewer_mLibServices.SetMultiplePlayerInstanceInfoShown
   
   // join instance
   
   public function CreateNewGameInstance (localGameId:String, password:String, numPlayers:int):Object
   {
      mMultiplePlayerInstance = null;
      
      if (Viewer_mLibServices == null)
         return null;
      
      if (numPlayers < 2 || numPlayers > 4)
         return null;
      
      var gameId:String = GetFullGameId (localGameId);
      
      if (password != null)
         password = TextUtil.TrimString (password);
      else
         password = "";
      
      mMultiplePlayerInstance = CreateMultiplePlayerInstanceObject ();
      
      ////Viewer_mLibServices.CreateNewGameInstance (mMultiplePlayerInstance.mRequestId, gameId, password, numPlayers);
      //
      //Viewer_mLibServices.SendMultiplePlayerServerRequest ({
      //                           "type"        : "CreateNewInstance", 
      //                           "game_id"     : gameId,
      //                           "password"    : password, // may contains '&', '+', etc.
      //                           "num_players" : numPlayers.toString (),
      //                           "request_id"  : mMultiplePlayerInstance.mRequestId
      //                        });
      
      var requestData:ByteArray = new ByteArray ();
      
      requestData.writeShort (Define.MaxMutiplePlayerDataFormatVersion);
      requestData.writeShort (Define.MutiplePlayerRequestType_CreateInstance); // type
      requestData.writeUTF (mMultiplePlayerInstance.mRequestId);
      
      requestData.writeUTF (gameId);
      requestData.writeUTF (password);
      requestData.writeShort (numPlayers);
      
      Viewer_mLibServices.SendMultiplePlayerServerRequest ({mRequestData: requestData});
      
      return mMultiplePlayerInstance;
   }
   
   public function JoinRandomGameInstance (localGameId:String, createNewIfNoAvailables:Boolean, numPlayers:int):Object
   {
      mMultiplePlayerInstance = null;
      
      if (Viewer_mLibServices == null)
         return null;
      
      if (createNewIfNoAvailables)
      {
         if (numPlayers < 2 || numPlayers > 4)
            return null;
      }
      
      var gameId:String = GetFullGameId (localGameId);
      
      mMultiplePlayerInstance = CreateMultiplePlayerInstanceObject ();
      
      //Viewer_mLibServices.SendMultiplePlayerServerRequest ({
      //                           "type"               : "JoinRandomInstance", 
      //                           "game_id"            : gameId,
      //                           "create_new_on_fail" : createNewIfNoAvailables ? "1" : "0",
      //                           "num_players"        : numPlayers.toString (),
      //                           "request_id"         : mMultiplePlayerInstance.mRequestId
      //                        });
      
      var requestData:ByteArray = new ByteArray ();
      
      requestData.writeShort (Define.MaxMutiplePlayerDataFormatVersion);
      requestData.writeShort (Define.MutiplePlayerRequestType_JoinRandomInstance); // type
      requestData.writeUTF (mMultiplePlayerInstance.mRequestId);
      
      requestData.writeUTF (gameId);
      requestData.writeByte (createNewIfNoAvailables ? 1 : 0);
      requestData.writeShort (numPlayers);
      
      Viewer_mLibServices.SendMultiplePlayerServerRequest ({mRequestData: requestData});
      
      return mMultiplePlayerInstance;
   }
   
   //public function JoinGameInstanceByInstanceID (instanceId:String):Object
   //{
   //}
   
   // send player action data
   
   public function SendPlayerActionData (data:ByteArray):Boolean
   {
      if (Viewer_mLibServices == null)
         return false;
      
      if (     mMultiplePlayerInstance == null 
            || mMultiplePlayerInstance.mPlayerClientId == null
            || mMultiplePlayerInstance.mPlayerPosition < 0
            || mMultiplePlayerInstance.mPositionsEnabled == null
            || mMultiplePlayerInstance.mPositionsEnabled [mMultiplePlayerInstance.mPlayerPosition] == false
            )
      {
         return false;
      }
      
      if (data.length >= Define.MaxMutiplePlayerRequestDataLength)
         return false;
      
      //var dataAsString:String = DataFormat3.EncodeByteArray2String (data);
      //
      //Viewer_mLibServices.SendMultiplePlayerServerRequest ({
      //                           "type"       : "PlayerAction", 
      //                           "data"       : dataAsString,
      //                           "position"   : mMultiplePlayerInstance.mPlayerPosition.toString (),
      //                           "client_id"  : mMultiplePlayerInstance.mPlayerClientId,
      //                           "request_id" : mMultiplePlayerInstance.mRequestId
      //                        });
      
      var requestData:ByteArray = new ByteArray ();
      
      requestData.writeShort(Define.MaxMutiplePlayerDataFormatVersion);
      requestData.writeShort (Define.MutiplePlayerRequestType_PlayAction); // type
      requestData.writeUTF (mMultiplePlayerInstance.mRequestId);
      
      requestData.writeShort (data.length);
      requestData.writeBytes (data, 0, data.length);
      
      Viewer_mLibServices.SendMultiplePlayerServerRequest ({mRequestData: requestData});
      
      return true;
   }
