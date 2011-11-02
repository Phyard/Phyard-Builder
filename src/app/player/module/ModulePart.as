package player.module {
   
   import common.Transform2D;

   public class ModulePart
   {
      protected var mModule:Module; 
         // 1. currently, SequenceModule is not supported.
         // 2. must NOT be null
         
      protected var mTransform:Transform2D;
         // for module sequences, must NOT be null
         // for module parts, can be null
      
      protected var mIsVisible:Boolean = true;
      protected var mAlpha:Number  = 1.0;
      
      public function ModulePart (module:Module, transform:Transform2D, visible:Boolean, alpha:Number)
      {
         mModule = module;
         
         mTransform = transform;
         
         mIsVisible = visible;
         mAlpha = alpha;
      }
      
      public function GetModule ():Module
      {
         return mModule;
      }
      
      public function GetTransform ():Transform2D
      {
         return mTransform;
      }
   }
}
