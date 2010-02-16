package common.trigger {
   
   public class CoreEventIds
   {
      public static const ID_Invalid:int = -1;
      
   // ...
      
      public static const ID_OnVoid:int = IdPool.EventId_10;
      
   // level
      
      //public static const ID_OnLevelBeginInitialize:int = IdPool.EventId_30;
      //public static const ID_OnLevelEndInitialize:int = IdPool.EventId_31;
      //public static const ID_OnLevelBeginUpdate:int = IdPool.EventId_32;
      //public static const ID_OnLevelEndUpdate:int = IdPool.EventId_33;
      
   // world (maybe in later versions)
      
      public static const ID_OnWorldBeforeInitializing:int = IdPool.EventId_0;
      public static const ID_OnWorldAfterInitialized:int = IdPool.EventId_1;
      public static const ID_OnLWorldBeforeUpdating:int = IdPool.EventId_2;
      public static const ID_OnWorldAfterUpdated:int = IdPool.EventId_3;
      
      
      public static const ID_OnWorldTimer:int = IdPool.EventId_50;
      
   // entity
      
      public static const ID_OnEntityInitialized:int = IdPool.EventId_70;
      public static const ID_OnEntityUpdated:int = IdPool.EventId_71;
      public static const ID_OnEntityDestroyed:int = IdPool.EventId_72;
      
      public static const ID_OnEntityTimer:int = IdPool.EventId_80;
      
      public static const ID_OnShapeMouseDown:int = IdPool.EventId_90;
      public static const ID_OnShapeMouseUp:int = IdPool.EventId_91;
      
   // entity / joint
      
      public static const ID_OnJointReachLowerLimit:int = IdPool.EventId_111;
      public static const ID_OnJointReachUpperLimit:int = IdPool.EventId_112;
      
   // entity pair
      
      //public static const ID_OnSensorContainsPhysicsShape:int = IdPool.EventId_130;
      public static const ID_OnTwoPhysicsShapesBeginContacting:int = IdPool.EventId_131;
      public static const ID_OnTwoPhysicsShapesKeepContacting:int = IdPool.EventId_132;
      public static const ID_OnTwoPhysicsShapesEndContacting:int = IdPool.EventId_133;
      
      public static const ID_OnEntityPairTimer:int = IdPool.EventId_150;
      
   // mouse event (entity)
      
      public static const ID_OnPhysicsShapeMouseDown:int = IdPool.EventId_200;
      public static const ID_OnPhysicsShapeMouseUp:int = IdPool.EventId_201;
      public static const ID_OnEntityMouseClick:int = IdPool.EventId_202;
      public static const ID_OnEntityMouseDown:int = IdPool.EventId_203;
      public static const ID_OnEntityMouseUp:int = IdPool.EventId_204;
      public static const ID_OnEntityMouseMove:int = IdPool.EventId_205;
      public static const ID_OnEntityMouseEnter:int = IdPool.EventId_206; // mouse_over with mouseChildren == false
      public static const ID_OnEntityMouseOut:int = IdPool.EventId_207;
      
      public static const MaxEntityMouseEventId:int = ID_OnEntityMouseOut; 
      
   // mouse event (world)
      
      public static const ID_OnWorldMouseClick:int = IdPool.EventId_210;
      public static const ID_OnWorldMouseDown:int = IdPool.EventId_211;
      public static const ID_OnWorldMouseUp:int = IdPool.EventId_212;
      public static const ID_OnWorldMouseMove:int = IdPool.EventId_213;
      
      public static const MaxWorldMouseEventId:int = ID_OnWorldMouseMove; 
      
   // keyboard event
      
      public static const ID_OnWorldKeyDown:int = IdPool.EventId_220;
      public static const ID_OnWorldKeyUp:int = IdPool.EventId_221;
      public static const ID_OnWorldKeyHold:int = IdPool.EventId_222;
      
   // ================================
   }
}
