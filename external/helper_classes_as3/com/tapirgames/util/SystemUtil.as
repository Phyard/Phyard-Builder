
package com.tapirgames.util {
   
   import flash.system.System;
   
   public class SystemUtil {
      
      private static var AllowGC:Boolean = false;
      private static var EnableTrace:Boolean = false;
      
      public static function TraceMemory (msg:String = "", firstGC:Boolean = false):void
      {
         if (firstGC && AllowGC)
            System.gc ();
         
         if (EnableTrace)
            trace ("[System.totalMemory (AllowGC=" + AllowGC + ")] " + msg + ":> " + System.totalMemory);
      }
      
   }
}
