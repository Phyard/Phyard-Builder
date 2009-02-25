
package player.entity {
   
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShapePolygon;
   
   import common.Define;
   
   public class EntityShapePolygon extends EntityShape
   {
      
      protected var mLocalPoints:Array = null;
      
      public function EntityShapePolygon (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
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
      
      override public function BuildFromParams (params:Object):void
      {
         super.BuildFromParams (params);
         
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
            
            var displayPoints:Array = new Array (mLocalPoints.length);
            var tx:Number;
            var ty:Number;
            for (var i:int = 0; i < displayPoints.length; ++ i)
            {
               tx = mLocalPoints [i].x;
               ty = mLocalPoints [i].y;
               displayPoints [i] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            }
            
            if (IsPhysicsEntity () && mPhysicsProxy == null)
            {
               mPhysicsProxy  = mWorld.mPhysicsEngine.CreateProxyShapeConcavePolygon (
                                       mShapeContainer.mPhysicsProxy as PhysicsProxyBody, displayPoints, params);
               
               mPhysicsProxy.SetUserData (this);
            }
         }
         
         // for the initial pos and rot of shapeContainer are zeroes, so no need to translate to local values
         x = displayX;
         y = displayY;
         SetRotation (rot);
         
         RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
         //var filledColor:uint = Define.GetShapeFilledColor (mAiType);
         var filledColor:uint = mAiType >= 0 ? Define.GetShapeFilledColor (mAiType) : mFilledColor;
         
         var isBreakable:Boolean = Define.IsBreakableShape (mAiType);
         //var borderColor:uint = mIsStatic && ! isBreakable ? filledColor : Define.ColorObjectBorder;
         //var borderColor:uint = filledColor == Define.ColorStaticObject && ! isBreakable ? filledColor : Define.ColorObjectBorder;
         //var borderColor:uint = IsDrawBorder () ? Define.ColorObjectBorder : filledColor;
         var borderColor:uint = IsDrawBorder () ? mBorderColor : filledColor;
         
         if (GetVertexPointsCount () == 1)
         {
            GraphicsUtil.Clear (this);
         }
         else if (GetVertexPointsCount () == 2)
         {
            GraphicsUtil.ClearAndDrawLine (this, mLocalPoints[0].x, mLocalPoints[0].y, mLocalPoints[1].x, mLocalPoints[1].y, borderColor, 1);
         }
         else if (GetVertexPointsCount () > 2)
         {
            GraphicsUtil.ClearAndDrawPolygon (this, mLocalPoints, borderColor, 1, mDrawBackground, filledColor);
         }
      }

      
      
   }
   
}
