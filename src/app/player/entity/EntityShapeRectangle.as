package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityShapeRectangle extends EntityShape_WithBodyTexture // EntityShape
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
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mHalfWidth != undefined)
               SetHalfWidth (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mHalfWidth));
            if (entityDefine.mHalfHeight != undefined)
               SetHalfHeight (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mHalfHeight));
            //if (entityDefine.mIsRoundCorners != undefined)
            //   SetRoundCornors (entityDefine.mIsRoundCorners);
            if (entityDefine.mIsRoundJoint != undefined)
               SetRoundJoint (entityDefine.mIsRoundJoint);
            // corner
            if (entityDefine.mIsRoundCorner != undefined)
               SetRoundCorner (entityDefine.mIsRoundCorner);
            if (entityDefine.mCornerEclipseWidth != undefined)
               SetCornerEclipseWidth (entityDefine.mCornerEclipseWidth);
            if (entityDefine.mCornerEclipseHeight != undefined)
               SetCornerEclipseHeight (entityDefine.mCornerEclipseHeight);
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mHalfWidth = mWorld.GetCoordinateSystem ().P2D_Length (GetHalfWidth ());
         entityDefine.mHalfHeight = mWorld.GetCoordinateSystem ().P2D_Length (GetHalfHeight ());
         //entityDefine.mIsRoundCorners = IsRoundCornors ();
         entityDefine.mIsRoundJoint = IsRoundJoint ();
         
         entityDefine.mIsRoundCorner = IsRoundCorner ();
         entityDefine.mCornerEclipseWidth = mWorld.GetCoordinateSystem ().P2D_Length (GetCornerEclipseWidth ());
         entityDefine.mCornerEclipseHeight = mWorld.GetCoordinateSystem ().P2D_Length (GetCornerEclipseHeight ());
         
         entityDefine.mEntityType = Define.EntityType_ShapeRectangle;
         return entityDefine;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mHalfWidth:Number = 0.0;
      protected var mHalfHeight:Number = 0.0;

      //>> v1.07
      //protected var mIsRoundCornors:Boolean = false;
      protected var mIsRoundJoint:Boolean = false; // since v2.05.
      //<<

      public function SetHalfWidth (halfWidth:Number):void
      {
         if (halfWidth < 0)
            halfWidth = 0;
         
         mHalfWidth = halfWidth;
         
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance (); 
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
         
         // mNeedRebuildAppearanceObjects = true; // put in DelayUpdateAppearanceInternal now
         DelayUpdateAppearance (); 
      }
      
      public function GetHalfHeight ():Number
      {
         return mHalfHeight;
      }
      
      //public function SetRoundCornors (roundCorners:Boolean):void
      public function SetRoundJoint (roundJoint:Boolean):void
      {
         //mIsRoundCornors = roundJoint;
         mIsRoundJoint = roundJoint;
      }
      
      //public function IsRoundCornors ():Boolean
      public function IsRoundJoint ():Boolean
      {
         return mIsRoundJoint; // mIsRoundCornors;
      }
      
      // corner, since v2.05
      
      protected var mIsRoundCorner:Boolean = false;
      
      protected var mCornerEclipseWidth:Number = 0.0;
      protected var mCornerEclipseHeight:Number = 0.0;

      public function GetCornerEclipseWidth ():Number
      {
         return mCornerEclipseWidth;
      }

      public function SetCornerEclipseWidth (ellipseWidth:Number):void
      {
         mCornerEclipseWidth = Math.abs (ellipseWidth);
         
         DelayUpdateAppearance ();
      }

      public function GetCornerEclipseHeight ():Number
      {
         return mCornerEclipseHeight;
      }

      public function SetCornerEclipseHeight (ellipseHeight:Number):void
      {
         mCornerEclipseHeight = Math.abs (ellipseHeight);
         
         DelayUpdateAppearance ();
      }
      
      public function IsRoundCorner ():Boolean
      {
         return mIsRoundCorner;
      }
      
      public function SetRoundCorner (roundCorner:Boolean):void
      {
         mIsRoundCorner = roundCorner;
         
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   appearance
//=============================================================
      
      protected var mBackgroundShape:Shape = new Shape ();
      protected var mBorderShape    :Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible;
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayHalfWidth :Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth);
            var displayHalfHeight:Number = mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight);
            var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
            
            var cornerWidth:Number = mCornerEclipseWidth;
            var cornerHeight:Number = mCornerEclipseHeight;
            
            if (mBuildInterior || displayBorderThickness < Number.MIN_VALUE)
            {
               displayHalfWidth += 0.5 / GetScale (); // + 0.5 to avoid the visual leaps between contacting shapes sometimes
               displayHalfHeight += 0.5 / GetScale (); // + 0.5 to avoid the visual leaps between contacting shapes sometimes
               
               if (mIsRoundCorner)
               {
                  cornerWidth += 0.5 / GetScale ();
                  cornerHeight += 0.5 / GetScale ();
                  
                  if (cornerWidth > displayHalfWidth + displayHalfWidth)
                     cornerWidth = displayHalfWidth + displayHalfWidth;
                  if (cornerHeight > displayHalfHeight + displayHalfHeight)
                     cornerHeight = displayHalfHeight + displayHalfHeight;
               }
            }
            else
            {
               displayBorderThickness += 1.0 / GetScale (); // + 1.0 to avoid the visual leaps between contacting shapes sometimes
            }
            
            RebuildBackgroundAndBorder (displayHalfWidth, displayHalfHeight, displayBorderThickness, 
                                        cornerWidth, cornerHeight
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
      
      protected function RebuildBackgroundAndBorder (displayHalfWidth:Number, displayHalfHeight:Number, displayBorderThickness:Number, cornerWidth:Number, cornerHeight:Number):void
      {
         var displayWidth :Number = displayHalfWidth +  displayHalfWidth;
         var displayHeight:Number = displayHalfHeight +  displayHalfHeight;
         
         var isRoundCorner:Boolean = IsRoundCorner () && (cornerWidth > 0) && (cornerHeight > 0);
            
         // todo: body texture (remember add texture define in ToEntityDefine)
        
         GraphicsUtil.ClearAndDrawRect (
                  mBackgroundShape,
                  - displayHalfWidth,
                  - displayHalfHeight,
                  displayWidth,
                  displayHeight,
                  mBorderColor,
                  -1, // not draw border
                  true, // draw background
                  GetFilledColor (),
                  mIsRoundJoint && (! isRoundCorner), // mIsRoundCornors,
                  isRoundCorner, cornerWidth, cornerHeight,
                  mBodyTextureModule == null ? null : mBodyTextureModule.GetBitmapData (),
                  mBodyTextureTransform == null ? null : mBodyTextureTransform.ToMatrix ()
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
                  mIsRoundJoint && (! isRoundCorner), // mIsRoundCornors
                  isRoundCorner, cornerWidth, cornerHeight
               );
      }
      
//=============================================================
//   physics proxy
//=============================================================
     
      override protected function RebuildShapePhysicsInternal ():void
      {
         if (mPhysicsShapeProxy != null)
         {
            //mPhysicsShapeProxy.AddRectangle (mIsStatic, 0, 0, 0, mHalfWidth, mHalfHeight, mBuildInterior, mBuildBorder, mBorderThickness, mIsRoundCornors);
            var accTrans:Transform2D = mWorld.GetCoordinateSystem ().As_D2P_Vector_Transform_CombineByTransform (mLocalTransform);
            mPhysicsShapeProxy.AddRectangle (accTrans, 
                                             mWorld.GetCoordinateSystem ().P2D_Length (mHalfWidth), 
                                             mWorld.GetCoordinateSystem ().P2D_Length (mHalfHeight), 
                                             mBuildInterior, 
                                             mBuildBorder, 
                                             mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness), 
                                             mIsRoundJoint // mIsRoundCornors
                                             );
         }
      }
      
      
      
   }
}
