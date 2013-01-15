package player.module {
   
   import common.CoordinateSystem;
   import common.Transform2D;

   public class ModulePart
   {
      protected var mModule:Module; 
         // 1. currently, SequenceModule is not supported.
         // 2. must NOT be null
         
      protected var mTransform:Transform2D;
         // for module sequences, must NOT be null
         // for module parts, can be null

      protected var mIsVisible:Boolean = true;
      protected var mAlpha:Number  = 1.0;
      
      protected var mTransformInPhysics:Transform2D;
         // for physics (should update on switching scenes, other values don't need to update)
      
      public function ModulePart (module:Module, transform:Transform2D, visible:Boolean, alpha:Number)
      {
         mModule = module;
         
         mTransform = transform;
         
         mIsVisible = visible;
         mAlpha = alpha;
      }
      
      public function GetModule ():Module
      {
         return mModule;
      }
      
      public function GetTransform ():Transform2D
      {
         return mTransform;
      }
      
      public function AdjustTransformInPhysics (worldCoordinateSystem:CoordinateSystem):void
      {
         mTransformInPhysics = new Transform2D (
                                       worldCoordinateSystem.D2P_Length (mTransform.mOffsetX), 
                                       worldCoordinateSystem.D2P_Length (mTransform.mOffsetY), 
                                       mTransform.mScale, mTransform.mFlipped, 
                                       worldCoordinateSystem.D2P_RotationRadians (mTransform.mRotation)
                                    );
         
      }
      
      public function GetTransformInPhysics ():Transform2D
      {
         return mTransformInPhysics;
      }
      
      public function IsVisible ():Boolean
      {
         return mIsVisible;
      }
      
      public function GetAlpha ():Number
      {
         return mAlpha;
      }
   }
}
