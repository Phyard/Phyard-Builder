
package player.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShapePolygon;
   
   import common.Define;
   
   public class EntityUtilityCamera extends EntityContainerChild
   {
      public function EntityUtilityCamera (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         //var worldPoint:Point = DisplayObjectUtil.LocalToLocal (this, mWorld, new Point (0, 0));
         var worldPoint:Point = mWorld.globalToLocal ( this.localToGlobal (new Point (0, 0) ) );
         
         //trace ("worldPoint = " + worldPoint);
         
         mWorld.MoveWorldSceneTo (worldPoint.x, worldPoint.y);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
      }
      
   }
   
}
