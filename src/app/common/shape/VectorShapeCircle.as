package common.shape
{
   import common.Define;

   public class VectorShapeCircle extends VectorShapeArea
   {
      public function VectorShapeCircle ()
      {
      }
      
      // appearance type
      
      public var mAppearacneType:int = Define.CircleAppearanceType_Ball;

      public function GetAppearanceType ():int
      {
         return mAppearacneType;
      }

      public function SetAppearanceType (type:int):void
      {
         mAppearacneType = type;
      }
      
      // radius
      
      public var mRadius:Number = 0.0;

      public function GetRadius ():Number
      {
         return mRadius;
      }

      public function SetRadius (radius:Number):void
      {
         mRadius = radius;
      }
   }
}
