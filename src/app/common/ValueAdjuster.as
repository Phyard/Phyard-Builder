package common {
   
   //import flash.geom.Point;
   
   public class ValueAdjuster
   {
      
//===========================================================================
// 
//===========================================================================
      
      // only for player
      public static function AdjustPhysicsShapesPotentialMaxCount (count:uint, keepZero:Boolean = false):uint
      {
         if (count == 0 && keepZero)
            return 0;
         
         if (count <= 256)
            return 256;
         
         if (count <= 512)
            return 512;
         
         if (count <= 1024)
            return 1024;
         
         if (count <= 2048)
            return 2048;
         
         if (count <= 2048)
            return 2048;
         
         return 4096;
      }
      
      public static function AdjustPhysicsShapesPopulationDensityLevel (level:uint, keepZero:Boolean = false):uint
      {
         if (level == 0 && keepZero)
            return 0;
         
         if (level <= 1)
            return 1;
         
         if (level <= 2)
            return 2;
         
         if (level <= 4)
            return 4;
         
         if (level <= 8)
            return 8;
         
         return 16;
      }
      
//===========================================================================
// 
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
// 
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