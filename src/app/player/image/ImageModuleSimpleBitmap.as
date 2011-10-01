package player.image {

   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   
   import player.physics.PhysicsProxyBody;

   public class BitmapModuleBasic extends BitmapModule
   {
      public var mBitmap:Bitmap; // already transformed
      
      public function BitmapModuleBasic ()
      {
      }
      
      override public function BuildAppearance (contianer:DisplayObjectContainer):void
      {
         if (mBitmap != null)
         {
            contianer.addChild (mBitmap);
         }
      }
   }
}
