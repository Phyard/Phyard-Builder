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
   
   private var mKeyboardEventHandlerValueSource4:ValueSource_Direct = new ValueSource_Direct (null);
   private var mKeyboardEventHandlerValueSource3:ValueSource_Direct = new ValueSource_Direct (null, mKeyboardEventHandlerValueSource4);
   private var mKeyboardEventHandlerValueSource2:ValueSource_Direct = new ValueSource_Direct (null, mKeyboardEventHandlerValueSource3);
   private var mKeyboardEventHandlerValueSource1:ValueSource_Direct = new ValueSource_Direct (null, mKeyboardEventHandlerValueSource2);
   private var mKeyboardEventHandlerValueSource0:ValueSource_Direct = new ValueSource_Direct (null, mKeyboardEventHandlerValueSource1);
   private var mKeyboardEventHandlerValueSourceList:ValueSource = mKeyboardEventHandlerValueSource0;
   
   public function HandleKeyEventByKeyCode (event:KeyboardEvent, isDownEvent:Boolean):void
   {
      var keyCode:int = event.keyCode;
      
      if (keyCode < 0 || keyCode >= KeyCodes.kNumKeys)
         return;
      
      // ...
      mKeyboardEventHandlerValueSource0.mValueObject = keyCode;
      mKeyboardEventHandlerValueSource1.mValueObject = event.charCode;
      mKeyboardEventHandlerValueSource2.mValueObject = event.ctrlKey;
      mKeyboardEventHandlerValueSource3.mValueObject = event.shiftKey;
      mKeyboardEventHandlerValueSource4.mValueObject = mKeyHoldInfo [keyCode][KeyHoldInfo_Ticks];
      
      // ...
      var listElement:ListElement_EventHandler = isDownEvent ? mKeyDownEventHandlerLists [keyCode] : mKeyUpEventHandlerLists [keyCode];
      
      while (listElement != null)
      {
         listElement.mEventHandler.HandleEvent (mKeyboardEventHandlerValueSourceList);
         
         listElement = listElement.mNextListElement;
      }
   }
   
   // key down and up events have already handled when they are triggered.
   private function HandleKeyHoldEvents ():void
   {
      var info:Array;
      var ticks:int;
      var listElement:ListElement_EventHandler;
      
      mKeyboardEventHandlerValueSource2.mValueObject = IsKeyHold (Keyboard.CONTROL);
      mKeyboardEventHandlerValueSource3.mValueObject = IsKeyHold (Keyboard.SHIFT);
      
      var keyCode:int = mKeyHoldListHead;
      while (keyCode >= 0)
      {
         info = mKeyHoldInfo [keyCode];
         ticks = info [KeyHoldInfo_Ticks];
         if (ticks > 0)
         {
            mKeyboardEventHandlerValueSource0.mValueObject = keyCode;
            mKeyboardEventHandlerValueSource1.mValueObject = info [KeyHoldInfo_CharCode];
            mKeyboardEventHandlerValueSource4.mValueObject = ticks;
            
            listElement = mKeyHoldEventHandlerLists [keyCode];
            
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

   private function KeyReleased (keyCode:int):void
   {
      if (keyCode < 0 || keyCode >= KeyCodes.kNumKeys)
         return;
      
      var info:Array = mKeyHoldInfo [keyCode];
      
      if (info [KeyHoldInfo_IsHold  ] == false)
         return;
      
      var next:int = info [KeyHoldInfo_Next   ];
      var prev:int = info [KeyHoldInfo_Prev   ];
      
      info [KeyHoldInfo_IsHold  ] = false;
      info [KeyHoldInfo_CharCode] = 0;
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
      var info:Array;
      var ticks:int;
      var listElement:ListElement_EventHandler;
      
      mKeyboardEventHandlerValueSource2.mValueObject = IsKeyHold (Keyboard.CONTROL);
      mKeyboardEventHandlerValueSource3.mValueObject = IsKeyHold (Keyboard.SHIFT);
      
      var keyCode:int = mKeyHoldListHead;
      mKeyHoldListHead = -1;
      
      while (keyCode >= 0)
      {
         info = mKeyHoldInfo [keyCode];
         
         if (fireKeyReleasedEvents)
         {
            mKeyboardEventHandlerValueSource0.mValueObject = keyCode;
            mKeyboardEventHandlerValueSource1.mValueObject = info [KeyHoldInfo_CharCode];
            mKeyboardEventHandlerValueSource4.mValueObject = info [KeyHoldInfo_Ticks ];
            
            listElement = mKeyUpEventHandlerLists [keyCode];
            
            while (listElement != null)
            {
               listElement.mEventHandler.HandleEvent (mKeyboardEventHandlerValueSourceList);
               
               listElement = listElement.mNextListElement;
            }
         }
         
         keyCode = info [KeyHoldInfo_Next];
         
         info [KeyHoldInfo_IsHold] = false;
         info [KeyHoldInfo_Ticks ] = 0;
         info [KeyHoldInfo_Next  ] = -1;
         info [KeyHoldInfo_Prev  ] = -1;
      }
   }
   

   //public function SetKeyboardEventHandlingEnabled (enabled:Boolean):void
   //{
   //   
   //}

