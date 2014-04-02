
//==========================================
// update multiple player instance
//==========================================

   public function UpdateMultiplePlayerInstance ():void
   {
      //if (mConnectionId
      
      HandleMultiplePlayerInstanceEvents ();
   }

//==========================================
// Data ...
//==========================================
   
   // to cache GlobalSocketMessage and GameInstanceChanged events in Viewer
   
   //private function GetFullGameId (localGameId:String):String
   //{
   //   var fullGameId:String = GetWorldKey ();
   //   if (localGameId != null)
   //   {
   //      localGameId = TextUtil.TrimString (localGameId);
   //      if (localGameId.length > 0)
   //      {
   //         fullGameId = fullGameId + "/" + localGameId;
   //      }
   //   }
   //   
   //   return fullGameId;
   //}

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

//==========================================
// callback for viewer
//==========================================
   
   public function OnMultiplePlayerEvent (params:Object):Boolean
   {
      switch (params.mEventType)
      {
         case "OnGameInstanceSeatsInfoChanged":
            break;
         default:
         {
            return false;
         }
      }
      
      mIsMultiplePlayerInstanceChanged = true;
      
      return true;
   }
   
   
   