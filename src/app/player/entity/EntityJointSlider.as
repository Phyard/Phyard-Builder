package player.entity {
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   import player.physics.PhysicsProxyJointSlider;
   
   import common.Define;
   
   public class EntityJointSlider extends EntityJoint
   {
      protected var mAnchor:SubEntityJointAnchor = null;
      
      public function EntityJointSlider (world:World)
      {
         super (world);

         mCollideConnected = false;
         
         mProxyJointSlider = new PhysicsProxyJointSlider (mWorld.GetPhysicsEngine ());
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mEnableLimits != undefined)
               SetEnableLimits (entityDefine.mEnableLimits);
            if (entityDefine.mLowerTranslation != undefined && entityDefine.mUpperTranslation != undefined)
            {
               SetTranslationLimits (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mLowerTranslation), 
                                    mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mUpperTranslation));
            }
            if (entityDefine.mEnableMotor != undefined)
               SetEnableMotor (entityDefine.mEnableMotor);
            if (entityDefine.mMotorSpeed != undefined)
               SetMotorSpeed (mWorld.GetCoordinateSystem ().D2P_LinearVelocityMagnitude (entityDefine.mMotorSpeed));
            if (entityDefine.mBackAndForth != undefined)
               SetBackAndForth (entityDefine.mBackAndForth);
            if (entityDefine.mMaxMotorForce != undefined)
               SetMaxMotorForce (mWorld.GetCoordinateSystem ().D2P_ForceMagnitude (entityDefine.mMaxMotorForce));
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mLowerTranslation:Number = 0.0;
      protected var mUpperTranslation:Number = 0.0;
      protected var mEnableLimits:Boolean = false;
      protected var mEnableMotor:Boolean = false;
      protected var mMotorSpeed:Number = 0.0;
      protected var mBackAndForth:Boolean = false;
      protected var mMaxMotorForce:Number = 100000000;
      
      public function SetTranslationLimits (lowerTranslation:Number, upperTranslation:Number):void
      {
         if (lowerTranslation < upperTranslation)
         {
            mLowerTranslation = lowerTranslation;
            mUpperTranslation = upperTranslation;
         }
         else
         {
            mLowerTranslation = upperTranslation;
            mUpperTranslation = lowerTranslation;
         }
         
         if (mPhysicsProxy != null)
         {
            mProxyJointSlider.SetLimits (mLowerTranslation, mUpperTranslation);
         }
      }
      
      public function GetLowerTranslation ():Number
      {
         return mLowerTranslation;
      }
      
      public function GetUpperTranslation ():Number
      {
         return mUpperTranslation;
      }
      
      override public function SetEnableLimits (enableLimits:Boolean):void
      {
         mEnableLimits = enableLimits;
         
         if (mPhysicsProxy != null)
         {
            mProxyJointSlider.SetLimitsEnabled (mEnableLimits);
         }
      }
      
      override public function SetEnableMotor (enableMotor:Boolean):void
      {
         mEnableMotor = enableMotor;
         
         if (mPhysicsProxy != null)
         {
            mProxyJointSlider.SetMotorEnabled (mEnableMotor);
         }
      }
      
      public function GetMotorSpeed ():Number
      {
         return mMotorSpeed;
      }
      
      public function SetMotorSpeed (speed:Number):void
      {
         mMotorSpeed = speed;
         
         if (mPhysicsProxy != null)
            mProxyJointSlider.SetMotorSpeed (mMotorSpeed);
      }
      
      public function SetBackAndForth (backAndForth:Boolean):void
      {
         mBackAndForth = backAndForth;
      }
      
      public function SetMaxMotorForce (maxForce:Number):void
      {
         if (maxForce < 0)
            maxForce = 0.0;
         
         mMaxMotorForce = maxForce;
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
         //mWorld.RemoveChildFromEntityLayer (mAnchorShape);
         
         super.DestroyInternal ();
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         DelayUpdateAppearance ();
         
         var proxyJointSlider:PhysicsProxyJointSlider = mPhysicsProxy as PhysicsProxyJointSlider;
         
         if (mEnableLimits && mEnableMotor)
         {
            var translation:Number = proxyJointSlider.GetJointTranslation ();
            
            if ( mMotorSpeed < 0 && translation < mLowerTranslation )
            {
               OnJointReachLowerLimit ();
               
               if (mBackAndForth)
               {
                  mMotorSpeed = -mMotorSpeed;
                  proxyJointSlider.SetMotorSpeed (mMotorSpeed);
               }
            }
            else if (mMotorSpeed > 0 && translation > mUpperTranslation )
            {
               OnJointReachUpperLimit ();
               
               if (mBackAndForth)
               {
                  mMotorSpeed = -mMotorSpeed;
                  proxyJointSlider.SetMotorSpeed (mMotorSpeed);
               }
            }
         }
      }
      
//=============================================================
//   appearance
//=============================================================
      
      public function RebuildAppearance ():void
      {
         //
      }
      
//=============================================================
//   physics proxy
//=============================================================
      
      protected var mProxyJointSlider:PhysicsProxyJointSlider;
      
      override internal function GetPhysicsProxyJoint ():PhysicsProxyJoint
      {
         return mPhysicsProxy == null ? null :mProxyJointSlider;
      }
      
      override public function ConfirmConnectedShapes ():void
      {
         ConfirmConnectedShapes_NonHinge (mAnchor1.GetPositionX (), mAnchor1.GetPositionY (), mAnchor2.GetPositionX (), mAnchor2.GetPositionY ());
      }
      
      override protected function RebuildJointPhysicsInternal ():void
      {
         mPhysicsProxy = mProxyJointSlider;
         mProxyJointSlider.BuildSlider (
                  mAnchor1, mAnchor2, mCollideConnected, 
                  mEnableLimits, mLowerTranslation, mUpperTranslation,
                  mEnableMotor, mMotorSpeed, mMaxMotorForce
               );
      }
      
      
      
   }
}
