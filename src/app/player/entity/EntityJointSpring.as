package player.entity {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import player.world.World;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJointDistance;
   
   import common.Define;
   import common.Setting;
   
   public class EntityJointSpring extends EntityJoint
   {
      public function EntityJointSpring (world:World)
      {
         super (world);

         mCollideConnected = true;
         
         mProxyJointDistance = new PhysicsProxyJointDistance (mWorld.GetPhysicsEngine ());
         
         mWorld.GetEntityLayer ().addChild (mSpringShape);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mSpringType != undefined)
               SetSpringType (entityDefine.mSpringType);
            if (entityDefine.mStaticLengthRatio != undefined)
               SetStaticLengthRatio (entityDefine.mStaticLengthRatio);
            if (entityDefine.mDampingRatio != undefined)
               SetDampingRatio (entityDefine.mDampingRatio);
            
            //>>from v1.08
            if (entityDefine.mFrequencyDeterminedManner != undefined)
               SetFrequencyDeterminedManner (entityDefine.mFrequencyDeterminedManner);
            if (entityDefine.mFrequency != undefined)
               SetFrequency (entityDefine.mFrequency);
            if (entityDefine.mBreakExtendedLength != undefined)
               SetBreakExtendedLength (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mBreakExtendedLength));
            //<<
         }
         else if (createStageId == 2)
         {
            var currentLength:Number = Point.distance (new Point (mAnchor2.mPositionX, mAnchor2.mPositionY), new Point (mAnchor1.mPositionX, mAnchor1.mPositionY));
            var staticPhysicsLength:Number = currentLength * mStaticLengthRatio;
            var params:Object = Setting.GetSpringParamsByType (mSpringType, staticPhysicsLength);
            
            mDisplayStaticLength = mWorld.GetCoordinateSystem ().P2D_Length (staticPhysicsLength);
            mDisplayDiameter = params.mDiameter;
            mDisplayWireDiameter = params.mWireDiameter;
            mDisplayStaticSegmentLength = params.mStaticSegmentLength;
            
            if (mFrequencyDeterminedManner == Define.SpringFrequencyDetermineManner_CustomFrequency)
               mFrequencyHz = mFrequency;
            else
               mFrequencyHz = params.mFrequencyHz;
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mSpringType:Number = Define.SpringType_Normal;
      
      protected var mFrequencyHz:Number = 0.0;
      
      protected var mStaticLengthRatio:Number = 1.0;
      protected var mDampingRatio:Number = 0.0;
      
      //>> v1.08
      protected var mFrequencyDeterminedManner:int = 0;
      protected var mFrequency:Number = 0.0;
      //protected var mCustomSpringConstant:Number = 0.0;
      
      protected var mBreakExtendedLength:Number = 0.0;
      //<<
      
      public function SetSpringType (type:int):void
      {
         mSpringType = type;
      }
      
      public function SetStaticLengthRatio (ratio:Number):void
      {
         mStaticLengthRatio = ratio;
      }
      
      public function SetDampingRatio (ratio:Number):void
      {
         mDampingRatio = ratio;
      }
      
      public function SetFrequencyDeterminedManner (manner:int):void
      {
         mFrequencyDeterminedManner = manner;
      }
      
      public function GetFrequencyDeterminedManner ():int
      {
         return mFrequencyDeterminedManner;
      }
      
      public function SetFrequency (f:Number):void
      {
         mFrequency = f;
      }
      
      public function GetFrequency ():Number
      {
         return mFrequency;
      }
      
      //public function SetCustomSpringConstant (k:Number):Number
      //{
      //   mCustomSpringConstant = k;
      //}
      
      //public function GetCustomSpringConstant ():Number
      //{
      //   return mCustomSpringConstant;
      //}
      
      public function SetBreakExtendedLength (length:Number):void
      {
         mBreakExtendedLength = length;
      }
      
      public function GetBreakExtendedLength ():Number
      {
         return mBreakExtendedLength;
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
         mWorld.GetEntityLayer ().removeChild (mSpringShape);
         
         super.DestroyInternal ();
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mPhysicsProxy != null)
         {
            if (mBreakable && mProxyJointDistance.GetCurrentLength () - mProxyJointDistance.GetStaticLength () > mBreakExtendedLength)
            {
               Destroy ();
               
               return;
            }
         }
         
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   appearance
//=============================================================
      
      private var mSpringShape:Shape = new Shape ();
      
      protected var mDisplayStaticLength:Number = 0.0;
      protected var mDisplayDiameter:Number = 11;
      protected var mDisplayWireDiameter:Number = 2;
      protected var mDisplayStaticSegmentLength:Number = 6;
      
      override public function UpdateAppearance ():void
      {
         var x1:Number = mWorld.GetCoordinateSystem ().P2D_PositionX (mAnchor1.mPositionX);
         var y1:Number = mWorld.GetCoordinateSystem ().P2D_PositionX (mAnchor1.mPositionY);
         var x2:Number = mWorld.GetCoordinateSystem ().P2D_PositionX (mAnchor2.mPositionX);
         var y2:Number = mWorld.GetCoordinateSystem ().P2D_PositionX (mAnchor2.mPositionY);
         var dx:Number = x2 - x1;
         var dy:Number = y2 - y1;
         
         mSpringShape.x = x1;
         mSpringShape.y = y1;
         mSpringShape.rotation = Math.atan2 (y2 - y1, x2 - x1) * Define.kRadians2Degrees;
         
         var currentDisplayLength:Number = Math.sqrt (dx * dx + dy * dy);
         var halfSpringWidth:Number = int (mDisplayDiameter * 0.5);
         var springWireWidth:Number = mDisplayWireDiameter;
         var staticSegmentLen:Number = mDisplayStaticSegmentLength;
         var numSegments:int = int ( mDisplayStaticLength / staticSegmentLen );
         if (numSegments < 1) numSegments = 1;
         var segmentLen:Number = currentDisplayLength / numSegments;
         
         mSpringShape.graphics.clear ();
         
         var xa:Number = 0;
         var ya:Number = 0;
         var xb:Number = segmentLen / 3;
         var yb:Number = - halfSpringWidth;
         var xc:Number = segmentLen * 2 / 3;
         var yc:Number = halfSpringWidth;
         var xd:Number = segmentLen;
         var yd:Number = 0;
         for (var i:int = 0; i < numSegments; ++ i)
         {
            GraphicsUtil.DrawLine (mSpringShape, xa, ya, xb, yb, 0x0, springWireWidth);
            GraphicsUtil.DrawLine (mSpringShape, xb, yb, xc, yc, 0x0, springWireWidth);
            GraphicsUtil.DrawLine (mSpringShape, xc, yc, xd, yd, 0x0, springWireWidth);
            
            xa += segmentLen;
            xb += segmentLen;
            xc += segmentLen;
            xd += segmentLen;
         }
         
         mSpringShape.visible = mVisible;
         mSpringShape.alpha = mAlpha;
      }
      
//=============================================================
//   physics proxy
//=============================================================
      
      protected var mProxyJointDistance:PhysicsProxyJointDistance;
      
      override public function ConfirmConnectedShapes ():void
      {
         ConfirmConnectedShapes_NonHinge (mAnchor1.GetPositionX (), mAnchor1.GetPositionY (), mAnchor2.GetPositionX (), mAnchor2.GetPositionY ());
      }
      
      override protected function RebuildJointPhysicsInternal ():void
      {
         var staticLengthRatio:Number = (mFrequencyHz < Number.MIN_VALUE) ? 1.0 : mStaticLengthRatio;
         
         mPhysicsProxy = mProxyJointDistance;
         mProxyJointDistance.BuildDistance (
                  mAnchor1, mAnchor2, mCollideConnected, 
                  staticLengthRatio, mFrequencyHz, mDampingRatio
               );
      }
      
      
      
   }
}
