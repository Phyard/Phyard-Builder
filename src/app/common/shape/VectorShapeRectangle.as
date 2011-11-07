package common.shape
{
   public class VectorShapeRectangle extends VectorShapeArea
   {
      public function IsRoundCorners ():Boolean
      {
         return (mAttributeBits & Flag_RoundCorners) != 0;
      }

      public function SetRoundCorners (round:Boolean):void
      {
         if (round)
            mAttributeBits |= Flag_RoundCorners;
         else
            mAttributeBits &= ~Flag_RoundCorners;
      }

      // half width and height

      protected var mHalfWidth:Number = 0;
      protected var mHalfHeight:Number = 0;

      public function GetHalfWidth ():Number
      {
         return mHalfWidth;
      }

      public function SetHalfWidth (halfWidth:Number):void
      {
         mHalfWidth = Math.abs (halfWidth);
      }

      public function GetHalfHeight ():Number
      {
         return mHalfHeight;
      }

      public function SetHalfHeight (halfHeight:Number):void
      {
         mHalfHeight = Math.abs (halfHeight);
      }

//==============================================
// for playing
//==============================================

      protected var mHalfWidthInPhysics:Number;
      protected var mHalfHeightInPhysics:Number;

      public function GetHalfWidthInPhysics ():Number
      {
         return mHalfWidthInPhysics;
      }

      public function SetHalfWidthInPhysics (halfWidth:Number):void
      {
         mHalfWidthInPhysics = halfWidth;
      }

      public function GetHalfHeightInPhysics ():Number
      {
         return mHalfHeightInPhysics;
      }

      public function SetHalfHeightInPhysics (halfHeight:Number):void
      {
         mHalfHeightInPhysics = halfHeight;
      }
   }
}
