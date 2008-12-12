
package com.tapirgames.util {
   
   import com.tapirgames.util.Logger;
   
   public class FpsStat {
      
      private var mTimeSpan:TimeSpan;
      
      private var mAccumTime:Number;
      private var mUpdateSteps:int = 10;
      
      private var mFps:Number;
      private var mMspf:Number;
      
      public function FpsStat ()
      {
         mTimeSpan = new TimeSpan ();
         
         mAccumTime = 0;
         mTimeSpan.Start ();
      }
      
      public function SetUpdateSteps (steps:int):void
      {
         if (steps < 1) steps = 1;
         mUpdateSteps = steps;
      }
      
      public function Step (dt:Number = NaN):Boolean
      {
         mTimeSpan.End ();
         
         mAccumTime += isNaN (dt) ? mTimeSpan.GetLastSpan () : dt;
         ++ mUpdateSteps;
         
         if (mUpdateSteps >= 10)
         {
            mMspf = mAccumTime / mUpdateSteps;
            mFps = 1.0 / mMspf;
            
            mUpdateSteps = 0;
            mAccumTime = 0;
         }
         
         mTimeSpan.Start ();
         
         return mUpdateSteps == 0;
      }
      
      public function GetFps ():Number
      {
         return mFps;
      }
      
      public function Trace (msg:String = null):void
      {
         Logger.Trace ("[Fps Stat] " + (msg == null ? "" : msg) + ": " + mFps);
      }
   }
}
