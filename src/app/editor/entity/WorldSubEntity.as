
package editor.entity {
   
   import editor.world.World;
   
   public class WorldSubEntity extends SubEntity 
   {
      protected var mWorld:World;
      
      public function WorldSubEntity (world:World, mainEntity:Entity = null, subIndex:int = -1)
      {
         super (world, mainEntity, subIndex);
         
         mWorld = world;
      }
      
   }
}