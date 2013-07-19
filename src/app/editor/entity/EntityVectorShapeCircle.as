
package editor.entity {

   import flash.display.Sprite;
   import flash.display.Shape;

   import com.tapirgames.util.GraphicsUtil;

   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.image.vector.*;
   import common.shape.*;
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Config;

   public class EntityVectorShapeCircle extends EntityVectorShapeArea
   {
   // geom

      //public var mRadius:Number;
      protected var mVectorShapeCircle:VectorShapeCircleForEditing = new VectorShapeCircleForEditing ();

      // ball
      // wheel
      protected var mAppearanceType:int = Define.CircleAppearanceType_Ball;

      public function EntityVectorShapeCircle (container:Scene)
      {
         super (container, mVectorShapeCircle);

         SetRadius (1.0);
         SetFilledColor (Define.ColorMovableObject);
         SetBuildBorder (true);
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
         return super.GetInfoText () + ", radius = " + ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_Length (GetRadius ()), 6);
      }

      override public function GetPhysicsShapesCount ():uint
      {
         return IsPhysicsEnabled () ? 1 : 0;
      }

      override public function UpdateAppearance ():void
      {
         super.UpdateAppearance ();

         var visualRadius:Number = GetRadius () + 0.5; // be consistent with player

         var decoShape:Shape = null;
         if (mAppearanceType == Define.CircleAppearanceType_Ball)
         {
            var pos:Number;
            if (Define.IsBombShape (GetAiType ()))
               pos = GetRadius () * 0.75;// * 0.707;
            else
               pos = (GetRadius () * 0.66) - 1;// * 0.707 - 1;
            if (pos < 0) pos = 0;

            var invertFilledColor:uint = GraphicsUtil.GetInvertColor_b (GetFilledColor ());
            
            decoShape = new Shape ();
            GraphicsUtil.DrawEllipse (decoShape, pos, 0, 1, 1, invertFilledColor, 1, true, invertFilledColor);
            
         }
         else if (mAppearanceType == Define.CircleAppearanceType_Column)
         {
            var radius2:Number = GetRadius () * 0.5;
            
            decoShape = new Shape ();
            GraphicsUtil.DrawEllipse (decoShape, - radius2, - radius2, radius2 + radius2, radius2 + radius2, GetBorderColor (), 1, false, GetFilledColor ());
            GraphicsUtil.DrawLine (decoShape, radius2, 0, visualRadius, 0, GetBorderColor (), 1);
         }

         if (Define.IsBombShape (GetAiType ()))
         {
            if (decoShape == null)
               decoShape = new Shape ();
            GraphicsUtil.DrawEllipse (decoShape, - GetRadius () * 0.5, - GetRadius () * 0.5, GetRadius (), GetRadius (), 0x808080, 0, true, 0x808080);
         }
         
         if (decoShape != null)
         {
            this.addChild (decoShape);
         }
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

         ////mRadius = Math.round (radius);
         ////>> from 1.02
         //mRadius = radius;
         ////<<
         mVectorShapeCircle.SetRadius (radius);

         //UpdateAppearance ();
         //UpdateSelectionProxy ();
      }

      public function GetRadius ():Number
      {
         //return mRadius;
         return mVectorShapeCircle.GetRadius ();
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
         return new EntityVectorShapeCircle (mEntityContainer);
      }

      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var cirlce:EntityVectorShapeCircle = entity as EntityVectorShapeCircle;
         cirlce.SetRadius ( GetRadius () );
         cirlce.SetAppearanceType ( GetAppearanceType () );
      }

   }
}
