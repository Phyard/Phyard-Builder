package player.entity {
   
   import player.world.World;

   import player.physics.PhysicsProxyShape;
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
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mEnableLimits != undefined)
               SetEnableLimits (entityDefine.mEnableLimits);
            if (entityDefine.mLowerAngle != undefined)
               SetLowerAngle (entityDefine.mLowerAngle * Define.kDegrees2Radians);
            if (entityDefine.mUpperAngle != undefined)
               SetUpperAngle (entityDefine.mUpperAngle * Define.kDegrees2Radians);
            if (entityDefine.mEnableMotor != undefined)
               SetEnableMotor (entityDefine.mEnableMotor);
            if (entityDefine.mMotorSpeed != undefined)
               SetMotorSpeed (entityDefine.mMotorSpeed * Define.kDegrees2Radians);
            if (entityDefine.mBackAndForth != undefined)
               SetBackAndForth (entityDefine.mBackAndForth);
            if (entityDefine.mMaxMotorTorque != undefined)
               SetMaxMotorTorque (mWorld.DisplayTorque2PhysicsTorque (entityDefine.mMaxMotorTorque));
         }
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
      
      public function SetLowerAngle (angle:Number):void
      {
         mLowerAngle = angle;
      }
      
      public function GetLowerAngle ():Number
      {
         return mLowerAngle;
      }
      
      public function SetUpperAngle (angle:Number):void
      {
         mUpperAngle = angle;
      }
      
      public function GetUpperAngle ():Number
      {
         return mUpperAngle;
      }
      
      public function SetEnableLimits (enableLimits:Boolean):void
      {
         mEnableLimits = enableLimits;
      }
      
      public function IsLimitsEnabled ():Boolean
      {
         return mEnableLimits;
      }
      
      public function SetEnableMotor (enableMotor:Boolean):void
      {
         mEnableMotor = enableMotor;
      }
      
      public function IsMotorEnabled ():Boolean
      {
         return mEnableMotor;
      }
      
      public function SetMotorSpeed (speed:Number):void
      {
         mMotorSpeed = speed;
      }
      
      public function GetMotorSpeed ():Number
      {
         return mMotorSpeed;
      }
      
      public function SetMaxMotorTorque (maxTorque:Number):void
      {
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
         //mWorld.GetEntityLayer ().removeChild (mAnchorShape);
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         DelayUpdateAppearance ();
         
         var proxyJointHinge:PhysicsProxyJointHinge = mPhysicsProxy as PhysicsProxyJointHinge;
         
         if (mEnableLimits && mEnableMotor)
         {
            var angle:Number = proxyJointHinge.GetJointAngle ();
            
            if ( mMotorSpeed < 0 && angle < mLowerAngle )
            {
               OnJointReachLowerLimit ();
               
               if (mBackAndForth)
               {
                  mMotorSpeed = - mMotorSpeed;
                  proxyJointHinge.SetMotorSpeed (mMotorSpeed);
               }
            }
            else if (mMotorSpeed > 0 && angle > mUpperAngle )
            {
               OnJointReachUpperLimit ();
               
               if (mBackAndForth)
               {
                  mMotorSpeed = - mMotorSpeed;
                  proxyJointHinge.SetMotorSpeed (mMotorSpeed);
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
      
      override public function ConfirmConnectedShapes ():void
      {
         ConfirmConnectedShapes_Hinge (mAnchor1.GetPositionX (), mAnchor1.GetPositionY ());
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
