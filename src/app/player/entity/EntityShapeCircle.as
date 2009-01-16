
package player.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShapeCircle;
   
   import common.Define;
   
   public class EntityShapeCircle extends EntityShape
   {
      
      private var mRadius:Number = 0;
      private var mAppearanceType:int = Define.CircleAppearanceType_Ball;
      
      public function EntityShapeCircle (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
      }
      
      public function GetRadius ():Number
      {
         return mRadius;
      }
      
      override public function BuildPhysicsProxy (params:Object):void
      {
         super.BuildPhysicsProxy (params);
         
         //
         
         mRadius = params.mRadius;
         mAppearanceType = params.mAppearanceType;
         
         var displayX:Number = params.mPosX;
         var displayY:Number = params.mPosY;
         var rot:Number = params.mRotation;
         
         var containerPosition:Point = mShapeContainer.GetPosition ();
         displayX -= containerPosition.x;
         displayY -= containerPosition.y;
         
         if (mIsPhysicsShape && mPhysicsProxy == null)
         {
            mPhysicsProxy  = mWorld.mPhysicsEngine.CreateProxyShapeCircle (
                                    mShapeContainer.mPhysicsProxy as PhysicsProxyBody, displayX, displayY, mRadius, params);
            
            mPhysicsProxy.SetUserData (this);
         }
         
         // for the initial pos and rot of shapeContainer are zeroes, so no need to translate to local values
         x = displayX;
         y = displayY;
         SetRotation (rot);
         
         RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
         var filledColor:uint = Define.GetShapeFilledColor (mAiType);
         var isBreakable:Boolean = Define.IsBreakableShape (mAiType);
         var borderColor:uint = mIsStatic && ! isBreakable ? filledColor : Define.ColorObjectBorder;
         
         GraphicsUtil.ClearAndDrawEllipse (this, 
                                          - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, 
                                          borderColor, 1, true, filledColor);
         
         if (mAppearanceType == Define.CircleAppearanceType_Ball)
         {
            var pos:Number;
            if (Define.IsBombShape (GetShapeAiType ()))
            {
               pos = mRadius * 0.75 * 0.707;
               if (pos < 0) pos = 0;
               GraphicsUtil.DrawEllipse (this, pos, pos, 1, 1, 0xFFFFFF, 1, true, 0xFFFFFF);
            }
            else
            {
               pos = (mRadius * 0.66) * 0.707 - 1;
               if (pos < 0) pos = 0;
               GraphicsUtil.DrawEllipse (this, pos, pos, 1, 1, borderColor, 1, true, borderColor);
            }
         }
         else if (mAppearanceType == Define.CircleAppearanceType_Column)
         {
            var radius2:Number = mRadius * 0.5;
            GraphicsUtil.DrawEllipse (this, - radius2, - radius2, radius2 + radius2, radius2 + radius2, borderColor, 1, false, filledColor);
            if (Define.IsBombShape (GetShapeAiType ()))
               GraphicsUtil.DrawLine (this, radius2, 0, mRadius, 0, 0x808080, 1);
            else
               GraphicsUtil.DrawLine (this, radius2, 0, mRadius, 0, borderColor, 1);
         }
         
         if (Define.IsBombShape (GetShapeAiType ()))
         {
            GraphicsUtil.DrawEllipse (this, - mRadius * 0.5, - mRadius * 0.5, mRadius, mRadius, 0x808080, 0, true, 0x808080);
         }
      }
   }
}
