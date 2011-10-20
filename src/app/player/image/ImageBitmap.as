package player.image
{
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;
   
   import player.module.Module;

   public class ImageBitmap extends Module
   {
      protected var mBitmapData:BitmapData;
      
      public function ImageBitmap (bitmapData:BitmapData)
      {
         mBitmapData = bitmapData;
      }
      
      override public function BuildAppearance (container:Sprite, transform:Transform2D):void
      {
         if (mBitmapData != null)
         {
            var bitmap:Bitmap = new Bitmap (mBitmapData);
            if (transform != null)
               transform.TransformUntransformedDisplayObject (bitmap);
            
            container.addChild (bitmap);
         }
      }
   }
}
