package com.tapirgames.suit2d.loader {
   
   public class ModuleSequence extends ModulePart
   {
      public var mDuration:int;
      
      public function ModuleSequence (module:Module, flags:int, offsetX:int, offsetY:int, duration:int)
      {
         super (module, flags, offsetX, offsetY);
         
         mDuration = duration;
      }
   }
}
