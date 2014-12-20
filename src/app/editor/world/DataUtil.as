package editor.world {
   
   import flash.ui.Keyboard;
   
   import common.Define;
   import common.KeyCodes;
   import common.trigger.ValueDefine;
   
   public class DataUtil
   {
      // the list must have label and data field
      public static function SelectedValue2SelectedIndex (list:Array, value:Object):int
      {
         for (var i:int = 0; i < list.length; ++ i)
         {
            if (list [i].data == value)
               return i;
         }
         
         return -1;
      }
      
      public static function GetListWithDataInLabel (list:Array):Array
      {
         var newList:Array = new Array (list.length);
         
         for (var i:int = 0; i < list.length; ++ i)
         {
            newList [i] = {label: list [i].label + " (" + list [i].data + ")", data: list [i].data};
         }
         
         return newList;
      }
      
      //public static const kBornTimeOfCIE:Date = new Date (2009); 
      //
      //public static function MakeUUID ()
      //{
      //   author
      //     1. on phyard: /tapir
      //     2. offline  : tapir
      //   int (new Date ().getTime ()) & 0xFFFFFFFFFFFF
      //   Math.random () * 0xFFFFFF
      //   asset type
      //   asset acc id
      //   
      //   DataFormat3.EncodeByteArray2String ();
      //}
      
      public static function ParseColor (colorText:String):uint
      {
         if (colorText == null)
            return 0x000000;
         
         if (colorText.length > 1 && colorText.substr (0, 1).toLowerCase() == "#")
         {
            return parseInt (colorText.substr (1), 16);
         }
         else if (colorText.length > 2 && colorText.substr (0, 2).toLowerCase() == "0x")
         {
            return parseInt (colorText.substr (2), 16);
         }
         else
         {
            return parseInt (colorText);
         }
      }
      
   }
}
