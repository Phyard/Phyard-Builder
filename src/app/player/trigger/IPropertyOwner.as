package player.trigger
{
   public interface IPropertyOwner
   {
      function GetPropertyValue (propertyId:int):Object;
      
      function SetPropertyValue (propertyId:int, value:Object):void;
   }
}