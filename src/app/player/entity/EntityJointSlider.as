package player.entity {
   
   import player.world.World;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyJointSlider;
   
   public class EntityJointSlider extends EntityJoint
   {
      
      private var mBackAndForth:Boolean = true;
      
      public function EntityJointSlider (world:World)
      {
         super (world);
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
         
         trace ("---------------------------");
         trace ("translation = " + slider.GetJointTranslation ());
         trace ("speed = " + slider.GetMotorSpeed ());
         trace ("mBackAndForth = " + mBackAndForth);
      }
      
      override public function BuildPhysicsProxy (params:Object):void
      {
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
         
         RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
      }
      
      
      
   }
}



