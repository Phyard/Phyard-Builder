package player.image
{
   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;
   
   import player.module.Module;

   public class ImageVector extends Module
   {
      protected var mVectorShape:VectorShapeForPlaying;
      
      public function ImageVector (vectorShape:VectorShapeForPlaying)
      {
         mVectorShape = vectorShape;
      }
      
      override public function BuildAppearance (container:Sprite, transform:Transform2D):void
      {
         mVectorShape.BuildAppearance (container, transform);
      }
      
      override public function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         mVectorShape.BuildPhysicsProxy (physicsBodyProxy, transform);
      }
   }
}
