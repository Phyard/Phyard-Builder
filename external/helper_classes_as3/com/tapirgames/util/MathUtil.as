
package com.tapirgames.util {
   
   import com.tapirgames.util.Logger;
   
   public class MathUtil {
      
      
      
      public static function GetClipValue (value:Number, min:Number, max:Number):Number
      {
         if (value <= min)
            return min;
         
         if (value >= max)
            return max;
         
         return value;
      }
      
      public static function ParseNumber (valueStr:String, defaultValue:Number):Number
      {
         var value:Number;
         
         try {
            value = parseFloat (valueStr);
         } catch (err:Error) {
            value = NaN;
         }
         if (isNaN (value))
         {
            value = defaultValue;
         }
         
         return value;
      }
      
   }
}
