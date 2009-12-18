package player.entity {
   
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import flash.geom.Point;
   
   import player.world.World;   
   
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapePolygon extends EntityShape
   {
      public function EntityShapePolygon (world:World)
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
            if (entityDefine.mLocalPoints != undefined)
               SetLocalDisplayVertexPoints (entityDefine.mLocalPoints);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      protected var mLocalPoints:Array = null;
      protected var mLocalDisplayPoints:Array = null;

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
      
//=============================================================
//   appearance
//=============================================================
      
      private var mBackgroundShape:Shape = new Shape ();
      private var mBorderShape    :Shape = new Shape ();
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         if (mNeedRebuildAppearanceObjects)
         {
            mNeedRebuildAppearanceObjects = false;
            
            var displayBorderThickness:Number = mWorld.GetCoordinateSystem ().P2D_Length (mBorderThickness);
            
            GraphicsUtil.ClearAndDrawPolygon (
                     mBackgroundShape,
                     mLocalDisplayPoints,
                     mBorderColor,
                     -1, // not draw border
                     true, // draw background
                     GetFilledColor ()
                  );
            
            GraphicsUtil.ClearAndDrawPolygon (
                     mBorderShape,
                     mLocalDisplayPoints,
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
     
      override protected function RebuildShapePhysicsInternal ():void
      {
         if (mProxyShape != null)
         {
            mProxyShape.AddPolygon (mLocalPoints, mBuildInterior, mBuildBorder, mBorderThickness);
         }
      }
      
      
      
   }
}
