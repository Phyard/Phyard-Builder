

private var mFreeContactInfoListHead:ShapeContactInfo = null;

private var mNumContactInfos:int = 0;
private var mShapeContactInfoHashtable:Dictionary = null;
private var mFirstShapeContactInfo:ShapeContactInfo = null;

private var mShapeContactInfos_StepQueue:Array = new Array ();

private function PushShapeContactEvent (contactInfo:ShapeContactInfo):void
{
   contactInfo.mLastIndexInStepQueue = mShapeContactInfos_StepQueue.length;
   mShapeContactInfos_StepQueue.push (contactInfo);
}

private function OnShapeContactStarted (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
{
   //InfectShapes (proxyShape1.GetUserData () as EntityShape, proxyShape2.GetUserData () as EntityShape);
   //
   //return;
   
   var shape1:EntityShape = proxyShape1.GetEntityShape ();
   var shape2:EntityShape = proxyShape2.GetEntityShape ();
   
//trace ("+++++++++++++++++++++++++ OnShapeContactStarted, id1 = " + shape1.GetCreationId () + ", id2 = " + shape2.GetCreationId ());
//trace ("+++++++++++++++++++++++++ OnShapeContactStarted, proxy id1 = " + shape1.GetContactProxyId () + ", proxy id2 = " + shape2.GetContactProxyId ());
   
   if (shape1 == null || shape2 == null)
      return;
   
   //var id1:int = shape1.GetCreationId ();
   var id1:int = shape1.GetContactProxyId (); // from v1.56
   if (id1 < 0 || id1 > 0xFFFF)
      return;
   
   //var id2:int = shape2.GetCreationId ();
   var id2:int = shape2.GetContactProxyId (); // from v1.56
   if (id2 < 0 || id2 > 0xFFFF)
      return;
   
   var contact_id:int = id1 > id2 ? (id2 << 16) | (id1) : (id1 << 16) | (id2);
   
   // here mShapeContactInfoHashtable is a Dictionary. contact_id will be converted to a string,
   // maybe writing a hashtable with interger as keys is better.
   
   var contact_info:ShapeContactInfo = mShapeContactInfoHashtable [contact_id];
   
   if (contact_info != null)
   {
//trace ("+ old, contact_id = " + contact_id);

      // if contact_info.mNumContactPoints is zero, it means there is "out-and-in" happens.
      // now the "out-and-in" <=> nothing happend
      
      // if contact_info.mNumContactPoints >= 1, it means more than one contacts are created for the shape pair
      
      ++ contact_info.mNumContactPoints;
      contact_info.mNewestBeginContactingFrame = mNumSimulatedSteps;
      
      // from v1.56
      // need not to push, just hint last end contact event will be ignored
      PushShapeContactEvent (contact_info);
   }
   else
   {
//trace ("+ new, contact_id = " + contact_id);
   
      if (mFreeContactInfoListHead != null)
      {
         contact_info = mFreeContactInfoListHead;
         mFreeContactInfoListHead = mFreeContactInfoListHead.mNextFreeContactInfo;
         
         contact_info.mNextFreeContactInfo = null;
      }
      else
      {
         contact_info = new ShapeContactInfo ();
      }
      
      contact_info.mContactId = contact_id;
      contact_info.mEntityId1 = id1;
      contact_info.mEntityId2 = id2;
      contact_info.mEntityShape1 = shape1;
      contact_info.mEntityShape2 = shape2;
      contact_info.mNumContactPoints = 1;
      contact_info.mIsNewContact = true;
      contact_info.mInKeepContactingList = false;
      contact_info.mBeginContactingFrame = mNumSimulatedSteps;
      
      // todo: use cache to get a faster FindEventHandlerForEntityPair
      
      contact_info.mFirstBeginContactingHandler = FindEventHandlerForEntityPair (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, shape1, shape2, true);
      contact_info.mFirstEndContactingHandler   = FindEventHandlerForEntityPair (CoreEventIds.ID_OnTwoPhysicsShapesEndContacting, shape1, shape2, true);
      
      //contact_info.mFirstKeepContactingHandler  = FindEventHandlerForEntityPair (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting, shape1, shape2, true); // make this search when nneeded now
      contact_info.mKeepContactingHandlerSearched = false;
      
      //if (shape1.IsSensor () && shape2.IsShapeCenterPoint ())
      //   FindEventHandlerForEntityPair (CoreEventIds.ID_OnSensorContainsPhysicsShape, );
      //if (shape2.IsSensor () && shape1.IsShapeCenterPoint ())
      //   FindEventHandlerForEntityPair (CoreEventIds.ID_OnSensorContainsPhysicsShape, );
      
      mShapeContactInfoHashtable [contact_id] = contact_info;
      
      //{ before v1.56
      //contact_info.mPrevContactInfo = null;
      //contact_info.mNextContactInfo = mFirstShapeContactInfo;
      //
      //if (mFirstShapeContactInfo != null)
      //   mFirstShapeContactInfo.mPrevContactInfo = contact_info;
      //mFirstShapeContactInfo = contact_info;
      //
      //++ mNumContactInfos;
      ////trace (" +++ mNumContactInfos = " + mNumContactInfos);
      //}
      //{from v1.56
      contact_info.mPrevContactInfo = null;
      contact_info.mNextContactInfo = null;

      PushShapeContactEvent (contact_info);
      //}}
   }
   
   //trace ("contact_info#" + contact_id + "'s.mNumContactPoints = " + contact_info.mNumContactPoints);
}

private function OnShapeContactFinished (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
{
   //return;
   
   var shape1:EntityShape = proxyShape1.GetEntityShape ();
   var shape2:EntityShape = proxyShape2.GetEntityShape ();
   
//trace ("------------------------ OnShapeContactFinished, id1 = " + shape1.GetCreationId () + ", id2 = " + shape2.GetCreationId ());
//trace ("------------------------ OnShapeContactFinished, proxy id1 = " + shape1.GetContactProxyId () + ", proxy id2 = " + shape2.GetContactProxyId ());
   
   if (shape1 == null || shape2 == null)
      return;
   
   //var id1:int = shape1.GetCreationId ();
   var id1:int = shape1.GetContactProxyId (); // from v1.56
   if (id1 < 0 || id1 > 0xFFFF)
      return;
   
   //var id2:int = shape2.GetCreationId ();
   var id2:int = shape2.GetContactProxyId (); // from v1.56
   if (id2 < 0 || id2 > 0xFFFF)
      return;
   
   var contact_id:int = id1 > id2 ? (id2 << 16) | (id1) : (id1 << 16) | (id2);
   
   // here mShapeContactInfoHashtable is a Dictionary. contact_id will be converted to a string,
   // maybe writing a hashtable with interger as keys is better.
   
   var contact_info:ShapeContactInfo = mShapeContactInfoHashtable [contact_id];
   
   if (contact_info == null)
   {
      trace ("Error: contact_info == null");
      return;
   }
   
   -- contact_info.mNumContactPoints;
   
   //trace ("contact_info#" + contact_id + "'s.mNumContactPoints = " + contact_info.mNumContactPoints);
   
   //if (contact_info.mNumContactPoints <= 0)
   //{
      // lazy destroy, this line is moved to HandleShapeContactEvents
      // RemoveContactFromContactList (contact_info);
   //}
   
   // from v1.56
   //if (contact_info.mNumContactPoints <= 0)
   //{
      PushShapeContactEvent (contact_info);
   //}
}

private var mContactEventHandlerValueSource2:Parameter_Direct = new Parameter_Direct (null);
private var mContactEventHandlerValueSource1:Parameter_Direct = new Parameter_Direct (null, mContactEventHandlerValueSource2);
private var mContactEventHandlerValueSource0:Parameter_Direct = new Parameter_Direct (null, mContactEventHandlerValueSource1);
private var mContactEventHandlerValueSourceList:Parameter = mContactEventHandlerValueSource0;

private var mContactEventHandlerValueSource1_InvertEntityOrder:Parameter_Direct = new Parameter_Direct (null, mContactEventHandlerValueSource2);
private var mContactEventHandlerValueSource0_InvertEntityOrder:Parameter_Direct = new Parameter_Direct (null, mContactEventHandlerValueSource1_InvertEntityOrder);
private var mContactEventHandlerValueSourceList_InvertEntityOrder:Parameter = mContactEventHandlerValueSource0_InvertEntityOrder;

// new handling from v1.56
private function HandleShapeContactEvents ():void
{
   // All events created in box2d.world.step will be cached and delay-executed after box2d.world.step ().
   // This is to prevent problems caused by some API callings, such as DestroyEntity, CreateEntity and TeleportEntity, etc. 
   // After box2d.world.step (), the events created in box2d.world.step will be handled 
   // by the occurring sequence (what this function HandleShapeContactEvents does). 
   // 
   // The handling described above may cause some weird or unreasonable things. For example:
   // - a DestroyEntity calling will make an entity destroyed. But there are still some contact events related with it to handle in the event queue.
   // - a Move/Rotate/Scale?/Flip Shape calling will make 2 shapes beging or end contacting, but this is not reflected immediately to sequenced events in queue.
   // These defects are hard to avoid gracefully.  
   //
   // Another point to notice is this function will only handle the events when the function HandleShapeContactEvents is just called.
   // New contact events created by some API callings such as DestroyEntity will be handled in the next step.

   var contact_info:ShapeContactInfo;
   
   // handle contact begin and end events
   
   var newShapeContactInfos:Array = new Array ();
   
   var shape1:EntityShape;
   var shape2:EntityShape;
   
   var i:int;
   var count:int = mShapeContactInfos_StepQueue.length;
   
//if (count > 0 ) trace (">>>>>>>>>>>>>>>>>>>>>>> HandleShapeContactEvents, step events count = " + count + ", mNumContactInfos = " + mNumContactInfos);

   for (i = 0; i < count; ++ i)
   {
      contact_info = mShapeContactInfos_StepQueue [i] as ShapeContactInfo;
      
      shape1 = contact_info.mEntityShape1;
      shape2 = contact_info.mEntityShape2;

//trace ("11111111111  i = " + i);
      // the first start contacting event for a pair
      if (contact_info.mIsNewContact)
      {
//trace ("       aa   mIsNewContact = " + contact_info.mIsNewContact + ", contact_info.mContactId = " + contact_info.mContactId);

         // add contact elements
         contact_info.mContactElement1.mEntityShape = shape2; shape1.AddContactedShape (contact_info.mContactElement1);
         contact_info.mContactElement2.mEntityShape = shape1; shape2.AddContactedShape (contact_info.mContactElement2);
         
         // handle event
         HandleShapeContactEvent (contact_info, contact_info.mFirstBeginContactingHandler, true);
         ++ mNumContactInfos;
         //trace (" ++ mNumContactInfos = " + mNumContactInfos);
          
         // add to new contact list 
         
         contact_info.mIsNewContact = false;
         contact_info.mBeginContactingFrame = mNumSimulatedSteps;
               // sometimes, contact_info.mBeginContactingFrame + 1 = mNumSimulatdSteps, so adjust it 
               // ? forget what this means. :(, (maybe it is only needed in the old handling function)
               // Edit: the reason is a contact may be destroy by a API calling.
         
         if (contact_info.mNumContactPoints > 0)
         {
            newShapeContactInfos.push (contact_info);
         }
      }

//trace ("222222222222222222 mNumContactPoints = " + contact_info.mNumContactPoints);
      // the last end contacting event for a pair 
      if (contact_info.mNumContactPoints <= 0)
      {
//trace ("     bb     contact_info.mLastIndexInStepQueue = " + contact_info.mLastIndexInStepQueue);
         if (contact_info.mLastIndexInStepQueue == i) // only handle it if it is the last one of this contact info in the queue
         {
//trace ("          mLastIndexInStepQueue = " + contact_info.mLastIndexInStepQueue + ", contact_info.mContactId = " + contact_info.mContactId);

            // remove contact element
            shape1.RemoveContactedShape (contact_info.mContactElement1); contact_info.mContactElement1.mEntityShape = null;
            shape2.RemoveContactedShape (contact_info.mContactElement2); contact_info.mContactElement2.mEntityShape = null;

            // handle event
            HandleShapeContactEvent (contact_info, contact_info.mFirstEndContactingHandler, false);
            -- mNumContactInfos;
            //trace (" -- mNumContactInfos = " + mNumContactInfos);
            
            // remove
            
            delete mShapeContactInfoHashtable [contact_info.mContactId];
               
            if (contact_info.mInKeepContactingList)
            {
//trace ("    bb   cc   mInKeepContactingList = " + contact_info.mInKeepContactingList);
               if (contact_info.mPrevContactInfo != null)
                  contact_info.mPrevContactInfo.mNextContactInfo = contact_info.mNextContactInfo;
               else //if (mFirstShapeContactInfo == contact_info)
                  mFirstShapeContactInfo = mFirstShapeContactInfo.mNextContactInfo;
               
               if (contact_info.mNextContactInfo != null)
                  contact_info.mNextContactInfo.mPrevContactInfo = contact_info.mPrevContactInfo;
               
               // mvoe to free list
               
               contact_info.mNextFreeContactInfo = mFreeContactInfoListHead;
               mFreeContactInfoListHead = contact_info;
               
               contact_info.mPrevContactInfo = null;
               contact_info.mNextContactInfo = null;               
            }
         }
      }
   }
   
   //mShapeContactInfos_StepQueue = new Array (); // wrong!!! This will discard new ones created by API callings in the above loop.
   mShapeContactInfos_StepQueue = mShapeContactInfos_StepQueue.slice (count); // subArray. New created contact events will be handled in the next step.
   
   // very important! For contact events can't be added in the above loop block (the following should not use for (i = 0; i < count; )
   for each (contact_info in mShapeContactInfos_StepQueue)
   {
      if (contact_info.mLastAdjustQueneIdStep < mNumSimulatedSteps)
      {
         contact_info.mLastAdjustQueneIdStep = mNumSimulatedSteps;
         contact_info.mLastIndexInStepQueue -= count;
      }
   }
   
   // handle keep contacting events
   
   var last_contact_info:ShapeContactInfo;
   contact_info = mFirstShapeContactInfo;
   while (contact_info != null)
   {
      if (! contact_info.mKeepContactingHandlerSearched)
      {
         contact_info.mFirstKeepContactingHandler  = FindEventHandlerForEntityPair (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting, contact_info.mEntityShape1, contact_info.mEntityShape2, true); // make this search when nneeded now
         contact_info.mKeepContactingHandlerSearched = true;   
      }
      
      HandleShapeContactEvent (contact_info, contact_info.mFirstKeepContactingHandler, true);
      
      last_contact_info = contact_info;
      contact_info = contact_info.mNextContactInfo;
   }
   
   // append new contacts to the end of contact list
   
   count = newShapeContactInfos.length;
   for (i = 0; i < count; ++ i)
   {
      contact_info = newShapeContactInfos [i] as ShapeContactInfo;
      
      if (last_contact_info == null) // mFirstShapeContactInfo must be null
      {
         mFirstShapeContactInfo = contact_info;   
      }
      else
      {
         //if (mFirstShapeContactInfo != null)
         //   mFirstShapeContactInfo.mPrevContactInfo = contact_info;
         //mFirstShapeContactInfo = contact_info;
         
         last_contact_info.mNextContactInfo = contact_info;
         contact_info.mPrevContactInfo = last_contact_info;
      }
      
      contact_info.mInKeepContactingList = true;

      last_contact_info = contact_info;
   }
   
   // ...
   
   ConfirmFreedContactProxyIds ();
}

private function HandleShapeContactEvent (contactInfo:ShapeContactInfo, contactingHandlerListElement:ListElement_EventHandler, doInfection:Boolean):void
{
   if (doInfection)
   {
      InfectShapes (contactInfo.mEntityShape1, contactInfo.mEntityShape2);
   }
   
   mContactEventHandlerValueSource0.mValueObject = contactInfo.mEntityShape1;
   mContactEventHandlerValueSource1.mValueObject = contactInfo.mEntityShape2;
   mContactEventHandlerValueSource2.mValueObject = mNumSimulatedSteps - contactInfo.mBeginContactingFrame;
   
   mContactEventHandlerValueSource0_InvertEntityOrder.mValueObject = contactInfo.mEntityShape2;
   mContactEventHandlerValueSource1_InvertEntityOrder.mValueObject = contactInfo.mEntityShape1;
   
   IncStepStage ();
   while (contactingHandlerListElement != null)
   {
      contactingHandlerListElement.mEventHandler.HandleEvent (contactingHandlerListElement.mNeedExchangePairOrder ? mContactEventHandlerValueSourceList_InvertEntityOrder :mContactEventHandlerValueSourceList);
      
      contactingHandlerListElement = contactingHandlerListElement.mNextListElement;
   }
}

// old handling before v1.56
/*
private function HandleShapeContactEvents ():void
{
   var list_element:ListElement_EventHandler;
   var isContactContinued:Boolean;
   var contact_info:ShapeContactInfo = mFirstShapeContactInfo;
   
   while (contact_info != null)
   {
      mContactEventHandlerValueSource0.mValueObject = contact_info.mEntityShape1;
      mContactEventHandlerValueSource1.mValueObject = contact_info.mEntityShape2;
      mContactEventHandlerValueSource2.mValueObject = mNumSimulatedSteps - contact_info.mBeginContactingFrame;
      
      mContactEventHandlerValueSource0_InvertEntityOrder.mValueObject = contact_info.mEntityShape2;
      mContactEventHandlerValueSource1_InvertEntityOrder.mValueObject = contact_info.mEntityShape1;
      
      isContactContinued = true;
      
      if (contact_info.mIsNewContact)
      {
         isContactContinued = false;
         
         contact_info.mIsNewContact = false;
         contact_info.mBeginContactingFrame = mNumSimulatedSteps; // sometimes, ontact_info.mBeginContactingFrame + 1 = mNumSimulatdSteps, so adjust it
         
         InfectShapes (contact_info.mEntityShape1, contact_info.mEntityShape2);
         
      //trace ("contact_info.mFirstBeginContactingHandler = " + contact_info.mFirstBeginContactingHandler);
         
         //
         list_element = contact_info.mFirstBeginContactingHandler;
         
         IncStepStage ();
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (list_element.mNeedExchangePairOrder ? mContactEventHandlerValueSourceList_InvertEntityOrder : mContactEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }
      
      if (contact_info.mNumContactPoints <= 0)
      {
         isContactContinued = false;
         
         list_element = contact_info.mFirstEndContactingHandler;
         
         IncStepStage ();
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (list_element.mNeedExchangePairOrder ? mContactEventHandlerValueSourceList_InvertEntityOrder : mContactEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
         
         // remove
         
         if (contact_info.mPrevContactInfo != null)
            contact_info.mPrevContactInfo.mNextContactInfo = contact_info.mNextContactInfo;
         else //if (mFirstShapeContactInfo == contact_info)
            mFirstShapeContactInfo = mFirstShapeContactInfo.mNextContactInfo;
         
         if (contact_info.mNextContactInfo != null)
            contact_info.mNextContactInfo.mPrevContactInfo = contact_info.mPrevContactInfo;
         
         delete mShapeContactInfoHashtable [contact_info.mContactId];
         
         //-- mNumContactInfos; // move to handling function
         //trace (" --- mNumContactInfos = " + mNumContactInfos);
         
         // mvoe to free list
         
         contact_info.mNextFreeContactInfo = mFreeContactInfoListHead;
         mFreeContactInfoListHead = contact_info;
         
         //contact_info.mPrevContactInfo = null;
         //contact_info.mNextContactInfo = null;
      }
      
      if (isContactContinued)
      {
         InfectShapes (contact_info.mEntityShape1, contact_info.mEntityShape2);
         
         //
         list_element = contact_info.mFirstKeepContactingHandler;
         
         IncStepStage ();
         while (list_element != null)
         {
            list_element.mEventHandler.HandleEvent (list_element.mNeedExchangePairOrder ? mContactEventHandlerValueSourceList_InvertEntityOrder :mContactEventHandlerValueSourceList);
            
            list_element = list_element.mNextListElement;
         }
      }
      
      contact_info = contact_info.mNextContactInfo;
   }
}
*/

private function FindEventHandlerForEntityPair (eventId:int, shape1:EntityShape, shape2:EntityShape, ignorePairOrder:Boolean):ListElement_EventHandler
{
   // assume all params are valid
   
   var return_handlers:ListElement_EventHandler = null;
   
   var handler_element:ListElement_EventHandler = mEventHandlersByTypes [eventId];
   
   var new_handler_element:ListElement_EventHandler;
   var selector_element:ListElement_EntitySelector
   var result:int;

   while (handler_element != null)
   {
      // check if this handler will handle this pair contacting event
      
      result = EntitySelector.PairContainingResult_False;

      selector_element = handler_element.mEventHandler.mFirstEntitySelector;
      
      while (selector_element != null)
      {
         result = selector_element.mEntitySelector.ContainsEntityPair (shape1, shape2, ignorePairOrder);
         
         if (result != EntitySelector.PairContainingResult_False)
            break;
         
         selector_element = selector_element.mNextListElement;
      }
      
      // handling?
      
      if (result != EntitySelector.PairContainingResult_False)
      {
         new_handler_element = new ListElement_EventHandler (handler_element.mEventHandler);
         new_handler_element.mNeedExchangePairOrder = (result == EntitySelector.PairContainingResult_TrueButNeedExchangePairOrder);
         
         new_handler_element.mNextListElement = return_handlers;
         return_handlers = new_handler_element;
      }
      
      handler_element = handler_element.mNextListElement;
   }
   
   return return_handlers;
}
