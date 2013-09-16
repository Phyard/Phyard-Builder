
package editor.entity {

   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.geom.Point;
   import flash.system.Capabilities;

   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;

   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.image.vector.*;
   import common.shape.*;

   import common.Define;

   public class EntityVectorShapeRectangle extends EntityVectorShapeArea
   {
   // geom

      //public var mHalfWidth:Number;
      //public var mHalfHeight:Number;
      //
      //protected var mRoundCorners:Boolean = false;
      protected var mVectorShapeRectangle:VectorShapeRectangleForEditing = new VectorShapeRectangleForEditing ();

      public function EntityVectorShapeRectangle (container:Scene)
      {
         super (container, mVectorShapeRectangle);

         SetHalfWidth (0);
         SetHalfHeight (0);
         SetFilledColor (Define.ColorMovableObject);
         SetBuildBorder (true);
      }

      override public function GetTypeName ():String
      {
         if (mAiType == Define.ShapeAiType_Bomb)
            return "Rectangle Bomb";
         else
            return "Rectangle";
      }

      override public function GetPhysicsShapesCount ():uint
      {
         return IsPhysicsEnabled () ? 1 : 0;
      }

      override public function UpdateAppearance ():void
      {
         super.UpdateAppearance ();

         var visualHalfWidth:Number = GetHalfWidth () + 0.5;
         var visualHalfHeight:Number = GetHalfHeight () + 0.5;

         if (mAiType == Define.ShapeAiType_Bomb)
         {
            var innerRectShape:Shape = new Shape ();
            GraphicsUtil.DrawRect (innerRectShape, - visualHalfWidth * 0.5, - visualHalfHeight * 0.5, visualHalfWidth, visualHalfHeight, 0x808080, 0, true, 0x808080);
            this.addChild (innerRectShape);
         }
      }

      public function SetHalfWidth (halfWidth:Number, validate:Boolean = true):void
      {
         if (validate)
         {
            var minHalfWidth:Number = mAiType == Define.ShapeAiType_Bomb ? Define.MinBombSquareSideLength * 0.5 : Define.MinRectSideLength * 0.5;
            var maxHalfWidth:Number = mAiType == Define.ShapeAiType_Bomb ? Define.MaxBombSquareSideLength * 0.5 : Define.MaxRectSideLength * 0.5;

            if (halfWidth * GetHalfHeight () * 4 > Define.MaxRectArea)
               halfWidth = Define.MaxRectArea / (GetHalfHeight () * 4);

            if (halfWidth > maxHalfWidth)
               halfWidth = maxHalfWidth;
            if (halfWidth < minHalfWidth)
               halfWidth = minHalfWidth;
         }

         //mHalfWidth = halfWidth;
         mVectorShapeRectangle.SetHalfWidth (halfWidth);
      }

      public function SetHalfHeight (halfHeight:Number, validate:Boolean = true):void
      {
         if (validate)
         {
            var minHalfWidth:Number = mAiType == Define.ShapeAiType_Bomb ? Define.MinBombSquareSideLength * 0.5 : Define.MinRectSideLength * 0.5;
            var maxHalfWidth:Number = mAiType == Define.ShapeAiType_Bomb ? Define.MaxBombSquareSideLength * 0.5 : Define.MaxRectSideLength * 0.5;

            if (halfHeight * GetHalfWidth () * 4 > Define.MaxRectArea)
               halfHeight = Define.MaxRectArea / (GetHalfWidth () * 4);

            if (halfHeight > maxHalfWidth)
               halfHeight = maxHalfWidth;
            if (halfHeight < minHalfWidth)
               halfHeight = minHalfWidth;
         }

         //mHalfHeight = halfHeight;
         mVectorShapeRectangle.SetHalfHeight (halfHeight);
      }

      public function GetHalfWidth ():Number
      {
         //return mHalfWidth;
         return mVectorShapeRectangle.GetHalfWidth ();
      }

      public function GetHalfHeight ():Number
      {
         //return mHalfHeight;
         return mVectorShapeRectangle.GetHalfHeight ();
      }

      //public function SetRoundCorners (round:Boolean):void
      public function SetRoundJoint (round:Boolean):void
      {
         //mRoundCorners = round;
         //mVectorShapeRectangle.SetRoundCorners (round);
         mVectorShapeRectangle.SetRoundJoint (round);
      }

      //public function IsRoundCorners ():Boolean
      public function IsRoundJoint ():Boolean
      {
         //return mRoundCorners;
         return mVectorShapeRectangle.IsRoundJoint (); // IsRoundCorners ();
      }
      
      //public function SetCornerEclipseWidth (cornerEclipseWidth:Number):void
      //{
      //   mVectorShapeRectangle.SetCornerEclipseWidth (cornerEclipseWidth);
      //}
      
      //public function GetCornerEclipseWidth ():Number
      //{
      //   return mVectorShapeRectangle.GetCornerEclipseWidth ();
      //}
      
      //public function SetCornerEclipseHeight (cornerEclipseHeight:Number):void
      //{
      //   mVectorShapeRectangle.SetCornerEclipseHeight (cornerEclipseHeight);
      //}
      
      //public function GetCornerEclipseHeight ():Number
      //{
      //   return mVectorShapeRectangle.GetCornerEclipseHeight ();
      //}
      
      //public function SetRoundCorner (roundCorner:Boolean):void
      //{
      //   mVectorShapeRectangle.SetRoundCorner (roundCorner);
      //   if (roundCorner) // now round rect doesn't support physics.
      //   {
      //      SetPhysicsEnabled (false);
      //   }
      //}
      
      //public function IsRoundCorner ():Boolean
      //{
      //   return mVectorShapeRectangle.IsRoundCorner ();
      //}
      
//====================================================================
//   clone
//====================================================================

      override protected function CreateCloneShell ():Entity
      {
         return new EntityVectorShapeRectangle (mEntityContainer);
      }

      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var rect:EntityVectorShapeRectangle = entity as EntityVectorShapeRectangle;
         rect.SetHalfWidth ( GetHalfWidth () );
         rect.SetHalfHeight ( GetHalfHeight () );
         //rect.SetRoundCorners (IsRoundCorners ());
         rect.SetRoundJoint (IsRoundJoint ());
         
         // cancelled
         //rect.SetRoundCorner (IsRoundCorner ());
         //rect.SetCornerEclipseWidth (GetCornerEclipseWidth ());
         //rect.SetCornerEclipseHeight (GetCornerEclipseHeight ());
      }

   }
}
