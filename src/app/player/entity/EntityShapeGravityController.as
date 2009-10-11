
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
      private var mGravityAcceleration:Number = Define.DefaultGravityAcceleration;
      private var mGravityAngle:Number = Math.PI * 0.5;
      
      //private var mIsInteractive:Boolean = true;
      
      private var mInteractiveZones:int = 1 << Define.GravityController_InteractiveZone_AllArea;
      
      public var mInteractiveConditions:int = 0;
      
      private var mLastRotation:Number
      
      private var mTextG:Bitmap = null;
      
      private var mInteractiveZonesParams:Array = null;
      
      // 
      private var mInteractive:Boolean = false;
      
      public function EntityShapeGravityController (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
         
      // 
         
      }
      
      override protected function DestroyInternal ():void
      {
         super.DestroyInternal ();
         
         if (mInteractiveZones != 0)
         {
            removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseMove);
            removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
            removeEventListener (MouseEvent.MOUSE_UP, OnMouseMove);
         }
      }
      
      public function SetInteractiveZones (zoneFlags:uint):void
      {
         mInteractiveZones = zoneFlags;
      }
      
      public function GetInteractiveZones ():uint
      {
         return mInteractiveZones;
      }
      
      public function IsZoneInteractive (zoneId:uint):Boolean
      {
         return (mInteractiveZones & (1 << zoneId)) != 0;
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         super.UpdateInternal (dt);
         
         // parent is a ShapeContainer, which is a child of mWorld
         var nowRotation:Number = mGravityAngle + (rotation + parent.rotation) * Math.PI / 180.0;
         
         if (mLastRotation != nowRotation)
         {
            mLastRotation = nowRotation;
            mWorld.mPhysicsEngine.SetGravityByScaleAndAngle (mGravityAcceleration, mLastRotation);
         }
         
         var lastInteractive:Boolean = mInteractive;
         mInteractive = ! (mInteractiveConditions == 1 && mWorld.mPhysicsEngine.GetActiveMovableBodiesCount (true) > 0);
         if (mInteractive != lastInteractive)
            RebuildAppearance ();
      }
      
      private function UpdateInteractiveZonesParams ():void
      {
         if (mInteractiveZonesParams == null)
            mInteractiveZonesParams = new Array (Define.GravityController_InteractiveZonesCount);
            
         var outerRadius:Number = mRadius - Define.GravityControllerZeroRegionRadius;
         if (outerRadius < Define.GravityControllerZeroRegionRadius + Define.GravityControllerZeroRegionRadius)
            outerRadius = Define.GravityControllerZeroRegionRadius + Define.GravityControllerZeroRegionRadius;
         
         // isEnabled?, centerX, centerY, radius, g, gAngle
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_AllArea] = [IsZoneInteractive (Define.GravityController_InteractiveZone_AllArea), 0, 0, mRadius, 0, 0];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Up]     = [IsZoneInteractive (Define.GravityController_InteractiveZone_Up), 0, -outerRadius, Define.GravityControllerZeroRegionRadius, Define.DefaultGravityAcceleration, - Math.PI * 0.5];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Down]   = [IsZoneInteractive (Define.GravityController_InteractiveZone_Down), 0, outerRadius, Define.GravityControllerZeroRegionRadius, Define.DefaultGravityAcceleration, Math.PI * 0.5];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Left]   = [IsZoneInteractive (Define.GravityController_InteractiveZone_Left), -outerRadius, 0, Define.GravityControllerZeroRegionRadius, Define.DefaultGravityAcceleration, Math.PI];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Right]  = [IsZoneInteractive (Define.GravityController_InteractiveZone_Right), outerRadius, 0, Define.GravityControllerZeroRegionRadius, Define.DefaultGravityAcceleration, 0];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Center] = [IsZoneInteractive (Define.GravityController_InteractiveZone_Center), 0, 0, Define.GravityControllerZeroRegionRadius, 0, Math.PI * 0.5];
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         // remved from v1.05
         /////mIsInteractive = params.mIsInteractive;
         
         // added from v1.05
         SetInteractiveZones (params.mInteractiveZones);
         mInteractiveConditions = params.mInteractiveConditions;
         
         //mGravityAcceleration = ValueAdjuster.AdjustInitialGravityAcceleration (params.mInitialGravityAcceleration);
         mGravityAcceleration = params.mInitialGravityAcceleration;
         mGravityAngle = params.mInitialGravityAngle * Math.PI / 180.0;
         
         mLastRotation = mGravityAngle + rotation * Math.PI / 180.0;
         
         mWorld.mPhysicsEngine.SetGravityByScaleAndAngle (mGravityAcceleration, mLastRotation);
         
         if (mInteractiveZones != 0)
         {
            addEventListener (MouseEvent.MOUSE_DOWN, OnMouseMove);
            addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
            addEventListener (MouseEvent.MOUSE_UP, OnMouseMove);
         }
         
         mInteractive = false;
         
         UpdateInteractiveZonesParams ();
         
         if (updateAppearance)
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
         
         var interactiveDownColor:uint = 0x6060FF;
         var unInteractiveColor:uint = 0xA0A0A0;
         
         var bandColor:uint = mInteractive && IsZoneInteractive (Define.GravityController_InteractiveZone_AllArea) ? interactiveDownColor : unInteractiveColor;
         
         alpha = 0.85;
         
         var radius_0b:Number = Define.GravityControllerZeroRegionRadius;
         //if (radius_0b > mRadius)
         //   radius_0b = mRadius;
         var radius_1a:Number = mRadius - Define.GravityControllerOneRegionThinkness;
         if (radius_1a < radius_0b)
            radius_1a = radius_0b;
         var radius_1b:Number = mRadius;
         if (radius_1b < radius_1a)
            radius_1b = radius_1a;
         
         GraphicsUtil.Clear (this);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_1b, borderColor, borderSize, true, bandColor);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_1a, borderColor, 1, true, 
                        IsZoneInteractive (Define.GravityController_InteractiveZone_AllArea) && mInteractive ? interactiveDownColor : unInteractiveColor);
         //GraphicsUtil.DrawCircle (this, 0, 0, radius_0b, borderColor, 1, true, filledColor);
         
         var params:Array;
         if (mInteractiveZonesParams == null)
            UpdateInteractiveZonesParams ();
         
         for (var i:int = Define.GravityController_InteractiveZone_Up; i <= Define.GravityController_InteractiveZone_Center; ++ i)
         {
            params = mInteractiveZonesParams [i];
            if (params [0])
            {
               GraphicsUtil.DrawCircle (this, params [1], params[2], params [3], mBorderColor, 1, true, 
                              mInteractive ? interactiveDownColor : unInteractiveColor);
            }
         }
         
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
         
         event.stopPropagation ();
      }
      
      private function UpdateGravity (offsetX:Number, offsetY:Number):void
      {
         if (! mInteractive)
            return;
         
      // ...
         
         var zoneId:int;
         var params:Array;
         var dx:Number;
         var dy:Number;
         for (zoneId = Define.GravityController_InteractiveZone_Center; zoneId >= 0; -- zoneId)
         {
            params = mInteractiveZonesParams [zoneId];
            if (params [0])
            {
               dx = params [1] - offsetX;
               dy = params [2] - offsetY;
               if ( Math.sqrt (dx * dx + dy * dy) < params  [3] )
               {
                  break;
               }
            } 
         }
         
         if (zoneId < 0)
            return;
         
         if (zoneId > Define.GravityController_InteractiveZone_AllArea)
         {
            mGravityAcceleration = params [4];
            mGravityAngle = params [5];
         }
         else
         {
            mGravityAngle = Math.atan2 (offsetY, offsetX);
            
            var length:Number = Math.sqrt (offsetX * offsetX + offsetY * offsetY);
            
            if (length <= Define.GravityControllerZeroRegionRadius)
               mGravityAcceleration = 0;
            else if (length >= mRadius - Define.GravityControllerOneRegionThinkness)
               mGravityAcceleration = Define.DefaultGravityAcceleration;
            else
               mGravityAcceleration = Define.DefaultGravityAcceleration * (length - Define.GravityControllerZeroRegionRadius) / (mRadius - Define.GravityControllerOneRegionThinkness - Define.GravityControllerZeroRegionRadius);
         }
         
         mGravityAcceleration = MathUtil.GetClipValue (mGravityAcceleration, 0, Define.DefaultGravityAcceleration * length);
         
         mLastRotation = mGravityAngle + (rotation + parent.rotation) * Math.PI / 180.0;
         
         mWorld.mPhysicsEngine.SetGravityByScaleAndAngle (mGravityAcceleration, mLastRotation);
         
         RebuildAppearance ();
      }
   }
}
