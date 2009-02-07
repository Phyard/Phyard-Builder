package player.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyJointDistance;
   
   import common.Define;
   import common.Setting;
   
   public class EntityJointSpring extends EntityJoint
   {
      
      private var mSpriteAnchor1:Sprite;
      private var mSpriteAnchor2:Sprite;
      
      //private var mWireDiameter:Number = 2;
      //private var mDiameter:Number = 9;
      
      private var mSpringType:int = Define.SpringType_Unkonwn;
      
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
         RebuildAppearance ();
      }
      
      override public function BuildFromParams (params:Object):void
      {
         super.BuildFromParams (params);
         
         mSpringType = params.mSpringType;
         
         // ...
         var anchor1Params:Object = params.mAnchor1Params;
         var anchor2Params:Object = params.mAnchor2Params;
         
         var anchorDisplayX1:Number = anchor1Params.mPosX;
         var anchorDisplayY1:Number = anchor1Params.mPosY;
         var anchorDisplayX2:Number = anchor2Params.mPosX;
         var anchorDisplayY2:Number = anchor2Params.mPosY;
         
         var currentLength:Number = Math.sqrt ( (anchorDisplayX1 - anchorDisplayX2) * (anchorDisplayX1 - anchorDisplayX2) 
                                             + (anchorDisplayY1 - anchorDisplayY2) * (anchorDisplayY1 - anchorDisplayY2) );
         
         params.mFrequencyHz = Setting.GetSpringParamsByType (mSpringType, currentLength * params.mStaticLengthRatio).mFrequencyHz;
         if (params.mFrequencyHz >= Define.MaxSpringFrequencyHz)
         {
            params.mFrequencyHz = 0;
            params.mStaticLengthRatio = 1.0;
         }
         
         if (mPhysicsProxy == null)
         {
            mPhysicsProxy  =  mWorld.mPhysicsEngine.CreateProxyJointDistanceAuto (anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
            
            mPhysicsProxy.SetUserData (this);
         }
         
         //mSpriteAnchor1.x = anchorDisplayX1;
         //mSpriteAnchor1.y = anchorDisplayY1;
         //mSpriteAnchor2.x = anchorDisplayX2;
         //mSpriteAnchor2.y = anchorDisplayY2;
         
         //
         RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
         var point1:Point = (mPhysicsProxy as PhysicsProxyJointDistance).GetAnchorPoint1 ();
         var point2:Point = (mPhysicsProxy as PhysicsProxyJointDistance).GetAnchorPoint2 ();
         mWorld.mPhysicsEngine._PhysicsPoint2DisplayPoint (point1);
         mWorld.mPhysicsEngine._PhysicsPoint2DisplayPoint (point2);
         
         var x1:Number = point1.x;
         var y1:Number = point1.y;
         var x2:Number = point2.x;
         var y2:Number = point2.y;
         
         var dx:Number = x2 - x1;
         var dy:Number = y2 - y1;
         var length:Number = Math.sqrt (dx * dx + dy * dy);
         
         x = point1.x;
         y = point1.y;
         
         SetRotation (Math.atan2 (dy, dx));
         
         mSpriteAnchor1.x = 0;
         mSpriteAnchor1.y = 0;
         mSpriteAnchor2.x = length;
         mSpriteAnchor2.y = 0;
         
         var staticLength:Number = mWorld.mPhysicsEngine.PhysicsLength2DisplayLength ( (mPhysicsProxy as PhysicsProxyJointDistance).GetStaticLength () );
         
         var params:Object = Setting.GetSpringParamsByType (mSpringType, staticLength);
         
         var halfSpringWidth:Number = int (params.mDiameter * 0.5);
         var springWireWidth:Number = params.mWireDiameter;
         var staticSegmentLen:Number = params.mStaticSegmentLength;
         var numSegments:int = int ( staticLength / staticSegmentLen );
         if (numSegments < 1) numSegments = 1;
         var segmentLen:Number = length / numSegments;
         
         graphics.clear ();
         
         var xa:Number = 0;
         var ya:Number = 0;
         var xb:Number = segmentLen / 3;
         var yb:Number = - halfSpringWidth;
         var xc:Number = segmentLen * 2 / 3;
         var yc:Number = halfSpringWidth;
         var xd:Number = segmentLen;
         var yd:Number = 0;
         for (var i:int = 0; i < numSegments; ++ i)
         {
            GraphicsUtil.DrawLine (this, xa, ya, xb, yb, 0x0, springWireWidth);
            GraphicsUtil.DrawLine (this, xb, yb, xc, yc, 0x0, springWireWidth);
            GraphicsUtil.DrawLine (this, xc, yc, xd, yd, 0x0, springWireWidth);
            
            xa += segmentLen;
            xb += segmentLen;
            xc += segmentLen;
            xd += segmentLen;
         }
         
         /*
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
         */
      }
      
      
      
   }
}
