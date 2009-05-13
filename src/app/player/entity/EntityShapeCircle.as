
package player.entity {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class EntityShapeCircle extends EntityShape
   {
      
      protected var mRadius:Number = 0;
      protected var mAppearanceType:int = Define.CircleAppearanceType_Ball;
      
      protected var mBackgroundShape:Shape = null;
      protected var mBorderShape:Shape = null;
      
      public function EntityShapeCircle (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
         
         mBackgroundShape = new Shape ();
         mBorderShape = new Shape ();
         addChild (mBackgroundShape);
         addChild (mBorderShape);
      }
      
      public function GetRadius ():Number
      {
         return mRadius;
      }
      
      public function GetPhysicsRadius ():Number
      {
         //if (mWorld.GetVersion () < 0x0105)
         //   return mRadius;
         
         var borderThickness:uint = GetBorderThickness ();
         
         if (borderThickness == 0)
            return mRadius;
         else
            return mRadius + borderThickness * 0.5 - 0.5;
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         // this "if" is put in AdjustNumberValuesInWorldDefine now
         // 
         //if ( params.mWorldDefine != null && params.mWorldDefine.mVersion >= 0x0102)
         //{
         //   mRadius = ValueAdjuster.AdjustCircleRadius (params.mRadius, params.mWorldDefine.mVersion);
         //}
         //else
         //{
            mRadius = params.mRadius;
         //}
         
         mAppearanceType = params.mAppearanceType;
         
         var displayX:Number = params.mPosX;
         var displayY:Number = params.mPosY;
         var rot:Number = params.mRotation;
         
         var containerPosition:Point = mShapeContainer.GetPosition ();
         displayX -= containerPosition.x;
         displayY -= containerPosition.y;
         
         if (IsPhysicsEntity () && mPhysicsProxy == null)
         {
            mPhysicsProxy  = mWorld.mPhysicsEngine.CreateProxyShape (mShapeContainer.mPhysicsProxy as PhysicsProxyBody);
            mWorld.mPhysicsEngine.AddCircleToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayX, displayY, GetPhysicsRadius (), params);
            
            //mPhysicsProxy  = mWorld.mPhysicsEngine.CreateProxyShapeCircle (
            //                        mShapeContainer.mPhysicsProxy as PhysicsProxyBody, displayX, displayY, 
            //                        GetPhysicsRadius (), params);
            
            mPhysicsProxy.SetUserData (this);
         }
         
         // for the initial pos and rot of shapeContainer are zeroes, so no need to translate to local values
         x = displayX;
         y = displayY;
         SetRotation (rot);
         
         if (updateAppearance)
            RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
         var filledColor:uint = GetFilledColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();
         
         GraphicsUtil.Clear (this);
         alpha = 1.0;
         
         GraphicsUtil.Clear (mBackgroundShape);
         mBackgroundShape.alpha = GetTransparency () * 0.01;
         if (drawBg)
         {
            GraphicsUtil.DrawEllipse (mBackgroundShape, 
                                          - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, 
                                          borderColor, -1, drawBg, filledColor);
         }
         
         GraphicsUtil.Clear (mBorderShape);
         mBorderShape.alpha = GetBorderTransparency () * 0.01;
         if (drawBorder)
         {
            GraphicsUtil.DrawEllipse (mBorderShape, 
                                          - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, 
                                          borderColor, borderThickness, false, filledColor);
         }
         
         if (mAppearanceType == Define.CircleAppearanceType_Ball)
         {
            var pos:Number;
            if (Define.IsBombShape (GetShapeAiType ()))
               pos = mRadius * 0.75;// * 0.707;
            else
               pos = (mRadius * 0.66) - 1;//* 0.707 - 1;
            if (pos < 0) pos = 0;
            
            var invertFilledColor:uint = GraphicsUtil.GetInvertColor_b (filledColor);
            if (! drawBg)
               invertFilledColor = borderColor;
            
            GraphicsUtil.DrawEllipse (mBackgroundShape, pos, 0, 1, 1, invertFilledColor, 1, true, invertFilledColor);
         }
         else if (mAppearanceType == Define.CircleAppearanceType_Column)
         {
            var radius2:Number = mRadius * 0.5;
            GraphicsUtil.DrawEllipse (mBackgroundShape, - radius2, - radius2, radius2 + radius2, radius2 + radius2, borderColor, 1, false, filledColor);
            GraphicsUtil.DrawLine (mBackgroundShape, radius2, 0, mRadius, 0, borderColor, 1);
         }
         
         if (Define.IsBombShape (GetShapeAiType ()))
         {
            GraphicsUtil.DrawEllipse (mBackgroundShape, - mRadius * 0.5, - mRadius * 0.5, mRadius, mRadius, 0x808080, 0, true, 0x808080);
         }
      }
   }
}
