package player.image {

   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;

   public class Module
   {
      private var mPhysicsGeomData:Object;
      
      public var mParentModule:BitmapModule = null; // null means root
      
      private var mNumLoopedCycles:int;int = 0;
      
      public function Module ()
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
