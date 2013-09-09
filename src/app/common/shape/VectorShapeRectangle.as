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
