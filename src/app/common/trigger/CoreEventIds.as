

package common.trigger {
   
   public class CoreEventIds
   {
      public static const ID_OnVoid:int = -1;
      
   // level related
      
      public static const ID_OnLevelBeginInitialize:int = 0;
      public static const ID_OnLevelEndInitialize:int = 1;
      public static const ID_OnLevelBeginUpdate:int = 2;
      public static const ID_OnLevelEndUpdate:int = 3;
      //public static const ID_OnLevelFinished:int = 4;
      //public static const ID_OnLevelFailed:int = 5;
      
   // world related (maybe in later versions)
      
      //public static const ID_OnWorldInitialize:int = 30;
      //public static const ID_OnWorldActivated:int = 31;
      //public static const ID_OnWorldDeactivated:int = 32;
      //public static const ID_OnWorldPreUpdate:int = 33;
      //public static const ID_OnWorldPostUpdate:int = 34;
      
      public static const ID_OnTimer:int = 50;
      //public static const ID_OnTrigger:int = 51; // seems this is not essential
      
   // entity related
      
      public static const ID_OnEntityInitialized:int = 70;
      public static const ID_OnEntityUpdated:int = 71;
      public static const ID_OnEntityDestroyed:int = 72;
      
      public static const ID_OnShapeMouseDown:int = 90;
      public static const ID_OnShapeMouseUp:int = 91;
      
      //public static const ID_OnJointBroken:int = 110;
      public static const ID_OnJointReachLowerLimit:int = 111;
      public static const ID_OnJointReachUpperLimit:int = 112;
      
   // 2 shapes contact
      
      //public static const ID_OnSensorContainsPhysicsShape:int = 130;
      public static const ID_OnTwoPhysicsShapesBeginContacting:int = 131;
      public static const ID_OnTwoPhysicsShapesKeepContacting:int = 132;
      public static const ID_OnTwoPhysicsShapesEndContacting:int = 133;
      
   // ================================
      
      public static const NumEventTypes:int = 200;
   }
}
