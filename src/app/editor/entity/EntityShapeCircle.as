
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
         if (mAiType == Define.ShapeAiType_Bomb)
            return "Bomb Circle";
         else
            return "Circle";
      }
      
      override public function GetInfoText ():String
      {
         return super.GetInfoText () + ", radius = " + ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().DisplayLength2PhysicsLength (GetRadius ()), 6);
      }
      
      override public function GetPhysicsShapesCount ():uint
      {
         return IsPhysicsEnabled () ? 1 : 0;
      }
      
      override public function UpdateAppearance ():void
      {
         var filledColor:uint = GetFilledColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();
         
         if (mAiType >= 0)
         {
            filledColor =  Define.GetShapeFilledColor (mAiType);
            borderColor = Define.ColorObjectBorder;
            drawBg = true;
         }
         
         if ( ! drawBorder)
         {
            drawBg = true;
            borderThickness = -1;
         }
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            if (borderThickness * mWorld.GetZoomScale () < 3)
               borderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         alpha = 0.30 + GetTransparency () * 0.01 * 0.40;
         
         GraphicsUtil.ClearAndDrawCircle (this, 0, 0, mRadius, borderColor, 
                                                            borderThickness, drawBg, filledColor);
         
         if (mAppearanceType == Define.CircleAppearanceType_Ball)
         {
            var pos:Number;
            if (Define.IsBombShape (GetAiType ()))
               pos = mRadius * 0.75;// * 0.707;
            else
               pos = (mRadius * 0.66) - 1;// * 0.707 - 1;
            if (pos < 0) pos = 0;
            
            var invertFilledColor:uint = GraphicsUtil.GetInvertColor_b (filledColor);
            GraphicsUtil.DrawEllipse (this, pos, 0, 1, 1, invertFilledColor, 1, true, invertFilledColor);
         }
         else if (mAppearanceType == Define.CircleAppearanceType_Column)
         {
            var radius2:Number = mRadius * 0.5;
            GraphicsUtil.DrawEllipse (this, - radius2, - radius2, radius2 + radius2, radius2 + radius2, borderColor, 1, false, filledColor);
            GraphicsUtil.DrawLine (this, radius2, 0, mRadius, 0, borderColor, 1);
         }
         
         if (Define.IsBombShape (GetAiType ()))
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
         
         var borderThickness:Number = GetBorderThickness ();
         if ( ! IsDrawBorder () )
            borderThickness = 0;
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle ( GetRotation (), GetPositionX (), GetPositionY (), GetRadius () + borderThickness * 0.5 );
      }
      
      
      public function SetRadius (radius:Number, validate:Boolean = true):void
      {
         if (validate)
         {
            var minRadius:Number = mAiType == Define.ShapeAiType_Bomb ? Define.MinBombRadius : EditorSetting.MinCircleRadium;
            var maxRadius:Number = mAiType == Define.ShapeAiType_Bomb ? Define.MaxBombRadius : Define.MaxCircleRadium;
            
            if (radius > maxRadius)
               radius =  maxRadius;
            if (radius < minRadius)
               radius =  minRadius;
         }
         
         if (radius < 0)
            radius = 0;
         
         //mRadius = Math.round (radius);
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
