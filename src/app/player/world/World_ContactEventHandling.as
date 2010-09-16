

private var mFreeContactInfoListHead:ShapeContactInfo = null;

private var mNumContactInfos:int = 0;
private var mShapeContactInfoHashtable:Dictionary = null;
private var mFirstShapeContactInfo:ShapeContactInfo = null;

private function OnShapeContactStarted (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
{
   //InfectShapes (proxyShape1.GetUserData () as EntityShape, proxyShape2.GetUserData () as EntityShape);
   //
   //return;
   
   var shape1:EntityShape = proxyShape1.GetEntityShape ();
   var shape2:EntityShape = proxyShape2.GetEntityShape ();
   
   if (shape1 == null || shape2 == null)
      return;
   
   var id1:int = shape1.GetCreationId ();
   if (id1 < 0 || id1 > 0x7FFF)
      return;
   
   var id2:int = shape2.GetCreationId ();
   if (id2 < 0 || id2 > 0x7FFF)
      return;
   
   var contact_id:int = id1 > id2 ? (id2 << 16) | (id1) : (id1 << 16) | (id2);
   
   // here mShapeContactInfoHashtable is a Dictionary. contact_id will be converted to a string,
   // maybe writing a hashtable with interger as keys is better.
   
   var contact_info:ShapeContactInfo = mShapeContactInfoHashtable [contact_id];
   
   if (contact_info != null)
   {
      // if contact_info.mNumContactPoints is zero, it means there is "out-and-in" happens.
      // now the "out-and-in" <=> nothing happend
      
      // if contact_info.mNumContactPoints >= 1, it means more than one contacts are created for the shape pair
      
      ++ contact_info.mNumContactPoints;
      contact_info.mNewestBeginContactingFrame = mNumSimulatedSteps;
   }
   else
   {
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
      contact_info.mBeginContactingFrame = mNumSimulatedSteps;
      
      contact_info.mFirstBeginContactingHandler = FindEventHandlerForEntityPair (CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting, id1, id2, true);
      contact_info.mFirstKeepContactingHandler  = FindEventHandlerForEntityPair (CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting, id1, id2, true);
      contact_info.mFirstEndContactingHandler   = FindEventHandlerForEntityPair (CoreEventIds.ID_OnTwoPhysicsShapesEndContacting, id1, id2, true);
      
      //if (shape1.IsSensor () && shape2.IsShapeCenterPoint ())
      //   FindEventHandlerForEntityPair (CoreEventIds.ID_OnSensorContainsPhysicsShape, );
      //if (shape2.IsSensor () && shape1.IsShapeCenterPoint ())
      //   FindEventHandlerForEntityPair (CoreEventIds.ID_OnSensorContainsPhysicsShape, );
      
      contact_info.mPrevContactInfo = null;
      contact_info.mNextContactInfo = mFirstShapeContactInfo;
      
      if (mFirstShapeContactInfo != null)
         mFirstShapeContactInfo.mPrevContactInfo = contact_info;
      mFirstShapeContactInfo = contact_info;
      
      mShapeContactInfoHashtable [contact_id] = contact_info;
      
      ++ mNumContactInfos;
      //trace (" +++ mNumContactInfos = " + mNumContactInfos);
   }
   
   //trace ("contact_info#" + contact_id + "'s.mNumContactPoints = " + contact_info.mNumContactPoints);
}

private function OnShapeContactFinished (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
{
   //return;
   
   var shape1:EntityShape = proxyShape1.GetEntityShape ();
   var shape2:EntityShape = proxyShape2.GetEntityShape ();
   
   if (shape1 == null || shape2 == null)
      return;
   
   var id1:int = shape1.GetCreationId ();
   if (id1 < 0 || id1 > 0x7FFF)
      return;
   
   var id2:int = shape2.GetCreationId ();
   if (id2 < 0 || id2 > 0x7FFF)
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
      // lazy destroy, this lien is moved to HandleShapeContactEvents
      // RemoveContactFromContactList (contact_info);
   //}
}

private var mContactEventHandlerValueSource2:Parameter_Direct = new Parameter_Direct (null);
private var mContactEventHandlerValueSource1:Parameter_Direct = new Parameter_Direct (null, mContactEventHandlerValueSource2);
private var mContactEventHandlerValueSource0:Parameter_Direct = new Parameter_Direct (null, mContactEventHandlerValueSource1);
private var mContactEventHandlerValueSourceList:Parameter = mContactEventHandlerValueSource0;

private var mContactEventHandlerValueSource1_InvertEntityOrder:Parameter_Direct = new Parameter_Direct (null, mContactEventHandlerValueSource2);
private var mContactEventHandlerValueSource0_InvertEntityOrder:Parameter_Direct = new Parameter_Direct (null, mContactEventHandlerValueSource1_InvertEntityOrder);
private var mContactEventHandlerValueSourceList_InvertEntityOrder:Parameter = mContactEventHandlerValueSource0_InvertEntityOrder;

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
      //trace ("new");
      
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
         
         -- mNumContactInfos;
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

private function FindEventHandlerForEntityPair (eventId:int, entityId1:int, entityId2:int, ignorePairOrder:Boolean):ListElement_EventHandler
{
   // assume all params are valid
   
   var result:int;
   var list_head:ListElement_EventHandler;
   var list_element:ListElement_EventHandler;
   
   var handler_element:ListElement_EventHandler = mEventHandlers [eventId];
   
   while (handler_element != null)
   {
      result = EntityInputEntityAssigner.GetContainingEntityPairResult (handler_element.mEventHandler.mFirstEntityAssigner, entityId1, entityId2, ignorePairOrder);
      
      if (result != EntityInputEntityAssigner.ContainingResult_False)
      {
         list_element = new ListElement_EventHandler (handler_element.mEventHandler);
         list_element.mNeedExchangePairOrder = result == EntityInputEntityAssigner.ContainingResult_TrueButNeedExchangePairOrder;
         
         list_element.mNextListElement = list_head;
         list_head = list_element;
      }
      
      handler_element = handler_element.mNextListElement;
   }
   
   return list_head;
}
