package editor.runtime {
   
   public class Resource
   {
   // camera icon
      
      [Embed("../../res/create/camera.png")]
      public static var IconCamera:Class;
      
   // event icons
      
      // entity init / update / destroy
      
      [Embed("../../res/create/event_on_entity_initilized.png")]
      public static var IconOnEntityInitilizedEvent:Class;
      [Embed("../../res/create/event_on_entity_updated.png")]
      public static var IconOnEntityUpdatedEvent:Class;
      [Embed("../../res/create/event_on_entity_destroyed.png")]
      public static var IconOnEntityDestroyedEvent:Class;
      
      // joint limts
      
      [Embed("../../res/create/event_on_joint_reach_lower_limit.png")]
      public static var IconOnJointReachLowerLimitEvent:Class;
      [Embed("../../res/create/event_on_joint_reach_upper_limit.png")]
      public static var IconOnJointReachUpperLimitEvent:Class;
      
      // level init / update
      
      [Embed("../../res/create/event_on_level_before_initilizing.png")]
      public static var IconOnBeforeLevelInitializingEvent:Class;
      [Embed("../../res/create/event_on_level_after_initilized.png")]
      public static var IconOnAfterLevelInitializedEvent:Class;
      [Embed("../../res/create/event_on_level_before_updating.png")]
      public static var IconOnBeforeLevelUpdatingEvent:Class;
      [Embed("../../res/create/event_on_level_after_updated.png")]
      public static var IconOnAfterLevelUpdatedEvent:Class;
      
      // shape contact
      
      [Embed("../../res/create/event_on_shape_start_contacting.png")]
      public static var IconOnShapeStartContactingEvent:Class;
      [Embed("../../res/create/event_on_shape_keep_contacting.png")]
      public static var IconOnShapeKeepContactingEvent:Class;
      [Embed("../../res/create/event_on_shape_stop_contacting.png")]
      public static var IconOnShapeStopContactingEvent:Class;
      
      // keyboard
      
      [Embed("../../res/create/event_on_keyboard.png")]
      public static var IconOnKeyDownEvent:Class;
      
      // mouse
      
      [Embed("../../res/create/event_on_world_mouse_clicked.png")]
      public static var IconOnWorldMouseClickedEvent:Class;
      
      [Embed("../../res/create/event_on_shape_mouse_clicked.png")]
      public static var IconOnEntityMouseClickedEvent:Class;
      
      // timer
      
      [Embed("../../res/create/event_on_entity_timer.png")]
      public static var IconOnEntityTimerEvent:Class;
      
      [Embed("../../res/create/event_on_entity_pair_timer.png")]
      public static var IconOnEntityPairTimerEvent:Class;
      
      [Embed("../../res/create/event_on_world_timer.png")]
      public static var IconOnWorldTimerEvent:Class;
      
   // keyboard icons
      
      [Embed("../../res/keyboard/keyboard-wasd-space.png")]
      public static var KeyboardSpaceAndWASD:Class;
      [Embed("../../res/keyboard/key-a-sel.png")]
      public static var KeyA:Class;
      [Embed("../../res/keyboard/key-d-sel.png")]
      public static var KeyD:Class;
      [Embed("../../res/keyboard/key-s-sel.png")]
      public static var KeyS:Class;
      [Embed("../../res/keyboard/key-w-sel.png")]
      public static var KeyW:Class;
      [Embed("../../res/keyboard/key-up-sel.png")]
      public static var KeyUp:Class;
      [Embed("../../res/keyboard/key-down-sel.png")]
      public static var KeyDown:Class;
      [Embed("../../res/keyboard/key-left-sel.png")]
      public static var KeyLeft:Class;
      [Embed("../../res/keyboard/key-right-sel.png")]
      public static var KeyRight:Class;
      [Embed("../../res/keyboard/key-SPACE-sel.png")]
      public static var KeySpace:Class;
   }
}
