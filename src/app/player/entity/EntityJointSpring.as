package player.entity {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import player.world.World;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
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
         
         mWorld.AddChildToEntityLayer (mSpringShape);
         mAppearanceObject = mSpringShape;
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
            if (entityDefine.mSpringConstant != undefined)
               SetSpringConstant (entityDefine.mSpringConstant * mWorld.GetCoordinateSystem ().D2P_Length (1.0) / mWorld.GetCoordinateSystem ().D2P_ForceMagnitude (1.0));
            if (entityDefine.mBreakExtendedLength != undefined)
               SetBreakExtendedLength (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mBreakExtendedLength));
            //<<
         }
         else if (createStageId == 2)
         {
            if (entityDefine.mCloneFromEntity == null)
            {
               var currentLength:Number = Point.distance (new Point (mAnchor2.mPositionX, mAnchor2.mPositionY), new Point (mAnchor1.mPositionX, mAnchor1.mPositionY));
               var staticPhysicsLength:Number = currentLength * mStaticLengthRatio;
               var params:Object = Setting.GetSpringParamsByType (mSpringType,  mWorld.GetCoordinateSystem ().P2D_Length (staticPhysicsLength));
               
               mDisplayStaticLength = mWorld.GetCoordinateSystem ().P2D_Length (staticPhysicsLength);
               mDisplayDiameter = params.mDiameter;
               mDisplayWireDiameter = params.mWireDiameter;
               mDisplayStaticSegmentLength = params.mStaticSegmentLength;
               
               if (mFrequencyDeterminedManner == Define.SpringFrequencyDetermineManner_Preset)
                  mFrequency = params.mFrequencyHz;
            }
            else
            {
               var cloneFromJoint:EntityJointSpring = entityDefine.mCloneFromEntity as EntityJointSpring;
               mDisplayStaticLength = cloneFromJoint.mDisplayStaticLength;
               mDisplayDiameter = cloneFromJoint.mDisplayDiameter;
               mDisplayWireDiameter = cloneFromJoint.mDisplayWireDiameter;
               mDisplayStaticSegmentLength = cloneFromJoint.mDisplayStaticSegmentLength;
               mFrequency = cloneFromJoint.mFrequency;
            }
         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mSpringType = GetSpringType ();
         entityDefine.mStaticLengthRatio = GetStaticLengthRatio ();
         entityDefine.mDampingRatio = GetDampingRatio ();
      
         //>>from v1.08
         entityDefine.mFrequencyDeterminedManner = GetFrequencyDeterminedManner ();
         entityDefine.mFrequency = GetFrequency ();
         entityDefine.mSpringConstant = GetSpringConstant () * mWorld.GetCoordinateSystem ().D2P_ForceMagnitude (1.0) / mWorld.GetCoordinateSystem ().D2P_Length (1.0);
         entityDefine.mBreakExtendedLength = mWorld.GetCoordinateSystem ().P2D_Length (GetBreakExtendedLength ());
         //<<
         
         entityDefine.mEntityType = Define.EntityType_JointSpring;
         
         return entityDefine;
     }
      
//=============================================================
//   
//=============================================================
      
      protected var mSpringType:Number = Define.SpringType_Normal;
      
      
      protected var mStaticLengthRatio:Number = 1.0;
      protected var mDampingRatio:Number = 0.0;
      
      //>> v1.08
      protected var mFrequencyDeterminedManner:int = 0;
      protected var mFrequency:Number = 0.0;
      protected var mSpringConstant:Number = 0.0;
      
      protected var mBreakExtendedLength:Number = 0.0;
      //<<
      
      public function SetSpringType (type:int):void
      {
         mSpringType = type;
      }
      
      public function GetSpringType ():int
      {
         return mSpringType;
      }
      
      public function SetStaticLengthRatio (ratio:Number):void
      {
         mStaticLengthRatio = ratio;
      }
      
      public function GetStaticLengthRatio ():Number
      {
         return mStaticLengthRatio;
      }
      
      public function SetDampingRatio (ratio:Number):void
      {
         mDampingRatio = ratio;
      }
      
      public function GetDampingRatio ():Number
      {
         return mDampingRatio;
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
      
      public function SetSpringConstant (k:Number):void
      {
         if (k < 0)
            k = 0;
         
         mSpringConstant = k;
      }
      
      public function GetSpringConstant ():Number
      {
         return mSpringConstant;
      }
      
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
         mWorld.RemoveChildFromEntityLayer (mSpringShape);
         
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
         var y1:Number = mWorld.GetCoordinateSystem ().P2D_PositionY (mAnchor1.mPositionY);
         var x2:Number = mWorld.GetCoordinateSystem ().P2D_PositionX (mAnchor2.mPositionX);
         var y2:Number = mWorld.GetCoordinateSystem ().P2D_PositionY (mAnchor2.mPositionY);
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
         
         springWireWidth *= mScale; // v1.56
         halfSpringWidth *= mScale; // v1.56
         
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
         
         mSpringShape.scaleY = mFlipped ? - 1 : 1; // v1.56
      }
      
//=============================================================
//   physics proxy
//=============================================================
      
      protected var mProxyJointDistance:PhysicsProxyJointDistance;
      
      override internal function GetPhysicsProxyJoint ():PhysicsProxyJoint
      {
         return mPhysicsProxy == null ? null : mProxyJointDistance;
      }
      
      override protected function ConfirmConnectedShapesInternal ():void
      {
         ConfirmConnectedShapes_TwoAnchors (mAnchor1.GetPositionX (), mAnchor1.GetPositionY (), mAnchor2.GetPositionX (), mAnchor2.GetPositionY ());
      }
      
      override protected function RebuildJointPhysicsInternal ():void
      {
         var frequencyHz:Number;
         var springConstant:Number;
         var staticLengthRatio:Number;
         
         if (mFrequencyDeterminedManner == Define.SpringFrequencyDetermineManner_CustomSpringConstant)
         {
            springConstant = mSpringConstant;
            frequencyHz = -1.0;
            
            staticLengthRatio = (springConstant < Number.MIN_VALUE) ? 1.0 : mStaticLengthRatio;
         }
         else 
         {
            springConstant = -1.0;
            frequencyHz = mFrequency;
            
            staticLengthRatio = (frequencyHz < Number.MIN_VALUE) ? 1.0 : mStaticLengthRatio;
         }
         
         if (frequencyHz < 0 && springConstant < 0)
            frequencyHz = 0.0;
         
         mPhysicsProxy = mProxyJointDistance;
         mProxyJointDistance.BuildDistance (
                  mAnchor1, mAnchor2, mCollideConnected, 
                  staticLengthRatio, frequencyHz, mDampingRatio, 
                  springConstant
               );
      }
      
      
      
   }
}
