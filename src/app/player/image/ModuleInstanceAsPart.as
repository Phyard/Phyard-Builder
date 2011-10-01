package player.image {

   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;

   public class ImageModuleInstance
   {
      private var mImageModule:ImageModule;
      
      public var mParent:ImageModuleInstance = null; // null means root
      public var nChildList:ImageModuleInstance = null; // null means leaf
      
      private var mNumLoopedCycles:int;int = 0;
      
      public function ImageModuleInstance ()
      {
      }
      
      
      
      public function OnSequenceStart ():void
      {
      }
      
      public function Step ():Boolean
      {
         return true;
      }
      
      final public function BuildRootAppearance ():DisplayObject
      {
         var sprite:Sprite = new Sprite ();
         BuildAppearance (sprite);
         return sprite;
      }
      
      public function BuildAppearance (contianer:DisplayObjectContainer):void
      {
      }
      
      public function BuildPhysics (body:PhysicsProxyBody):void
      {
         return mBitmap;
      }
   }
}
