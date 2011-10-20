package player.module {

   public class ModuleSequence extends ModulePart
   {
      protected var mDuration:int;
      
      public function ModuleSequence (module:Module, transform:Transform2D, dutation:int)
      {
         super (module, transform);
         
         mDuration = duration;
      }
      
      public function GetDuration ():int
      {
         return mDuration;
      }
   }
}
