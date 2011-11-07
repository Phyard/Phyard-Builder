package player.image
{
   import common.display.ModuleSprite;

   import player.physics.PhysicsProxyShape;

   import common.Transform2D;

   public interface VectorShapeForPlaying
   {
      function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void;

      function BuildPhysicsProxy (physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void;
   }
}
