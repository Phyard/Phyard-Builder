
//==========================================
// 
//==========================================

   private function HandleUpdateMultiplePlayerEvents ():void
   {
      if (mIsGameInstanceInfoChangedInLastStep)
      {
         var valueSource4:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kBooleanClassDefinition, mIsGameInstanceSeatsInfoChanged, null);
         var valueSource3:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kBooleanClassDefinition, mIsGameInstancePhaseChanged, valueSource4);
         var valueSource2:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kBooleanClassDefinition, mIsPlayerStatusChanged, valueSource3);
         var valueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kBooleanClassDefinition, mIsGameInstanceServerConnectionStatusChanged, valueSource2);
         var valueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kMultiplePlayerInstanceClassDefinition, null, valueSource1);
         
         // ...
         
         mIsGameInstanceInfoChangedInLastStep = false;
         
         mIsGameInstanceServerConnectionStatusChanged = false;
         mIsPlayerStatusChanged = false;
         mIsGameInstancePhaseChanged = false;
         mIsGameInstanceSeatsInfoChanged = false;
         
         // ...
         
         HandleEventById (CoreEventIds.ID_OnMultiplePlayerInstanceInfoChanged, valueSource0);
         
      }
   }

//==========================================
// 
//==========================================

   private var mIsGameInstanceInfoChangedInLastStep:Boolean = false;
      
      private var mIsGameInstanceServerConnectionStatusChanged:Boolean = false;
      private var mIsPlayerStatusChanged:Boolean = false;
      private var mIsGameInstancePhaseChanged:Boolean = false;
      private var mIsGameInstanceSeatsInfoChanged:Boolean = false;

//==========================================
// callback for viewer 
//==========================================
   
   public function OnMultiplePlayerEvent (eventType:String, params:Object):Boolean
   {
      switch (eventType)
      {
         case "OnGameInstanceInfoChanged":
         {
            mIsGameInstanceInfoChangedInLastStep = true;
            
            var reason:String = params == null ? null : params.mReason;
            if (reason == "Connected" || reason == "Disconnected") // in fact, these will never happen. 
               mIsGameInstanceServerConnectionStatusChanged = true;
            else if (reason == "PlayerStatusChanged")
               mIsPlayerStatusChanged = true;
            else if (reason == "InstancePhaseChanged")
               mIsGameInstancePhaseChanged = true;
            else if (reason == "MySeatIndexChanged" || reason == "SeatBasicInfoChanged" || reason == "SeatDanymicInfoChanged" || reason == "ChannelSeatInfoChanged")
               mIsGameInstanceSeatsInfoChanged = true;
            
            break;
         }
         case "OnChannelSeatMessage":
         {
            var valueSource3:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kByteArrayClassDefinition, params.mMessageData, null);
            var valueSource2:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kNumberClassDefinition, params.mSeatIndex, valueSource3);
            var valueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kNumberClassDefinition, params.mChannelIndex, valueSource2);
            var valueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kMultiplePlayerInstanceClassDefinition, null, valueSource1);
            
            RegisterCachedSystemEvent ([CachedEventType_General, mEventHandlersByTypes [CoreEventIds.ID_OnMultiplePlayerInstanceChannelMessage], valueSource0]);
            
            break;
         }
         default:
         {
            return false;
         }
      }
      
      return true;
   }
   
   
   