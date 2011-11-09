package player.module {

   import common.display.ModuleSprite;
   
   import player.physics.PhysicsProxyShape;
   
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
      
      override public function BuildAppearance (frameIndex:int, moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         if (frameIndex >= 0 && frameIndex < mModuleSequences.length)
         {
            var moudlePart:ModuleSequence = mModuleSequences [frameIndex] as ModuleSequence;
            if (moudlePart.IsVisible ())
            {
               var accTranform:Transform2D = transform == null ? moudlePart.GetTransform ().Clone () : Transform2D.CombineTransforms (transform, moudlePart.GetTransform ());
               moudlePart.GetModule ().BuildAppearance (0, moduleSprite, accTranform, moudlePart.GetAlpha () * alpha);
            }
         }
      }
      
      override public function BuildPhysicsProxy (frameIndex:int, physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
         if (frameIndex >= 0 && frameIndex < mModuleSequences.length)
         {
            var moudlePart:ModuleSequence = mModuleSequences [frameIndex] as ModuleSequence;
            moudlePart.GetModule ().BuildPhysicsProxy (0, physicsShapeProxy, Transform2D.CombineTransforms (transform, moudlePart.GetTransformInPhysics ()));
         }
      }
   }
}
