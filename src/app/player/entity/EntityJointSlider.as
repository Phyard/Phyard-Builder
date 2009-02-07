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
      
      override public function Update (dt:Number):void
      {
         var slider:PhysicsProxyJointSlider = mPhysicsProxy as PhysicsProxyJointSlider;
         
         if (mBackAndForth && slider.IsLimitsEnabled () && slider.IsMotorEnabled ())
         {
            var translation:Number = slider.GetJointTranslation ();
            var speed:Number = slider.GetMotorSpeed ();
            if ( speed < 0 && translation < slider.GetLowerLimit () 
              || speed > 0 && translation > slider.GetUpperLimit () 
            )
            {
               slider.SetMotorSpeed (-speed);
            }
         }
      }
      
      override public function BuildFromParams (params:Object):void
      {
         super.BuildFromParams (params);
         
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
            
            mPhysicsProxy  =  mWorld.mPhysicsEngine.CreateProxyJointSliderAuto (anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
            
            mPhysicsProxy.SetUserData (this);
         }
         
         mBackAndForth = params.mBackAndForth;
         visible = params.mIsVisible && params.mEnableLimits;
         
         RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
      }
      
      
      
   }
}



