package editor.image.vector
{
   public class VectorShapeRectangle extends VectorShapeArea
   {
      //protected var mAttributeBits:int = 0;
         public static const Flag_RoundCorners   :int = 1 << 16;
            
      protected var mHalfWidth:Number = 0;
      protected var mHalfHeight:Number = 0;
      
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
   }
}
