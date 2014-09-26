
package com.tapirgames.util {
   
   public class FrequencyStat {
      
      private var mMaxAllowedHits:int = 5;
      private var mTimeInterval:int = 5000; // ms
      
      private var mHitsTimer:Array;
      private var mTailCursor:int;
      private var mHeadCursor:int;
      
      public function FrequencyStat (maxHits:int, timeInterval:int)
      {
         mMaxAllowedHits = maxHits;
         mTimeInterval = timeInterval;
         
         mHitsTimer = new Array (mMaxAllowedHits);
         Reset ();
      }
      
      public function Reset ():void
      {
         mHeadCursor = 0;
         mTailCursor = 0;
      }
      
      // return can hit or not.
      public function Hit (timer:int):Boolean
      {
         if (mMaxAllowedHits <= 0)
            return true;
         
         var headTimer:int = mHitsTimer [mHeadCursor];
         var tailTimer:int;
         while (mTailCursor != mHeadCursor)
         {
            tailTimer = mHitsTimer [mTailCursor];
            if (tailTimer + mTimeInterval > headTimer)
               break;
            
            ++ mTailCursor;
            if (mTailCursor >= mMaxAllowedHits)
            {
               mTailCursor = 0;
            }
         }
         
         var sameCursor:Boolean = mTailCursor == mHeadCursor;
         
         var nextHead:int = mHeadCursor + 1;
         if (nextHead >= mMaxAllowedHits)
            nextHead = 0;
         if (nextHead == mTailCursor)
         {
            return false;
         }
         
         mHeadCursor = nextHead;
         mHitsTimer [mHeadCursor] = timer;
         
         if (sameCursor)
         {
            tailTimer = mHitsTimer [mTailCursor];
            if (tailTimer + mTimeInterval < timer)
               mTailCursor = mHeadCursor;
         }
         
         return true;
      }
   }
}
