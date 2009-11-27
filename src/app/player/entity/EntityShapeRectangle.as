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
               SetHalfWidth (mWorld.DisplayLength2PhysicsLength (entityDefine.mHalfWidth));
            if (entityDefine.mHalfHeight != undefined)
               SetHalfHeight (mWorld.DisplayLength2PhysicsLength (entityDefine.mHalfHeight));
            if (entityDefine.mIsRoundCorner != undefined)
               SetRoundCornor (entityDefine.mIsRoundCorner);
         }
      }
      
//=============================================================
//   
//=============================================================
      
		protected var mHalfWidth:Number = 0.0;
		protected var mHalfHeight:Number = 0.0;
		
		//>> v1.07
		protected var mIsRoundCornor:Boolean = false;
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
      
      public function SetRoundCornor (roundCorner:Boolean):void
      {
			mIsRoundCornor = roundCorner;
      }
      
      public function IsRoundCornor ():Boolean
      {
			return mIsRoundCornor;
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
            
            var displayHalfWidth :Number = mWorld.PhysicsLength2DisplayLength (mHalfWidth) + 0.5; // + 0.5 to avoid the visual leaps between contacting shapes sometimes
            var displayHalfHeight:Number = mWorld.PhysicsLength2DisplayLength (mHalfHeight) + 0.5;
            var displayWidth :Number = 2.0 * displayHalfWidth;
            var displayHeight:Number = 2.0 * displayHalfHeight;
            var displayBorderThickness:Number = mWorld.PhysicsLength2DisplayLength (mBorderThickness);
         
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
                     false // not draw background
                  );
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
     
      override public function RebuildShapePhysics ():void
      {
         var proxyShape:PhysicsProxyShape = PrepareRebuildShapePhysics ();
         if (proxyShape != null)
         {
            proxyShape.AddRectangle (0, 0, 0, mHalfWidth, mHalfHeight, mBuildInterior, mBuildBorder, mBorderThickness, mIsRoundCornor);
			}
      }
      
      
      
   }
}
