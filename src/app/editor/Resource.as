package editor {
   
   import flash.utils.Dictionary;
   import flash.display.Bitmap;
   
   import common.trigger.CoreEventIds;
   
   public class Resource
   {
   // camera icon
      
      [Embed("../../res/create/camera.png")]
      public static const IconCamera:Class;
      
      [Embed("../../res/create/force-linear.png")]
      public static const IconForce:Class;
      [Embed("../../res/create/force-angular.png")]
      public static const IconTorque:Class;
      [Embed("../../res/create/acceleration-linear.png")]
      public static const IconLinearAcceleration:Class;
      [Embed("../../res/create/acceleration-angular.png")]
      public static const IconAngularAcceleration:Class;
      [Embed("../../res/create/impulse-linear.png")]
      public static const IconLinearImpulse:Class;
      [Embed("../../res/create/impulse-angular.png")]
      public static const IconAngularImpulse:Class;
      [Embed("../../res/create/velocity-linear.png")]
      public static const IconLinearVelocity:Class;
      [Embed("../../res/create/velocity-angular.png")]
      public static const IconAngularVelocity:Class;
      
   // conditon and action, entity limiters
      
      [Embed("../../res/create/condition.png")]
      public static const IconBasicCondition:Class;
      [Embed("../../res/create/action.png")]
      public static const IconTriggerAction:Class;
      [Embed("../../res/create/input_entity_limiter.png")]
      public static const IconInputEntityManualAssigner:Class;
      [Embed("../../res/create/input_entity_pair_limiter.png")]
      public static const IconInputEntityPairManualAssigner:Class;
      [Embed("../../res/create/input_entity_region_selector.png")]
      public static const IconInputEntityRegionSelector:Class;
      [Embed("../../res/create/input_entity_filter.png")]
      public static const IconInputEntityScriptFilter:Class;
      [Embed("../../res/create/input_entity_pair_filter.png")]
      public static const IconInputEntityPairScriptFilter:Class;
      
   // event icons
      
      //
      
      [Embed("../../res/create/event_on_game_activated.png")]
      public static const IconOnGameActivatedEvent:Class;
      [Embed("../../res/create/event_on_game_deactivated.png")]
      public static const IconOnGameDeactivatedEvent:Class;
      
      [Embed("../../res/create/event_on_world_before_repainting.png")]
      public static const IconOnWorldBeforeRepaintingEvent:Class;
      
      [Embed("../../res/create/event_on_viewport_size_changed.png")]
      public static const IconOnWorldViewportSizeChanged:Class;
      
      // entity init / update / destroy
      
      [Embed("../../res/create/event_on_entity_created.png")]
      public static const IconOnEntityCteatedEvent:Class;
      [Embed("../../res/create/event_on_entity_initilized.png")]
      public static const IconOnEntityInitilizedEvent:Class;
      [Embed("../../res/create/event_on_entity_updated.png")]
      public static const IconOnEntityUpdatedEvent:Class;
      [Embed("../../res/create/event_on_entity_destroyed.png")]
      public static const IconOnEntityDestroyedEvent:Class;
      
      // joint limts
      
      [Embed("../../res/create/event_on_joint_reach_lower_limit.png")]
      public static const IconOnJointReachLowerLimitEvent:Class;
      [Embed("../../res/create/event_on_joint_reach_upper_limit.png")]
      public static const IconOnJointReachUpperLimitEvent:Class;
      
      // text changed
      
      [Embed("../../res/create/event_on_text_changed.png")]
      public static const IconOnTextChangedEvent:Class;
      
      // level init / update
      
      [Embed("../../res/create/event_on_level_before_initilizing.png")]
      public static const IconOnBeforeLevelInitializingEvent:Class;
      [Embed("../../res/create/event_on_level_after_initilized.png")]
      public static const IconOnAfterLevelInitializedEvent:Class;
      [Embed("../../res/create/event_on_level_before_updating.png")]
      public static const IconOnBeforeLevelUpdatingEvent:Class;
      [Embed("../../res/create/event_on_level_after_updated.png")]
      public static const IconOnAfterLevelUpdatedEvent:Class;
      [Embed("../../res/create/event_on_level_before_exiting.png")]
      public static const IconOnBeforeLevelExitingEvent:Class;
      
      // shape contact
      
      [Embed("../../res/create/event_on_shape_start_contacting.png")]
      public static const IconOnShapeStartContactingEvent:Class;
      [Embed("../../res/create/event_on_shape_keep_contacting.png")]
      public static const IconOnShapeKeepContactingEvent:Class;
      [Embed("../../res/create/event_on_shape_stop_contacting.png")]
      public static const IconOnShapeStopContactingEvent:Class;
      
      [Embed("../../res/create/event_on_shape_pre_solve_colliding.png")]
      public static const IconOnTwoPhysicsShapesPreSolveContacting:Class;
      [Embed("../../res/create/event_on_shape_post_solve_colliding.png")]
      public static const IconOnTwoPhysicsShapesPostSolveContacting:Class;
      
      // module loop to end
      
      [Embed("../../res/create/event_on_module_loop_to_end.png")]
      public static const IconOnShapeModuleLoopToEndEvent:Class;
      
      // keyboard
      
      [Embed("../../res/create/event_on_key_down.png")]
      public static const IconOnKeyDownEvent:Class;
      [Embed("../../res/create/event_on_key_up.png")]
      public static const IconOnKeyUpEvent:Class;
      [Embed("../../res/create/event_on_key_hold.png")]
      public static const IconOnKeyHoldEvent:Class;
      
      // touch
      
      [Embed("../../res/create/event_on_world_touch_tap.png")]
      public static const IconOnWorldTouchTapEvent:Class;
      [Embed("../../res/create/event_on_world_touch_move.png")]
      public static const IconOnWorldTouchMoveEvent:Class;
      [Embed("../../res/create/event_on_world_touch_begin.png")]
      public static const IconOnWorldTouchBeginEvent:Class;
      [Embed("../../res/create/event_on_world_touch_end.png")]
      public static const IconOnWorldTouchEndEvent:Class;
      
      [Embed("../../res/create/event_on_shape_touch_tap.png")]
      public static const IconOnEntityTouchTapEvent:Class;
      [Embed("../../res/create/event_on_shape_touch_move.png")]
      public static const IconOnEntityTouchMoveEvent:Class;
      [Embed("../../res/create/event_on_shape_touch_begin.png")]
      public static const IconOnEntityTouchBeginEvent:Class;
      [Embed("../../res/create/event_on_shape_touch_end.png")]
      public static const IconOnEntityTouchEndEvent:Class;
      [Embed("../../res/create/event_on_shape_touch_enter.png")]
      public static const IconOnEntityTouchEnterEvent:Class;
      [Embed("../../res/create/event_on_shape_touch_out.png")]
      public static const IconOnEntityTouchOutEvent:Class;
      
      // mouse
      
      [Embed("../../res/create/event_on_world_mouse_right_clicked.png")]
      public static const IconOnWorldMouseRightClickedEvent:Class;
      [Embed("../../res/create/event_on_world_mouse_right_down.png")]
      public static const IconOnWorldMouseRightDownEvent:Class;
      [Embed("../../res/create/event_on_world_mouse_right_up.png")]
      public static const IconOnWorldMouseRightUpEvent:Class;
      
      [Embed("../../res/create/event_on_world_mouse_clicked.png")]
      public static const IconOnWorldMouseClickedEvent:Class;
      [Embed("../../res/create/event_on_world_mouse_move.png")]
      public static const IconOnWorldMouseMoveEvent:Class;
      [Embed("../../res/create/event_on_world_mouse_down.png")]
      public static const IconOnWorldMouseDownEvent:Class;
      [Embed("../../res/create/event_on_world_mouse_up.png")]
      public static const IconOnWorldMouseUpEvent:Class;
      
      [Embed("../../res/create/event_on_physics_shape_mouse_right_down.png")]
      public static const IconOnPhysicsEntityMouseRightDownEvent:Class;
      [Embed("../../res/create/event_on_physics_shape_mouse_right_up.png")]
      public static const IconOnPhysicsEntityMouseRightUpEvent:Class;
      
      [Embed("../../res/create/event_on_physics_shape_mouse_down.png")]
      public static const IconOnPhysicsEntityMouseDownEvent:Class;
      [Embed("../../res/create/event_on_physics_shape_mouse_up.png")]
      public static const IconOnPhysicsEntityMouseUpEvent:Class;
      
      [Embed("../../res/create/event_on_shape_mouse_right_clicked.png")]
      public static const IconOnEntityMouseRightClickedEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_right_down.png")]
      public static const IconOnEntityMouseRightDownEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_right_up.png")]
      public static const IconOnEntityMouseRightUpEvent:Class;
      
      [Embed("../../res/create/event_on_shape_mouse_clicked.png")]
      public static const IconOnEntityMouseClickedEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_move.png")]
      public static const IconOnEntityMouseMoveEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_down.png")]
      public static const IconOnEntityMouseDownEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_up.png")]
      public static const IconOnEntityMouseUpEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_enter.png")]
      public static const IconOnEntityMouseEnterEvent:Class;
      [Embed("../../res/create/event_on_shape_mouse_out.png")]
      public static const IconOnEntityMouseOutEvent:Class;
      
      // timer
      
      [Embed("../../res/create/event_on_entity_timer.png")]
      public static const IconOnEntityTimerEvent:Class;
      
      [Embed("../../res/create/event_on_entity_pair_timer.png")]
      public static const IconOnEntityPairTimerEvent:Class;
      
      [Embed("../../res/create/event_on_world_timer.png")]
      public static const IconOnWorldTimerEvent:Class;
      
      // gesture
      
      [Embed("../../res/create/event_on_mouse_gesture.png")]
      public static const IconOnMouseGesture:Class;
      
      // system back
      
      [Embed("../../res/create/event_on_system_back.png")]
      public static const IconOnSystemBack:Class;
      
      // network
      
      [Embed("../../res/create/event_on_multiple-instance-info.png")]
      public static const IconOnMultiplePlayerInstanceInfoChanged:Class;
      [Embed("../../res/create/event_on_multiple-instance-channel-message.png")]
      public static const IconOnMultiplePlayerInstanceChannelMessage:Class;
      
      [Embed("../../res/create/event_on_error.png")]
      public static const IconOnError:Class;
      
   // event id -> icon
      
      private static var sEventId2IconClass:Dictionary = null;
      
      public static function EventId2IconBitmap (eventId:int):Bitmap
      {
         if (sEventId2IconClass == null)
         {
            sEventId2IconClass = new Dictionary ();
            
            sEventId2IconClass [CoreEventIds.ID_OnGameActivated  ] = IconOnGameActivatedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnGameDeactivated] = IconOnGameDeactivatedEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldBeforeRepainting] = IconOnWorldBeforeRepaintingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldViewportSizeChanged] = IconOnWorldViewportSizeChanged;
            
            sEventId2IconClass [CoreEventIds.ID_OnEntityCreated    ] = IconOnEntityCteatedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityInitialized] = IconOnEntityInitilizedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityUpdated    ] = IconOnEntityUpdatedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityDestroyed  ] = IconOnEntityDestroyedEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnJointReachLowerLimit] = IconOnJointReachLowerLimitEvent;
            sEventId2IconClass [CoreEventIds.ID_OnJointReachUpperLimit] = IconOnJointReachUpperLimitEvent;

            sEventId2IconClass [CoreEventIds.ID_OnTextChanged] = IconOnTextChangedEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldBeforeInitializing] = IconOnBeforeLevelInitializingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldAfterInitialized  ] = IconOnAfterLevelInitializedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldBeforeUpdating    ] = IconOnBeforeLevelUpdatingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldAfterUpdated      ] = IconOnAfterLevelUpdatedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldBeforeExiting     ] = IconOnBeforeLevelExitingEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnTwoPhysicsShapesBeginContacting] = IconOnShapeStartContactingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnTwoPhysicsShapesKeepContacting ] = IconOnShapeKeepContactingEvent;
            sEventId2IconClass [CoreEventIds.ID_OnTwoPhysicsShapesEndContacting  ] = IconOnShapeStopContactingEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnTwoPhysicsShapesPreSolveContacting ] = IconOnTwoPhysicsShapesPreSolveContacting;
            sEventId2IconClass [CoreEventIds.ID_OnTwoPhysicsShapesPostSolveContacting] = IconOnTwoPhysicsShapesPostSolveContacting;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldKeyDown] = IconOnKeyDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldKeyUp  ] = IconOnKeyUpEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldKeyHold] = IconOnKeyHoldEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldTouchTap   ] = IconOnWorldTouchTapEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldTouchBegin ] = IconOnWorldTouchBeginEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldTouchEnd   ] = IconOnWorldTouchEndEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldTouchMove  ] = IconOnWorldTouchMoveEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnEntityTouchTap     ] = IconOnEntityTouchTapEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityTouchBegin   ] = IconOnEntityTouchBeginEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityTouchEnd     ] = IconOnEntityTouchEndEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityTouchMove    ] = IconOnEntityTouchMoveEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityTouchEnter   ] = IconOnEntityTouchEnterEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityTouchOut     ] = IconOnEntityTouchOutEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseRightClick] = IconOnWorldMouseRightClickedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseRightDown ] = IconOnWorldMouseRightDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseRightUp   ] = IconOnWorldMouseRightUpEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseClick] = IconOnWorldMouseClickedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseDown ] = IconOnWorldMouseDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseUp   ] = IconOnWorldMouseUpEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldMouseMove ] = IconOnWorldMouseMoveEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnPhysicsShapeMouseRightDown] = IconOnPhysicsEntityMouseRightDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnPhysicsShapeMouseRightUp  ] = IconOnPhysicsEntityMouseRightUpEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseRightClick     ] = IconOnEntityMouseRightClickedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseRightDown      ] = IconOnEntityMouseRightDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseRightUp        ] = IconOnEntityMouseRightUpEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnPhysicsShapeMouseDown] = IconOnPhysicsEntityMouseDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnPhysicsShapeMouseUp  ] = IconOnPhysicsEntityMouseUpEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseClick     ] = IconOnEntityMouseClickedEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseDown      ] = IconOnEntityMouseDownEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseUp        ] = IconOnEntityMouseUpEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseMove      ] = IconOnEntityMouseMoveEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseEnter     ] = IconOnEntityMouseEnterEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityMouseOut       ] = IconOnEntityMouseOutEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnSequencedModuleLoopToEnd] = IconOnShapeModuleLoopToEndEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnEntityTimer    ] = IconOnEntityTimerEvent;
            sEventId2IconClass [CoreEventIds.ID_OnEntityPairTimer] = IconOnEntityPairTimerEvent;
            sEventId2IconClass [CoreEventIds.ID_OnWorldTimer     ] = IconOnWorldTimerEvent;
            
            sEventId2IconClass [CoreEventIds.ID_OnMouseGesture   ] = IconOnMouseGesture;
            
            sEventId2IconClass [CoreEventIds.ID_OnSystemBack   ] = IconOnSystemBack;
            
            sEventId2IconClass [CoreEventIds.ID_OnMultiplePlayerInstanceInfoChanged] = IconOnMultiplePlayerInstanceInfoChanged;
            sEventId2IconClass [CoreEventIds.ID_OnMultiplePlayerInstanceChannelMessage] = IconOnMultiplePlayerInstanceChannelMessage;
            
            
            sEventId2IconClass [CoreEventIds.ID_OnError] = IconOnError;
         }
         
         var iconClass:Class = sEventId2IconClass [eventId];
         
         return iconClass == null ? null : new iconClass ();
      }
      
   // keyboard icons
      
      [Embed("../../res/keyboard/keyboard.png")]
      public static const Keyboard:Class;

      [Embed("../../res/keyboard/key-escape-sel.png")]
      public static const KeyEscape:Class;
      
      [Embed("../../res/keyboard/key-a-sel.png")]
      public static const KeyA:Class;
      [Embed("../../res/keyboard/key-b-sel.png")]
      public static const KeyB:Class;
      [Embed("../../res/keyboard/key-c-sel.png")]
      public static const KeyC:Class;
      [Embed("../../res/keyboard/key-d-sel.png")]
      public static const KeyD:Class;
      [Embed("../../res/keyboard/key-e-sel.png")]
      public static const KeyE:Class;
      [Embed("../../res/keyboard/key-f-sel.png")]
      public static const KeyF:Class;
      [Embed("../../res/keyboard/key-g-sel.png")]
      public static const KeyG:Class;
      [Embed("../../res/keyboard/key-h-sel.png")]
      public static const KeyH:Class;
      [Embed("../../res/keyboard/key-i-sel.png")]
      public static const KeyI:Class;
      [Embed("../../res/keyboard/key-j-sel.png")]
      public static const KeyJ:Class;
      [Embed("../../res/keyboard/key-k-sel.png")]
      public static const KeyK:Class;
      [Embed("../../res/keyboard/key-l-sel.png")]
      public static const KeyL:Class;
      [Embed("../../res/keyboard/key-m-sel.png")]
      public static const KeyM:Class;
      [Embed("../../res/keyboard/key-n-sel.png")]
      public static const KeyN:Class;
      [Embed("../../res/keyboard/key-o-sel.png")]
      public static const KeyO:Class;
      [Embed("../../res/keyboard/key-p-sel.png")]
      public static const KeyP:Class;
      [Embed("../../res/keyboard/key-q-sel.png")]
      public static const KeyQ:Class;
      [Embed("../../res/keyboard/key-r-sel.png")]
      public static const KeyR:Class;
      [Embed("../../res/keyboard/key-s-sel.png")]
      public static const KeyS:Class;
      [Embed("../../res/keyboard/key-t-sel.png")]
      public static const KeyT:Class;
      [Embed("../../res/keyboard/key-u-sel.png")]
      public static const KeyU:Class;
      [Embed("../../res/keyboard/key-v-sel.png")]
      public static const KeyV:Class;
      [Embed("../../res/keyboard/key-w-sel.png")]
      public static const KeyW:Class;
      [Embed("../../res/keyboard/key-x-sel.png")]
      public static const KeyX:Class;
      [Embed("../../res/keyboard/key-y-sel.png")]
      public static const KeyY:Class;
      [Embed("../../res/keyboard/key-z-sel.png")]
      public static const KeyZ:Class;
      [Embed("../../res/keyboard/key-up-sel.png")]
      public static const KeyUp:Class;
      [Embed("../../res/keyboard/key-down-sel.png")]
      public static const KeyDown:Class;
      [Embed("../../res/keyboard/key-left-sel.png")]
      public static const KeyLeft:Class;
      [Embed("../../res/keyboard/key-right-sel.png")]
      public static const KeyRight:Class;
      [Embed("../../res/keyboard/key-space-sel.png")]
      public static const KeySpace:Class;
      [Embed("../../res/keyboard/key-backspace-sel.png")]
      public static const KeyBackspace:Class;
      [Embed("../../res/keyboard/key-ctrl-sel.png")]
      public static const KeyCtrl:Class;
      [Embed("../../res/keyboard/key-shift-sel.png")]
      public static const KeyShift:Class;
      [Embed("../../res/keyboard/key-caps-sel.png")]
      public static const KeyCaps:Class;
      [Embed("../../res/keyboard/key-tab-sel.png")]
      public static const KeyTab:Class;
      [Embed("../../res/keyboard/key-0-sel.png")]
      public static const Key0:Class;
      [Embed("../../res/keyboard/key-1-sel.png")]
      public static const Key1:Class;
      [Embed("../../res/keyboard/key-2-sel.png")]
      public static const Key2:Class;
      [Embed("../../res/keyboard/key-3-sel.png")]
      public static const Key3:Class;
      [Embed("../../res/keyboard/key-4-sel.png")]
      public static const Key4:Class;
      [Embed("../../res/keyboard/key-5-sel.png")]
      public static const Key5:Class;
      [Embed("../../res/keyboard/key-6-sel.png")]
      public static const Key6:Class;
      [Embed("../../res/keyboard/key-7-sel.png")]
      public static const Key7:Class;
      [Embed("../../res/keyboard/key-8-sel.png")]
      public static const Key8:Class;
      [Embed("../../res/keyboard/key-9-sel.png")]
      public static const Key9:Class;
      [Embed("../../res/keyboard/key-enter-sel.png")]
      public static const KeyEnter:Class;
      [Embed("../../res/keyboard/key-quote-sel.png")]
      public static const KeyQuote:Class;
      [Embed("../../res/keyboard/key-backquote-sel.png")]
      public static const KeyBackquote:Class;
      [Embed("../../res/keyboard/key-slash-sel.png")]
      public static const KeySlash:Class;
      [Embed("../../res/keyboard/key-backslash-sel.png")]
      public static const KeyBackslash:Class;
      [Embed("../../res/keyboard/key-comma-sel.png")]
      public static const KeyComma:Class;
      [Embed("../../res/keyboard/key-period-sel.png")]
      public static const KeyPeriod:Class;
      [Embed("../../res/keyboard/key-semicolon-sel.png")]
      public static const KeySemicolon:Class;
      [Embed("../../res/keyboard/key-square-bracket-left-sel.png")]
      public static const KeySquareBracketLeft:Class;
      [Embed("../../res/keyboard/key-square-bracket-right-sel.png")]
      public static const KeySquareBracketRight:Class;
      [Embed("../../res/keyboard/key-add-sel.png")]
      public static const KeyAdd:Class;
      [Embed("../../res/keyboard/key-subtract-sel.png")]
      public static const KeySubtract:Class;
      [Embed("../../res/keyboard/key-pageup-sel.png")]
      public static const KeyPageup:Class;
      [Embed("../../res/keyboard/key-pagedown-sel.png")]
      public static const KeyPagedown:Class;
      [Embed("../../res/keyboard/key-home-sel.png")]
      public static const KeyHome:Class;
      [Embed("../../res/keyboard/key-end-sel.png")]
      public static const KeyEnd:Class;
      [Embed("../../res/keyboard/key-insert-sel.png")]
      public static const KeyInsert:Class;
      [Embed("../../res/keyboard/key-del-sel.png")]
      public static const KeyDel:Class;
      
   // gesture icons
      
      [Embed("../../res/gesture/line-000.png")]
      public static const Gesture_Line000:Class;
      [Embed("../../res/gesture/line-000-sel.png")]
      public static const Gesture_Line000_Selected:Class;
      [Embed("../../res/gesture/line-045.png")]
      public static const Gesture_Line045:Class;
      [Embed("../../res/gesture/line-045-sel.png")]
      public static const Gesture_Line045_Selected:Class;
      
      [Embed("../../res/gesture/line-arrow-000.png")]
      public static const Gesture_LineArrow000:Class;
      [Embed("../../res/gesture/line-arrow-000-sel.png")]
      public static const Gesture_LineArrow000_Selected:Class;
      [Embed("../../res/gesture/line-arrow-045.png")]
      public static const Gesture_LineArrow045:Class;
      [Embed("../../res/gesture/line-arrow-045-sel.png")]
      public static const Gesture_LineArrow045_Selected:Class;
      
      [Embed("../../res/gesture/arrow-000.png")]
      public static const Gesture_Arrow000:Class;
      [Embed("../../res/gesture/arrow-000-sel.png")]
      public static const Gesture_Arrow000_Selected:Class;
      [Embed("../../res/gesture/arrow-045.png")]
      public static const Gesture_Arrow045:Class;
      [Embed("../../res/gesture/arrow-045-sel.png")]
      public static const Gesture_Arrow045_Selected:Class;
      
      [Embed("../../res/gesture/pool-000.png")]
      public static const Gesture_Pool000:Class;
      [Embed("../../res/gesture/pool-000-sel.png")]
      public static const Gesture_Pool000_Selected:Class;
      
      [Embed("../../res/gesture/wave-000.png")]
      public static const Gesture_Wave000:Class;
      [Embed("../../res/gesture/wave-000-sel.png")]
      public static const Gesture_Wave000_Selected:Class;
      
      [Embed("../../res/gesture/zigzag-z.png")]
      public static const Gesture_ZigzagZ:Class;
      [Embed("../../res/gesture/zigzag-z-sel.png")]
      public static const Gesture_ZigzagZ_Selected:Class;
      [Embed("../../res/gesture/zigzag-s.png")]
      public static const Gesture_ZigzagS:Class;
      [Embed("../../res/gesture/zigzag-s-sel.png")]
      public static const Gesture_ZigzagS_Selected:Class;
      
      [Embed("../../res/gesture/long-press.png")]
      public static const Gesture_LongPress:Class;
      [Embed("../../res/gesture/long-press-sel.png")]
      public static const Gesture_LongPress_Selected:Class;
      
      [Embed("../../res/gesture/circle.png")]
      public static const Gesture_Circle:Class;
      [Embed("../../res/gesture/circle-sel.png")]
      public static const Gesture_Circle_Selected:Class;
      
      [Embed("../../res/gesture/triangle.png")]
      public static const Gesture_Triangle:Class;
      [Embed("../../res/gesture/triangle-sel.png")]
      public static const Gesture_Triangle_Selected:Class;
      
      [Embed("../../res/gesture/five-point-star.png")]
      public static const Gesture_FivePointStar:Class;
      [Embed("../../res/gesture/five-point-star-sel.png")]
      public static const Gesture_FivePointStar_Selected:Class;
   }
}
