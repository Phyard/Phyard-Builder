
      // todo: move this part into Viewer

      protected /*static*/ var mRandomNumberGenerators:Array = new Array (Define.NumRngSlots);
      
      public /*static*/ function CreateRandomNumberGenerator (rngSlot:int, rngMethod:int):void
      {
         if (rngSlot < 0 || rngSlot >= Define.NumRngSlots)
            throw new Error ("Invalid RNG slot " + rngSlot);
         
         if (rngMethod < 0 || rngMethod >= Define.NumRngMethods)
            throw new Error ("Invalid RNG method " + rngMethod);
         
         if (rngMethod == 0)
         {
            mRandomNumberGenerators [rngSlot] = new MersenneTwisterRNG ();
         }
      }
      
      public /*static*/ function GetRandomNumberGenerator (rngSlot:int):RandomNumberGenerator
      {
         return mRandomNumberGenerators [rngSlot];
      }
      
      
