

package com.tapirgames.util {
   
   public class Logger {
      
      
      public function Logger ()
      {
      }
      
      public static function Trace (msg:String):void
      {
         trace (msg);
      }
      
      public static function Info (msg:String):void
      {
         trace (msg);
      }
      
      public static function Assert (assert:Boolean, msg:String):void
      {
         if (!assert) trace (msg);
      }
   }
}
