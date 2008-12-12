package com.tapirgames.suit2d.loader {
   
   public class ModuleRef
   {
      public static const ModuleFlag_FlipX:int = 0x8000;
      public static const ModuleFlag_FlipY:int = 0x4000;
      
      public var mModule:Module;
      
      public var mFlipX:Boolean;
      public var mFlipY:Boolean;
      
      // temp, not support
      //private var mPaletteID:int;
      
      public function ModuleRef (module:Module, flags:int)
      {
         mModule = module;
         mFlipX  = (flags & ModuleFlag_FlipX) != 0;
         mFlipY  = (flags & ModuleFlag_FlipY) != 0;
      }
   }
}
