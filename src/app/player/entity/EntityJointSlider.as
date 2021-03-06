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
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
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
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mEnableLimits = IsLimitsEnabled ();
         entityDefine.mLowerTranslation = mWorld.GetCoordinateSystem ().P2D_Length (GetLowerTranslation ());
         entityDefine.mUpperTranslation = mWorld.GetCoordinateSystem ().P2D_Length (GetUpperTranslation ());
         entityDefine.mEnableMotor = IsMotorEnabled ();
         entityDefine.mMotorSpeed = mWorld.GetCoordinateSystem ().P2D_LinearVelocityMagnitude (GetMotorSpeed ());
         entityDefine.mBackAndForth = IsBackAndForth ();
         entityDefine.mMaxMotorForce = mWorld.GetCoordinateSystem ().P2D_ForceMagnitude (GetMaxMotorForce ());
         
         entityDefine.mEntityType = Define.EntityType_JointSlider;
         
         return entityDefine;
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
      
      public function IsLimitsEnabled ():Boolean
      {
         return mEnableLimits;
      }
      
      override public function SetEnableMotor (enableMotor:Boolean):void
      {
         mEnableMotor = enableMotor;
         
         if (mPhysicsProxy != null)
         {
            mProxyJointSlider.SetMotorEnabled (mEnableMotor);
         }
      }
      
      public function IsMotorEnabled ():Boolean
      {
         return mEnableMotor;
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
      
      public function SetMaxMotorForce (maxForce:Number):void
      {
         if (maxForce < 0)
            maxForce = 0.0;
         
         mMaxMotorForce = maxForce;
      }
      
      public function GetMaxMotorForce ():Number
      {
         return mMaxMotorForce;
      }
      
      public function SetBackAndForth (backAndForth:Boolean):void
      {
         mBackAndForth = backAndForth;
      }
      
      public function IsBackAndForth ():Boolean
      {
         return mBackAndForth;
      }
      
//=============================================================
//   runtime info
//=============================================================
      
      public function GetCurrentTranslation ():Number
      {
         if (mPhysicsProxy == null)
            return 0.0;
         else
            return mProxyJointSlider.GetJointTranslation ();
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
      
      override protected function ConfirmConnectedShapesInternal ():void
      {
         ConfirmConnectedShapes_TwoAnchors (mAnchor1.GetPositionX (), mAnchor1.GetPositionY (), mAnchor2.GetPositionX (), mAnchor2.GetPositionY ());
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
