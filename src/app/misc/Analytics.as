package misc {
   
   import flash.display.DisplayObject;
   import flash.utils.getTimer;
   
   //
   import com.google.analytics.GATracker;
   import com.google.analytics.AnalyticsTracker;
   
   import common.Config;
   
   public class Analytics
   {
      private var mTracker:AnalyticsTracker;
      
      private var mStartTimer:uint;
      
      
      private var mTrackTimeDuration:Array = null;
      private var mNumTrackedDurations:int = 0;
      
      public function Analytics (displayObject:DisplayObject, trackTimeDurations:Array )
      {
         mStartTimer = getTimer();
         
         if (! Config.EnablePageAnalytics)
            return;
         
         mTracker = new GATracker( displayObject, Config.GoogleAnalyticsID, "AS3", false );
      }
      
      public function TrackPageview (page:String):void
      {
         if (! Config.EnablePageAnalytics)
            return;
         
         mTracker.trackPageview( page );
      }
      
      public function TrackTime (pagePrefix:String):void
      {
         if (! Config.EnablePageAnalytics)
            return;
         
         if (mTrackTimeDuration != null && mNumTrackedDurations < mTrackTimeDuration.length)
         {
            var duration:Number = getTimer() - mStartTimer;
            duration *= 0.001;
            
            if (duration >= mTrackTimeDuration [mNumTrackedDurations])
            {
               mTracker.trackPageview( pagePrefix + "/" +  mTrackTimeDuration [mNumTrackedDurations]);
               ++ mNumTrackedDurations;
            }
         }
      }
      
   }
}
