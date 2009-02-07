package common {
   
   //import flash.geom.Point;
   
   public class ValueAdjuster
   {
      // for both editor and player
      public static function AdjustCircleRadius (radius:Number, version:int):Number
      {
         if ( version >= 0x0102)
         {
            return Math.floor (radius + 0.5);
         }
         else
         {
            return radius;
         }
      }
      
      // for both editor and player
      public static function AdjustInitialGravityAcceleration (ga:Number, params:Object = null):Number
      {
         return 0.1 * ( Math.floor (ga * 10.0 + 0.5) );
      }
      
      // for editor only
      public static function AdjustSliderTranslation (trans:Number, version:int):Number
      {
         if ( version >= 0x0102)
         {
            return Math.floor (trans + 0.5);
         }
         else
         {
            return trans;
         }
      }
      
      // for editor only
      //public staticfunction  AdjustEntityPosition (posX:Number, posY:Number, params:Object = null):Point
      //{
      //   return null;
      //}
   }
}