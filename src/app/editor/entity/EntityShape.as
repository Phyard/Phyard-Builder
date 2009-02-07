
package editor.entity {
   
   import flash.display.Sprite;
   
   
   import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityShape extends Entity 
   {
      protected var mWorld:World;
      
   // visual
      protected var mBorderColor:uint = EditorSetting.BorderColorUnselectedObject;
      
      protected var mFilledColor:uint = 0xFFFFFF;
      protected var mDrawBorder:Boolean = true;
      protected var mDrawBackground:Boolean = true;
      
      
   // physics
      
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
         shape.SetFilledColor ( GetFilledColor () );
         shape.SetBorderColor ( GetBorderColor () );
         shape.SetDrawBorder ( IsDrawBorder () );
         shape.SetDrawBackground ( IsDrawBackground () );
         shape.SetStatic ( IsStatic () );
         
         shape.mIsBullet = mIsBullet;
         shape.mDensity = mDensity;
         shape.mFriction = mFriction;
         shape.mRestitution = mRestitution;
         
         shape.SetCollisionCategoryIndex ( GetCollisionCategoryIndex () );
      }
      
      
//======================================================
// appearance
//======================================================
      
      public function GetFilledColor ():uint
      {
         return mFilledColor;
      }
      
      public function GetBorderColor ():uint
      {
         return mBorderColor;
      }
      
      public function IsDrawBorder ():Boolean
      {
         return mDrawBorder;
      }
      
      public function IsDrawBackground ():Boolean
      {
         return mDrawBackground;
      }
      
      public function SetFilledColor (color:uint):void
      {
         mFilledColor = color;
      }
      
      public function SetBorderColor (color:uint):void
      {
         mBorderColor = color;
      }
      
      public function SetDrawBorder (draw:Boolean):void
      {
         var needUpdateArrearance:Boolean = (mDrawBorder != draw);
         
         mDrawBorder = draw;
         
         //if (needUpdateArrearance)
         //   UpdateAppearance ();
      }
      
      public function SetDrawBackground (draw:Boolean):void
      {
         mDrawBackground = draw;
      }
      
//======================================================
// physics
//======================================================
      
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
