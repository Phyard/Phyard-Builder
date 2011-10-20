package player.image
{
   import flash.display.Sprite;

   import player.physics.PhysicsProxyBody;

   import common.Transform2D;
   import common.shape.VectorShapePolygon;

   public class VectorShapePolygonForPlaying extends VectorShapePolygon implements VectorShapeForPlaying
   {
      public function BuildAppearance (container:Sprite, transform:Transform2D):void
      {
      }

      function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
      }
   }
}
