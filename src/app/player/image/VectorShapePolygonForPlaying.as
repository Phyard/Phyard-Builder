package player.image
{
   import common.display.ModuleSprite;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.physics.PhysicsProxyShape;

   import common.Transform2D;
   import common.shape.VectorShapePolygon;

   public class VectorShapePolygonForPlaying extends VectorShapePolygon implements VectorShapeForPlaying
   {
      public function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
      }

      public function BuildPhysicsProxy (physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
      }
   }
}
