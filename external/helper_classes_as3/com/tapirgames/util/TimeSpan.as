
package com.tapirgames.util {
   
   import flash.utils.getTimer;
   
   import com.tapirgames.util.Logger;
   
   public class TimeSpan {
      
      private var mStartTime:Number;
      private var mEndTime:Number;
      private var mSpanTime:Number;
      
      public function TimeSpan ()
      {
         Start ();
      }
      
      public function Start ():void
      {
         mStartTime = getTimer ();
      }
      
      public function End ():void
      {
         mEndTime = getTimer ();
         mSpanTime = (mEndTime - mStartTime) * 0.001;
      }
      
      public function GetLastSpan ():Number
      {
         return mSpanTime;
      }
      
      public function Trace (msg:String = null):void
      {
         Logger.Trace ("[Time Span] " + (msg == null ? "" : msg) + ": " + mSpanTime);
      }
   }
}
