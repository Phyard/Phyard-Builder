
package editor.world {
   
   import flash.utils.Dictionary;
   
   import editor.entity.Entity;
   
   public class SelectionListManager 
   {  
      private var mSelectedEntities:Array = new Array ();
      
      public function GetNumSelectedEntities ():int
      {
         return mSelectedEntities.length;
      }
      
      public function GetSelectedEntities ():Array
      {
         return mSelectedEntities.concat ();
      }
      
      public function ClearSelectedEntities ():void
      {
         //while (mSelectedEntities.length > 0)
         //{
         //   if (mSelectedEntities [0] is Entity)
         //   {
         //      RemoveSelectedEntity (mSelectedEntities[0]);
         //   }
         //}
         
         var oldSelections:Array = mSelectedEntities;
         
         mSelectedEntities = new Array ();
         
         for each (var entity:Entity in oldSelections)
         {
            entity.NotifySelectedChanged (false);
         }
      }
      
      //>> a temp optimized implementation for bath selections
      public function SelectEntities (entityArray:Array, clearOldSelections:Boolean):Boolean
      {
         if (entityArray == null || entityArray.length == 0)
         {
            if (clearOldSelections && mSelectedEntities.length > 0)
            {
               ClearSelectedEntities ();
               
               return true;
            }
            
            return false;
         }
         
         var entity:Entity;
         var actionId:int = Entity.GetNextActionId ();
         
         var entitiesToSelect:Array = new Array ();
         for each (entity in entityArray)
         {
            entity.SetCurrentActionId (actionId);
            if (! entity.IsSelected ())
            {
               entitiesToSelect.push (entity);
            }
         }
         
         var entitiesToDeselect:Array = new Array ();
         var entitiesToKeepSelected:Array;
         if (clearOldSelections)
         {
            entitiesToKeepSelected = new Array ();
            
            for each (entity in mSelectedEntities)
            {
               if (entity.GetCurrentActionId () < actionId)
               {
                  entitiesToDeselect.push (entity);
               }
               else
               {
                  entitiesToKeepSelected.push (entity);
               }
            }
         }
         else
         {
            entitiesToKeepSelected = mSelectedEntities;
         }
         
         if (entitiesToSelect.length == 0 && entitiesToDeselect.length == 0)
            return false;
         
         if (entitiesToSelect.length == 0)
            mSelectedEntities = entitiesToKeepSelected;
         else if (entitiesToKeepSelected.length == 0)
            mSelectedEntities = entitiesToSelect;
         else
            mSelectedEntities = entitiesToKeepSelected.concat (entitiesToSelect);
         
         for each (entity in entitiesToDeselect)
         {
            entity.NotifySelectedChanged (false);
         }
         
         for each (entity in entitiesToSelect)
         {
            entity.NotifySelectedChanged (true);
         }
         
         return true;
      }
      //<<
      
      public function AddSelectedEntity (entity:Entity):void
      {
         if (entity == null)
            return;
         
         if (mSelectedEntities.indexOf (entity) >= 0)
            return;
         
         mSelectedEntities.unshift (entity);
         entity.NotifySelectedChanged (true);
      }
      
      public function RemoveSelectedEntity (entity:Entity):void
      {
         if (entity == null)
            return;
         
         var index:int = mSelectedEntities.indexOf (entity);
         if (index >= 0)
         {
            mSelectedEntities.splice (index, 1);
            entity.NotifySelectedChanged (false);
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
      
      public function AreSelectedEntitiesContainingPoint (pointX:Number, pointY:Number):Boolean
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
         
         var checkTable:Dictionary = new Dictionary ();
         var newArray:Array = new Array ();
          
         for (i = 0; i < mSelectedEntities.length; ++ i)
         {
            entity = (mSelectedEntities [i] as Entity).GetMainEntity ();
            
            if (checkTable [entity] != true)
            {
               newArray.push (entity);
               checkTable [entity] = true;
            }
         }
         
         //newArray = newArray.reverse ();
         
         return newArray;
      }
      
   }
}
