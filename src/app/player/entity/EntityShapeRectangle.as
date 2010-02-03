package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.world.World;   
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapeRectangle extends EntityShape
   {
      public function EntityShapeRectangle (world:World)
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
            if (entityDefine.mHalfWidth != undefined)
               SetHalfWidth (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mHalfWidth));
            if (entityDefine.mHalfHeight != undefined)
               SetHalfHeight (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mHalfHeight));
            if (entityDefine.mIsRoundCorners != undefined)
               SetRoundCornors (entityDefine.mIsRoundCorners);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mHalfWidth:Number = 0.0;
      protected var mHalfHeight:Number = 0.0;

      //>> v1.07
      protected var mIsRoundCornors:Boolean = false;
      //<<

      public function SetHalfWidth (halfWidth:Number):void
      {
         if (halfWidth < 0)
            halfWidth = 0;
         
         mHalfWidth = halfWidth;
      }
      
      public function GetHalfWidth ():Number
      {
         return mHalfWidth;
      }
      
      public function SetHalfHeight (halfHeight:Number):void
      {
         if (halfHeight < 0)
            halfHeight = 0;
         
         mHalfHeight = halfHeight;
      }
      
      public function GetHalfHeight ():Number
      {
         return mHalfHeight;
      }
      
      public function SetRoundCornors (roundCorners:Boolean):void
      {
         mIsRoundCornors = roundCorners;
      }
      
      public function IsRoundCornors ():Boolean
      {
         return mIsRoundCornors;
      }
      
//=============================================================
//   appearance
//=============================================================
      
      protected var mBackgroundShape:Shape = new Shape ();
      protected var mBorderShape    :Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayHalfWidth :Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth);
            var displayHalfHeight:Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight);
            var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
            if (mBuildInterior || displayBorderThickness < Number.MIN_VALUE)
            {
               displayHalfWidth += 0.5; // + 0.5 to avoid the visual leaps between contacting shapes sometimes
               displayHalfHeight += 0.5; // + 0.5 to avoid the visual leaps between contacting shapes sometimes
            }
            else
            {
               displayBorderThickness += 1.0; // + 1.0 to avoid the visual leaps between contacting shapes sometimes
            }
            
            RebuildBackgroundAndBorder (displayHalfWidth, displayHalfHeight, displayBorderThickness);
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
      
      protected function RebuildBackgroundAndBorder (displayHalfWidth:Number, displayHalfHeight:Number, displayBorderThickness:Number):void
      {
         var displayWidth :Number = displayHalfWidth +  displayHalfWidth;
         var displayHeight:Number = displayHalfHeight +  displayHalfHeight;
         
         GraphicsUtil.ClearAndDrawRect (
                  mBackgroundShape,
                  - displayHalfWidth,
                  - displayHalfHeight,
                  displayWidth,
                  displayHeight,
                  mBorderColor,
                  -1, // not draw border
                  true, // draw background
                  GetFilledColor ()
               );
         
         GraphicsUtil.ClearAndDrawRect (
                  mBorderShape,
                  - displayHalfWidth,
                  - displayHalfHeight,
                  displayWidth,
                  displayHeight,
                  mBorderColor,
                  displayBorderThickness, // draw border
                  false, // not draw background
                  0x0, // invald bg color
                  mIsRoundCornors
               );
      }
      
//=============================================================
//   physics proxy
//=============================================================
     
      override protected function RebuildShapePhysicsInternal ():void
      {
         if (mProxyShape != null)
         {
            mProxyShape.AddRectangle (0, 0, 0, mHalfWidth, mHalfHeight, mBuildInterior, mBuildBorder, mBorderThickness, mIsRoundCornors);
         }
      }
      
      
      
   }
}
