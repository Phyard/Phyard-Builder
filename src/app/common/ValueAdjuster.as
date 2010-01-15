package common {
   
   //import flash.geom.Point;
   
   public class ValueAdjuster
   {
      
//===========================================================================
// 
//===========================================================================
      
//===========================================================================
// 
//===========================================================================
      
      // for positions, 14 precisions digits, and witeDouble in bytearray
      //public static const 
      
      // for other float values, 7 precisions digits, writefloat in bytearray
      
//===========================================================================
// number precision
//===========================================================================
      
      public static const sUnsafeLowerValues:Array = [
            NaN,
            parseFloat ("9.5e+0"),
            parseFloat ("9.5e+1"),
            parseFloat ("9.5e+2"),
            parseFloat ("9.5e+3"),
            parseFloat ("9.5e+4"),
            parseFloat ("9.5e+5"),
            parseFloat ("9.5e+6"),
            parseFloat ("9.5e+7"),
            parseFloat ("9.5e+8"),
            parseFloat ("9.5e+9"),
            parseFloat ("9.5e+10"),
            parseFloat ("9.5e+11"),
            parseFloat ("9.5e+12"),
            parseFloat ("9.5e+13"),
            parseFloat ("9.5e+14"),
         ];
      
      public static const sUnsafeUpperValues:Array = [
            NaN,
            parseFloat ("1e+1"),
            parseFloat ("1e+2"),
            parseFloat ("1e+3"),
            parseFloat ("1e+4"),
            parseFloat ("1e+5"),
            parseFloat ("1e+6"),
            parseFloat ("1e+7"),
            parseFloat ("1e+8"),
            parseFloat ("1e+9"),
            parseFloat ("1e+10"),
            parseFloat ("1e+11"),
            parseFloat ("1e+12"),
            parseFloat ("1e+13"),
            parseFloat ("1e+14"),
            parseFloat ("1e+15"),
         ];
      
      public static function Number2Fixed (number:Number, numFractionDigits:uint):Number
      {
         return parseFloat (number.toFixed (numFractionDigits));
      }
      
      // 1 <= numDigits <= 15
      public static function Number2PrecisionString (number:Number, numDigits:uint):String
      {
         if (! isFinite (number))
            return String (number);
         //
         var unsafeUpperValue:Number = sUnsafeUpperValues [numDigits]; 
         var unsafeLowerValue:Number = sUnsafeLowerValues [numDigits];
         
         var abs_number:Number = Math.abs (number);
         
         if (abs_number > unsafeUpperValue)
         {
            var num2:Number = abs_number;
            
            // here, the theory value is 0.5, but seems some prcision losses make it unsafe.
            // In fact, a value large than 0.5 but smaller than 5.0 is safer and workable.
            var adjust:Number = 1.0; //0.5;
            while (num2 > unsafeUpperValue)
            {
               num2 *= 0.1;
               adjust *= 10.0;
            }
            
            if (num2 >= unsafeLowerValue)
            {
               abs_number += adjust;
               
               if (number < 0)
                  number = - abs_number;
               else
                  number = abs_number;
            }
         }
         
         return number.toPrecision (numDigits);
      }
      
      //public static function Test_Number2PrecisionString (num:Number):void
      //{
      //   trace ("num = " + num);
      //   trace ("  -6- flex.toPrecision (" + 6 + ") = " + num.toPrecision ( 6));
      //   trace ("  -6- Number2PrecisionString (" + 6 + ") = " + Number2PrecisionString (num, 6));
      //   trace ("  -12- flex.toPrecision (" + 12 + ") = " + num.toPrecision ( 12));
      //   trace ("  -12- Number2PrecisionString (" + 12 + ") = " + Number2PrecisionString (num, 12));
      //}
      
      public static function Number2Precision (number:Number, numDigits:uint):Number
      {
         //return parseFloat (number.toPrecision (numDigits));
         
         return parseFloat (Number2PrecisionString (number, numDigits));
      }
      
//===========================================================================
// 
//===========================================================================
      
      // for both editor and player
      public static function AdjustCircleDisplayRadius (displayRadius:Number, version:int):Number
      {
         if ( version >= 0x0108)
         {
            return (Math.round (2.0 * displayRadius)) * 0.5;
         }
         else if ( version >= 0x0102)
         {
            return Math.round (displayRadius);
         }
         else
         {
            return displayRadius;
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