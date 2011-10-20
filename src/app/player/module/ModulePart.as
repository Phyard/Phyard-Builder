package player.module {

   public class ModulePart
   {
      protected var mModule:Module; 
         // 1. currently, SequenceModule is not supported.
         // 2. must NOT be null
         
      protected var mTransform:Transform2D;
      
      public function ModulePart (module:Module, transform:Transform2D)
      {
         mModule = module;
         
         mTransform = transform;
      }
      
      
      public function GetTransform ():Transform2D
      {
         return mTransform;
      }
   }
}
