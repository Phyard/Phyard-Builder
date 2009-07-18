package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   public class EventSetting
   {
      public var mMaxAllowedInstances:int = 0; // 0 means infinite
      public var mReplaceableEvents:Array = null; // event ids, the homogeneous events
      public var mAssignableEntityParamsCount:int = 0;
      public var mValidEntityLimiterTypes:Array = null;
      public var mDefaultEntityLimiterType:int = -1;
      
      
         //Max Allowed Instances
         //ReplaceableEventIds:
         //EntityParamsCount: 0/1/2
         //ValidEntityLimiterTypes: 1-1, M-M, A-A, A1M, A2M / 1, M, A
         //DefaultLimiterType:
      
      public function EventSetting (id:int, name:String, paramDefines:Array = null, description:String = null):void
      {
      }
      
      
      
   }
}

