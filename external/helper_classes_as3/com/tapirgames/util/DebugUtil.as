
package com.tapirgames.util {
   
   public class DebugUtil 
   {
      public static function TraceCallingStack ():void
      {
         trace (new Error().getStackTrace());
      }
   }
}
