
package editor.entity {
   
   import editor.world.World;
   
   public class SubEntity extends Entity 
   {
      protected var mMainEntity:Entity;
      
      public function SubEntity (world:World, mainEntity:Entity = null)
      {
         super (world);
         
         mMainEntity = mainEntity;
      }
      
//====================================================================
//   when clone and delete, we need the main entity
//====================================================================
      
      override public function GetMainEntity ():Entity
      {
         return mMainEntity == null ? this : mMainEntity;
      }
   }
}
