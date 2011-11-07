package player.image
{
   import common.display.ModuleSprite;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.physics.PhysicsProxyBody;

   import common.Transform2D;
   import common.shape.VectorShapePolyline;

   public class VectorShapePolylineForPlaying extends VectorShapePolyline implements VectorShapeForPlaying
   {
      public function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
      }

      public function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
      }
   }
}
