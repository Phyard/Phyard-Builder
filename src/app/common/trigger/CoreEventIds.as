package common.trigger {

   public class CoreEventIds
   {
      public static const ID_Invalid:int = -1;

   // ...

      public static const ID_OnVoid:int = IdPool.EventId_10;

   // game

      public static const ID_OnGameActivated:int = IdPool.EventId_6;
      public static const ID_OnGameDeactivated:int = IdPool.EventId_7;
      
      public static const ID_OnWorldBeforeRepainting:int = IdPool.EventId_5;

   // world (maybe in later versions)

      public static const ID_OnWorldBeforeInitializing:int = IdPool.EventId_0;
      public static const ID_OnWorldAfterInitialized:int = IdPool.EventId_1;
      public static const ID_OnWorldBeforeUpdating:int = IdPool.EventId_2;
      public static const ID_OnWorldAfterUpdated:int = IdPool.EventId_3;

      public static const ID_OnWorldTimer:int = IdPool.EventId_50;
      public static const ID_OnWorldPreTimer:int = IdPool.EventId_51;
      public static const ID_OnWorldPostTimer:int = IdPool.EventId_52;

   // level

      //public static const ID_OnLevelBeginInitialize:int = IdPool.EventId_30;
      //public static const ID_OnLevelEndInitialize:int = IdPool.EventId_31;
      //public static const ID_OnLevelBeginUpdate:int = IdPool.EventId_32;
      //public static const ID_OnLevelEndUpdate:int = IdPool.EventId_33;

   // entity

      public static const ID_OnEntityCreated:int = IdPool.EventId_69;
      public static const ID_OnEntityInitialized:int = IdPool.EventId_70;
      public static const ID_OnEntityUpdated:int = IdPool.EventId_71;
      public static const ID_OnEntityDestroyed:int = IdPool.EventId_72;

      public static const ID_OnEntityTimer:int = IdPool.EventId_80;

   // entity / shape / module

      public static const ID_OnSequencedModuleLoopToEnd:int = IdPool.EventId_100;

   // entity / joint

      public static const ID_OnJointReachLowerLimit:int = IdPool.EventId_111;
      public static const ID_OnJointReachUpperLimit:int = IdPool.EventId_112;

   // entity / text
   
      public static const ID_OnTextChanged:int = IdPool.EventId_120;

   // entity pair

      //public static const ID_OnSensorContainsPhysicsShape:int = IdPool.EventId_130;
      public static const ID_OnTwoPhysicsShapesBeginContacting:int = IdPool.EventId_131;
      public static const ID_OnTwoPhysicsShapesKeepContacting:int = IdPool.EventId_132;
      public static const ID_OnTwoPhysicsShapesEndContacting:int = IdPool.EventId_133;
      
      public static const ID_OnTwoPhysicsShapesPreSolveContacting:int = IdPool.EventId_138; //
      public static const ID_OnTwoPhysicsShapesPostSolveContacting:int = IdPool.EventId_139; // if this is changed (should not), the ones in CoreFunctionDeclarations should also be chagned.

      public static const ID_OnEntityPairTimer:int = IdPool.EventId_150;

   // mouse event (entity)
      
      public static const ID_OnPhysicsShapeMouseRightDown:int = IdPool.EventId_195;
      public static const ID_OnPhysicsShapeMouseRightUp:int = IdPool.EventId_196;
      public static const ID_OnEntityMouseRightClick:int = IdPool.EventId_197;
      public static const ID_OnEntityMouseRightDown:int = IdPool.EventId_198;
      public static const ID_OnEntityMouseRightUp:int = IdPool.EventId_199;

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
   
      public static const ID_OnWorldMouseRightClick:int = IdPool.EventId_214;
      public static const ID_OnWorldMouseRightDown:int = IdPool.EventId_215;
      public static const ID_OnWorldMouseRightUp:int = IdPool.EventId_216;

      public static const MaxWorldMouseEventId:int = ID_OnWorldMouseRightUp;

   // keyboard event

      public static const ID_OnWorldKeyDown:int = IdPool.EventId_220;
      public static const ID_OnWorldKeyUp:int = IdPool.EventId_221;
      public static const ID_OnWorldKeyHold:int = IdPool.EventId_222;

   // mouse gesture

      public static const ID_OnMouseGesture:int = IdPool.EventId_190;
      
      // note: about multiple touch events, it is best to blend it into the current mouse and gesture events.
      //       by adding a mouse id parameter.
      
   // system back
      
      public static const ID_OnSystemBack:int = IdPool.EventId_189;
      
   // multiple players
      
      //public static const ID_OnPlayerJoinedInstance:int = IdPool.EventId_169;
      //public static const ID_OnPlayerLeavedInstance:int = IdPool.EventId_169;
      //OnSpectatorEntered
      //OnSpectatorExited
      //OnSpectatorHaveInterestsInCurrentRound
      //public static const ID_OnPlayerReadyForNewRound:int = IdPool.EventId_169;
      //public static const ID_OnPlayerLeavedInstance:int = IdPool.EventId_169;
      //public static const ID_OnInstanceCreated:int = IdPool.EventId_169;
      
      
      //public static const ID_OnInstanceRestarted:int = IdPool.EventId_169;
      
      //public static const ID_OnInstanceEnterPlayingPhase:int = IdPool.EventId_169;
      
      public static const ID_OnMultiplePlayerInstanceInfoChanged      :int = IdPool.EventId_167; //       
      
      public static const ID_OnMultiplePlayerInstanceChannelMessage   :int = IdPool.EventId_168; //       

      public static const ID_OnError                                  :int = IdPool.EventId_169; // need an API: GetErrorDebugInfo (errorId)
      
   // ================================
      
   }
}
