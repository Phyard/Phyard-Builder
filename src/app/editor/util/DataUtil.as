package editor.util {
   
   import flash.ui.Keyboard;
   
   import common.Define;
   import common.KeyCodes;
   import common.trigger.ValueDefine;
   import common.trigger.ValueTypeDefine;
   
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
   }
}
