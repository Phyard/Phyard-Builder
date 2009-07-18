
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.World;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityCondition extends EntityLogic 
   {
      
      public function EntityCondition (world:World)
      {
         super (world);
      }
      
//====================================================================
//   storer
//====================================================================
      
      public function GetTargetValueByLinkZoneId (zoneId:int):int
      {
         return zoneId;
      }
      
      public function GetTargetValueZoneWorldCenter (targetValue:int):Point
      {
         return new Point (GetPositionX (), GetPositionY ());
      }
      
   }
}
