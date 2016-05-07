package player.trigger.data
{
   import player.trigger.entity.EntitySelector;
   
   public class ListElement_EntitySelector
   {
      public var mEntitySelector:EntitySelector = null;
      
      public var mNextListElement:ListElement_EntitySelector = null;
      
      public function ListElement_EntitySelector (selector:EntitySelector)
      {
         mEntitySelector = selector;
      }
   }
}