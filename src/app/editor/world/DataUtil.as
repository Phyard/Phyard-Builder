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
   }
}
