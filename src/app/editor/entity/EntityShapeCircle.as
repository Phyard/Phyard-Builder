
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Config;
   
   public class EntityShapeCircle extends EntityShape 
   {
   // geom
      
      public var mRadius:Number;
      
      // ball
      // wheel
      protected var mAppearanceType:int = Define.CircleAppearanceType_Ball;
      
      public function EntityShapeCircle (world:World)
      {
         super (world);
         
         SetRadius (0.0);
      }
      
      override public function GetTypeName ():String
      {
         return "Circle";
      }
      
      override public function GetInfoText ():String
      {
         return super.GetInfoText () + ", radius = " + ValueAdjuster.AdjustCircleRadius (GetRadius (), Config.VersionNumber);
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
            //borderColor = IsDrawBorder () ? mBorderColor : mFilledColor;
            //borderSize  = IsDrawBorder () ? 1 : 0;
            
            borderColor = mBorderColor;
            borderSize = 1;
         }
         
         alpha = 0.7;
         
         GraphicsUtil.ClearAndDrawEllipse (this, - mRadius, - mRadius, mRadius + mRadius, mRadius + mRadius, borderColor, borderSize, true, mFilledColor);
         
         if (mAppearanceType == Define.CircleAppearanceType_Ball)
         {
            var pos:Number;
            if (GetFilledColor () == Define.ColorBombObject)
            {
               pos = mRadius * 0.75 * 0.707;
               if (pos < 0) pos = 0;
               GraphicsUtil.DrawEllipse (this, pos, pos, 1, 1, 0xFFFFFF, 1, true, 0xFFFFFF);
            }
            else
            {
               pos = (mRadius * 0.66) * 0.707 - 1;
               if (pos < 0) pos = 0;
               GraphicsUtil.DrawEllipse (this, pos, pos, 1, 1, borderColor, 1, true, borderColor);
            }
         }
         else if (mAppearanceType == Define.CircleAppearanceType_Column)
         {
            var radius2:Number = mRadius * 0.5;
            GraphicsUtil.DrawEllipse (this, - radius2, - radius2, radius2 + radius2, radius2 + radius2, borderColor, 1, false, mFilledColor);
            if (GetFilledColor () == Define.ColorBombObject)
               GraphicsUtil.DrawLine (this, radius2, 0, mRadius, 0, 0x808080, 1);
            else
               GraphicsUtil.DrawLine (this, radius2, 0, mRadius, 0, borderColor, 1);
         }
         
         if (GetFilledColor () == Define.ColorBombObject)
         {
            GraphicsUtil.DrawEllipse (this, - mRadius * 0.5, - mRadius * 0.5, mRadius, mRadius, 0x808080, 0, true, 0x808080);
         }
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
      
      
      public function SetRadius (radius:Number, validate:Boolean = true):void
      {
         if (validate)
         {
            var minRadius:Number = GetFilledColor () == Define.ColorBombObject ? EditorSetting.MinBombSquareSideLength : EditorSetting.MinCircleRadium;
            var maxRadius:Number = GetFilledColor () == Define.ColorBombObject ? EditorSetting.MaxBombSquareSideLength : EditorSetting.MaxCircleRadium;
            
            if (radius > maxRadius)
               radius =  maxRadius;
            if (radius < minRadius)
               radius =  minRadius;
         }
         
         if (radius < 0)
            radius = 0;
         
         //mRadius = Math.floor (radius + 0.5);
         //>> from 1.02
         mRadius = radius;
         //<<
         
         UpdateAppearance ();
         UpdateSelectionProxy ();
      }
      
      public function GetRadius ():Number
      {
         return mRadius;
      }
      
      public function SetAppearanceType (appearanceType:int):void
      {
         mAppearanceType = appearanceType;
         
         UpdateAppearance ();
      }
      
      public function GetAppearanceType ():int
      {
         return mAppearanceType;
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
         cirlce.SetAppearanceType ( GetAppearanceType () );
         cirlce.UpdateAppearance ();
         cirlce.UpdateSelectionProxy ();
      }
      
      
//====================================================================
//   move, rotate, scale
//====================================================================
      
      override public function ScaleSelf (ratio:Number):void
      {
         var radius:Number = mRadius * ratio;
         
         SetRadius (radius);
      }
      
      
      
   }
}
