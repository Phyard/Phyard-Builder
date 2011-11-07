package player.module {
   
   import common.Transform2D;

   public class ModuleSequence extends ModulePart
   {
      protected var mDuration:int; // may be changed to Number later
      
      public function ModuleSequence (module:Module, transform:Transform2D, transformInPhysics:Transform2D, visible:Boolean, alpha:Number, duration:int)
      {
         super (module, transform, transformInPhysics, visible, alpha);
         
         mDuration = duration;
      }
      
      public function GetDuration ():int
      {
         return mDuration;
      }
   }
}
