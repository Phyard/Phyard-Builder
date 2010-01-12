package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;   
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapePolyline extends EntityShape
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
      
      protected var mLocalPoints:Array = null;
      protected var mLocalDisplayPoints:Array = null;
      
      protected var mCurveThickness:Number = 1.0; 
      protected var mIsRoundEnds:Boolean = true;

      public function GetVertexPointsCount ():int
      {
         if (mLocalPoints == null)
            return 0;
         else
            return mLocalPoints.length;
      }
      
      public function SetLocalDisplayVertexPoints (points:Array):void
      {
         var i:int;
         var inputDisplayPoint:Point;
         var displayPoint:Point;
         var physicsPoint:Point;
         if (mLocalPoints == null || mLocalPoints.length != points.length)
         {
            mLocalPoints = new Array (points.length);
            mLocalDisplayPoints = new Array (points.length);
            for (i = 0; i < mLocalPoints.length; ++ i)
            {
               mLocalPoints        [i] = new Point ();
               mLocalDisplayPoints [i] = new Point ();
            }
         }
         
         for (i = 0; i < mLocalPoints.length; ++ i)
         {
            inputDisplayPoint = points [i];

            displayPoint = mLocalDisplayPoints [i];
            displayPoint.x = inputDisplayPoint.x;
            displayPoint.y = inputDisplayPoint.y;

            physicsPoint = mLocalPoints [i];
            physicsPoint.x =  mWorld.GetCoordinateSystem ().D2P_PositionX (inputDisplayPoint.x);
            physicsPoint.y =  mWorld.GetCoordinateSystem ().D2P_PositionY (inputDisplayPoint.y);
         }
      }
            
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
         if (mProxyShape != null)
         {
            mProxyShape.AddPolyline (mLocalPoints, mCurveThickness, mIsRoundEnds);
         }
      }
      
      
      
   }
}
