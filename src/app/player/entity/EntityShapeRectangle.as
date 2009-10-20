
package player.entity {
   
   import flash.display.Shape;
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
      
      protected var mBackgroundShape:Shape = null;
      protected var mBorderShape:Shape = null;
      
      public function EntityShapeRectangle (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
         
         mBackgroundShape = new Shape ();
         mBorderShape = new Shape ();
         addChild (mBackgroundShape);
         addChild (mBorderShape);
      }
      
      public function GetWidth ():Number
      {
         return mHalfWidth * 2.0;
      }
      
      public function GetHeight ():Number
      {
         return mHalfHeight * 2.0;
      }
      
      public function GetPhysicsWidth ():Number
      {
         //if (mWorld.GetVersion () < 0x0105)
         //   return mHalfWidth * 2.0;
         
         var borderThickness:uint = GetBorderThickness ();
         
         if (borderThickness == 0)
            return mHalfWidth * 2.0;
         else
            return mHalfWidth * 2.0 + borderThickness - 1.0;
      }
      
      public function GetPhysicsHeight ():Number
      {
         //if (mWorld.GetVersion () < 0x0105)
         //   return mHalfHeight * 2.0;
         
         var borderThickness:uint = GetBorderThickness ();
         
         if (borderThickness == 0)
            return mHalfHeight * 2.0;
         else
            return mHalfHeight * 2.0 + borderThickness - 1.0;
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         //
         
         mHalfWidth = params.mHalfWidth;
         mHalfHeight = params.mHalfHeight;
         
         var displayX:Number = params.mPosX;
         var displayY:Number = params.mPosY;
         var rot:Number = params.mRotation;
         
         var containerPosition:Point = GetParentContainer ().GetPosition ();
         displayX -= containerPosition.x;
         displayY -= containerPosition.y;
         
         if (IsPhysicsShapeEntity ())
         {
            var cos:Number = Math.cos (rot);
            var sin:Number = Math.sin (rot);
            
            var displayPoints:Array = new Array ();
            var tx:Number;
            var ty:Number;
            
            var halfWidth:Number = GetPhysicsWidth () * 0.5;
            var halfHeight:Number = GetPhysicsHeight () * 0.5;
            
            tx = - halfWidth; ty = - halfHeight; displayPoints [0] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            tx =   halfWidth; ty = - halfHeight; displayPoints [1] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            tx =   halfWidth; ty =   halfHeight; displayPoints [2] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            tx = - halfWidth; ty =   halfHeight; displayPoints [3] = new Point ( displayX + tx * cos - ty * sin, displayY + tx * sin + ty * cos );
            
            if (IsPhysicsShapeEntity () && mPhysicsProxy == null)
            {
               mPhysicsProxy  = mWorld.mPhysicsEngine.CreateProxyShapeConvexPolygon (
                                       GetParentContainer ().mPhysicsProxy as PhysicsProxyBody, displayPoints, params);
               
               // if create hollow border, editor.rectangle.GetPhysicsShapesCount () should be modified
               
               mPhysicsProxy.SetUserData (this);
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
         
         GraphicsUtil.Clear (this);
         
         GraphicsUtil.Clear (mBackgroundShape);
         mBackgroundShape.alpha = GetTransparency () * 0.01;
         if (drawBg)
         {
            GraphicsUtil.DrawRect ( mBackgroundShape, 
                                    - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, 
                                    borderColor, -1, drawBg, filledColor);
         }
         
         GraphicsUtil.Clear (mBorderShape);
         mBorderShape.alpha = GetBorderTransparency () * 0.01;
         if (drawBorder)
         {
            GraphicsUtil.DrawRect ( mBorderShape, 
                                    - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, 
                                    borderColor, borderThickness, false, filledColor);
         }
         
         if (Define.IsBombShape (GetShapeAiType ()))
         {
            GraphicsUtil.DrawRect (mBackgroundShape, - mHalfWidth * 0.5, - mHalfHeight * 0.5, mHalfWidth, mHalfHeight, 0x808080, 0, true, 0x808080);
         }
      }
      
      
      
   }
   
}
