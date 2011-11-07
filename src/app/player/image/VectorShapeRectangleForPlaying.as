package player.image
{
   import common.display.ModuleSprite;

   import player.physics.PhysicsProxyBody;

   import common.Transform2D;
   import common.shape.VectorShapeRectangle;

   public class VectorShapeRectangleForPlaying extends VectorShapeRectangle implements VectorShapeForPlaying
   {
      public function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
      }

      public function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
      }
   }
}
