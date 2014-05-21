package common.shape
{
   public class VectorShapeRectangle extends VectorShapeArea
   {
      public function VectorShapeRectangle ()
      {
         //SetRoundCorners (false); // <=> SetJointType (JointType_Moter);
         SetRoundJoint (false); // <=> SetJointType (JointType_Moter);
      }
      
      //public function IsRoundCorners ():Boolean
      public function IsRoundJoint ():Boolean
      {
         return GetJointType () == JointType_Round;
      }

      //public function SetRoundCorners (round:Boolean):void
      public function SetRoundJoint (round:Boolean):void
      {
         SetJointType (round ? JointType_Round : JointType_Moter);
      }

      // half width and height

      protected var mHalfWidth:Number = 1.0;
      protected var mHalfHeight:Number = 1.0;

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
      
      // corner
      
      protected var mCornerEclipseWidth:Number = 0.0;
      protected var mCornerEclipseHeight:Number = 0.0;

      public function GetCornerEclipseWidth ():Number
      {
         return mCornerEclipseWidth;
      }

      public function SetCornerEclipseWidth (ellipseWidth:Number):void
      {
         mCornerEclipseWidth = Math.abs (ellipseWidth);
      }

      public function GetCornerEclipseHeight ():Number
      {
         return mCornerEclipseHeight;
      }

      public function SetCornerEclipseHeight (ellipseHeight:Number):void
      {
         mCornerEclipseHeight = Math.abs (ellipseHeight);
      }
      
      public function IsRoundCorner ():Boolean
      {
         return (mAttributeBits & Flag_RoundCorner) != 0;
      }
      
      public function SetRoundCorner (roundCorner:Boolean):void
      {
         if (roundCorner)
            mAttributeBits |= Flag_RoundCorner;
         else
            mAttributeBits &= ~Flag_RoundCorner;
      }

//==============================================
// for playing
//==============================================

      //protected var mHalfWidthInPhysics:Number;
      //protected var mHalfHeightInPhysics:Number;

      //public function GetHalfWidthInPhysics ():Number
      //{
      //   return mHalfWidthInPhysics;
      //}

      //public function SetHalfWidthInPhysics (halfWidth:Number):void
      //{
      //   mHalfWidthInPhysics = halfWidth;
      //}

      //public function GetHalfHeightInPhysics ():Number
      //{
      //   return mHalfHeightInPhysics;
      //}

      //public function SetHalfHeightInPhysics (halfHeight:Number):void
      //{
      //   mHalfHeightInPhysics = halfHeight;
      //}
   }
}
