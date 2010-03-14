
package editor.trigger.entity {
   
   import flash.geom.Point;
   
   public interface ICondition
   {
      function GetTargetValueByLinkZoneId (zoneId:int):int;
      
      function GetTargetValueZoneWorldCenter (targetValue:int):Point;
   }
}
