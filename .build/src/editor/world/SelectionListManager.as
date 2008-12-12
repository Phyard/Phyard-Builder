
package editor.world {
   
   import editor.entity.Entity;
   
   public class SelectionListManager 
   {
      
      private var mSelectedEntities:Array = new Array ();
      
      
      
      public function GetSelectedEntities ():Array
      {
         return mSelectedEntities.slice ();
      }
      
      public function ClearSelectedEntities ():void
      {
         while (mSelectedEntities.length > 0)
         {
            if (mSelectedEntities [0] is Entity)
            {
               RemoveSelectedEntity (mSelectedEntities[0]);
            }
         }
      }
      
      public function AddSelectedEntity (entity:Entity):void
      {
         if (entity == null)
            return;
         
         for (var i:uint = 0; i < mSelectedEntities.length; ++ i)
         {
            if (mSelectedEntities [i] == entity)
               return;
         }
         
         mSelectedEntities.unshift (entity);
         entity.NotifySelectedChanged (true);
      }
      
      public function RemoveSelectedEntity (entity:Entity):void
      {
         if (entity == null)
            return;
         
         for (var i:uint = 0; i < mSelectedEntities.length; ++ i)
         {
            if (mSelectedEntities [i] == entity)
            {
               mSelectedEntities.splice (i, 1);
               entity.NotifySelectedChanged (false);
               return;
            }
         }
      }
      
      public function IsEntitySelected (entity:Entity):Boolean
      {
         if (entity == null)
            return false;
         
         for (var i:uint = 0; i < mSelectedEntities.length; ++ i)
         {
            if (mSelectedEntities [i] == entity)
            {
               return true;
            }
         }
         
         return false;
      }
      
      public function IsSelectedEntitiesContainPoint (pointX:Number, pointY:Number):Boolean
      {
         for (var i:uint = 0; i < mSelectedEntities.length; ++ i)
         {
            if (mSelectedEntities [i].ContainsPoint (pointX, pointY))
            {
               return true;
            }
         }
         
         return false;
      }
      
      public function GetSelectedMainEntities ():Array
      {
         var i:uint;
         var entity:Entity;
         
         var newArray:Array = new Array ();
         var k:uint;
          
         for (i = 0; i < mSelectedEntities.length; ++ i)
         {
            entity = (mSelectedEntities [i] as Entity).GetMainEntity ();
            
            for (k = 0; k < newArray.length; ++ k)
            {
               if (newArray[k] == entity)
                  break;
            }
            
            if (k == newArray.length)
               newArray.unshift (entity);
         }
         
         return newArray;
      }
      
      
      
      
      
      
   }
}
