package player.entity {
   
   import flash.display.Shape;
   
   import player.world.World;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJointDistance;
   
   import common.Define;
   
   public class EntityJointDistance extends EntityJoint
   {
      public function EntityJointDistance (world:World)
      {
         super (world);

         mCollideConnected = true;
         
         mWorld.GetEntityLayer ().addChild (mLineShape);
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
         mWorld.GetEntityLayer ().removeChild (mLineShape);
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
      
      private var mLineShape:Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         GraphicsUtil.ClearAndDrawLine (
                  mLineShape, 
                  mWorld.PhysicsX2DisplayX (mAnchor1.GetPositionX ()), 
                  mWorld.PhysicsY2DisplayY (mAnchor1.GetPositionY ()), 
                  mWorld.PhysicsX2DisplayX (mAnchor2.GetPositionX ()), 
                  mWorld.PhysicsY2DisplayY (mAnchor2.GetPositionY ())
               );
         
         mLineShape.visible = mVisible;
         mLineShape.alpha = mAlpha;
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
         
         var proxyJointDistance:PhysicsProxyJointDistance;
         mPhysicsProxy = proxyJointDistance = new PhysicsProxyJointDistance (mWorld.GetPhysicsEngine ());
         proxyJointDistance.BuildDistance (
                  mAnchor1, mAnchor2, mCollideConnected
               );
      }
      
      
      
   }
}
