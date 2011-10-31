
package editor.entity {

   import flash.display.Sprite;

   import editor.world.World;

   import editor.selection.SelectionProxy;

   import common.Define;

   public class EntityVectorShape extends EntityShape
   {
   // C.I.

      protected var mAiType:int = Define.ShapeAiType_Unknown;

   // appearance

      protected var mDrawBorder:Boolean = true;
      protected var mDrawBackground:Boolean = true;

      protected var mBorderColor:uint = Define.BorderColorUnselectedObject;
      protected var mBorderThickness:uint = 1; // from v1.04
      protected var mBorderTransparency:uint = 100; // from v1.05

      protected var mFilledColor:uint = 0xFFFFFF;

      protected var mTransparency:uint = 100; // from v1.04

   // geometry

      //>> form v1.05
      protected var mIsHollow:Boolean = false;
      //<<

      //>> v1.08
      protected var mBuildBorder:Boolean = true;
      //<<

//====================================================================
//
//====================================================================

      public function EntityVectorShape (world:World)
      {
         super (world);
      }

      override public function GetVisibleAlpha ():Number
      {
         return 0.39 + GetTransparency () * 0.01 * 0.40;
      }

      override public function GetTypeName ():String
      {
         return "Shape";
      }

//====================================================================
//   clone
//====================================================================

      // to override
      override protected function CreateCloneShell ():Entity
      {
         return null;
      }

      // to override
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var shape:EntityVectorShape = entity as EntityVectorShape;

         shape.SetAiType (mAiType);

         shape.SetFilledColor ( GetFilledColor () );
         shape.SetBorderColor ( GetBorderColor () );
         shape.SetDrawBorder ( IsDrawBorder () );
         shape.SetDrawBackground ( IsDrawBackground () );
         shape.SetBorderThickness (mBorderThickness);
         shape.SetTransparency (mTransparency);
         shape.SetBorderTransparency (GetBorderTransparency ());

         shape.SetPhysicsEnabled (mPhysicsEnabled);
         shape.mDensity = mDensity;
         shape.mFriction = mFriction;
         shape.mRestitution = mRestitution;
         shape.mIsSensor = mIsSensor;

         shape.SetCollisionCategoryIndex ( GetCollisionCategoryIndex () );

         shape.SetHollow (IsHollow ());
         shape.SetBuildBorder (IsBuildBorder ());

         shape.SetLinearVelocityMagnitude (GetLinearVelocityMagnitude ());
         shape.SetLinearVelocityAngle (GetLinearVelocityAngle ());
         shape.SetAngularVelocity (GetAngularVelocity ());
         shape.SetLinearDamping (GetLinearDamping ());
         shape.SetAngularDamping (GetAngularDamping ());

         shape.SetAllowSleeping (IsAllowSleeping ());
         shape.SetFixRotation (IsFixRotation ());
      }

//======================================================
// C.I. special
//======================================================

      public function GetAiType ():int
      {
         return mAiType;
      }

      public function SetAiType (aiType:int):void
      {
         mAiType = aiType;
      }

//======================================================
// appearance
//======================================================

      public function SetDrawBackground (draw:Boolean):void
      {
         mDrawBackground = draw;
      }

      public function IsDrawBackground ():Boolean
      {
         return mDrawBackground;
      }

      public function SetFilledColor (color:uint):void
      {
         mFilledColor = color;
      }

      public function GetFilledColor ():uint
      {
         return mFilledColor;
      }

      public function SetDrawBorder (draw:Boolean):void
      {
         var needUpdateArrearance:Boolean = (mDrawBorder != draw);

         mDrawBorder = draw;

         //if (needUpdateArrearance)
         //   UpdateAppearance ();
      }

      public function IsDrawBorder ():Boolean
      {
         return mDrawBorder;
      }

      public function SetBorderColor (color:uint):void
      {
         mBorderColor = color;
      }

      public function GetBorderColor ():uint
      {
         return mBorderColor;
      }

      public function SetBorderThickness (thinkness:uint):void
      {
         mBorderThickness = thinkness;
      }

      public function GetBorderThickness ():Number
      {
         if (mBorderThickness < 0)
            return 0;

         return mBorderThickness;
      }

      public function SetTransparency (transparency:uint):void
      {
         mTransparency = transparency;
      }

      public function GetTransparency ():uint
      {
         return mTransparency;
      }

      public function SetBorderTransparency (transparency:uint):void
      {
         mBorderTransparency = transparency;
      }

      public function GetBorderTransparency ():uint
      {
         return mBorderTransparency;
      }

//======================================================
// physics
//======================================================

      public function SetHollow (hollow:Boolean):void
      {
         mIsHollow = hollow;
      }

      public function IsHollow ():Boolean
      {
         return mIsHollow;
      }

      public function SetBuildBorder (build:Boolean):void
      {
         mBuildBorder = build;
      }

      public function IsBuildBorder ():Boolean
      {
         return mBuildBorder;
      }

      override public function SetStatic (isStatic:Boolean):void
      {
         var oldIsStatic:Boolean = IsStatic ();
         
         if (oldIsStatic && ! isStatic && mAiType == Define.ShapeAiType_Static)
         {
            SetAiType (Define.ShapeAiType_Movable);
            SetFilledColor (Define.ColorMovableObject);
            SetDrawBorder (true);
            UpdateAppearance ();
         }

         if (! oldIsStatic && isStatic && mAiType == Define.ShapeAiType_Movable)
         {
            SetAiType (Define.ShapeAiType_Static);
            SetFilledColor (Define.ColorStaticObject);
            SetDrawBorder (false);
            UpdateAppearance ();
         }

         super.SetStatic (isStatic);
      }

   }
}
