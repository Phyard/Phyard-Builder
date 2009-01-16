
package editor.entity {
   
   import flash.display.Sprite;
   
   
   import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   import editor.setting.EditorSetting;
   
   public class EntityShape extends Entity 
   {
   // visual
      
      protected var mFilledColor:uint = 0xFFFFFF;
      protected var mBorderColor:uint = EditorSetting.BorderColorUnselectedObject;
      protected var mDrawBorder:Boolean = true;
      
      
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
      
      
   // collison friends
      
      protected var mFriends:Array = new Array ();
      
      
      public function EntityShape (world:World)
      {
         super (world);
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
         shape.SetDrawBorder ( GetDrawBorder () );
         shape.SetStatic ( IsStatic () );
         
         shape.mIsBullet = mIsBullet;
         shape.mDensity = mDensity;
         shape.mFriction = mFriction;
         shape.mRestitution = mRestitution;
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
      
      public function GetDrawBorder ():Boolean
      {
         return mDrawBorder;
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
         mDrawBorder = draw;
      }
      
//======================================================
// physics
//======================================================
      
      public function SetStatic (isStatic:Boolean):void
      {
         mIsStatic = isStatic;
      }
      
      public function IsStatic ():Boolean
      {
         return mIsStatic;
      }
   }
}
