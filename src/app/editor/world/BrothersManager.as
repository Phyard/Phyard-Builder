package editor.world {
   
   import com.tapirgames.util.Logger;
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   
   import common.Define;
   
   public class BrothersManager 
   {
      // if add a member mBrothers to Entity, code will be more efficent.
      // meanwhile, need more code in World, would be more bugs.
      
      
      public var mBrotherGroupArray:Array = new Array ();
      
      
      public function MakeBrothers (entityArray:Array):void
      {
         var brothers:Array = entityArray.concat ();
         
         BreakApartBrothers (entityArray);
         
         if (brothers.length <= 1)
            return;
         
         //mBrotherGroupArray.unshift (brothers); // when loading, will makethe order of groups inversed
         mBrotherGroupArray.push (brothers);
         
         var i:int;
         for (i = 0; i < brothers.length; ++ i)
         {
            (brothers [i] as Entity).SetBrothers (brothers);
         }
      }
      
      public function BreakApartBrothers (entityArray:Array):void
      {
         var brotherGroupsToBreakApart:Array = new Array ();
         var entityId:int;
         var brothers:Array;
         var groupId:int;
         var index:int;
         
         for (entityId = 0; entityId < entityArray.length; ++ entityId)
         {
            brothers = entityArray [entityId].GetBrothers ();
            
            if (brothers != null)
            {
               index = brotherGroupsToBreakApart.indexOf (brothers);
               if (index < 0)
                  brotherGroupsToBreakApart.push (brothers);
            }
         }
         
         for (groupId = 0; groupId < brotherGroupsToBreakApart.length; ++ groupId)
         {
            brothers = brotherGroupsToBreakApart [groupId];
            
            index = mBrotherGroupArray.indexOf (brothers);
            if (index < 0)
            {
               Logger.Assert (false, "brothers not in mBrotherGroupArray");
               continue;
            }
            mBrotherGroupArray.splice (index, 1);
            
            for (entityId = 0; entityId < brothers.length; ++ entityId)
            {
               (brothers [entityId] as Entity).SetBrothers (null);
            }
         }
      }
      
      public function GetBrothersOfEntity (entity:Entity):Array
      {
         return entity.GetBrothers ();
      }
      
      public function OnDestroyEntity (entity:Entity):void
      {
         var brothers:Array = entity.GetBrothers ();
         
         if (brothers == null)
            return;
         
         while (true) // mystery: sometimes, an entity will be put in a brother group more than one times
         {
            var index:int = brothers.indexOf (entity);
            
            if (index < 0)
            {
               //Logger.Assert (false, "entity not in brothers");
               //return;
               
               break;
            }
            
            brothers.splice (index, 1);
            entity.SetBrothers (null);
         }
         
         if (brothers.length == 1)
         {
            brothers [0].SetBrothers (null);
         }
         
         if (brothers.length == 0)
         {
            index = mBrotherGroupArray.indexOf (brothers);
            if (index < 0)
            {
               Logger.Assert (false, "brothers not in mBrotherGroupArray (GetBrothersOfEntity)");
               return;
            }
            mBrotherGroupArray.splice (index, 1);
         }
      }
      
      
      
      
   }
}