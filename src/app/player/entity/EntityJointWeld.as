package player.entity {
   
   import player.world.World;

   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   import player.physics.PhysicsProxyJointWeld;
   
   import common.Define;
   
   public class EntityJointWeld extends EntityJoint
   {
      public function EntityJointWeld (world:World)
      {
         super (world);

         mCollideConnected = false;
         
         mProxyJointWeld = new PhysicsProxyJointWeld (mWorld.GetPhysicsEngine ());
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mEntityType = Define.EntityType_JointWeld;
         
         return entityDefine;
     }
      
//=============================================================
//   
//=============================================================
      
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
      
      protected var mProxyJointWeld:PhysicsProxyJointWeld;
      
      override internal function GetPhysicsProxyJoint ():PhysicsProxyJoint
      {
         return mPhysicsProxy == null ? null : mProxyJointWeld;
      }
      
      override public function ConfirmConnectedShapes ():void
      {
         ConfirmConnectedShapes_OneAnchor (mAnchor1.GetPositionX (), mAnchor1.GetPositionY ());
      }

      override protected function RebuildJointPhysicsInternal ():void
      {
         mPhysicsProxy = mProxyJointWeld;;
         mProxyJointWeld.BuildWeld (
                  mAnchor1, mAnchor2, mCollideConnected
               );
      }
      
   }
}
