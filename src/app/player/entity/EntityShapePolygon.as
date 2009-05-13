
package player.entity {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapePolygon extends EntityShape
   {
      
      protected var mLocalPoints:Array = null;
      
      protected var mBackgroundShape:Shape = null;
      protected var mBorderShape:Shape = null;
      
      public function EntityShapePolygon (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
         
         mBackgroundShape = new Shape ();
         mBorderShape = new Shape ();
         addChild (mBackgroundShape);
         addChild (mBorderShape);
      }
      
      public function GetVertexPointsCount ():int
      {
         if (mLocalPoints == null)
            return 0;
         else
            return mLocalPoints.length;
      }
      
      public function SetLocalVertexPoints (points:Array):void
      {
         if (mLocalPoints == null || mLocalPoints.length != points.length)
         {
            mLocalPoints = new Array (points.length);
            for (i = 0; i < mLocalPoints.length; ++ i)
               mLocalPoints [i] = new Point ();
         }
         
         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            mLocalPoints [i].x =  points [i].x;
            mLocalPoints [i].y =  points [i].y;
         }
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         //
         
         SetLocalVertexPoints (params.mLocalPoints);
         
         var displayX:Number = params.mPosX;
         var displayY:Number = params.mPosY;
         var rot:Number = params.mRotation;
         
         var containerPosition:Point = mShapeContainer.GetPosition ();
         displayX -= containerPosition.x;
         displayY -= containerPosition.y;
         
         if (IsPhysicsEntity () && mLocalPoints != null)
         {
            var cos:Number = Math.cos (rot);
            var sin:Number = Math.sin (rot);
            
            var i:int;
            var displayPoints:Array = new Array (mLocalPoints.length);
            var tx:Number;
            var ty:Number;
            for (i = 0; i < displayPoints.length; ++ i)
            {
               tx = mLocalPoints [i].x;
               ty = mLocalPoints [i].y;
               displayPoints [i] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            }
            
            if (mPhysicsProxy == null)
            {
               mPhysicsProxy  = mWorld.mPhysicsEngine.CreateProxyShape (mShapeContainer.mPhysicsProxy as PhysicsProxyBody);
               
               mPhysicsProxy.SetUserData (this);
               
               if ( ! IsHollow () )
                  mWorld.mPhysicsEngine.AddConcavePolygonToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayPoints, params);
               
            // border
               
               var borderThickness:uint = GetBorderThickness ();
               
               if (borderThickness > 1)
               {
                  borderThickness = borderThickness - 1.0;
                  var halfThickness:Number = borderThickness * 0.5;
                  
                  if (GetVertexPointsCount () > 0)
                     mWorld.mPhysicsEngine.AddCircleToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayPoints [0].x, displayPoints [0].y, halfThickness, params);
                  for (i = 1; i < mLocalPoints.length; ++ i)
                  {
                     mWorld.mPhysicsEngine.AddLineSegmentToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayPoints [i - 1].x, displayPoints [i - 1].y, displayPoints [i].x, displayPoints [i].y, borderThickness, params);
                     mWorld.mPhysicsEngine.AddCircleToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayPoints [i].x, displayPoints [i].y, halfThickness, params);
                  }
                  if (GetVertexPointsCount () > 2)
                     mWorld.mPhysicsEngine.AddLineSegmentToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayPoints [displayPoints.length - 1].x, displayPoints [displayPoints.length - 1].y, displayPoints [0].x, displayPoints [0].y, borderThickness, params);
               }
            }
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
            GraphicsUtil.DrawPolygon (mBackgroundShape, mLocalPoints, borderColor, -1, drawBg, filledColor);
         }
         
         GraphicsUtil.Clear (mBorderShape);
         mBorderShape.alpha = GetBorderTransparency () * 0.01;
         if (drawBorder)
         {
            if (GetVertexPointsCount () == 2)
            {
               GraphicsUtil.DrawLine (mBorderShape, mLocalPoints[0].x, mLocalPoints[0].y, mLocalPoints[1].x, mLocalPoints[1].y, borderColor, borderThickness);
            }
            else
            {
               GraphicsUtil.DrawPolygon (mBorderShape, mLocalPoints, borderColor, borderThickness, false, filledColor);
            }
         }
      }
      
   }
   
}
