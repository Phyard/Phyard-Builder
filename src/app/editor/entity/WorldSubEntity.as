
package editor.entity {
   
   import editor.world.World;
   
   public class WorldSubEntity extends WorldEntity 
   {
      protected var mMainEntity:Entity;
      
      protected var mSubIndex:int = -1;
      
      public function WorldSubEntity (world:World, mainEntity:Entity = null, subIndex:int = -1)
      {
         super (world);
         
         mMainEntity = mainEntity;
         
         mSubIndex = subIndex;
      }
      
//====================================================================
//   when clone and delete, we need the main entity
//====================================================================
      
      override public function GetMainEntity ():Entity
      {
         return mMainEntity == null ? this : mMainEntity;
      }
      
      override public function GetSubIndex ():int
      {
         return mSubIndex;
      }
      
   }
}