package player.module {

   import flash.display.Sprite;
   
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
      
      override public function BuildAppearance (frameIndex:int, container:Sprite, transform:Transform2D):void
      {
         for each (var moudlePart:ModulePart in mModuleParts)
         {
            var accTranform:Transform2D = transform == null ? transform.Clone () : Transform2D.CombineTransforms (transform, moudlePart.GetTransform ());
            moudlePart.GetModule ().BuildAppearance (0, container, accTranform);
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

