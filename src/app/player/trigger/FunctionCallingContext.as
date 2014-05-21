package player.trigger
{
   import player.world.World;
   
   public class FunctionCallingContext
   {
      internal var mWorld:World;
      
      // todo
      internal var mCallingLevel:int = 0;
      internal var mTotalCallingTime:Number = 0.0;
      
      public function FunctionCallingContext (world:World)
      {
         mWorld = world;
         
         Reset ();
      }
      
      public function Reset ():void
      {
         mCallingLevel = 0;
         mTotalCallingTime = 0;
      }
   }
}