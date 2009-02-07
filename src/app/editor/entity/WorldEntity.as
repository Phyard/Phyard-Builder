
package editor.entity {
   
   import editor.world.World;
   
   public class WorldEntity extends Entity 
   {
      protected var mWorld:World;
      
      public function Entity (world:World)
      {
         super (world);
      }
      
   }
}