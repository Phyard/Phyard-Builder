
package player.entity {
   
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShapePolygon;
   
   import common.Define;
   
   public class EntityShapeRectangle extends EntityShape
   {
      
      protected var mHalfWidth:Number = 0;
      protected var mHalfHeight:Number = 0;
      
      public function EntityShapeRectangle (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
      }
      
      public function GetWidth ():Number
      {
         return mHalfWidth * 2.0;
      }
      
      public function GetHeight ():Number
      {
         return mHalfHeight * 2.0;
      }
      
      override public function BuildFromParams (params:Object):void
      {
         super.BuildFromParams (params);
         
         //
         
         mHalfWidth = params.mHalfWidth;
         mHalfHeight = params.mHalfHeight;
         
         var displayX:Number = params.mPosX;
         var displayY:Number = params.mPosY;
         var rot:Number = params.mRotation;
         
         var containerPosition:Point = mShapeContainer.GetPosition ();
         displayX -= containerPosition.x;
         displayY -= containerPosition.y;
         
         if (IsPhysicsEntity ())
         {
            var cos:Number = Math.cos (rot);
            var sin:Number = Math.sin (rot);
            
            var displayPoints:Array = new Array ();
            var tx:Number;
            var ty:Number;
            
            tx = - mHalfWidth; ty = - mHalfHeight; displayPoints [0] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            tx =   mHalfWidth; ty = - mHalfHeight; displayPoints [1] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            tx =   mHalfWidth; ty =   mHalfHeight; displayPoints [2] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            tx = - mHalfWidth; ty =   mHalfHeight; displayPoints [3] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            
            if (IsPhysicsEntity () && mPhysicsProxy == null)
            {
               mPhysicsProxy  = mWorld.mPhysicsEngine.CreateProxyShapeConvexPolygon (
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
         var filledColor:uint = GetFilledColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();
         
         borderThickness = 1;
         
         alpha = GetTransparency () * 0.01;
         
         if (drawBg || drawBorder)
            GraphicsUtil.ClearAndDrawRect (this, 
                                          - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, 
                                          borderColor, borderThickness, drawBg, filledColor);
         
         if (Define.IsBombShape (GetShapeAiType ()))
         {
            GraphicsUtil.DrawRect (this, - mHalfWidth * 0.5, - mHalfHeight * 0.5, mHalfWidth, mHalfHeight, 0x808080, 0, true, 0x808080);
         }
      }

      
      
   }
   
}
