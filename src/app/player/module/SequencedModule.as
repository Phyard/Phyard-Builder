package player.module {

   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;

   public class SequencedModule extends Module
   {
      protected var mModuleSequences:Array;
         // must NOT be null
      
      public function SequencedModule ()
      {
      }
      
      public function SetModuleSequences (moduleSequences:Array):void
      {
         mModuleSequences = moduleSequences;
      }
      
      override public function GetNumFrames ():int
      {
         return mModuleSequences.length;
      }
      
      override public function GetFrameDuration (frameIndex:int):int
      {
         if (frameIndex < 0 || frameIndex >= mModuleSequences.length)
            return 0;
         
         return (mModuleSequences [frameIndex] as ModuleSequence).GetDuration ();
      }
      
      override public function BuildAppearance (frameIndex:int, container:Sprite, transform:Transform2D):void
      {
         if (frameIndex >= 0 && frameIndex < mModuleSequences.length)
         {
            var moudlePart:ModuleSequence = mModuleSequences [frameIndex] as ModuleSequence;
            moudlePart.GetModule ().BuildAppearance (0, container, Transform2D.CombineTransforms (transform, moudlePart.GetTransform ()));
         }
      }
      
      override public function BuildPhysicsProxy (frameIndex:int, physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         if (frameIndex >= 0 && frameIndex < mModuleSequences.length)
         {
            var moudlePart:ModuleSequence = mModuleSequences [frameIndex] as ModuleSequence;
            moudlePart..GetModule ().BuildPhysicsProxy (0, physicsBodyProxy, Transform2D.CombineTransforms (transform, moudlePart.GetTransform ()));
         }
      }
   }
}
