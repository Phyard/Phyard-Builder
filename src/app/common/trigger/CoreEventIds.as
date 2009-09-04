

package common.trigger {
   
   public class CoreEventIds
   {
      public static const ID_OnVoid:int = -1;
      
   // level related
      
      public static const ID_OnLevelInitialize:int = 0;
      public static const ID_OnLeveBeginUpdate:int = 1;
      public static const ID_OnLeveEndUpdate:int = 2;
      public static const ID_OnLeveFinished:int = 3;
      public static const ID_OnLeveFailed:int = 4;
      
   // world related
      
      public static const ID_OnWorldInitialize:int = 30;
      public static const ID_OnWorldActivated:int = 31;
      public static const ID_OnWorldDeactivated:int = 32;
      public static const ID_OnWorldPreUpdate:int = 33;
      public static const ID_OnWorldPostUpdate:int = 34;
      
      public static const ID_OnTimer:int = 50;
      public static const ID_OnTrigger:int = 51;
      
   // entity related
      
      public static const ID_OnEntityInitialize:int = 70;
      public static const ID_OnEntityUpdate:int = 71;
      
      public static const ID_OnShapeMouseDown:int = 90;
      public static const ID_OnShapeMouseUp:int = 91;
      
      public static const ID_OnPhysicsJointBroken:int = 110;
      public static const ID_OnHingeJointReachUpperTranslation:int = 111;
      public static const ID_OnHingeJointReachLowerTranslation:int = 112;
      public static const ID_OnHingeJointReachMaxMotorTorque:int = 113;
      public static const ID_OnSliderJointReachUpperTranslation:int = 116;
      public static const ID_OnSliderJointReachLowerTranslation:int = 117;
      public static const ID_OnSliderJointReachMaxMotorForce:int = 118;
      
   // 2 shapes contact
      
      public static const ID_OnSensorContainsPhysicsShape:int = 130;
      public static const ID_OnTwoPhysicsShapesBeginContacting:int = 131;
      public static const ID_OnTwoPhysicsShapesKeepContacting:int = 132;
      public static const ID_OnTwoPhysicsShapesEndContacting:int = 133;
      
   // ================================
      
      public static const NumEventTypes:int = 200;
   }
}
