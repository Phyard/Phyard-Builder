//==================================
// keyboard event handler
//==================================
   
   protected var mKeyDownEventHandlerLists:Array = new Array (KeyCodes.kNumKeys);
   protected var mKeyUpEventHandlerLists:Array = new Array (KeyCodes.kNumKeys);
   protected var mKeyHoldEventHandlerLists:Array = new Array (KeyCodes.kNumKeys);
   
   public function RegisterKeyboardEventHandler (keyboardEventHandler:EntityEventHandler_Keyboard, keyCodes:Array):void
   {
      if (keyboardEventHandler == null || keyCodes == null || keyCodes.length == 0)
         return;
      
      switch (keyboardEventHandler.GetEventId ())
      {
         case CoreEventIds.ID_OnWorldKeyDown:
            RegisterKeyboardEventHandlerToLists (mKeyDownEventHandlerLists, keyboardEventHandler, keyCodes);
            break;
         case CoreEventIds.ID_OnWorldKeyUp:
            RegisterKeyboardEventHandlerToLists (mKeyUpEventHandlerLists, keyboardEventHandler, keyCodes);
            break;
         case CoreEventIds.ID_OnWorldKeyHold:
            RegisterKeyboardEventHandlerToLists (mKeyHoldEventHandlerLists, keyboardEventHandler, keyCodes);
            break;
         default:
            break;
      }
   }
   
   private static function RegisterKeyboardEventHandlerToLists (keyEventHandlerLists:Array, keyboardEventHandler:EntityEventHandler_Keyboard, keyCodes:Array):void
   {
      for (var i:int = 0; i < keyCodes.length; ++ i)
      {
         var keyCode:int = keyCodes [i];
         if (keyCode < 0 || keyCode >= KeyCodes.kNumKeys)
            continue;
         
         var listHead:ListElement_EventHandler = keyEventHandlerLists [keyCode];
         
         var newHead:ListElement_EventHandler = new ListElement_EventHandler (keyboardEventHandler);
         newHead.mNextListElement = listHead;
         keyEventHandlerLists [keyCode] = newHead;
      }
   }
   
   private var mKeyboardEventHandlerValueSource4:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.GetNumberClassDefinition (), 0, null);
   private var mKeyboardEventHandlerValueSource3:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.GetBooleanClassDefinition (), false, mKeyboardEventHandlerValueSource4);
   private var mKeyboardEventHandlerValueSource2:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.GetBooleanClassDefinition (), false, mKeyboardEventHandlerValueSource3);
   private var mKeyboardEventHandlerValueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.GetNumberClassDefinition (), 0, mKeyboardEventHandlerValueSource2);
   private var mKeyboardEventHandlerValueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.GetNumberClassDefinition (), 0, mKeyboardEventHandlerValueSource1);
   private var mKeyboardEventHandlerValueSourceList:Parameter = mKeyboardEventHandlerValueSource0;
   
   // key down and up events have already handled when they are triggered.
   private function HandleKeyHoldEvents ():void
   {
      if (! IsInteractiveEnabledNow ())
         return;
      
      if (mKeyHoldListHead < 0)
         return;
      
      var info:Array;
      var ticks:int;
      var listElement:ListElement_EventHandler;
      
      mKeyboardEventHandlerValueSource2.mValueObject = IsKeyHold (Keyboard.CONTROL);
      mKeyboardEventHandlerValueSource3.mValueObject = IsKeyHold (Keyboard.SHIFT);
      
  //var num:int = 0;
      var keyCode:int = mKeyHoldListHead;
      while (keyCode >= 0)
      {
  //if (++ num > 1)
  //  trace (num + ", keyCode = " + keyCode);
         info = mKeyHoldInfo [keyCode];
         ticks = info [KeyHoldInfo_Ticks];
         if (ticks > 0)
         {
            mKeyboardEventHandlerValueSource0.mValueObject = keyCode;
            mKeyboardEventHandlerValueSource1.mValueObject = info [KeyHoldInfo_CharCode];
            mKeyboardEventHandlerValueSource4.mValueObject = ticks;
            
            listElement = mKeyHoldEventHandlerLists [keyCode];
            
            IncStepStage ();
            while (listElement != null)
            {
               listElement.mEventHandler.HandleEvent (mKeyboardEventHandlerValueSourceList);
               
               listElement = listElement.mNextListElement;
            }
         }
         
         info [KeyHoldInfo_Ticks] = ++ ticks;
         
         keyCode = info [KeyHoldInfo_Next];
      }
   }
   
// the key-hold info will be moved to Level class later

   public static const KeyHoldInfo_IsHold:int = 0;
   public static const KeyHoldInfo_CharCode:int = 1;
   public static const KeyHoldInfo_Ticks:int = 2;
   public static const KeyHoldInfo_Next:int = 3;
   public static const KeyHoldInfo_Prev:int = 4;

   private var mKeyHoldInfo:Array = null;
   private var mKeyHoldListHead:int = -1;

   private function KeyPressed (keyCode:int, charCode:int):void
   {
      if (mKeyHoldInfo == null) // world is not inited yet
         return;
      
      if (keyCode < 0 || keyCode >= KeyCodes.kNumKeys)
         return;
      
      var info:Array = mKeyHoldInfo [keyCode];
      
      info [KeyHoldInfo_IsHold  ] = true;
      info [KeyHoldInfo_CharCode] = charCode;
      info [KeyHoldInfo_Ticks   ] = 0;
      info [KeyHoldInfo_Next    ] = mKeyHoldListHead;
      info [KeyHoldInfo_Prev    ] = -1;
      
      if (mKeyHoldListHead >= 0)
      {
         var oldHeadInfo:Array = mKeyHoldInfo [mKeyHoldListHead];
         oldHeadInfo [KeyHoldInfo_Prev] = keyCode;
      }
      mKeyHoldListHead = keyCode;
   }

   private function KeyReleased (keyCode:int, charCode:int):void
   {
      if (mKeyHoldInfo == null) // world is not inited yet
         return;
      
      if (keyCode < 0 || keyCode >= KeyCodes.kNumKeys)
         return;
      
      var info:Array = mKeyHoldInfo [keyCode];
      
      if (info [KeyHoldInfo_IsHold  ] == false)
         return;
      
      var next:int = info [KeyHoldInfo_Next   ];
      var prev:int = info [KeyHoldInfo_Prev   ];
      
      info [KeyHoldInfo_IsHold  ] = false;
      info [KeyHoldInfo_CharCode] = charCode;
      info [KeyHoldInfo_Ticks   ] = 0;
      info [KeyHoldInfo_Next    ] = -1;
      info [KeyHoldInfo_Prev    ] = -1;
      
      if (next >= 0)
      {
         var nextInfo:Array = mKeyHoldInfo [next];
         nextInfo [KeyHoldInfo_Prev] = prev;
      }
      
      if (prev >= 0)
      {
         var prevInfo:Array = mKeyHoldInfo [prev];
         prevInfo [KeyHoldInfo_Next] = next;
      }
      else // keyCode == mKeyHoldListHead
      {
         mKeyHoldListHead = next;
      }
   }

   public function IsKeyHold (keyCode:int):Boolean
   {
      if (mKeyHoldInfo == null) // world is not inited yet
         return false;
      
      if (keyCode < 0 || keyCode >= KeyCodes.kNumKeys)
         return false;

      return mKeyHoldInfo [keyCode][KeyHoldInfo_IsHold];
   }

   private function InitKeyHoldInfo ():void
   {
      if (mKeyHoldInfo != null)
         return;
      
      mKeyHoldInfo = new Array (KeyCodes.kNumKeys)
      
      for (var keyCode:int = 0; keyCode < KeyCodes.kNumKeys; ++ keyCode)
      {
         var info:Array = new Array (4);
         mKeyHoldInfo [keyCode] = info;
      }
      
      ClearKeyHoldInfo (false);
   }

   public function ClearKeyHoldInfo (fireKeyReleasedEvents:Boolean):void
   {
      if (mKeyHoldInfo == null) // world is not inited yet
         return;
      
      // mouse
      
      mIsMouseButtonDown = false; // the status may be different with that one in mKeyHoldListHead. Remove this variable later?
      
      // keyboard
      
      var info:Array;
      var ticks:int;
      var listElement:ListElement_EventHandler;
      
      var keyCode:int = mKeyHoldListHead;
      mKeyHoldListHead = -1;
      
      while (keyCode >= 0)
      {
         if (keyCode != KeyCodes.LeftMouseButton)
         {
            info = mKeyHoldInfo [keyCode];
            
            if (fireKeyReleasedEvents)
            {
               _KeyboardUpEvent.keyCode  = keyCode;
               _KeyboardUpEvent.charCode = info [KeyHoldInfo_CharCode];
               _KeyboardUpEvent.ctrlKey  = IsKeyHold (Keyboard.CONTROL);
               _KeyboardUpEvent.shiftKey = IsKeyHold (Keyboard.SHIFT);
               //HandleKeyEventByKeyCode (_KeyboardUpEvent, false);
               RegisterKeyboardEvent (keyCode, _KeyboardUpEvent, mKeyUpEventHandlerLists);
            }
            
            var nextKeyCode:int = info [KeyHoldInfo_Next];
            
            info [KeyHoldInfo_IsHold] = false;
            info [KeyHoldInfo_Ticks ] = 0;
            info [KeyHoldInfo_Next  ] = -1;
            info [KeyHoldInfo_Prev  ] = -1;
         }
         
         keyCode = nextKeyCode;
      }
   }
   
   //public function SetKeyboardEventHandlingEnabled (enabled:Boolean):void
   //{
   //   
   //}

