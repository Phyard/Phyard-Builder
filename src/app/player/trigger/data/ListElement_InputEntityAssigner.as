package player.trigger.data
{
   import player.trigger.entity.EntityInputEntityAssigner;
   
   public class ListElement_InputEntityAssigner
   {
      public var mInputEntityAssigner:EntityInputEntityAssigner = null;
      
      public var mNextListElement:ListElement_InputEntityAssigner = null;
      
      public function ListElement_InputEntityAssigner (assigner:EntityInputEntityAssigner)
      {
         mInputEntityAssigner = assigner;
      }
   }
}