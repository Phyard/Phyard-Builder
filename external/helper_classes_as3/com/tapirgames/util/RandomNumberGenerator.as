
package com.tapirgames.util
{
   
   public class RandomNumberGenerator
   {
      public function SetSeed (seedId:uint, seed:uint):void
      {
         // to override
      }

      public function NextUnsignedInt ():uint
      {
         return 0; // to override
      }

      public final function NextFloat ():Number
      {
         const MaxUintAsFloat:Number = Number (0xFFFFFFFF);
         return Number (NextUnsignedInt ()) / MaxUintAsFloat;
      }

      public final function NextIntegerBetween (i1:int, i2:int):int
      {
         if (i1 > i2)
         {
            if (i1 == i2 + 1)
               return i1;
            
            return i1 - (NextUnsignedInt () % (i1 - i2));
         }
         else if (i1 < i2)
         {
            if (i2 == i1 + 1)
               return i1;
            
            return i1 + (NextUnsignedInt () % (i2 - i1));
         }
         else
         {
            return i1;
         }
      }
   }
}
