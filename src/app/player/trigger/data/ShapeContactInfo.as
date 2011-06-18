package player.trigger.data
{
   import player.entity.EntityShape;
   
   public class ShapeContactInfo
   {
   // next free contact_info structure
      
      public var mNextFreeContactInfo:ShapeContactInfo = null;
      
   //
      
      public var mPrevContactInfo:ShapeContactInfo = null;
      public var mNextContactInfo:ShapeContactInfo = null;
      
      public var mContactId:int;
      public var mIsNewContact:Boolean;
      public var mInKeepContactingList:Boolean;
      public var mLastIndexInStepQueue:int; // used to judge if the last one in queue
      public var mLastAdjustQueneIdStep:int = -1; // very important, see world.contact handling part for details
      
      public var mBeginContactingFrame:int;       // for the first contact of the pair
      public var mNewestBeginContactingFrame:int; // for any contacts of the pair
      
      public var mContactStartTimesInLastStep:int;
      public var mContactFinisheTimesInLastStep:int;
      
      public var mEntityId1:int;
      public var mEntityId2:int;
      
      public var mEntityShape1:EntityShape;
      public var mEntityShape2:EntityShape;
      public var mContactElement1:ListElement_EntityShape = new ListElement_EntityShape (); // .mEntityShape = mEntityShape2 // some wasteful
      public var mContactElement2:ListElement_EntityShape = new ListElement_EntityShape (); // .mEntityShape = mEntityShape1 // some wasteful
      
      public var mNumContactPoints:int; // it is still possible more than one contacts exist simultaneously.
                                        // a value of 0 means the contact is finished
      
      //public var mBeginPointX:Number;
      //public var mBeginPointY:Number;
      //public var mEndPointX:Number;
      //public var mEndPointY:Number;
      
      public var mFirstBeginContactingHandler:ListElement_EventHandler = null;
      public var mFirstEndContactingHandler:ListElement_EventHandler = null;
      
      public var mFirstKeepContactingHandler:ListElement_EventHandler = null;
      public var mKeepContactingHandlerSearched:Boolean = false;
      
      //public var mFirstSensorContainsShapeHandler:ListElement_EventHandler = null;
   }
}