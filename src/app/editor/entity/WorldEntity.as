
package editor.entity {
   
   import editor.world.World;
   
   public class WorldEntity extends Entity 
   {
      protected var mWorld:World;
      
      public function WorldEntity (world:World)
      {
         super (world);
         
         mWorld = world;
      }
      
   }
}