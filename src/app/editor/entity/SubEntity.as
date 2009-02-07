
package editor.entity {
   
   import editor.world.EntityContainer;
   //import editor.world.World;
   
   public class SubEntity extends Entity 
   {
      protected var mMainEntity:Entity;
      
      public function SubEntity (container:EntityContainer, mainEntity:Entity = null)
      {
         super (container);
         
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
