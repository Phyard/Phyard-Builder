
package editor.entity {

   import flash.display.Sprite;

   import com.tapirgames.util.GraphicsUtil;

   import editor.world.World;

   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;



   import common.Define;
   import common.ValueAdjuster;
   import common.Config;

   public class EntityVectorShapeCircle extends EntityVectorShape
   {
   // geom

      public var mRadius:Number;

      // ball
      // wheel
      protected var mAppearanceType:int = Define.CircleAppearanceType_Ball;

      public function EntityVectorShapeCircle (world:World)
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
         return super.GetInfoText () + ", radius = " + ValueAdjuster.Number2Precision (mWorld.GetCoordinateSystem ().D2P_Length (GetRadius ()), 6);
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
            borderColor = Define.BorderColorSelectedObject;
            if (borderThickness * mWorld.GetZoomScale () < 3)
               borderThickness  = 3.0 / mWorld.GetZoomScale ();
         }

         SetVisibleInEditor (mVisibleInEditor); //  recal alpha

         var visualRadius:Number = mRadius + 0.5; // be consistent with player

         GraphicsUtil.ClearAndDrawCircle (this, 0, 0, visualRadius, borderColor,
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
            GraphicsUtil.DrawLine (this, radius2, 0, visualRadius, 0, borderColor, 1);
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

         (mSelectionProxy as SelectionProxyCircle).RebuildCircle (GetPositionX (), GetPositionY (), GetRadius () + borderThickness * 0.5, GetRotation ());
      }


      public function SetRadius (radius:Number, validate:Boolean = true):void
      {
         if (validate)
         {
            var minRadius:Number = mAiType == Define.ShapeAiType_Bomb ? Define.MinBombRadius : Define.MinCircleRadius;
            var maxRadius:Number = mAiType == Define.ShapeAiType_Bomb ? Define.MaxBombRadius : Define.MaxCircleRadius;

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
         return new EntityVectorShapeCircle (mWorld);
      }

      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var cirlce:EntityVectorShapeCircle = entity as EntityVectorShapeCircle;
         cirlce.SetRadius ( GetRadius () );
         cirlce.SetAppearanceType ( GetAppearanceType () );
      }


//====================================================================
//   move, rotate, scale
//====================================================================

      override public function ScaleSelf (ratio:Number):void
      {
         var radius:Number = mRadius * ratio;
      //trace ("ratio = " + ratio + ", radius = " + radius);

         SetRadius (radius);
      }



   }
}