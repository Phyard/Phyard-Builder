
package common {
   
   public class Setting
   {
      /*
      private static const SpringHalfWidth:Array = [2, 2, 3, 3, 4, 4, 5, 5];
      private static const SpringWireWidth:Array = [1, 2, 1, 2, 1, 2, 1, 2];
      
      private static const kSpringParams:Array = [
         // wire width, 1, 2 ,3, [halfWidth, staticSegmentLength]
         [ [], [], [] ],
         [ [], [], [] ],
         [ [], [], [] ],
      ];
      
      public static function GetSpringAppearanceParams (frequencyHz:Number):Object
      {
         var params:Object = new Object ();
         params.mStaticSegmentLength = 5;
         
         var fLevel:int = int (frequencyHz * 4 + 0.5);
         if (fLevel < 1)
            fLevel = 1;
         if (fLevel > SpringHalfWidth.length)
            fLevel = SpringHalfWidth.length;
         -- fLevel;
         
         params.mHalfWidth = SpringHalfWidth [fLevel];
         params.mWireWidth = SpringWireWidth [fLevel];
         
         return params;
      }
      */
      
      /*
      private static const kStandardDiameter:Number = 5;
      private static const kStandardWireDiameter:Number = 1;
      
      private static const kStandardSegmentLength:Number = 4;
      
      private static const kStandardFrequencyHz:Number = 1;
      private static const kStandardNumSegments:Number = 8;
      
      public static function GetSpringStaticSegmentLength (diameter:Number, wireDiameter:Number):Number
      {
         //return kStandardSegmentLength * diameter * kStandardWireDiameter / (kStandardDiameter * wireDiameter);
         //return kStandardSegmentLength * diameter / (kStandardDiameter);
         return kStandardSegmentLength * Math.pow (diameter / kStandardDiameter, 0.5);
      }
      
      public static function GetSpringFrequencyHz (diameter:Number, wireDiameter:Number, numSegments:Number):Number
      {
         return kStandardFrequencyHz * Math.pow (kStandardNumSegments / numSegments, 1) * Math.pow (kStandardDiameter / diameter, 0.30) * Math.pow (wireDiameter / kStandardWireDiameter, 2.2);
      }
      */
      
      public static function GetSpringParamsByType (type:int, staticLength:Number):Object
      {
         var params:Object = new Object ();
         
         switch (type)
         {
            case Define.SpringType_Weak:
               params.mDiameter = 7;
               params.mWireDiameter = 1;
               params.mStaticSegmentLength = 4;
               params.mFrequencyHz = 0.25;
               
               break;
            case Define.SpringType_Normal:
            default:
               params.mDiameter = 11;
               params.mWireDiameter = 2;
               params.mStaticSegmentLength = 8;
               params.mFrequencyHz = 1;
               
               break;
         }
         
         params.mFrequencyHz = params.mFrequencyHz * 100 / staticLength;
         
         return params;
      }
   }
}

