package player.entity {
   
   import com.tapirgames.util.GraphicsUtil;
   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyJointHinge;
   
   public class EntityJointHinge extends EntityJoint
   {
      
      private var mBackAndForth:Boolean = false;
      
      public function EntityJointHinge (world:World)
      {
         super (world);
      }
      
      override public function Update (dt:Number):void
      {
         var point1:Point = (mPhysicsProxy as PhysicsProxyJointHinge).GetAnchorPoint1 ();
         var point2:Point = (mPhysicsProxy as PhysicsProxyJointHinge).GetAnchorPoint2 ();
         mWorld.mPhysicsEngine._PhysicsPoint2DisplayPoint (point1);
         mWorld.mPhysicsEngine._PhysicsPoint2DisplayPoint (point2);
         
         x = (point1.x + point2.x) * 0.5;
         y = (point1.y + point2.y) * 0.5;
         
         var hinge:PhysicsProxyJointHinge = mPhysicsProxy as PhysicsProxyJointHinge;
         
         if (mBackAndForth && hinge.IsLimitsEnabled () && hinge.IsMotorEnabled ())
         {
            var angle:Number = hinge.GetJointAngle ();
            var speed:Number = hinge.GetMotorSpeed ();
            if ( speed < 0 && angle < hinge.GetLowerLimit () 
              || speed > 0 && angle > hinge.GetUpperLimit () 
            )
            {
               hinge.SetMotorSpeed (-speed);
            }
         }
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         var anchorParams:Object = params.mAnchorParams;
         
         var anchorDisplayX:Number = anchorParams.mPosX;
         var anchorDisplayY:Number = anchorParams.mPosY;
         
         if (mPhysicsProxy == null)
         {
            params.mLowerAngle = params.mLowerAngle * Math.PI / 180.0;
            params.mUpperAngle = params.mUpperAngle * Math.PI / 180.0;
            params.mMotorSpeed = mWorld.mPhysicsEngine.DisplayLength2PhysicsLength (params.mMotorSpeed);
            
            mPhysicsProxy  =  mWorld.mPhysicsEngine.CreateProxyJointHingeAuto (anchorDisplayX, anchorDisplayY, params);
            
            mPhysicsProxy.SetUserData (this);
         }
         
         x = anchorDisplayX;
         y = anchorDisplayY;
         
         mBackAndForth = params.mBackAndForth;
         visible = params.mIsVisible;
         
         if (updateAppearance)
            RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
         GraphicsUtil.ClearAndDrawEllipse (this, - 5, - 5, 5 + 5, 5 + 5, 0x0, 1, true, 0xFFFFFF);
         GraphicsUtil.DrawEllipse (this, - 1, - 1, 1 + 1, 1 + 1);
      }
      
      
      
   }
}
