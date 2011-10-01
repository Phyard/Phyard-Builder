pacakge editor.image.vector
{
   public class VectorShapeRectangle extends VectorShapeArea
   {
      //protected var mAttributeBits:int = 0;
         public static const Mask_RoundCorners   :int = 1 << 16;
            
      protected var mHalfWidth:Number;
      protected var mHalfHeight:Number;
      
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
      
      public function GetHalfWidth ():Number
      {
         return mHalfWidth;
      }
      
      public function SetHalfWidth (halfWidth:Number):void
      {
         mHalfWidth = halfWidth;
      }
      
      public function GetHalfHeight ():Number
      {
         return mHeight;
      }
      
      public function SetHalfHeight (halfHeight:Number):void
      {
         mHalfHeight = halfHeight;
      }
   }
}
