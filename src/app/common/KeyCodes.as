
package common {
   
   import flash.ui.Keyboard;
   
   public class KeyCodes
   {
      public static const Key_A:int = 65;
      public static const Key_B:int = 66;
      public static const Key_C:int = 67;
      public static const Key_D:int = 68;
      public static const Key_E:int = 69;
      public static const Key_F:int = 70;
      public static const Key_G:int = 71;
      public static const Key_H:int = 72;
      public static const Key_I:int = 73;
      public static const Key_J:int = 74;
      public static const Key_K:int = 75;
      public static const Key_L:int = 76;
      public static const Key_M:int = 77;
      public static const Key_N:int = 78;
      public static const Key_O:int = 79;
      public static const Key_P:int = 80;
      public static const Key_Q:int = 81;
      public static const Key_R:int = 82;
      public static const Key_S:int = 83;
      public static const Key_T:int = 84;
      public static const Key_U:int = 85;
      public static const Key_V:int = 86;
      public static const Key_W:int = 87;
      public static const Key_X:int = 88;
      public static const Key_Y:int = 89;
      public static const Key_Z:int = 90;
      
      public static const Key_0:int = 48;
      public static const Key_1:int = 49;
      public static const Key_2:int = 50;
      public static const Key_3:int = 51;
      public static const Key_4:int = 52;
      public static const Key_5:int = 53;
      public static const Key_6:int = 54;
      public static const Key_7:int = 55;
      public static const Key_8:int = 56;
      public static const Key_9:int = 57;
      
      public static const Semicolon:int = 186; // ;
      public static const Add:int = 187; // ;
      public static const Comma:int = 188; // ;
      public static const Subtract:int = 189; // ;
      public static const Period:int = 190; // ;
      public static const Slash:int = 191; // ;
      public static const BackQuote:int = 192; // ;
      
      public static const LeftSquareBracket:int = 219; // ;
      public static const BackSlash:int = 220; // ;
      public static const RightSquareBracket:int = 221; // ;
      public static const Quote:int = 222; // ;
      
     
      // mouse
      public static const LeftMouseButton:int = 256;
      public static const VirtualAnyKeys:int = 257;
      
      //
      public static const kNumKeys:int = 258;
      
      //
      private static var sAnyKeyCodes:Array = null;
      public static function GetAnyKeyCodes ():Array
      {
         if (sAnyKeyCodes == null)
         {
            sAnyKeyCodes = new Array ();
            
            var key:int;
            for (key = Keyboard.SPACE; key <= Keyboard.DOWN; ++ key) // 32 - 40
               sAnyKeyCodes.push (key);
            for (key = Key_0; key <= Key_9; ++ key) // 48 - 57
               sAnyKeyCodes.push (key);
            for (key = Key_A; key <= Key_Z; ++ key) // 65 - 90
               sAnyKeyCodes.push (key);
            for (key = Keyboard.NUMPAD_0; key <= Keyboard.NUMPAD_DIVIDE; ++ key) // 96 - 111
               sAnyKeyCodes.push (key);
            for (key = Keyboard.F1; key <= Keyboard.F12; ++ key) // 112 - 123
               sAnyKeyCodes.push (key);
            
            sAnyKeyCodes.push (Keyboard.BACKSPACE); // 8
            sAnyKeyCodes.push (Keyboard.TAB); // 9
            sAnyKeyCodes.push (Keyboard.ENTER); // 13
            sAnyKeyCodes.push (Keyboard.SHIFT); // 16
            sAnyKeyCodes.push (Keyboard.CONTROL); // 17
            sAnyKeyCodes.push (Keyboard.CAPS_LOCK); // 20
            sAnyKeyCodes.push (Keyboard.ESCAPE); // 27
            sAnyKeyCodes.push (Keyboard.INSERT); // 45
            sAnyKeyCodes.push (Keyboard.DELETE); // 46
         }
         
         return sAnyKeyCodes;
      }
   }
}
