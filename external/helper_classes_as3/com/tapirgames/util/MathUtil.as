
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
      
   }
}
