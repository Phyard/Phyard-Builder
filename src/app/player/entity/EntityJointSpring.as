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
         }
         else if (createStageId == 2)
         {
            var currentLength:Number = Point.distance (new Point (mAnchor2.mPositionX, mAnchor2.mPositionY), new Point (mAnchor1.mPositionX, mAnchor1.mPositionY));
            var staticPhysicsLength:Number = currentLength * mStaticLengthRatio;
            var params:Object = Setting.GetSpringParamsByType (mSpringType, staticPhysicsLength);
            
            mDisplayStaticLength = mWorld.PhysicsLength2DisplayLength (staticPhysicsLength);
            mDisplayDiameter = params.mDiameter;
            mDisplayWireDiameter = params.mWireDiameter;
            mDisplayStaticSegmentLength = params.mStaticSegmentLength;
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
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
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
         var x1:Number = mWorld.PhysicsX2DisplayX (mAnchor1.mPositionX);
         var y1:Number = mWorld.PhysicsX2DisplayX (mAnchor1.mPositionY);
         var x2:Number = mWorld.PhysicsX2DisplayX (mAnchor2.mPositionX);
         var y2:Number = mWorld.PhysicsX2DisplayX (mAnchor2.mPositionY);
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
      
      override public function ConfirmConnectedShapes ():void
      {
         ConfirmConnectedShapes_NonHinge (mAnchor1.GetPositionX (), mAnchor1.GetPositionY (), mAnchor2.GetPositionX (), mAnchor2.GetPositionY ());
      }
      
      override public function RebuildJointPhysics ():void
      {
         if (mAlreadyDestroyed)
            return;
         
         DestroyPhysicsProxy ();
         
         var staticLengthRatio:Number = (mFrequencyHz < Number.MIN_VALUE) ? 1.0 : mStaticLengthRatio;
         
         var proxyJointDistance:PhysicsProxyJointDistance;
         mPhysicsProxy = proxyJointDistance = new PhysicsProxyJointDistance (mWorld.GetPhysicsEngine ());
         proxyJointDistance.BuildDistance (
                  mAnchor1, mAnchor2, mCollideConnected, 
                  staticLengthRatio, mFrequencyHz, mDampingRatio
               );
      }
      
      
      
   }
}
