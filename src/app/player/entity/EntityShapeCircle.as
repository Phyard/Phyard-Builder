package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapeCircle extends EntityShape
   {
      public function EntityShapeCircle (world:World)
      {
         super (world);
         
         mPhysicsShapePotentially = true;
         
         mAppearanceObjectsContainer.addChild (mBackgroundShape);
         mAppearanceObjectsContainer.addChild (mBorderShape);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mRadius != undefined)
               SetRadius (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mRadius));
            if (entityDefine.mAppearanceType != undefined)
               SetAppearanceType (entityDefine.mAppearanceType);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mRadius:Number = 0.0;
      protected var mAppearanceType:int = Define.CircleAppearanceType_Ball;

      public function SetRadius (radius:Number):void
      {
         if (radius < 0.0)
            radius = 0.0;
         
         mRadius = radius;
      }
      
      public function GetRadius ():Number
      {
         return mRadius;
      }
      
      public function SetAppearanceType (type:int):void
      {
         mAppearanceType = type;
      }
      
      public function GetAppearanceType ():int
      {
         return mAppearanceType;
      }
      
//=============================================================
//   appearance
//=============================================================
      
      protected var mBackgroundShape:Shape = new Shape ();
      protected var mBorderShape    :Shape = new Shape ();
      
      protected var mBallTypeDotPercent:Number = 0.67;
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayRadius:Number = mWorld.GetCoordinateSystem ().P2D_Length (mRadius) + 0.5; // + 0.5 to avoid the visual leaps between contacting shapes sometimes
            var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
            
         // background
            
            GraphicsUtil.ClearAndDrawCircle (
                     mBackgroundShape,
                     0,
                     0,
                     displayRadius,
                     mBorderColor, // useless
                     -1, // not draw border
                     true, // draw background
                     GetFilledColor ()
                  );
            
         // border
            
            GraphicsUtil.ClearAndDrawCircle (
                     mBorderShape,
                     0,
                     0,
                     displayRadius,
                     mBorderColor,
                     displayBorderThickness, // draw border
                     false // not draw background
                  );
                  
            if (mAppearanceType == Define.CircleAppearanceType_Ball)
            {
               GraphicsUtil.DrawCircle (
                        mBorderShape,
                        displayRadius * mBallTypeDotPercent,
                        0,
                        0.5, // radius
                        IsDrawBackground () ? GraphicsUtil.GetInvertColor_b (GetFilledColor ()) : mBorderColor, 
                        1, 
                        false
                     );
            }
            else if (mAppearanceType == Define.CircleAppearanceType_Column)
            {
               var halfRadius:Number = displayRadius * 0.5;
               GraphicsUtil.DrawCircle (
                        mBorderShape,
                        0,
                        0,
                        halfRadius,
                        mBorderColor, 
                        1, 
                        false
                     );
               GraphicsUtil.DrawLine (
                        mBorderShape, 
                        halfRadius, 
                        0, 
                        displayRadius, 
                        0, 
                        mBorderColor, 
                        1
                     );
            }
         }
         
         if (mNeedUpdateAppearanceProperties)
         {
            mNeedUpdateAppearanceProperties = false;
            
            mBackgroundShape.visible = IsDrawBackground ();
            mBackgroundShape.alpha = GetTransparency () * 0.01;
            mBorderShape.visible = IsDrawBorder ();
            mBorderShape.alpha = GetBorderTransparency () * 0.01;
         }
      }
      
//=============================================================
//   physics proxy
//=============================================================

      override protected function RebuildShapePhysicsInternal ():void
      {
         if (mProxyShape != null)
         {
            mProxyShape.AddCircle (0, 0, mRadius, mBuildInterior, mBuildBorder, mBorderThickness);
         }
      }

   }
}
