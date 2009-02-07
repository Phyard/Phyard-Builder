
package player.entity {
   
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import flash.events.MouseEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.util.MathUtil;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShapeCircle;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class EntityShapeGravityController extends EntityShapeCircle
   {
      private var mIsInteractive:Boolean = true;
      private var mGravityAcceleration:Number = Define.DefaultGravityAcceleration;
      private var mGravityAngle:Number = Math.PI * 0.5;
      
      private var mLastRotation:Number
      
      private var mTextG:Bitmap = null;
      
      public function EntityShapeGravityController (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
         
      // 
         
      }
      
      override public function Update (dt:Number):void
      {
         super.Update (dt);
         
         // parent is a ShapeContainer, which is a child a mWorld
         var nowRotation:Number = mGravityAngle + (rotation + parent.rotation) * Math.PI / 180.0;
         
         if (mLastRotation != nowRotation)
         {
            mLastRotation = nowRotation;
            mWorld.mPhysicsEngine.SetGravityByScaleAndAngle (mGravityAcceleration, mLastRotation);
         }
      }
      
      override public function BuildFromParams (params:Object):void
      {
         super.BuildFromParams (params);
         
         mIsInteractive = params.mIsInteractive;
         mGravityAcceleration = ValueAdjuster.AdjustInitialGravityAcceleration (params.mInitialGravityAcceleration);
         mGravityAngle = params.mInitialGravityAngle * Math.PI / 180.0;
         
         mLastRotation = mGravityAngle + rotation * Math.PI / 180.0;
         
         mWorld.mPhysicsEngine.SetGravityByScaleAndAngle (mGravityAcceleration, mLastRotation);
         
         if (mIsInteractive)
         {
            addEventListener (MouseEvent.MOUSE_DOWN, OnMouseMove);
            addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
            addEventListener (MouseEvent.MOUSE_UP, OnMouseMove);
         }
         
         RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
      // .
         if (mTextG == null)
         {
            var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='9'><i>g</i></font>", false, 0xFFFFFF, 0x0);
            
            mTextG = DisplayObjectUtil.CreateCacheDisplayObject (textField);
            
            addChild (mTextG);
            
            mTextG.x = - mTextG.width * 0.5;
            mTextG.y = - mTextG.height * 0.5 - 2;
         }
         
      // .
         var filledColor:uint = Define.GetShapeFilledColor (mAiType);
         var borderColor:uint = Define.ColorObjectBorder;
         var borderSize :int = 1;
         
         var bandColor:uint = mIsInteractive ? Define.ColorMovableObject : Define.ColorStaticObject;
         
         alpha = 0.7;
         
         var radius_0b:Number = Define.GravityControllerZeroRegionRadius;
         if (radius_0b > mRadius)
            radius_0b = mRadius;
         var radius_1a:Number = mRadius - Define.GravityControllerOneRegionThinkness;
         if (radius_1a < radius_0b)
            radius_1a = radius_0b;
         var radius_1b:Number = mRadius;
         if (radius_1b < radius_1a)
            radius_1b = radius_1a;
         
         GraphicsUtil.Clear (this);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_1b, borderColor, borderSize, true, bandColor);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_1a, borderColor, 1, true, filledColor);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_0b, borderColor, 1, true, filledColor);
         
         var direction:Number = mGravityAngle;
         var acceleration:Number;
         var gx0:Number;
         var gy0:Number;
         var gx1:Number;
         var gy1:Number;
         if (radius_1a > radius_0b)
         {
            gx0 = radius_0b * Math.cos (direction);
            gy0 = radius_0b * Math.sin (direction);
            acceleration = radius_0b + (radius_1a - radius_0b) * mGravityAcceleration / Define.DefaultGravityAcceleration;
            gx1 = acceleration * Math.cos (direction);
            gy1 = acceleration * Math.sin (direction);
         }
         else
         {
            gx0 = 0;
            gy0 = 0;
            acceleration = mRadius * mGravityAcceleration / Define.DefaultGravityAcceleration;
            gx1 = acceleration * Math.cos (direction);
            gy1 = acceleration * Math.sin (direction);
         }
         GraphicsUtil.DrawLine (this, gx0, gy0, gx1, gy1);
      }
      
      protected function OnMouseMove (event:MouseEvent):void
      {
         if (event.buttonDown)
            UpdateGravity (event.localX, event.localY);
      }
      
      private function UpdateGravity (offsetX:Number, offsetY:Number):void
      {
         mGravityAngle = Math.atan2 (offsetY, offsetX);
         
         var length:Number = Math.sqrt (offsetX * offsetX + offsetY * offsetY);
         
         if (length <= Define.GravityControllerZeroRegionRadius)
            mGravityAcceleration = 0;
         else if (length >= mRadius - Define.GravityControllerOneRegionThinkness)
            mGravityAcceleration = Define.DefaultGravityAcceleration;
         else
            mGravityAcceleration = Define.DefaultGravityAcceleration * (length - Define.GravityControllerZeroRegionRadius) / (mRadius - Define.GravityControllerOneRegionThinkness - Define.GravityControllerZeroRegionRadius);
         
         mGravityAcceleration = MathUtil.GetClipValue (mGravityAcceleration, 0, Define.DefaultGravityAcceleration * length);
         
         mLastRotation = mGravityAngle + rotation * Math.PI / 180.0;
         
         mWorld.mPhysicsEngine.SetGravityByScaleAndAngle (mGravityAcceleration, mLastRotation);
         
         RebuildAppearance ();
      }
   }
}
