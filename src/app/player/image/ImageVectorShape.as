package player.image
{
   import common.display.ModuleSprite;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Transform2D;
   
   import player.module.Module;

   public class ImageVectorShape extends Module
   {
      protected var mVectorShape:VectorShapeForPlaying;
      
      public function ImageVectorShape (vectorShape:VectorShapeForPlaying)
      {
         mVectorShape = vectorShape;
      }
      
      override public function BuildAppearance (frameIndex:int, moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         mVectorShape.BuildAppearance (moduleSprite, transform, alpha);
      }
      
      override public function BuildPhysicsProxy (frameIndex:int, physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
         mVectorShape.BuildPhysicsProxy (physicsShapeProxy, transform);
      }
   }
}
