package player.entity {
   
   import player.world.World;

   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   import player.physics.PhysicsProxyJointHinge;
   
   import common.Define;
   
   public class EntityJointHinge extends EntityJoint
   {
      public function EntityJointHinge (world:World)
      {
         super (world);

         mCollideConnected = false;
         
         mProxyJointHinge = new PhysicsProxyJointHinge (mWorld.GetPhysicsEngine ());
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
            if (entityDefine.mLowerAngle != undefined && entityDefine.mUpperAngle != undefined)
            {
               SetAngleLimits (mWorld.GetCoordinateSystem ().D2P_RotationDegrees (entityDefine.mLowerAngle) * Define.kDegrees2Radians, 
                               mWorld.GetCoordinateSystem ().D2P_RotationDegrees (entityDefine.mUpperAngle) * Define.kDegrees2Radians);
            }
            if (entityDefine.mEnableMotor != undefined)
               SetEnableMotor (entityDefine.mEnableMotor);
            if (entityDefine.mMotorSpeed != undefined)
               SetMotorSpeed (mWorld.GetCoordinateSystem ().D2P_AngularVelocity (entityDefine.mMotorSpeed * Define.kDegrees2Radians));
            if (entityDefine.mBackAndForth != undefined)
               SetBackAndForth (entityDefine.mBackAndForth);
            if (entityDefine.mMaxMotorTorque != undefined)
               SetMaxMotorTorque (mWorld.GetCoordinateSystem ().D2P_Torque (entityDefine.mMaxMotorTorque));
         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mEnableLimits = IsLimitsEnabled ();
         entityDefine.mLowerAngle = mWorld.GetCoordinateSystem ().P2D_RotationDegrees (GetLowerAngle ()) * Define.kRadians2Degrees;
         entityDefine.mUpperAngle = mWorld.GetCoordinateSystem ().P2D_RotationDegrees (GetUpperAngle ()) * Define.kRadians2Degrees;
         entityDefine.mEnableMotor = IsMotorEnabled ();
         entityDefine.mMotorSpeed = mWorld.GetCoordinateSystem ().P2D_AngularVelocity (GetMotorSpeed ()) * Define.kRadians2Degrees;
         entityDefine.mBackAndForth = IsBackAndForth ();
         entityDefine.mMaxMotorTorque = mWorld.GetCoordinateSystem ().P2D_Torque (GetMaxMotorTorque ());
         
         entityDefine.mEntityType = Define.EntityType_JointHinge;
         
         return entityDefine;
     }
      
//=============================================================
//   
//=============================================================
      
      protected var mLowerAngle:Number = 0.0;
      protected var mUpperAngle:Number = 0.0;
      protected var mEnableLimits:Boolean = false;
      protected var mEnableMotor:Boolean = false;
      protected var mMotorSpeed:Number = 0.0;
      protected var mBackAndForth:Boolean = false;
      protected var mMaxMotorTorque:Number = 10000000;
      
      public function SetAngleLimits (lowerAngle:Number, upperAngle:Number):void
      {
         if (lowerAngle < upperAngle)
         {
            mLowerAngle = lowerAngle;
            mUpperAngle = upperAngle;
         }
         else
         {
            mLowerAngle = upperAngle;
            mUpperAngle = lowerAngle;
         }
         
         if (mPhysicsProxy != null)
         {
            mProxyJointHinge.SetLimits (mLowerAngle, mUpperAngle);
         }
      }
      
      public function GetLowerAngle ():Number
      {
         return mLowerAngle;
      }
      
      public function GetUpperAngle ():Number
      {
         return mUpperAngle;
      }
      
      override public function SetEnableLimits (enableLimits:Boolean):void
      {
         mEnableLimits = enableLimits;
         
         if (mPhysicsProxy != null)
         {
            mProxyJointHinge.SetLimitsEnabled (mEnableLimits);
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
            mProxyJointHinge.SetMotorEnabled (mEnableMotor);
         }
      }
      
      public function IsMotorEnabled ():Boolean
      {
         return mEnableMotor;
      }
      
      public function SetMotorSpeed (speed:Number):void
      {
         mMotorSpeed = speed;
         
         if (mPhysicsProxy != null)
            mProxyJointHinge.SetMotorSpeed (mMotorSpeed);
      }
      
      public function GetMotorSpeed ():Number
      {
         return mMotorSpeed;
      }
      
      public function SetMaxMotorTorque (maxTorque:Number):void
      {
         if (maxTorque < 0)
            maxTorque = 0.0;
         
         mMaxMotorTorque = maxTorque;
      }
      
      public function GetMaxMotorTorque ():Number
      {
         return mMaxMotorTorque;
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
      
      public function GetCurrentAngle ():Number
      {
         if (mPhysicsProxy == null)
            return 0.0;
         else
            return mProxyJointHinge.GetJointAngle ();
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
         if (mPhysicsProxy != null)
         {
            //if (mBreakable && mProxyJointHinge.GetReactionTorque (mWorld.GetLastSimulatedStepInterval_Inv ()) > mMaxMotorTorque)
            //{
            //   Destroy ();
            //   return;
            //}
         }
         
         DelayUpdateAppearance ();
         
         if (mEnableLimits && mEnableMotor)
         {
            var angle:Number = mProxyJointHinge.GetJointAngle ();
            
            //if (_JointIsFlipped) // :(
            //{
            //   angle = - angle;
            //}
            
            if ( mMotorSpeed < 0 && angle < mLowerAngle)
            {
               OnJointReachLowerLimit ();
               
               if (mBackAndForth)
               {
                  mMotorSpeed = - mMotorSpeed;
                  mProxyJointHinge.SetMotorSpeed (mMotorSpeed);
               }
            }
            else if (mMotorSpeed > 0 && angle > mUpperAngle )
            {
               OnJointReachUpperLimit ();
               
               if (mBackAndForth)
               {
                  mMotorSpeed = - mMotorSpeed;
                  mProxyJointHinge.SetMotorSpeed (mMotorSpeed);
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
      
      protected var mProxyJointHinge:PhysicsProxyJointHinge;
      
      override internal function GetPhysicsProxyJoint ():PhysicsProxyJoint
      {
         return mPhysicsProxy == null ? null : mProxyJointHinge;
      }
      
      override protected function ConfirmConnectedShapesInternal ():void
      {
         ConfirmConnectedShapes_OneAnchor (mAnchor1.GetPositionX (), mAnchor1.GetPositionY ());
      }

      override protected function RebuildJointPhysicsInternal ():void
      {
         mPhysicsProxy = mProxyJointHinge;;
         mProxyJointHinge.BuildHinge (
                  mAnchor1, mAnchor2, mCollideConnected, 
                  mEnableLimits, mLowerAngle, mUpperAngle,
                  mEnableMotor, mMotorSpeed, mMaxMotorTorque
               );
      }
      
   }
}
