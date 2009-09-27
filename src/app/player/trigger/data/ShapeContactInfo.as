package player.trigger.data
{
   import player.entity.EntityShape;
   
   public class ShapeContactInfo
   {
      public var mPrevContactInfo:ShapeContactInfo = null;
      public var mNextContactInfo:ShapeContactInfo = null;
      
      public var mContactId:int;
      
      public var mBeginContactingFrame:int;       // for the first contact of the pair
      public var mNewestBeginContactingFrame:int; // for any contacts of the pair
      
      public var mContactStartTimesInLastStep:int;
      public var mContactFinisheTimesInLastStep:int;
      
      public var mEntityId1:int;
      public var mEntityId2:int;
      
      public var mEntityShape1:EntityShape;
      public var mEntityShape2:EntityShape;
      
      public var mNumContactPoints:int; // it is still possible more than one contacts exist simutaniously.
                                        // this value of 0 means the contact is finished
      
      //public var mBeginPointX:Number;
      //public var mBeginPointY:Number;
      //public var mEndPointX:Number;
      //public var mEndPointY:Number;
      
      public var mFirstBeginContactingHandler:ListElement_EventHandler = null;
      public var mFirstKeepContactingHandler:ListElement_EventHandler = null;
      public var mFirstEndContactingHandler:ListElement_EventHandler = null;
      public var mFirstSensorContainsShapeHandler:ListElement_EventHandler = null;
   }
}