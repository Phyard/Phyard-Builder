package player.entity {
   
   import flash.display.Shape;
   
   import player.world.World;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   import player.physics.PhysicsProxyJointDistance;
   
   import common.Define;
   
   public class EntityJointDistance extends EntityJoint
   {
      public function EntityJointDistance (world:World)
      {
         super (world);

         mCollideConnected = true;
         
         mProxyJointDistance = new PhysicsProxyJointDistance (mWorld.GetPhysicsEngine ());
         
         mWorld.AddChildToEntityLayer (mLineShape);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            //>>from v1.08
            if (entityDefine.mBreakDeltaLength != undefined)
               SetBreakDeltaLength (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mBreakDeltaLength));
            //<<
         }
      }
      
     override public function ToEntityDefine (entityDefine:Object):Object
     {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mBreakDeltaLength = mWorld.GetCoordinateSystem ().P2D_Length (GetBreakDeltaLength ());
         
         entityDefine.mEntityType = Define.EntityType_JointDistance;
         
         return entityDefine;
     }
      
//=============================================================
//   
//=============================================================
      
      protected var mBreakDeltaLength:Number = 0.0;
      
      public function SetBreakDeltaLength (dLength:Number):void
      {
         mBreakDeltaLength = dLength;
      }
      
      public function GetBreakDeltaLength ():Number
      {
         return mBreakDeltaLength;
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
         mWorld.RemoveChildFromEntityLayer (mLineShape);
         
         super.DestroyInternal ();
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         if (mPhysicsProxy != null)
         {
            if (mBreakable && Math.abs (mProxyJointDistance.GetCurrentLength () - mProxyJointDistance.GetStaticLength ()) > mBreakDeltaLength)
            {
               Destroy ();
               
               return;
            }
         }
         
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   appearance
//=============================================================
      
      private var mLineShape:Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         var thinkness:Number = mScale; // v1.56
         
         GraphicsUtil.ClearAndDrawLine (
                  mLineShape, 
                  mWorld.GetCoordinateSystem ().P2D_PositionX (mAnchor1.GetPositionX ()), 
                  mWorld.GetCoordinateSystem ().P2D_PositionY (mAnchor1.GetPositionY ()), 
                  mWorld.GetCoordinateSystem ().P2D_PositionX (mAnchor2.GetPositionX ()), 
                  mWorld.GetCoordinateSystem ().P2D_PositionY (mAnchor2.GetPositionY ()),
                  0x0, thinkness
               );
         
         mLineShape.visible = mVisible;
         mLineShape.alpha = mAlpha;
      }
      
//=============================================================
//   physics proxy
//=============================================================
      
      protected var mProxyJointDistance:PhysicsProxyJointDistance;
      
      override internal function GetPhysicsProxyJoint ():PhysicsProxyJoint
      {
         return mPhysicsProxy == null ? null :mProxyJointDistance;
      }
      
      override protected function ConfirmConnectedShapesInternal ():void
      {
         ConfirmConnectedShapes_TwoAnchors (mAnchor1.GetPositionX (), mAnchor1.GetPositionY (), mAnchor2.GetPositionX (), mAnchor2.GetPositionY ());
      }
      
      override protected function RebuildJointPhysicsInternal ():void
      {
         mPhysicsProxy = mProxyJointDistance;
         mProxyJointDistance.BuildDistance (
                  mAnchor1, mAnchor2, mCollideConnected
               );
      }
      
   }
}
