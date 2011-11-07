package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   import common.Transform2D;
   
   public class EntityShapePolyline extends EntityShapePolyShape
   {
      public function EntityShapePolyline (world:World)
      {
         super (world);
         
         SetCurveThickness (mWorld.GetCoordinateSystem ().D2P_Length (1.0));

         mPhysicsShapePotentially = true;
         
         mAppearanceObjectsContainer.addChild (mLineShape);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mLocalPoints != undefined)
               SetLocalDisplayVertexPoints (entityDefine.mLocalPoints);
            if (entityDefine.mCurveThickness != undefined)
               SetCurveThickness (mWorld.GetCoordinateSystem ().D2P_Length (entityDefine.mCurveThickness));
            if (entityDefine.mIsRoundEnds != undefined)
               SetRoundEnds (entityDefine.mIsRoundEnds);
            if (entityDefine.mIsClosed != undefined)
               SetClosed (entityDefine.mIsClosed);
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         // vetexes handled on parent class
         
         entityDefine.mCurveThickness = mWorld.GetCoordinateSystem ().P2D_Length (GetCurveThickness ());
         entityDefine.mIsRoundEnds = IsRoundEnds ();
         entityDefine.mIsClosed = IsClosed ();
         
         entityDefine.mEntityType = Define.EntityType_ShapePolyline;
         
         return entityDefine;
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mCurveThickness:Number = 1.0;  // from v?.??
      protected var mIsRoundEnds:Boolean = true; // from v1.08
      protected var mIsClosed:Boolean = true; // from v1.57

      public function SetCurveThickness (thickness:Number):void
      {
         mCurveThickness = thickness;
      }
      
      public function GetCurveThickness ():Number
      {
         return mCurveThickness;
      }
      
      public function SetRoundEnds (roundEnds:Boolean):void
      {
         mIsRoundEnds = roundEnds;
      }
      
      public function IsRoundEnds ():Boolean
      {
         return mIsClosed || mIsRoundEnds;
      }
      
      public function SetClosed (closed:Boolean):void
      {
         mIsClosed = closed;
      }
      
      public function IsClosed ():Boolean
      {
         return mIsClosed;
      }
      
//=============================================================
//   appearance
//=============================================================
      
      private var mLineShape:Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible;
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayCurveThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mCurveThickness);
            
            GraphicsUtil.ClearAndDrawPolyline (mLineShape, mLocalDisplayPoints, GetFilledColor (), displayCurveThickness, IsRoundEnds (), IsClosed ());
         }
         
         if (mNeedUpdateAppearanceProperties)
         {
            mNeedUpdateAppearanceProperties = false;
            
            mLineShape.visible = IsDrawBackground ();
            mLineShape.alpha = GetTransparency () * 0.01;
         }
      }
     
//=============================================================
//   physics proxy
//=============================================================
     
      override protected function RebuildShapePhysicsInternal ():void
      {
         if (mPhysicsShapeProxy != null)
         {
            //mPhysicsShapeProxy.AddPolyline (mIsStatic, mLocalPoints, mCurveThickness, IsRoundEnds (), IsClosed ());
            mPhysicsShapeProxy.AddPolyline (
                                       //new Transform2D (mLocalPositionX, mLocalPositionY, mScale, mFlipped, mRelativeRotation)
                                       // if mFlipped is true, mRelativeRotation should be changed to "PI - mRelativeRotation"?
                                       new Transform2D (mLocalPositionX, mLocalPositionY, mScale, false, mRelativeRotation), 
                                       mLocalPoints, mBuildInterior, mCurveThickness, IsRoundEnds (), IsClosed ());
         }
      }
      
      
      
   }
}
