package player.trigger.data
{
   import player.trigger.entity.EntityEventHandler;
   
   public class ListElement_EventHandler
   {
      public var mNextListElement:ListElement_EventHandler = null;
      
      public var mEventHandler:EntityEventHandler = null;
      
      // only valid for some shape pair event
      public var mNeedExchangePairOrder:Boolean = false;
      
      public function ListElement_EventHandler (eventHandler:EntityEventHandler)
      {
         mEventHandler = eventHandler;
      }
   }
}
