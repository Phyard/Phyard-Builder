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
         return GetEndType () == EndType_Round;
      }

      public function SetRoundEnds (round:Boolean):void
      {
         SetEndType (round ? EndType_Round : EndType_None);
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

//==============================================
// for playing
//==============================================

      //protected var mPathThicknessInPhysics:Number;

      //public function GetPathThicknessInPhysics ():Number
      //{
      //   return mPathThicknessInPhysics;
      //}

      //public function SetPathThicknessInPhysics (thickness:Number):void
      //{
      //   mPathThicknessInPhysics = thickness;
      //}

   }
}
