package player.entity {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import common.Define;

   // no initilize and update and destroy event for joint anchors
   public class SubEntityJointAnchor extends SubEntity
   {
      internal var mJoint:EntityJoint = null;
      internal var mAnchorIndex:int = 0;
      
      internal var mAnotherJointAnchor:SubEntityJointAnchor = null; // must not be null

      // the connected shape, null means ground. It is possible the shape is not a physics shape.
      internal var mShape:EntityShape = null;
      
      internal var mRelativeRotation:Number = 0.0; // relative to shape
      internal var mLocalPositionX:Number = 0.0; // in shape space
      internal var mLocalPositionY:Number = 0.0; // in shape space

      // anchor list of mShape
      internal var mPrevAnchor:SubEntityJointAnchor = null;
      internal var mNextAnchor:SubEntityJointAnchor = null;

      public function SubEntityJointAnchor (world:World)
      {
         super (world);
         
         mWorld.GetEntityLayer ().addChild (mAnchorShape);
      }

      public function GetShape ():EntityShape
      {
         return mShape;
      }

      // when calling this function, make sure the joint has not built physics.
      internal function SetShape (shape:EntityShape):void
      {
         if (mShape != shape)
         {
            if (mShape != null)
            {
               mShape.DetachJointAnchor (this);
            }
            
            if (shape != null)
            {
               shape.AttachJointAnchor (this);
            }
            
            UpdatelLocalPosition ();
         }
      }

      internal function UpdatelLocalPosition ():void
      {
         if (mShape != null)
         {
            mShape.UpdateSinCos ();
            
            var tempX:Number = (mPositionX - mShape.GetPositionX ());
            var tempY:Number = (mPositionY - mShape.GetPositionY ());
            mLocalPositionX =   tempX * mShape.mCosRotation + tempY * mShape.mSinRotation;
            mLocalPositionY = - tempX * mShape.mSinRotation + tempY * mShape.mCosRotation;
            mRelativeRotation  = mRotation  - mShape.GetRotation  ();
         }
      }

      internal function UpdatePositionFromLocalPosition ():void
      {
         if (mShape != null)
         {
            mShape.UpdateSinCos ();
            
            var point:Point = mShape.LocalPoint2WorldPoint (mLocalPositionX, mLocalPositionY);
            mPositionX = point.x;
            mPositionY = point.y;
            mRotation  = mShape.mRotation + mRelativeRotation;
         }
      }

//=============================================================
//   initialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   destroy
//=============================================================
      
      override protected function DestroyInternal ():void
      {
         if (mShape != null)
         {
            SetShape (null);
         }
         
         mWorld.GetEntityLayer ().removeChild (mAnchorShape);
      }
      
//=============================================================
//   
//=============================================================
      
      override public function SynchronizeWithPhysicsProxy ():void
      {
         if (mShape != null)
            mRotation = mShape.mRotation + mRelativeRotation;
         
         // the parent joint will update the positon of this anchor
         //mAnchorShape.x = mWorld.GetCoordinateSystem ().P2D_PositionX (mPositionX);
         //mAnchorShape.y = mWorld.GetCoordinateSystem ().P2D_PositionY (mPositionY);
         mAnchorShape.rotation = mWorld.GetCoordinateSystem ().P2D_RotationRadians (mRotation * Define.kRadians2Degrees);
         
         mAnchorShape.visible = mVisible;
         mAnchorShape.alpha = mAlpha;
      }
      
//=============================================================
//   appearance
//=============================================================
      
      internal var mAnchorShape:Shape = new Shape ();
      
      private var mRebuildAppearanceFunc:Function = null;
      
      override public function UpdateAppearance ():void
      {
         if (mRebuildAppearanceFunc == null)
            ConfirmRebuildAppearanceFunction ();
         
         mAnchorShape.visible = mVisible
         mAnchorShape.alpha = mAlpha; 
         
         mAnchorShape.graphics.clear ();
         mRebuildAppearanceFunc ();
      }
      
      internal function UpdateDisplayObjectPosition ():void
      {
         mAnchorShape.x = mWorld.GetCoordinateSystem ().P2D_PositionX (mPositionX);
         mAnchorShape.y = mWorld.GetCoordinateSystem ().P2D_PositionY (mPositionY);
      }
      
      private function ConfirmRebuildAppearanceFunction ():void
      {
         if (mJoint is EntityJointHinge)
         {
            if (mAnchorIndex == 0)
               mRebuildAppearanceFunc = RebuildAppearance_HingeOuter;
            else
               mRebuildAppearanceFunc = RebuildAppearance_HingeInner;
         }
         else if (mJoint is EntityJointSlider)
         {
            mRebuildAppearanceFunc = RebuildAppearance_Fixed;
         }
         else 
         {
            mRebuildAppearanceFunc = RebuildAppearance_General;
         }
      }

      private function RebuildAppearance_Hinge ():void
      {
         DrawCircle (5);
         DrawCircle (1);
      }

      private function RebuildAppearance_HingeOuter ():void
      {
         DrawCircle (5);
      }

      private function RebuildAppearance_HingeInner ():void
      {
         DrawCircle (1);
      }

      private function RebuildAppearance_Fixed ():void
      {
         //DrawCircle (5);
      }

      private function RebuildAppearance_General ():void
      {
         DrawCircle (3);
      }

      private function DrawCircle (displayRadius:Number):void
      {
         GraphicsUtil.DrawCircle (
                  mAnchorShape,
                  0,
                  0,
                  displayRadius,
                  0x0, // border color
                  1, // border thickness
                  true, // draw background
                  0xFFFFFF // filled color
               );
      }
   }
}