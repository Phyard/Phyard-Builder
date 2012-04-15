
package editor.asset {
   
   public interface Linkable
   {
      function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int;
      function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean;
      function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toManagerDisplayX:Number, toManagerDisplayY:Number):Boolean;
   }
}
