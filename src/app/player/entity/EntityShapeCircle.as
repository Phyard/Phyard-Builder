package player.entity {
   
   import flash.display.Shape;
   
   import flash.geom.Matrix;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityShapeCircle extends EntityShape_WithBodyTexture // EntityShape
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
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mRadius != undefined)
               SetRadius (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mRadius));
            if (entityDefine.mAppearanceType != undefined)
               SetAppearanceType (entityDefine.mAppearanceType);
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mRadius = mWorld.GetCoordinateSystem ().P2D_Length (GetRadius ());
         entityDefine.mAppearanceType = GetAppearanceType ();
         
         entityDefine.mEntityType = Define.EntityType_ShapeCircle;
         return entityDefine;
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
         
         mNeedRebuildAppearanceObjects = true;
         DelayUpdateAppearance (); 
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
         mAppearanceObjectsContainer.visible = mVisible;
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayRadius:Number = mWorld.GetCoordinateSystem ().P2D_Length (mRadius);
            var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
            if (mBuildInterior || displayBorderThickness < Number.MIN_VALUE)
            {
               displayRadius += 0.5 / GetScale (); // + 0.5 to avoid the visual leaps between contacting shapes sometimes
                                                   // ! it seems this is not good for (border thickness == 0)
            }
            else
            {
               displayBorderThickness += 1.0 / GetScale (); // + 1.0 to avoid the visual leaps between contacting shapes sometimes
            }
            
         // background
            
            // todo: body texture (remember add texture define in ToEntityDefine)
            
            GraphicsUtil.ClearAndDrawCircle (
                     mBackgroundShape,
                     0,
                     0,
                     displayRadius,
                     mBorderColor, // useless
                     -1, // not draw border
                     true, // draw background
                     GetFilledColor (), 
                     mBodyTextureModule == null ? null : mBodyTextureModule.GetBitmapData (),
                     mBodyTextureTransform == null ? null : mBodyTextureTransform.ToMatrix ()
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
         if (mPhysicsShapeProxy != null)
         {
            //mPhysicsShapeProxy.AddCircle (mIsStatic, 0, 0, mRadius, mBuildInterior, mBuildBorder, mBorderThickness);
            mPhysicsShapeProxy.AddCircle (mLocalTransform,
                                          mRadius, mBuildInterior, mBuildBorder, mBorderThickness
                                          );
         }
      }

   }
}
