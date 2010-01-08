

package common.trigger {
   
   public class CoreEventIds
   {
      public static const ID_Invalid:int = -1;
      
   // ...
      
      public static const ID_OnVoid:int = 10;
      
   // level
      
      //public static const ID_OnLevelBeginInitialize:int = 30;
      //public static const ID_OnLevelEndInitialize:int = 31;
      //public static const ID_OnLevelBeginUpdate:int = 32;
      //public static const ID_OnLevelEndUpdate:int = 33;
      
   // world (maybe in later versions)
      
      public static const ID_OnWorldBeforeInitializing:int = 0;
      public static const ID_OnWorldAfterInitialized:int = 1;
      public static const ID_OnLWorldBeforeUpdating:int = 2;
      public static const ID_OnWorldAfterUpdated:int = 3;
      
      
      public static const ID_OnWorldTimer:int = 50;
      
   // entity
      
      public static const ID_OnEntityInitialized:int = 70;
      public static const ID_OnEntityUpdated:int = 71;
      public static const ID_OnEntityDestroyed:int = 72;
      
      public static const ID_OnEntityTimer:int = 80;
      
      public static const ID_OnShapeMouseDown:int = 90;
      public static const ID_OnShapeMouseUp:int = 91;
      
   // entity / joint
      
      public static const ID_OnJointReachLowerLimit:int = 111;
      public static const ID_OnJointReachUpperLimit:int = 112;
      
   // entity pair
      
      //public static const ID_OnSensorContainsPhysicsShape:int = 130;
      public static const ID_OnTwoPhysicsShapesBeginContacting:int = 131;
      public static const ID_OnTwoPhysicsShapesKeepContacting:int = 132;
      public static const ID_OnTwoPhysicsShapesEndContacting:int = 133;
      
      public static const ID_OnEntityPairTimer:int = 150;
      
   // mouse event (entity)
      
      public static const ID_OnPhysicsShapeMouseDown:int = 200;
      public static const ID_OnPhysicsShapeMouseUp:int = 201;
      public static const ID_OnEntityMouseClick:int = 202;
      public static const ID_OnEntityMouseDown:int = 203;
      public static const ID_OnEntityMouseUp:int = 204;
      public static const ID_OnEntityMouseMove:int = 205;
      public static const ID_OnEntityMouseEnter:int = 206; // mouse_over with mouseChildren == false
      public static const ID_OnEntityMouseOut:int = 207;
      
      public static const MaxEntityMouseEventId:int = 207; 
      
   // mouse event (world)
      
      public static const ID_OnWorldMouseClick:int = 210;
      public static const ID_OnWorldMouseDown:int = 211;
      public static const ID_OnWorldMouseUp:int = 212;
      public static const ID_OnWorldMouseMove:int = 213;
      
      public static const MaxWorldMouseEventId:int = 215; 
      
   // keyboard event
      
      public static const ID_OnWorldKeyDown:int = 220;
      public static const ID_OnWorldKeyUp:int = 221;
      public static const ID_OnWorldKeyHold:int = 222;
      
   // ================================
      
      public static const NumEventTypes:int = 300;
   }
}
