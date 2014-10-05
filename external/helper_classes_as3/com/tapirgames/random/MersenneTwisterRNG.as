package com.tapirgames.random {
   
   // mt19937, http://en.wikipedia.org/wiki/Mersenne_twister
   
   // http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/MT2002/elicense.html
   // Commercial Use of Mersenne Twister
   // 2001/4/6
   // Until 2001/4/6, MT had been distributed under GNU Public License, but after 2001/4/6, 
   // we decided to let MT be used for any purpose, including commercial use. 
   // 2002-versions mt19937ar.c, mt19937ar-cok.c are considered to be usable freely. 
   
   // refs:
   // - http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/
   // - http://www.stephencalenderblog.com/?p=181
   
   public class MersenneTwisterRNG extends RandomNumberGenerator
   {
      //Mersenne Twister variables
      public static var MT:Array;
      public static var indexMT:int;;

      public function MersenneTwisterRNG ()
      {
         SetSeed (0, uint(Math.random () * 0xFFFFFFFF));
      }

      override public function SetSeed (seedId:uint, seed:uint):void
      {
          //the seed can be any positive integer
          if (MT == null)
          {
              MT = new Array (624);
          }
          
          indexMT = 624;
          MT[0] = seed;
          
          var i:int;
          for(i = 1; i < 624; i++)
          {
              MT[i] = uint(0xFFFFFFFF & (0x6C078965 * (MT[i-1] ^ (MT[i-1] >>> 30)) + i));
          }
      }

      override public function NextUnsignedInt ():uint
      {
          if(indexMT == 624)
          {
              indexMT = 0;
              generateRands();
          }
         
          var y:uint = MT[indexMT];
          y = y ^ (y >>> 11);
          y = y ^ ((y << 7) & 0x9D2C5680);
          y = y ^ ((y << 15) & 0xEFC60000);
          y = y ^ (y >>> 18);
          indexMT++;
          
          return y;
      }

      private static function generateRands():void
      {
          var i:int;
          var y:uint;
          
          for(i = 0; i < 227; i++)
          {
              y = (0x80000000 & MT[i]) + (0x7FFFFFFF & (MT[i+1]));
              MT[i] = MT[i + 397] ^ (y >>> 1) ^ ((y & 0x1) * 0x9908B0DF);
          }
          
          //special case for i + 397 > 624 to avoid a mod operator
          for(i = 227; i < 623; i++)
          {
              y = (0x80000000 & MT[i]) + (0x7FFFFFFF & (MT[i+1]));
              MT[i] = MT[i - 227] ^ (y >>> 1) ^ ((y & 0x1) * 0x9908B0DF);
          }
          
          //special case for last value, to avoid mod operator
          y = (0x80000000 & MT[623]) + (0x7FFFFFFF & (MT[0]));
          MT[623] = MT[396] ^ (y >>> 1) ^ ((y & 0x1) * 0x9908B0DF);
      }
   }
}

