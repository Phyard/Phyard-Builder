package player.image {

   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;

   public class ModuleInstance
   {
      private var mModule:Module;
      
      public var mParent:ModuleInstance = null; // null means root
      
      public var mParts:Array = null; // ModuleInstanceAsPart
      public var mSequences:Array = null; // ModuleInstanceAsSequence
      
      private var mNumLoopedCycles:int;int = 0;
      
      public function ModuleInstance ()
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
