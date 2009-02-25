
package editor.entity {
   
   import flash.display.Sprite;
   
   
   import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityShape extends Entity 
   {
      protected var mWorld:World;
      
   // C.I.
      
      protected var mAiType:int = Define.ShapeAiType_Unknown;
      
   // appearance
   
      protected var mDrawBorder:Boolean = true;
      protected var mDrawBackground:Boolean = true;
      
      protected var mBorderColor:uint = EditorSetting.BorderColorUnselectedObject;
      protected var mBorderThickness:uint = 1; // from v1.04
      
      protected var mFilledColor:uint = 0xFFFFFF;
      
      protected var mTransparency:uint = 100; // from v1.04
      
   // physics
      
      //>> form v1.04
      protected var mPhysicsEnabled:Boolean = true;
      public var mIsSensor:Boolean = false;
      //<<
      
      protected var mIsStatic:Boolean = false;
      public var mIsBullet:Boolean = false;
      
      public var mDensity:Number = 1.0;
      public var mFriction:Number = 0.1;
      public var mRestitution:Number = 0.2;
      
      
      // !!! when open these, remember modify SetPropertiesForClonedEntity
      //public var mLinearDamping:Number = 0.0;
      //public var mAngularDamping:Number = 0.0;
      // allow sleep
      // is sleeping
      
      // isSensor
      
      // collision category
      private var mCollisionCategory:EntityCollisionCategory = null;
      
      public function EntityShape (world:World)
      {
         super (world);
         
         mWorld = world;
      }
      
      override public function GetTypeName ():String
      {
         return "Shape";
      }
      
      public function IsBasicShapeEntity ():Boolean
      {
         return true;
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
         
         var shape:EntityShape = entity as EntityShape;
         
         shape.SetAiType (mAiType);
         
         shape.SetFilledColor ( GetFilledColor () );
         shape.SetBorderColor ( GetBorderColor () );
         shape.SetDrawBorder ( IsDrawBorder () );
         shape.SetDrawBackground ( IsDrawBackground () );
         shape.SetStatic ( IsStatic () );
         shape.SetBorderThickness (mBorderThickness);
         shape.SetTransparency (mTransparency);
         
         shape.mIsBullet = mIsBullet;
         shape.mDensity = mDensity;
         shape.mFriction = mFriction;
         shape.mRestitution = mRestitution;
         shape.mIsSensor = mIsSensor;
         shape.SetPhysicsEnabled (mPhysicsEnabled);
         
         shape.SetCollisionCategoryIndex ( GetCollisionCategoryIndex () );
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
      
      public function GetBorderThickness ():uint
      {
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
      
//======================================================
// physics
//======================================================
      
      public function SetPhysicsEnabled (enabled:Boolean):void
      {
         mPhysicsEnabled = enabled;
      }
      
      public function IsPhysicsEnabled ():Boolean
      {
         return mPhysicsEnabled;
      }
      
      public function SetStatic (isStatic:Boolean):void
      {
         if (mIsStatic && ! isStatic && mFilledColor == Define.ColorStaticObject)
         {
            SetFilledColor (Define.ColorMovableObject);
            SetDrawBorder (true);
            UpdateAppearance ();
         }
         
         if (! mIsStatic && isStatic && mFilledColor == Define.ColorMovableObject)
         {
            SetFilledColor (Define.ColorStaticObject);
            SetDrawBorder (false);
            UpdateAppearance ();
         }
         
         mIsStatic = isStatic;
      }
      
      public function IsStatic ():Boolean
      {
         return mIsStatic;
      }
      
//======================================================
// collision category
//======================================================
      
      public function GetCollisionCategoryIndex ():int
      {
         var index:int = mWorld.mCollisionManager.GetCollisionCategoryIndex (mCollisionCategory);
         
         if (index == Define.CollisionCategoryId_HiddenCategory)
            mCollisionCategory = null;
         
         return index;
      }
      
      public function SetCollisionCategoryIndex (index:int):void
      {
         mCollisionCategory = mWorld.mCollisionManager.GetCollisionCategoryByIndex (index);
      }
      
      
      
   }
}
