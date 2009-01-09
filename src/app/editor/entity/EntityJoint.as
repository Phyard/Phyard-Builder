
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class EntityJoint extends Entity 
   {
      
      public var mCollideConnected:Boolean = false;
      
      public function EntityJoint (world:World)
      {
         super (world);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         (entity as EntityJoint).mCollideConnected = mCollideConnected;
         
      }
      
   }
}
