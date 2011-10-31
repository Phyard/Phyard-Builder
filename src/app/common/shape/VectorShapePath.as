package common.shape
{
   // for compatibility, temp extends VectorShapeArea
   public class VectorShapePath extends VectorShape
   {
      public function VectorShapePath ():void
      {
         SetRoundEnds (true);
         SetClosed (false);
      }

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
      
      // thickness
      
      protected var mPathThickness:Number = 1.0;

      public function GetPathThickness ():Number
      {
         return mPathThickness;
      }

      public function SetPathThickness (thickness:Number):void
      {
         mPathThickness = thickness;
      }
   }
}
