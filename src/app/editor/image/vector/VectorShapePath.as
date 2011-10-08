package editor.image.vector
{
   // for compatibility, temp extends VectorShapeArea
   public class VectorShapePath extends VectorShapeArea // VectorShape
   {
      //protected var mAttributeBits:int = 0;
         public static const Flag_Closed           :int = 1 << 12;
         public static const Flag_RoundEnds        :int = 1 << 13; // will not support other svg end types
      
      protected var mCurveThickness:int; // 0-255. To change to float. To change name to mThickness
      
      public function IsClosed ():Boolean
      {
         return (mAttributeBits & Flag_Closed) != 0;
      }
      
      public function SetClosed (buildBorder:Boolean):void
      {
         if (buildBorder)
            mAttributeBits |= Flag_Closed;
         else
            mAttributeBits &= ~Flag_Closed;
      }
      
      public function IsRoundEnds ():Boolean
      {
         return (mAttributeBits & Flag_RoundEnds) != 0;
      }
      
      public function SetRoundEnds (buildBorder:Boolean):void
      {
         if (buildBorder)
            mAttributeBits |= Flag_RoundEnds;
         else
            mAttributeBits &= ~Flag_RoundEnds;
      }
      
      public function GetCurveThickness ():int
      {
         return mCurveThickness;
      }
      
      public function SetCurveThickness (thickness:int):void
      {
         mCurveThickness = thickness;
      }
   }
}
