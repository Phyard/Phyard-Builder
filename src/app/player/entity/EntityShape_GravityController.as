
package player.entity {
   
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import flash.events.MouseEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.util.MathUtil;
   
   import player.world.World;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class EntityShape_GravityController extends EntityShapeCircle
   {
      
      public function EntityShape_GravityController (world:World)
      {
         super (world);
         
         SetAlpha (0.75);
         
         mDirectionShape = mBorderShape;
         mAppearanceObjectsContainer.addChild (mTextG);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mInteractiveZones != undefined)
               SetInteractiveZones (entityDefine.mInteractiveZones);
            if (entityDefine.mInteractiveConditions != undefined)
               mInteractiveConditions = entityDefine.mInteractiveConditions;
            if (entityDefine.mInitialGravityAcceleration != null)
               mGravityAcceleration = entityDefine.mInitialGravityAcceleration;
            if (entityDefine.mInitialGravityAngle != undefined)
               mGravityAngle = entityDefine.mInitialGravityAngle * Define.kDegrees2Radians;
         }
         else if (createStageId == 2)
         {
            mLastRotation = mGravityAngle + mRotation;
            
            mWorld.GetPhysicsEngine ().SetGravity (mGravityAcceleration, mLastRotation);
         }
      }
           
//=============================================================
//   
//=============================================================
      
      private var mGravityAcceleration:Number = Define.DefaultGravityAccelerationMagnitude;
      private var mGravityAngle:Number = Math.PI * 0.5;
      private var mInteractiveZones:int = 1 << Define.GravityController_InteractiveZone_AllArea;
      private var mInteractiveConditions:int = 0;
      
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
      
//=============================================================
//   mouse event
//=============================================================
      
      protected function OnMouseMove (event:MouseEvent):void
      {
         if (event.buttonDown)
         {
            UpdateGravity (event.localX, event.localY);
         }
         
         event.stopPropagation ();
      }

//=============================================================
//   
//=============================================================
      
      private var mLastRotation:Number;
      private var mInteractiveZonesParams:Array = null;
      private var mInteractive:Boolean;
      
//=============================================================
//   intialize
//=============================================================
      
      override protected function InitializeInternal ():void
      {
         super.InitializeInternal ();
         
         if (mInteractiveZones != 0)
         {
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_DOWN, OnMouseMove);
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
            mAppearanceObjectsContainer.addEventListener (MouseEvent.MOUSE_UP, OnMouseMove);
         }
         
         mInteractive = GetInteractivity ();
         UpdateInteractiveZonesParams ();
         
         var textFiled:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='9'><i>g</i></font>", false, 0xFFFFFF, 0x0);
         DisplayObjectUtil.CreateCacheDisplayObjectInBitmap (textFiled, mTextG);
         mTextG.x = - 0.5 * mTextG.width;
         mTextG.y = - 0.5 * mTextG.height - 1;
   
         mNeedUpdateAppearanceProperties = true;
         mNeedRebuildAppearanceObjects = true;
         mNeedRepaintDirection = true;
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   destroy
//=============================================================
      
      override protected function DestroyInternal ():void
      {
         if (mInteractiveZones != 0)
         {
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseMove);
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
            mAppearanceObjectsContainer.removeEventListener (MouseEvent.MOUSE_UP, OnMouseMove);
         }
         
         super.DestroyInternal ();
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
         super.UpdateInternal (dt);
         
         // parent is a ShapeContainer, which is a child of mWorld
         var nowRotation:Number = mGravityAngle + mRotation;
         
         if (mLastRotation != nowRotation)
         {
            mLastRotation = nowRotation;
            mWorld.GetPhysicsEngine ().SetGravity (mGravityAcceleration, mLastRotation);
         }
         
         var lastInteractive:Boolean = mInteractive;
         mInteractive = GetInteractivity ();
         
         if (mInteractive != lastInteractive)
         {
            mNeedUpdateAppearanceProperties = true;
            mNeedRebuildAppearanceObjects = true;
            DelayUpdateAppearance ();
         }
      }
      
      private function GetInteractivity ():Boolean
      {
         return ! (mInteractiveConditions == 1 && mWorld.GetPhysicsEngine ().GetActiveMovableBodiesCount (true) > 0);
      }
      
      private function UpdateInteractiveZonesParams ():void
      {
         if (mInteractiveZonesParams == null)
            mInteractiveZonesParams = new Array (Define.GravityController_InteractiveZonesCount);
         
         var displayRadius:Number = mWorld.PhysicsLength2DisplayLength (mRadius)
         var outerRadius:Number = displayRadius - Define.GravityControllerZeroRegionRadius;
         if (outerRadius < Define.GravityControllerZeroRegionRadius + Define.GravityControllerZeroRegionRadius)
            outerRadius = Define.GravityControllerZeroRegionRadius + Define.GravityControllerZeroRegionRadius;
         
         var gMagnidue:Number = mWorld.GetNormalGravityAccelerationMagnitude ();
         
         // isEnabled?, centerX, centerY, radius, g, gAngle
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_AllArea] = [IsZoneInteractive (Define.GravityController_InteractiveZone_AllArea), 0, 0, displayRadius, 0, 0];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Up]      = [IsZoneInteractive (Define.GravityController_InteractiveZone_Up), 0, -outerRadius, Define.GravityControllerZeroRegionRadius, gMagnidue, - Math.PI * 0.5];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Down]    = [IsZoneInteractive (Define.GravityController_InteractiveZone_Down), 0, outerRadius, Define.GravityControllerZeroRegionRadius, gMagnidue, Math.PI * 0.5];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Left]    = [IsZoneInteractive (Define.GravityController_InteractiveZone_Left), -outerRadius, 0, Define.GravityControllerZeroRegionRadius, gMagnidue, Math.PI];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Right]   = [IsZoneInteractive (Define.GravityController_InteractiveZone_Right), outerRadius, 0, Define.GravityControllerZeroRegionRadius, gMagnidue, 0];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Center]  = [IsZoneInteractive (Define.GravityController_InteractiveZone_Center), 0, 0, Define.GravityControllerZeroRegionRadius, 0, Math.PI * 0.5];
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
         
         var displayRadius:Number = mWorld.PhysicsLength2DisplayLength (mRadius);
         
         if (zoneId > Define.GravityController_InteractiveZone_AllArea)
         {
            mGravityAcceleration = params [4];
            mGravityAngle = params [5];
         }
         else
         {
            mGravityAngle = Math.atan2 (offsetY, offsetX);
            
            var length:Number = Math.sqrt (offsetX * offsetX + offsetY * offsetY);
            
            var gMagnidue:Number = mWorld.GetNormalGravityAccelerationMagnitude ();
            
            if (length <= Define.GravityControllerZeroRegionRadius)
               mGravityAcceleration = 0;
            else if (length >= displayRadius - Define.GravityControllerOneRegionThinkness)
               mGravityAcceleration = gMagnidue;
            else
               mGravityAcceleration = gMagnidue * (length - Define.GravityControllerZeroRegionRadius) / (displayRadius - Define.GravityControllerOneRegionThinkness - Define.GravityControllerZeroRegionRadius);
         }
         
         mGravityAcceleration = MathUtil.GetClipValue (mGravityAcceleration, 0, gMagnidue);
         
         mLastRotation = mGravityAngle + mRotation;
         
         //mWorld.mPhysicsEngine.SetGravity (mGravityAcceleration, mLastRotation);
         // from v1.07
         mWorld.GetPhysicsEngine ().SetGravity (mGravityAcceleration, mLastRotation);
         mWorld.GetPhysicsEngine ().WakeUpAllBodies ();
         
         // 
         mNeedRepaintDirection = true;
         DelayUpdateAppearance ();
      }
      
//=============================================================
//   appearance
//=============================================================
      
      private var mInteractiveColor:uint = 0x6060FF;
      private var mUninteractiveColor:uint = 0xA0A0A0;
      
      private var mNeedRepaintDirection:Boolean = true;
      
      private var mDirectionShape:Shape; // = mBorderShape
      private var mTextG:Bitmap = new Bitmap ();
      
      override public function UpdateAppearance ():void
      {
         mAppearanceObjectsContainer.visible = mVisible
         mAppearanceObjectsContainer.alpha = mAlpha; 
         
         var displayRadius:Number = mWorld.PhysicsLength2DisplayLength (mRadius);
         var radius_0b:Number = Define.GravityControllerZeroRegionRadius;
         var radius_1a:Number = displayRadius - Define.GravityControllerOneRegionThinkness;
         if (radius_1a < radius_0b)
            radius_1a = radius_0b;
         var radius_1b:Number = displayRadius;
         if (radius_1b < radius_1a)
            radius_1b = radius_1a;
         
         var backgroundColor:uint = mInteractive && IsZoneInteractive (Define.GravityController_InteractiveZone_AllArea) ? mInteractiveColor : mUninteractiveColor;
         var lightBackgroundColor:uint = GraphicsUtil.BlendColor (backgroundColor, 0xFFFFFF, 0.5);
         
         if (mNeedRebuildAppearanceObjects)
         {  
            GraphicsUtil.ClearAndDrawCircle (
                     mBackgroundShape,
                     0,
                     0,
                     radius_1b,
                     0x0, // border color
                     1, // border thickness
                     true, // draw background
                     backgroundColor
                  );
            
            GraphicsUtil.DrawCircle (
                     mBackgroundShape,
                     0,
                     0,
                     radius_1a,
                     0x0, // border color
                     -1, // border thickness, not draw border
                     true, // draw background
                     lightBackgroundColor
                  );
                  
            var params:Array;
            if (mInteractiveZonesParams == null)
               UpdateInteractiveZonesParams ();
            
            var zoneColor:uint = mInteractive ? mInteractiveColor : mUninteractiveColor;
            for (var i:int = Define.GravityController_InteractiveZone_Up; i <= Define.GravityController_InteractiveZone_Center; ++ i)
            {
               params = mInteractiveZonesParams [i];
               if (params [0])
               {
                  GraphicsUtil.DrawCircle (
                        mBackgroundShape, 
                        params [1], 
                        params [2], 
                        params [3], 
                        0x0, // border color 
                        1, // bordr thickness
                        true, // filled
                        zoneColor
                     );
               }
            }
         }
         
         if (mNeedRepaintDirection)
         {
            mNeedRepaintDirection = false;
            
            var lineColor:uint = GraphicsUtil.GetInvertColor_b (lightBackgroundColor);
            
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
               acceleration = radius_0b + (radius_1a - radius_0b) * mGravityAcceleration / mWorld.GetNormalGravityAccelerationMagnitude ();
               gx1 = acceleration * Math.cos (direction);
               gy1 = acceleration * Math.sin (direction);
            }
            else
            {
               gx0 = 0;
               gy0 = 0;
               acceleration = displayRadius * mGravityAcceleration / mWorld.GetNormalGravityAccelerationMagnitude ();
               gx1 = acceleration * Math.cos (direction);
               gy1 = acceleration * Math.sin (direction);
            }
            
            GraphicsUtil.ClearAndDrawLine (
                  mDirectionShape, 
                  gx0, 
                  gy0, 
                  gx1, 
                  gy1,
                  lineColor,
                  1
               );
         }
      }
      
   }
}
