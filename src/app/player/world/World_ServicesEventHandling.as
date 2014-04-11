
   private var mIsGameInstanceInfoChangedInLastStep:Boolean = false;
   
   private function SetGameInstanceInfoChangedInLastStep (changed:Boolean):void
   {
      mIsGameInstanceInfoChangedInLastStep = changed;
   }

//==========================================
// callback for viewer
//==========================================
   
   public function OnMultiplePlayerEvent (eventType:String, params:Object):Boolean
   {
      switch (eventType)
      {
         case "OnGameInstanceInfoChanged":
         {
            if (! mIsGameInstanceInfoChangedInLastStep) // register most one time at each step
               RegisterCachedSystemEvent ([CachedEventType_General, mEventHandlersByTypes [CoreEventIds.ID_OnMultiplePlayerInstanceInfoChanged], null]);
            
            SetGameInstanceInfoChangedInLastStep (true);
            
            break;
         }
         case "OnChannelSeatMessage":
         {
            var valueSource2:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kByteArrayClassDefinition, params.mMessageData, null);
            var valueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kNumberClassDefinition, params.mSeatIndex, valueSource2);
            var valueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kNumberClassDefinition, params.mChannelIndex, valueSource1);

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
   
   
   