
package editor.ccat {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   import flash.net.FileReferenceList;
   import flash.net.FileReference;
   import flash.net.FileFilter;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import editor.entity.Scene;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class CollisionCategoryManager extends AssetManager
   {
      protected var mScene:Scene;
      
      // ...
      
      //private var mNameLookupTable:Dictionary = new Dictionary ();
      private var mCollisionGroupFriendPairs:Array = new Array ();
      
      private var mDefaultCategory:CollisionCategory = null;
      
      public function CollisionCategoryManager (scene:Scene)
      {
         super ();
         
         mScene = scene;
      }
      
      public function GetScene ():Scene
      {
         return mScene;
      }
      
      override public function SupportScaleRotateFlipTransforms ():Boolean
      {
         return false;
      }
      
//==========================================================      
// 
//==========================================================   
      
      public function GetNumCollisionCategories ():int
      {
         return numChildren;
      }
      
      public function GetDefaultCollisionCategory ():CollisionCategory
      {
         if( mDefaultCategory != null && ! contains (mDefaultCategory) )
            mDefaultCategory = null;
         
         return mDefaultCategory;
      }
      
      public function SetDefaultCollisionCategory (category:CollisionCategory):void
      {
         var oldCategory:CollisionCategory = GetDefaultCollisionCategory ();
         
         mDefaultCategory = category;
         
         if (mDefaultCategory != null)
            mDefaultCategory.UpdateAppearance ();
         
         if (oldCategory != null)
            oldCategory.UpdateAppearance ();
         
         SetChanged (true);
      }
      
      //private function GetRecommendName (groupName:String):String
      //{
      //   var n:int = 1;
      //   var groupNameN:String = groupName;
      //   while (true)
      //   {
      //      if (mNameLookupTable [groupNameN] == null)
      //         return groupNameN;
      //      
      //      groupNameN = groupName + " " + (n ++);
      //   }
      //   
      //   return null;
      //}
      
      public function GetCollisionCategoryFriendPairs ():Array
      {
         return mCollisionGroupFriendPairs;
      }
      
      public function GetCollisionCategoryIndex (category:CollisionCategory, allowReturnNoneCCatId:Boolean):int
      {
         //if (category == null || ! contains (category))
         //   return Define.CCatId_Hidden;
         //
         //return getChildIndex (category);
         
         if (category == null)
         {
            if (allowReturnNoneCCatId)
               return Define.CCatId_None; // since v2.06
            else
               return Define.CCatId_Hidden;
         }
         
         return category.GetAppearanceLayerId ();
      }
      
      public function GetCollisionCategoryByIndex (index:int):CollisionCategory
      {
         // GetAssetByAppearanceId or GetAssetByCreationId?
         return GetAssetByAppearanceId (index) as CollisionCategory;
      }
      
      public function CreateCollisionCategory (key:String, ccName:String = null, selectIt:Boolean = false):CollisionCategory
      {
         if (numChildren + 1 >= Define.MaxCCatsCount) // 1 for the hidden ccat
            return null;
         
         if (ccName == null)
            ccName = Define.DefaultCCatName;
         
         var category:CollisionCategory = new CollisionCategory (this, ValidateAssetKey (key), GetRecommendAssetName (ccName));
         addChild (category);
         
         //category.SetCategoryName ( GetRecommendName (ccName), false); // moved to above. 
         
         //mNameLookupTable [category.GetCategoryName ()] = category;
         
         if (selectIt)
         {
            category.SetPosition (mouseX, mouseY);
            SetSelectedAsset (category);
         }
         
         SetChanged (true);
         
         return category;
      }
      
      //public function ChangeCollisionCategoryName (newName:String, oldName:String):void
      //{
      //   if (oldName == null)
      //      return;
      //   if (newName == null)
      //      return;
      //   if (newName.length < Define.MinEntityNameLength)
      //      return;
      //   
      //   var category:CollisionCategory = mNameLookupTable [oldName];
      //   
      //   if (category == null)
      //      return;
      //   
      //   delete mNameLookupTable [oldName];
      //   
      //   if (newName.length > Define.MaxEntityNameLength)
      //      newName = newName.substr (0, Define.MaxEntityNameLength);
      //   
      //   newName = GetRecommendName (newName);
      //   
      //   mNameLookupTable [newName] = category;
      //   
      //   if (newName == oldName)
      //   {
      //      return;
      //   }
      //   
      //   category.SetCategoryName (newName, false);
      //   
      //   SetChanged (true);
      //}
      
      public function CreateCollisionCategoryFriendLink (category1:CollisionCategory, category2:CollisionCategory):void
      {
         CreateOrBreakCollisionCategoryFriendLink (category1, category2, true);
      }
      
      public function BreakCollisionCategoryFriendLink (category1:CollisionCategory, category2:CollisionCategory):Boolean
      {
         var exist:Boolean= false;
         
         for (var i:int = mCollisionGroupFriendPairs.length - 1; i >= 0; -- i)
         {
            var friends:Object = mCollisionGroupFriendPairs [i];
            if (friends.mCategory1 == category1 && friends.mCategory2 == category2
               || friends.mCategory1 == category2 && friends.mCategory2 == category1
               )
            {
               exist = true;
               mCollisionGroupFriendPairs.splice (i, 1);
            }
         }
         
         if (exist)
         {
            SetChanged (true);
         }
         
         return exist;
      }
      
      override public function DestroyAsset (asset:Asset):void
      {
         if (asset is CollisionCategory)
         {
            BreakFriendLinks (asset as CollisionCategory);
            
            //delete mNameLookupTable[ (asset as CollisionCategory).GetCategoryName () ];
         }
         
         SetChanged (true);
         
         super.DestroyAsset (asset);
         
         // ids changed, maybe
         var ccat:CollisionCategory;
         for (var i:int = 0; i < numChildren; ++ i)
         {
            ccat = getChildAt (i) as CollisionCategory;
            if (ccat != null) // should be
            {
               ccat.UpdateAppearance ();
            }
         }
      }
      
//=========================================================
// the 2 are called from view
//=========================================================
      
      public function CreateOrBreakCollisionCategoryFriendLink (category1:CollisionCategory, category2:CollisionCategory, alwaysCreate:Boolean = false):void
      {
         if (category1 == null || category2 == null)
            return;
         
         if (BreakCollisionCategoryFriendLink (category1, category2))
         {
            if (! alwaysCreate)
            {
               if (mAssetLinksChangedCallback != null)
                  mAssetLinksChangedCallback ();
               
               return;
            }
         }
         
         var friends:Object = new Object;
         friends.mCategory1 = category1;
         friends.mCategory2 = category2;
         
         mCollisionGroupFriendPairs.push (friends);
         
         SetChanged (true);
         
         if (mAssetLinksChangedCallback != null)
            mAssetLinksChangedCallback ();
      }
      
      public function BreakFriendLinks (ccat:CollisionCategory):Boolean
      {
         var changed:Boolean = false;
         for (var i:int = mCollisionGroupFriendPairs.length - 1; i >= 0; -- i)
         {
            var friends:Object = mCollisionGroupFriendPairs [i];
            if (friends.mCategory1 == ccat || friends.mCategory2 == ccat)
            {
               changed = true;
               mCollisionGroupFriendPairs.splice (i, 1);
            }
         }
         
         if (changed)
         {
            SetChanged (true);
            
            if (mAssetLinksChangedCallback != null)
               mAssetLinksChangedCallback ();
         }
         
         return changed;
      }

//=================================================================================
//   queries
//=================================================================================

      // isForPureCustomFunction
      public function GetCollisionCategoryListDataProvider (allowNoneCCat:Boolean, isForPureCustomFunction:Boolean = false):Array
      {
         var list:Array = new Array ();
         
         if (allowNoneCCat)
         {
            list.push ({label: Define.CCatId_None + ":{null}", mCategoryIndex:Define.CCatId_None});
         }
         
         list.push ({label: Define.CCatId_Hidden + ":{Hidden Category}", mCategoryIndex:Define.CCatId_Hidden});

         if (! isForPureCustomFunction)
         {
            var child:Object;
            var category:CollisionCategory;
            var numCats:int = GetNumCollisionCategories ();

            for (var i:int = 0; i < numCats; ++ i)
            {
               category = GetCollisionCategoryByIndex (i);

               var item:Object = new Object ();
               //item.label = i + ": " + category.GetCategoryName ();
               item.label = i + ": " + category.GetName ();
               item.mCategoryIndex = category.GetAppearanceLayerId ();
               list.push (item);
            }
         }

         return list;
      }

      public static function CollisionCategoryIndex2SelectListSelectedIndex (allowNoneCCat:Boolean, categoryIndex:int, dataProvider:Array):int
      {
         do
         {
            for (var i:int = 0; i < dataProvider.length; ++ i)
            {
               if (dataProvider[i].mCategoryIndex == categoryIndex)
                  return i;
            }
            
            categoryIndex = allowNoneCCat ? Define.CCatId_None : Define.CCatId_Hidden;
            
            continue;
         }
         while (false);
         
         return 0; // will never go here.
      }
      
//=============================================
// for undo point
//=============================================
      
      private var mIsChanged:Boolean = false;
      
      public function SetChanged (changed:Boolean):void
      {
         mIsChanged = changed;
      }
      
      public function IsChanged ():Boolean
      {
         return mIsChanged;
      }
        
//=====================================================================
// context menu
//=====================================================================
      
      override public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         /*
         var menuItemLoadLocalSoundss:ContextMenuItem = new ContextMenuItem("Load Local Sounds(s) ...", true);
         //var menuItemCreateSound:ContextMenuItem = new ContextMenuItem("Create Blank Sound ...");
         var menuItemDeleteSelecteds:ContextMenuItem = new ContextMenuItem("Delete Selected(s) ...", true);
         
         menuItemLoadLocalSoundss.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_LocalSounds);
         //menuItemCreateSound.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_CreateSound);
         menuItemDeleteSelecteds.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_DeleteSelectedAssets);

         customMenuItemsStack.push (menuItemLoadLocalSoundss);
         //customMenuItemsStack.push (menuItemCreateSound);
         customMenuItemsStack.push (menuItemDeleteSelecteds);
         */
         
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      /*
      private function OnContextMenuEvent_CreateSound (event:ContextMenuEvent):void
      {
         CreateSound (true);
      }
      
      private function OnContextMenuEvent_LocalSounds (event:ContextMenuEvent):void
      {
         OpenLocalSoundFileDialog ();
      }
      
      private function OnContextMenuEvent_DeleteSelectedAssets (event:ContextMenuEvent):void
      {
         DeleteSelectedAssets ();
      }
      */
      
   }
}

