
package editor.entity {

   import flash.display.Sprite;
   import flash.display.Bitmap;

   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;

   import editor.world.World;

   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;



   import common.Define;
   import common.ValueAdjuster;

   public class EntityVectorShapeGravityController extends EntityVectorShapeCircle
   {
      private var mMaximalGravityAcceleration:Number;
      private var mInitialGravityAcceleration:Number;
      private var mInitialGravityAngle:int;

      //private var mIsInteractive:Boolean = true;

      private var mInteractiveZones:int = 1 << Define.GravityController_InteractiveZone_AllArea;

      public var mInteractiveConditions:int = 0; // currently, only one condition: "when all independent bodies are stopped"

      private var mTextG:Bitmap = null;

      private var mInteractiveZonesParams:Array = null;

      public function EntityVectorShapeGravityController (world:World)
      {
         super (world);

         mMaximalGravityAcceleration = mWorld.GetDefaultGravityAccelerationMagnitude ();
         mInitialGravityAcceleration = mMaximalGravityAcceleration;
         mInitialGravityAngle = mWorld.GetDefaultGravityAccelerationAngle ();
      }

      override public function GetVisibleAlpha ():Number
      {
         return 0.70;
      }

      override public function IsBasicShapeEntity ():Boolean
      {
         return false;
      }

      override public function GetTypeName ():String
      {
         return "Gravity Controller";
      }

      override public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }

      //public function SetInteractive (interactive:Boolean):void
      //{
      //   mIsInteractive = interactive;
      //}
      //
      //public function IsInteractive ():Boolean
      //{
      //   return mIsInteractive;
      //}

      public function SetInteractiveZones (zoneFlags:uint):void
      {
         mInteractiveZones = zoneFlags;

         UpdateInteractiveZonesParams ();
      }

      public function GetInteractiveZones ():uint
      {
         return mInteractiveZones;
      }

      public function IsZoneInteractive (zoneId:uint):Boolean
      {
         return (mInteractiveZones & (1 << zoneId)) != 0;
      }

      public function SetInitialGravityAcceleration (ga:Number):void
      {
         if (ga < 0)
            ga = 0.0;

         mInitialGravityAcceleration = ga;
      }

      public function GetInitialGravityAcceleration ():Number
      {
         if (mInitialGravityAcceleration > mMaximalGravityAcceleration)
            mInitialGravityAcceleration = mMaximalGravityAcceleration;

         return mInitialGravityAcceleration;
      }

      public function SetMaximalGravityAcceleration (ga:Number):void
      {
         if (ga < 0)
            ga = 0.0;

         mMaximalGravityAcceleration = ga;
      }

      public function GetMaximalGravityAcceleration ():Number
      {
         return mMaximalGravityAcceleration;
      }

      public function SetInitialGravityAngle (angle:Number):void
      {
         mInitialGravityAngle = angle % 360.0;
      }

      public function GetInitialGravityAngle ():Number
      {
         return mInitialGravityAngle;
      }

      override public function UpdateAppearance ():void
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
         var allAeraInteractive:Boolean = IsZoneInteractive (Define.GravityController_InteractiveZone_AllArea);
         var backgroundColor:uint = allAeraInteractive ? Define.kInteractiveColor : Define.kUninteractiveColor;
         var lightBackgroundColor:uint = GraphicsUtil.BlendColor (backgroundColor, 0xFFFFFF, allAeraInteractive ? 0.5 : 0.5);
         var lightInteractiveBackgroundColor:uint = GraphicsUtil.BlendColor (Define.kInteractiveColor, 0xFFFFFF, 0.75);

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
         GraphicsUtil.DrawCircle (this, 0, 0, radius_1b, 0x0, 1, true, backgroundColor);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_1a, 0x0,-1, true, lightBackgroundColor);

         if ( IsSelected () )
         {
            var borderColor:uint = Define.BorderColorSelectedObject;
            var borderSize :int  = 3;

            borderSize /= mWorld.GetZoomScale ();

            GraphicsUtil.DrawCircle (this, 0, 0, radius_1b, borderColor, borderSize, false);
         }

         var params:Array;
         if (mInteractiveZonesParams == null)
            UpdateInteractiveZonesParams ();

         var outerRadius:Number = mRadius - Define.GravityControllerZeroRegionRadius;
         if (outerRadius < Define.GravityControllerZeroRegionRadius + Define.GravityControllerZeroRegionRadius)
            outerRadius = Define.GravityControllerZeroRegionRadius + Define.GravityControllerZeroRegionRadius;

         for (var i:int = Define.GravityController_InteractiveZone_Up; i <= Define.GravityController_InteractiveZone_Center; ++ i)
         {
            params = mInteractiveZonesParams [i];
            if (IsZoneInteractive (i))
            {
               GraphicsUtil.DrawCircle (this, params [0] * outerRadius, params[1] * outerRadius, params [2], 0x0, 1, true, lightInteractiveBackgroundColor);
            }
         }

         var direction:Number = mInitialGravityAngle * Define.kDegrees2Radians;
         var acceleration:Number;
         var gx0:Number;
         var gy0:Number;
         var gx1:Number;
         var gy1:Number;
         if (radius_1a > radius_0b)
         {
            gx0 = radius_0b * Math.cos (direction);
            gy0 = radius_0b * Math.sin (direction);
            acceleration = radius_0b + (radius_1a - radius_0b) * mInitialGravityAcceleration / mMaximalGravityAcceleration;
            gx1 = acceleration * Math.cos (direction);
            gy1 = acceleration * Math.sin (direction);
         }
         else
         {
            gx0 = 0;
            gy0 = 0;
            acceleration = mRadius * mInitialGravityAcceleration / mMaximalGravityAcceleration;
            gx1 = acceleration * Math.cos (direction);
            gy1 = acceleration * Math.sin (direction);
         }
         GraphicsUtil.DrawLine (this, gx0, gy0, gx1, gy1);

         if ( IsZoneInteractive (Define.GravityController_InteractiveZone_Up) )
         {
         }
      }

      private function UpdateInteractiveZonesParams ():void
      {
         if (mInteractiveZonesParams == null)
            mInteractiveZonesParams = new Array (Define.GravityController_InteractiveZonesCount);

         var outerRadius:Number = mRadius - Define.GravityControllerZeroRegionRadius;
         if (outerRadius < Define.GravityControllerZeroRegionRadius + Define.GravityControllerZeroRegionRadius)
            outerRadius = Define.GravityControllerZeroRegionRadius + Define.GravityControllerZeroRegionRadius;

         // isEnabled?, centerX, centerY, radius
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_AllArea] = [0, 0, 0];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Up]      = [0, -1, Define.GravityControllerZeroRegionRadius];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Down]    = [0, 1, Define.GravityControllerZeroRegionRadius];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Left]    = [- 1, 0, Define.GravityControllerZeroRegionRadius];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Right]   = [  1, 0, Define.GravityControllerZeroRegionRadius];
         mInteractiveZonesParams [Define.GravityController_InteractiveZone_Center]  = [0, 0, Define.GravityControllerZeroRegionRadius];
      }

//====================================================================
//   clone
//====================================================================

      // only one gc most in a scene
      override protected function CreateCloneShell ():Entity
      {
         return new EntityVectorShapeGravityController (mWorld);
      }

      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var gravityController:EntityVectorShapeGravityController = entity as EntityVectorShapeGravityController;

         gravityController.mInteractiveConditions = mInteractiveConditions;
         gravityController.SetInteractiveZones (GetInteractiveZones ());
         gravityController.SetInitialGravityAcceleration (GetInitialGravityAcceleration ());
         gravityController.SetMaximalGravityAcceleration (GetMaximalGravityAcceleration ());
         gravityController.SetInitialGravityAngle (GetInitialGravityAngle ());
      }

//====================================================================
//   flip
//====================================================================

      override public function FlipSelfHorizontally ():void
      {
         //SetRotation (Math.PI + Math.PI - GetRotation () );
         SetRotation (Math.PI - (GetRotation () - Math.PI * 0.5) + Math.PI * 0.5 );
      }

      override public function FlipSelfVertically ():void
      {
         SetRotation (Math.PI + Math.PI - (GetRotation () - Math.PI * 0.5) + Math.PI * 0.5 );
      }

//====================================================================
//
//====================================================================

   }
}
