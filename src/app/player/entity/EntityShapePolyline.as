package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
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
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mCurveThickness:Number = 1.0; 
      protected var mIsRoundEnds:Boolean = true;

      public function SetCurveThickness (thickness:Number):void
      {
         mCurveThickness = thickness;
      }
      
      public function GetCurveThickness ():uint
      {
         return mCurveThickness;
      }
      
      public function SetRoundEnds (roundEnds:Boolean):void
      {
         mIsRoundEnds = roundEnds;
      }
      
      public function IsRoundEnds ():Boolean
      {
         return mIsRoundEnds;
      }
      
//=============================================================
//   appearance
//=============================================================
      
      private var mLineShape:Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayCurveThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mCurveThickness);
            
            GraphicsUtil.ClearAndDrawPolyline (mLineShape, mLocalDisplayPoints, GetFilledColor (), displayCurveThickness, mIsRoundEnds);
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
            mPhysicsShapeProxy.AddPolyline (mLocalPoints, mCurveThickness, mIsRoundEnds);
         }
      }
      
      
      
   }
}
