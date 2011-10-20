package player.module {

   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;

   public class SequencedModule extends Module
   {
      protected var mModuleSequences:Array;
         // must NOT be null
      
      public function SequencedModule (moduleSequences:Array)
      {
         mModuleSequences = moduleSequences;
      }
      
      override public function CreateInstance ():ModuleInstance
      {
         return new SequencedModuleInstance (this);
      }
      
      public function GetNumFrames ():int
      {
         return mModuleSequences.length;
      }
      
      public finction GetFrameDuration (frameIndex:int):int
      {
         if (frameIndex < 0 || frameIndex >= mModuleSequences.length)
            return 0;
         
         return (mModuleSequences [frameIndex] as ModuleSequence).GetDuration ();
      }
      
      public function BuildFrameAppearance (frameIndex:int, container:Sprite, transform:Transform2D):void
      {
         if (frameIndex >= 0 && frameIndex < mModuleSequences.length)
         {
            var moudlePart:ModulePart = mModuleSequences [frameIndex] as ModulePart;
            var accTranform:Transform2D = transform == null ? transform.Clone () : Transform2D.CombineTransforms (transform, moudlePart.GetTransform ());
            moudlePart.BuildAppearance (container, transform);
         }
      }
      
      public function BuildFramePhysicsProxy (frameIndex:int, physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         if (frameIndex >= 0 && frameIndex < mModuleSequences.length)
         {
            var moudlePart:ModulePart = mModuleSequences [frameIndex] as ModulePart;
            var accTranform:Transform2D = transform == null ? transform.Clone () : Transform2D.CombineTransforms (transform, moudlePart.GetTransform ());
            moudlePart..GetModule ().BuildPhysicsProxy (physicsBodyProxy, transform);
         }
      }
   }
}
