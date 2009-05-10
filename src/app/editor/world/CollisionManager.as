package editor.world {
   
   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.utils.Dictionary;
   
   import com.tapirgames.util.Logger;
   
   import editor.entity.Entity;
   import editor.entity.EntityCollisionCategory;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class CollisionManager extends EntityContainer
   {
      //
      // create collision categories at the front part or children lsit,
      // create friend links at the back part of children list
      
      // ..
      private var mLookupTable:Dictionary = new Dictionary ();
      private var mCollisionGroupFriendPairs:Array = new Array ();
      
      private var mDefaultCategory:EntityCollisionCategory = null;
      
      public function CollisionManager ()
      {
      }
      
      override public function GetWorldHints ():Object
      {
         var world_hints:Object = new Object ();
         world_hints.mPhysicsShapesPotentialMaxCount = ValueAdjuster.AdjustPhysicsShapesPotentialMaxCount (256);
         world_hints.mPhysicsShapesPopulationDensityLevel = ValueAdjuster.AdjustPhysicsShapesPopulationDensityLevel (8);
         
         return world_hints;
      }
      
      public function GetDefaultCollisionCategory ():EntityCollisionCategory
      {
         if( mDefaultCategory != null && ! contains (mDefaultCategory) )
            mDefaultCategory = null;
         
         return mDefaultCategory;
      }
      
      public function SetDefaultCollisionCategory (category:EntityCollisionCategory):void
      {
         var oldCategory:EntityCollisionCategory = GetDefaultCollisionCategory ();
         
         mDefaultCategory = category;
         
         if (mDefaultCategory != null)
            mDefaultCategory.UpdateAppearance ();
         
         if (oldCategory != null)
            oldCategory.UpdateAppearance ();
      }
      
      private function GetRecommendName (groupName:String):String
      {
         var n:int = 1;
         var groupNameN:String = groupName;
         while (true)
         {
            if (mLookupTable [groupNameN] == null)
               return groupNameN;
            
            groupNameN = groupName + " " + (n ++);
         }
         
         return null;
      }
      
      public function GetCollisionCategoryFriendPairs ():Array
      {
         return mCollisionGroupFriendPairs;
      }
      
      public function GetCollisionCategoryIndex (category:EntityCollisionCategory):int
      {
         if (category == null || ! contains (category))
            return Define.CollisionCategoryId_HiddenCategory;
         
         return getChildIndex (category);
      }
      
      public function GetCollisionCategoryByIndex (index:int):EntityCollisionCategory
      {
         if (index < 0 || index >= numChildren)
            return null;
         
         return getChildAt (index) as EntityCollisionCategory;
      }
      
      public function CreateEntityCollisionCategoryFriendLink (category1:EntityCollisionCategory, category2:EntityCollisionCategory):void
      {
         BreakEntityCollisionCategoryFriendLink (category1, category2);
         
         var friends:Object = new Object;
         friends.mCategory1 = category1;
         friends.mCategory2 = category2;
         
         mCollisionGroupFriendPairs.push (friends);
      }
      
      public function CreateEntityCollisionCategory (ccName:String = null):EntityCollisionCategory
      {
         if (numChildren >= Define.MaxCollisionCategoriesCount - 1)
            return null;
         
         if (ccName == null)
            ccName = Define.CategoryDefaultName;
         
         var category:EntityCollisionCategory = new EntityCollisionCategory (this);
         addChild (category);
         
         category.SetCategoryName ( GetRecommendName (ccName), false );
         
         mLookupTable [category.GetCategoryName ()] = category;
         
         return category;
      }
      
      public function ChangeCollisionCategoryName (newName:String, oldName:String):void
      {
         if (oldName == null)
            return;
         if (newName == null)
            return;
         if (newName.length < Define.MinCollisionCategoryNameLength)
            return;
         
         var category:EntityCollisionCategory = mLookupTable [oldName];
         
         if (category == null)
            return;
         
         delete mLookupTable [oldName];
         
         if (newName.length > Define.MaxCollisionCategoryNameLength)
            newName = newName.substr (0, Define.MaxCollisionCategoryNameLength);
         
         newName = GetRecommendName (newName);
         
         mLookupTable [newName] = category;
         
         category.SetCategoryName (newName, false);
      }
      
      public function BreakEntityCollisionCategoryFriendLink (category1:EntityCollisionCategory, category2:EntityCollisionCategory):void
      {
         for (var i:int = mCollisionGroupFriendPairs.length - 1; i >= 0; -- i)
         {
            var friends:Object = mCollisionGroupFriendPairs [i];
            if (friends.mCategory1 == category1 && friends.mCategory2 == category2)
            {
               mCollisionGroupFriendPairs.splice (i, 1);
            }
         }
      }
      
      override public function DestroyEntity (entity:Entity):void
      {
         if (entity is EntityCollisionCategory)
         {
            for (var i:int = mCollisionGroupFriendPairs.length - 1; i >= 0; -- i)
            {
               var friends:Object = mCollisionGroupFriendPairs [i];
               if (friends.mCategory1 == entity || friends.mCategory2 == entity)
               {
                  mCollisionGroupFriendPairs.splice (i, 1);
               }
            }
            
            delete mLookupTable[ (entity as EntityCollisionCategory).GetCategoryName () ];
         }
         
         super.DestroyEntity (entity);
      }
      
   }
}
