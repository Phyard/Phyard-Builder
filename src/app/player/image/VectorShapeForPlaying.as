package player.image
{
   import common.display.ModuleSprite;

   import player.physics.PhysicsProxyBody;

   import common.Transform2D;

   public interface VectorShapeForPlaying
   {
      function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void;

      function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void;
   }
}
