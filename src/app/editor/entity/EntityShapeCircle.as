
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class EntityShapeCircle extends EntityShape 
   {
   // geom
      
      public var mRadius:Number;
      
      // ball
      // wheel
      public var mAppearanceType:int;
      
      public function EntityShapeCircle (world:World)
      {
         super (world);
         
         SetRadius (0.0);
      }
      
      override public function UpdateAppearance ():void
      {
         var borderColor:uint;
         var borderSize :int;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = mDrawBorder ? mBorderColor : mFilledColor;
            borderSize  = mDrawBorder ? 1 : 0;
         }
         
         alpha = 0.5;
         
         GraphicsUtil.ClearAndDrawEllipse (this, - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, borderColor, borderSize, true, mFilledColor);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle ( GetRotation (), GetPositionX (), GetPositionY (), GetRadius () );
      }
      
      
      public function SetRadius (radius:Number):void
      {
         mRadius = radius;
      }
      
      public function GetRadius ():Number
      {
         return mRadius;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityShapeCircle (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var cirlce:EntityShapeCircle = entity as EntityShapeCircle;
         cirlce.SetRadius ( GetRadius () );
         cirlce.UpdateAppearance ();
         cirlce.UpdateSelectionProxy ();
      }
      
      
//====================================================================
//   move, rotate, scale
//====================================================================
      
      override public function ScaleSelf (ratio:Number):void
      {
         var radius:Number = mRadius * ratio;
         
         if (radius > EditorSetting.MaxCircleRadium)
            radius =  EditorSetting.MaxCircleRadium;
         if (radius < EditorSetting.MinCircleRadium)
            radius =  EditorSetting.MinCircleRadium;
         
         SetRadius (radius);
      }
      
      
      
   }
}
