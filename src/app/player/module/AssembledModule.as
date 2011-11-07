package player.module {

   import common.display.ModuleSprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;

   public class AssembledModule extends Module
   {
      protected var mModuleParts:Array;
         // must NOT be null
      
      public function AssembledModule ()
      {
      }
      
      public function SetModuleParts (moduleParts:Array):void
      {
         mModuleParts = moduleParts;
      }
      
      override public function BuildAppearance (frameIndex:int, moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         for each (var moudlePart:ModulePart in mModuleParts)
         {
            if (moudlePart.IsVisible ())
            {
               var accTranform:Transform2D = transform == null ? moudlePart.GetTransform ().Clone () : Transform2D.CombineTransforms (transform, moudlePart.GetTransform ());
               moudlePart.GetModule ().BuildAppearance (0, moduleSprite, accTranform, moudlePart.GetAlpha () * alpha);
            }
         }
      }
      
      override public function BuildPhysicsProxy (frameIndex:int, physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         for each (var moudlePart:ModulePart in mModuleParts)
         {
            var accTranform:Transform2D = transform == null ? transform.Clone () : Transform2D.CombineTransforms (transform, moudlePart.GetTransform ());
            moudlePart.GetModule ().BuildPhysicsProxy (0, physicsBodyProxy, transform);
         }
      }
   }
}

