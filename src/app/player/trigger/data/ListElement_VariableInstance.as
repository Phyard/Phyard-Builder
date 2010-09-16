package player.trigger.data
{
   import player.trigger.entity.VariableInstance;
   
   public class ListElement_VariableInstance
   {
      public var mNextListElement:ListElement_VariableInstance = null;
      
      public var mVariableInstance:VariableInstance = null;
      
      public function ListElement_VariableInstance (vi:VariableInstance)
      {
         mVariableInstance = vi;
      }
   }
}