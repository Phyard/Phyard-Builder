package player.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyJointDistance;
   
   import common.Define;
   
   public class EntityJointSpring extends EntityJoint
   {
      
      private var mSpriteAnchor1:Sprite;
      private var mSpriteAnchor2:Sprite;
      
      public function EntityJointSpring (world:World)
      {
         super (world);
         
         mSpriteAnchor1 = new Sprite ();
         GraphicsUtil.ClearAndDrawEllipse (mSpriteAnchor1, - 2, - 2, 2 + 2, 2 + 2);
         addChild (mSpriteAnchor1);
         
         mSpriteAnchor2 = new Sprite ();
         GraphicsUtil.ClearAndDrawEllipse (mSpriteAnchor2, - 2, - 2, 2 + 2, 2 + 2);
         addChild (mSpriteAnchor2);
      }
      
      override public function Update (dt:Number):void
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
            mPhysicsProxy  =  mWorld.mPhysicsEngine.CreateProxyJointDistanceAuto (anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
            
            mPhysicsProxy.SetUserData (this);
         }
         
         mSpriteAnchor1.x = anchorDisplayX1;
         mSpriteAnchor1.y = anchorDisplayY1;
         mSpriteAnchor2.x = anchorDisplayX2;
         mSpriteAnchor2.y = anchorDisplayY2;
         
         //
         RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
         var x1:Number = mSpriteAnchor1.x;
         var y1:Number = mSpriteAnchor1.y;
         var x2:Number = mSpriteAnchor2.x;
         var y2:Number = mSpriteAnchor2.y;
         
         var dx:Number = x2 - x1;
         var dy:Number = y2 - y1;
         var length:Number = Math.sqrt (dx * dx + dy * dy);
         
         var staticLength:Number = mWorld.mPhysicsEngine.PhysicsLength2DisplayLength ( (mPhysicsProxy as PhysicsProxyJointDistance).GetStaticLength ());
         var staticLengthRatio:Number = staticLength / length;
         
         var stepLen:Number = Define.SpringSegmentLength;
         if (staticLengthRatio < 0.1)
            stepLen /= 0.1;
         else if (staticLengthRatio > 5)
            stepLen /= 5;
         else
            stepLen /= staticLengthRatio;
         
         var thickness:Number = 3;
         
         var startLen:Number = 0;
         var endLen:Number = stepLen;
         var segmentId:int = 0;
         
         graphics.clear ();
         
         if (length > 0)
         {
            while (startLen < length)
            {
               if (endLen > length)
                  endLen = length;
               
               var startX:Number = x1 + startLen * dx / length;
               var startY:Number = y1 + startLen * dy / length;
               var endX:Number = x1 + endLen * dx / length;
               var endY:Number = y1 + endLen * dy / length;
               
               GraphicsUtil.DrawLine (this, startX, startY, endX, endY, (segmentId & 1) == 0 ? 0x000000 : 0x808080, thickness);
               
               ++ segmentId;
               startLen += stepLen;
               endLen += stepLen;
            }
         }
      }
      
      
      
   }
}
