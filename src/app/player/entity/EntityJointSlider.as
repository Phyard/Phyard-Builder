package player.entity {
   
   import player.world.World;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyJointSlider;
   
   public class EntityJointSlider extends EntityJoint
   {
      
      //private var mSpriteAnchor1:Sprite; // 
      //private var mSpriteAnchor2:Sprite;
      
      private var mBackAndForth:Boolean = true;
      
      public function EntityJointSlider (world:World)
      {
         super (world);
         
         //mSpriteAnchor1 = new Sprite ();
         //GraphicsUtil.ClearAndDrawLine (mSpriteAnchor1, 0, -3, 0, 3);
         //addChild (mSpriteAnchor1);
         //
         //mSpriteAnchor2 = new Sprite ();
         //GraphicsUtil.ClearAndDrawLine (mSpriteAnchor2, 0, -3, 0, 3);
         //addChild (mSpriteAnchor2);
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         var slider:PhysicsProxyJointSlider = mPhysicsProxy as PhysicsProxyJointSlider;
         
         if (slider.IsLimitsEnabled () && slider.IsMotorEnabled ())
         {
            var translation:Number = slider.GetJointTranslation ();
            var speed:Number = slider.GetMotorSpeed ();
            if ( speed < 0 && translation < slider.GetLowerLimit () )
            {
               OnJointReachLowerLimit ();
               
               if (mBackAndForth)
               {
                  slider.SetMotorSpeed (-speed);
               }
            }
            else if (speed > 0 && translation > slider.GetUpperLimit () )
            {
               OnJointReachUpperLimit ();
               
               if (mBackAndForth)
               {
                  slider.SetMotorSpeed (-speed);
               }
            }
         }
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         var anchor1Params:Object = params.mAnchor1Params;
         var anchor2Params:Object = params.mAnchor2Params;
         
         var anchorDisplayX1:Number = anchor1Params.mPosX;
         var anchorDisplayY1:Number = anchor1Params.mPosY;
         var anchorDisplayX2:Number = anchor2Params.mPosX;
         var anchorDisplayY2:Number = anchor2Params.mPosY;
         
         if (mPhysicsProxy == null)
         {
            params.mLowerTranslation = mWorld.mPhysicsEngine.DisplayLength2PhysicsLength (params.mLowerTranslation);
            params.mUpperTranslation = mWorld.mPhysicsEngine.DisplayLength2PhysicsLength (params.mUpperTranslation);
            params.mMotorSpeed = mWorld.mPhysicsEngine.DisplayLength2PhysicsLength (params.mMotorSpeed);
            
            var object:Object = mWorld.mPhysicsEngine.CreateProxyJointSliderAuto (anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
            
            SetJointBasicInfo (object.mProxyJoint as PhysicsProxyJointSlider, object.mProxyShape1 == null ? null : object.mProxyShape1.GetUserData () as EntityShape, object.mProxyShape2 == null ? null : object.mProxyShape2.GetUserData () as EntityShape);
         }
         
         mBackAndForth = params.mBackAndForth;
         visible = params.mIsVisible && params.mEnableLimits;
         
         if (updateAppearance)
            RebuildAppearance ();
      }
      
      override public function RebuildAppearanceInternal ():void
      {
      }
      
//==============================================================================
// commands
//==============================================================================
      
      public function SetMotorEnabled (enabled:Boolean):void
      {
      }
      
      public function SetMotorSpeed (speed:Number):void
      {
      }
      
      
      
   }
}



