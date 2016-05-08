package player.entity {
   
   import flash.display.Shape;
   
   import player.world.World;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   import player.physics.PhysicsProxyJointDummy;
   
   import common.Define;
   
   public class EntityJointDummy extends EntityJoint
   {
      public function EntityJointDummy (world:World)
      {
         super (world);

         mCollideConnected = true;
         
         mProxyJointDummy = new PhysicsProxyJointDummy (mWorld.GetPhysicsEngine ());
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mEntityType = Define.EntityType_JointDummy;
         
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
         
         mAnchor1.SetVisible (false);
         mAnchor2.SetVisible (false);
      }
      
//=============================================================
//   destroy
//=============================================================
      
      override protected function DestroyInternal ():void
      {
         //mWorld.RemoveChildFromEntityLayer (mLineShape);
         
         super.DestroyInternal ();
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         //DelayUpdateAppearance ();
      }
      
//=============================================================
//   appearance
//=============================================================
      
      override public function UpdateAppearance ():void
      {
      }
      
//=============================================================
//   physics proxy
//=============================================================
      
      protected var mProxyJointDummy:PhysicsProxyJointDummy;
      
      override internal function GetPhysicsProxyJoint ():PhysicsProxyJoint
      {
         return mPhysicsProxy == null ? null :mProxyJointDummy;
      }
      
      override protected function ConfirmConnectedShapesInternal ():void
      {
         ConfirmConnectedShapes_TwoAnchors (mAnchor1.GetPositionX (), mAnchor1.GetPositionY (), mAnchor2.GetPositionX (), mAnchor2.GetPositionY ());
      }
      
      override protected function RebuildJointPhysicsInternal ():void
      {
         mPhysicsProxy = mProxyJointDummy;
         mProxyJointDummy.BuildDummy (
                  mAnchor1, mAnchor2, mCollideConnected
               );
      }
      
      
      
   }
}
