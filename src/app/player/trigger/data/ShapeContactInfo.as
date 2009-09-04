package player.trigger.data
{
   import player.entity.EntityShape;
   
   public class ShapeContactInfo
   {
      public var mPrevContactInfo:ShapeContactInfo = null;
      public var mNextContactInfo:ShapeContactInfo = null;
      
      public var mEntityId1:int;
      public var mEntityId2:int;
      
      public var mEntityShape1:EntityShape;
      public var mEntityShape2:EntityShape;
      
      public var mNumContactPoints:int;
      
      public var mBeginContactingFrame:int;
      
      public var mFirstBeginContactingHandler:ListElement_EventHandler = null;
      public var mFirstKeepContactingHandler:ListElement_EventHandler = null;
      public var mFirstEndContactingHandler:ListElement_EventHandler = null;
      public var mFirstSensorContainsShapeHandler:ListElement_EventHandler = null;
   }
}