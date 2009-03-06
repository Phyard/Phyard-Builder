
package editor.entity {
   
   import editor.world.EntityContainer;
   //import editor.world.World;
   
   public class SubEntity extends Entity 
   {
      protected var mMainEntity:Entity;
      
      protected var mSubIndex:int = -1;
      
      public function SubEntity (container:EntityContainer, mainEntity:Entity = null, subIndex:int = -1)
      {
         super (container);
         
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
