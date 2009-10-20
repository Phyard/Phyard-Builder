
package player.entity {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   
   import common.Define;
   
   public class EntityShapePolyline extends EntityShape
   {
      
      protected var mLocalPoints:Array = null;
      protected var mCurveThickness:uint = 1;
      
      protected var mLineShape:Shape = null;
      
      public function EntityShapePolyline (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
         
         mLineShape = new Shape ();
         addChild (mLineShape);
      }
      
      public function SetCurveThickness (thickness:uint):void
      {
         mCurveThickness = thickness;
      }
      
      public function GetCurveThickness ():uint
      {
         return mCurveThickness;
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
         SetCurveThickness (params.mCurveThickness);
         
         var displayX:Number = params.mPosX;
         var displayY:Number = params.mPosY;
         var rot:Number = params.mRotation;
         
         var containerPosition:Point = GetParentContainer ().GetPosition ();
         displayX -= containerPosition.x;
         displayY -= containerPosition.y;
         
         if (IsPhysicsShapeEntity () && mLocalPoints != null)
         {
            var cos:Number = Math.cos (rot);
            var sin:Number = Math.sin (rot);
            
            var displayPoints:Array = new Array (mLocalPoints.length);
            var tx:Number;
            var ty:Number;
            var i:int;
            for (i = 0; i < displayPoints.length; ++ i)
            {
               tx = mLocalPoints [i].x;
               ty = mLocalPoints [i].y;
               displayPoints [i] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            }
            
            if (mPhysicsProxy == null)
            {
               mPhysicsProxy  = mWorld.mPhysicsEngine.CreateProxyShape (GetParentContainer ().mPhysicsProxy as PhysicsProxyBody);
               
               mPhysicsProxy.SetUserData (this);
               
               var thickness:Number = GetCurveThickness ();
               
               if (thickness > 1) // if this condition changes, editor.polyline.GetPhysicsShapesCount () should be modified
               {
                  thickness = thickness - 1.0;
                  var halfThickness:Number = thickness * 0.5;
                  
                  if (GetVertexPointsCount () > 0)
                     mWorld.mPhysicsEngine.AddCircleToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayPoints [0].x, displayPoints [0].y, halfThickness, params);
                  for (i = 1; i < mLocalPoints.length; ++ i)
                  {
                     mWorld.mPhysicsEngine.AddLineSegmentToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayPoints [i - 1].x, displayPoints [i - 1].y, displayPoints [i].x, displayPoints [i].y, thickness, params);
                     mWorld.mPhysicsEngine.AddCircleToProxyShape ((mPhysicsProxy as PhysicsProxyShape), displayPoints [i].x, displayPoints [i].y, halfThickness, params);
                  }
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
      
      override public function RebuildAppearanceInternal ():void
      {
         var filledColor:uint = GetFilledColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();
         
         var curveThickness:Number = GetCurveThickness ();
         
         GraphicsUtil.Clear (this);
         
         GraphicsUtil.Clear (mLineShape);
         mLineShape.alpha = GetTransparency () * 0.01;
         
         for (var i:int = 1; i < GetVertexPointsCount (); ++ i)
         {
            GraphicsUtil.DrawLine (mLineShape, mLocalPoints [i - 1].x, mLocalPoints [i - 1].y, mLocalPoints [i].x, mLocalPoints [i].y, filledColor, curveThickness);
         }
      }

      
      
   }
   
}
