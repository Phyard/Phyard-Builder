package player.trigger.data
{
   import player.entity.EntityShape;
   
   public class ListElement_EntityShape
   {
      public var mEntityShape:EntityShape = null;
      
      public var mNextListElement:ListElement_EntityShape = null;
      public var mPrevListElement:ListElement_EntityShape = null;
   }
}
