
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
      
      protected var mIsStatic:Boolean = true;
      protected var mLinearDamping:Number = 0.0;
      protected var mAngularDamping:Number = 0.0;
      protected var mIsBullet:Boolean = false;
      
      protected var mDensity:Number = 1.0;
      protected var mFriction:Number = 0.2;
      protected var mRestitution:Number = 0.2;
      protected var mIsSensor:Boolean = false;
      
   // collison friends
      
      protected var mFriends:Array = new Array ();
      
      
      public function EntityShape (world:World)
      {
         super (world);
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
