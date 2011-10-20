package player.module {

   import flash.display.Sprite;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;

   public class AssembledModule extends Module
   {
      protected var mModuleParts:Array;
         // must NOT be null
      
      public function SequencedModule (moduleParts:Array)
      {
         mModuleParts = moduleParts;
      }
      
      override public function BuildAppearance (container:Sprite, transform:Transform2D):void
      {
         for each (var moudlePart:ModulePart : mModuleParts)
         {
            var accTranform:Transform2D = transform == null ? transform.Clone () : Transform2D.CombineTransforms (transform, moudlePart.GetTransform ());
            moudlePart.GetModule ().BuildAppearance (container, accTranform);
         }
      }
      
      override public function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
         for each (var moudlePart:ModulePart : mModuleParts)
         {
            var accTranform:Transform2D = transform == null ? transform.Clone () : Transform2D.CombineTransforms (transform, moudlePart.GetTransform ());
            moudlePart.GetModule ().BuildPhysicsProxy (physicsBodyProxy, transform);
         }
      }
   }
}

