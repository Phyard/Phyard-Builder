package player.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyJointDistance;
   
   public class EntityJointDistance extends EntityJoint
   {
      
      private var mSpriteAnchor1:Sprite;
      private var mSpriteAnchor2:Sprite;
      
      public function EntityJointDistance (world:World)
      {
         super (world);
         
         mSpriteAnchor1 = new Sprite ();
         GraphicsUtil.ClearAndDrawEllipse (mSpriteAnchor1, - 2, - 2, 2 + 2, 2 + 2);
         addChild (mSpriteAnchor1);
         
         mSpriteAnchor2 = new Sprite ();
         GraphicsUtil.ClearAndDrawEllipse (mSpriteAnchor2, - 2, - 2, 2 + 2, 2 + 2);
         addChild (mSpriteAnchor2);
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         var point1:Point = (mPhysicsProxy as PhysicsProxyJointDistance).GetAnchorPoint1 ();
         var point2:Point = (mPhysicsProxy as PhysicsProxyJointDistance).GetAnchorPoint2 ();
         mWorld.mPhysicsEngine._PhysicsPoint2DisplayPoint (point1);
         mWorld.mPhysicsEngine._PhysicsPoint2DisplayPoint (point2);
         
         
         
         mSpriteAnchor1.x = point1.x;
         mSpriteAnchor1.y = point1.y;
         mSpriteAnchor2.x = point2.x;
         mSpriteAnchor2.y = point2.y;
         
         RebuildAppearance ();
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
            var object:Object = mWorld.mPhysicsEngine.CreateProxyJointDistanceAuto (anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
            
            SetJointBasicInfo (object.mProxyJoint as PhysicsProxyJointDistance, object.mProxyShape1 == null ? null : object.mProxyShape1.GetUserData () as EntityShape, object.mProxyShape2 == null ? null : object.mProxyShape2.GetUserData () as EntityShape);
         }
         
         mSpriteAnchor1.x = anchorDisplayX1;
         mSpriteAnchor1.y = anchorDisplayY1;
         mSpriteAnchor2.x = anchorDisplayX2;
         mSpriteAnchor2.y = anchorDisplayY2;
         
         //
         if (updateAppearance)
            RebuildAppearance ();
      }
      
      override public function RebuildAppearanceInternal ():void
      {
         GraphicsUtil.ClearAndDrawLine (this, mSpriteAnchor1.x, mSpriteAnchor1.y, mSpriteAnchor2.x, mSpriteAnchor2.y);
      }
      
      
      
   }
}
