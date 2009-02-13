package common {
   
   //import flash.geom.Point;
   
   public class ValueAdjuster
   {
      
//===========================================================================
// number precisions
//===========================================================================
      
      // for positions, 14 precisions digits, and witeDouble in bytearray
      //public static const 
      
      // for other float values, 7 precisions digits, writefloat in bytearray
      
      
//===========================================================================
// number precision
//===========================================================================
      
      public static function Number2Fixed (number:Number, numFractionDigits:uint):Number
      {
         return parseFloat (number.toFixed (numFractionDigits));
      }
      
      public static function Number2Precision (number:Number, numFractionDigits:uint):Number
      {
         return parseFloat (number.toPrecision (numFractionDigits));
      }
      
//===========================================================================
// number precision
//===========================================================================
      
      // for both editor and player
      public static function AdjustCircleRadius (radius:Number, version:int):Number
      {
         if ( version >= 0x0102)
         {
            return Math.round (radius);
         }
         else
         {
            return radius;
         }
      }
      
      // for both editor and player
      //public static function AdjustInitialGravityAcceleration (ga:Number, params:Object = null):Number
      //{
      //   return 0.1 * ( Math.round (ga * 10.0) );
      //}
      
      // for editor only
      public static function AdjustSliderTranslation (trans:Number, version:int):Number
      {
         if ( version >= 0x0102)
         {
            return Math.round (trans);
         }
         else
         {
            return trans;
         }
      }
      
   }
}