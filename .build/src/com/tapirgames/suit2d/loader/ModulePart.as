package com.tapirgames.suit2d.loader {
   
   public class ModulePart extends ModuleRef
   {
      public var mOffsetX:int;
      public var mOffsetY:int;
      
      public function ModulePart (module:Module, flags:int, offsetX:int, offsetY:int)
      {
         super (module, flags);
         mOffsetX = offsetX;
         mOffsetY = offsetY;
      }
   }
}
