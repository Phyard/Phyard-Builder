
package editor.world {

   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;

   import com.tapirgames.util.Logger;

   import editor.selection.SelectionEngine;

   import editor.trigger.TriggerEngine;
   import editor.trigger.PlayerFunctionDefinesForEditing;

   import editor.image.AssetImageModule;
   import editor.image.AssetImageNullModule;

   import editor.image.AssetImageManager;
   import editor.image.AssetImagePureModuleManager;
   import editor.image.AssetImageCompositeModuleManager;
   
   import editor.sound.AssetSound;
   import editor.sound.AssetSoundManager;
   
   import editor.ccat.CollisionCategoryManager;
   import editor.ccat.CollisionCategory;
   
   import editor.codelib.CodeLibManager;
   
   import editor.entity.Scene;

   import common.Define;
   import common.ValueAdjuster;

   public class World
   {
      public function World ()
      {
         CreateNewScene ("Default Scene");
         
         mAssetImageManager = new AssetImageManager ();
         mAssetImagePureModuleManager = new AssetImagePureModuleManager ();
         mAssetImageAssembledModuleManager = new AssetImageCompositeModuleManager (false);
         mAssetImageSequencedModuleManager = new AssetImageCompositeModuleManager (true);
         mAssetSoundManager = new AssetSoundManager ();
         
         // temp

         mCodeLibManager = new CodeLibManager (this);
         mCodeLibManager.SetFunctionMenuGroup (PlayerFunctionDefinesForEditing.sCustomMenuGroup);
         mTriggerEngine = new TriggerEngine ();
         
         mCollisionCategoryManager = new CollisionCategoryManager ();
      }

      public function Destroy ():void
      {
         for each (var aScene:Scene in mScenes)
         {
            aScene.Destroy ();
         }
         
         mAssetImageManager.Destroy ();
         mAssetImagePureModuleManager.Destroy ();
         mAssetImageAssembledModuleManager.Destroy ();
         mAssetImageSequencedModuleManager.Destroy ();
         mAssetSoundManager.Destroy ();
         
         // temp 
         
         mCollisionCategoryManager.Destroy ();
         mCodeLibManager.Destroy ();
      }

      //override 
      public function DestroyAllAssets ():void
      {
         for each (var aScene:Scene in mScenes)
         {
            aScene.Destroy ();
         }
         
         mAssetImageSequencedModuleManager.DestroyAllAssets ();
         mAssetImageAssembledModuleManager.DestroyAllAssets ();
         mAssetImagePureModuleManager.DestroyAllAssets ();
         mAssetImageManager.DestroyAllAssets ();
         mAssetSoundManager.DestroyAllAssets ();
         
         // temp
         
         mCollisionCategoryManager.DestroyAllAssets ();
         mCodeLibManager.DestroyAllAssets ();
      }

//=================================================================================
//   settings
//=================================================================================

      private var mAuthorName:String = "";
      private var mAuthorHomepage:String = "";
      private var mShareSourceCode:Boolean = false;
      private var mPermitPublishing:Boolean = true;

      public function SetAuthorName (name:String):void
      {
         if (name == null)
            name = "";

         if (name.length > 30)
            name = name.substr (0, 30);

         mAuthorName = name;
      }

      public function GetAuthorName ():String
      {
         return mAuthorName;
      }

      public function SetAuthorHomepage (url:String):void
      {
         if (url == null)
            url = "";

         if (url.length > 0)
         {
            if (url.substr (0, 4).toLowerCase() != "http")
                url = "http://" + url;
            if (url.length > 100)
               url = url.substr (0, 100);
         }

         mAuthorHomepage = url;
      }

      public function GetAuthorHomepage ():String
      {
         return mAuthorHomepage;
      }

      public function SetShareSourceCode (share:Boolean):void
      {
         mShareSourceCode = share;
      }

      public function IsShareSourceCode ():Boolean
      {
         return mShareSourceCode;
      }

      public function SetPermitPublishing (permit:Boolean):void
      {
         mPermitPublishing = permit;
      }

      public function IsPermitPublishing ():Boolean
      {
         return mPermitPublishing;
      }
      
//=================================================================================
//   scenes
//=================================================================================
      
      private var mScenes:Array = new Array ();
      
      public function GetNumScenes ():int
      {
         return mScenes.length;
      }
      
      public function GetSceneByIndex (index:int):Scene
      {
         if (index < 0 || index >= mScenes.length)
            return null;
         
         return mScenes [index] as Scene;
      }
      
      public function CreateNewScene (name:String, afterIndex:int = -1):int
      {
         var newScene:Scene = new Scene ();
         newScene.SetName (name);
         
         if (afterIndex >= 0)
            ++ afterIndex;
         
         if (afterIndex < 0 || afterIndex > mScenes.length)
            afterIndex = mScenes.length;
            
         mScenes.splice (afterIndex, 0, newScene);
         
         UpdateSceneListDataProvider ();
         
         return afterIndex;
      }
      
      public function DeleteSceneByIndex (index:int):int
      {
         if (index < 0 || index >= mScenes.length)
            return -1;
         
         if (mScenes.length <= 1)
            return -1;
         
         mScenes.splice (index, 1);
         
         UpdateSceneListDataProvider ();
         
         return mScenes.length >= index ? mScenes.length - 1 : index;
      }
      
      public function ChangeSceneIndex (fromIndex:int, targetIndex:int):int
      {
         if (fromIndex < 0 || fromIndex >= mScenes.length)
            return -1;
         
         if (targetIndex < 0 || targetIndex >= mScenes.length)
            return -1;
         
         if (targetIndex == fromIndex)
            return -1;
         
         var scene:Scene = mScenes [targetIndex];
         mScenes [targetIndex] = mScenes [fromIndex];
         mScenes [fromIndex] = scene;
         
         UpdateSceneListDataProvider ();
         
         return targetIndex;
      }
      
      public function ChangeSceneNameByIndex (index:int, newName:String):int
      {
         if (index < 0 || index >= mScenes.length)
            return -1;
         
         var scene:Scene = mScenes [index];
         scene.SetName (newName);
         
         UpdateSceneListDataProvider ();
         
         return index;
      }
      
      private var mSceneListDataProvider:Array = new Array ();
      
      public function GetSceneListDataProvider ():Array
      {
         return mSceneListDataProvider;
      }
      
      private function UpdateSceneListDataProvider ():void
      {
         mSceneListDataProvider.splice (0, mSceneListDataProvider.length);
         
         for (var i:int = 0; i < mScenes.length; ++ i)
         {
            var scene:Scene = mScenes [i] as Scene;
            
            mSceneListDataProvider.push ({mName: i + "> " + scene.GetName (), mIndex: i, mDataTip: scene.GetName (), mData: scene});
         }
      }

//=================================================================================
//   image asset and sounds
//=================================================================================

      protected var mAssetImageManager:AssetImageManager;
      protected var mAssetImagePureModuleManager:AssetImagePureModuleManager;
      protected var mAssetImageAssembledModuleManager:AssetImageCompositeModuleManager;
      protected var mAssetImageSequencedModuleManager:AssetImageCompositeModuleManager;
      protected var mAssetSoundManager:AssetSoundManager;

      public function GetAssetImageManager ():AssetImageManager
      {
         return mAssetImageManager;
      }

      public function GetAssetImagePureModuleManager ():AssetImagePureModuleManager
      {
         return mAssetImagePureModuleManager;
      }

      public function GetAssetImageAssembledModuleManager ():AssetImageCompositeModuleManager
      {
         return mAssetImageAssembledModuleManager;
      }

      public function GetAssetImageSequencedModuleManager ():AssetImageCompositeModuleManager
      {
         return mAssetImageSequencedModuleManager;
      }
      
      // The global module index
      public function GetImageModuleIndex (imageModule:AssetImageModule):int
      {
         if (imageModule == null)
            return -1;
         
         var moduleType:int = imageModule.GetImageModuleType ();
         if (moduleType < 0 )
            return -1;
         
         var index:int = imageModule.GetAppearanceLayerId ();
         if (index < 0)
            return -1;
         
         if (moduleType == AssetImageModule.ImageModuleType_WholeImage)
         {
            if (imageModule.GetAssetImageModuleManager () != mAssetImageManager)
               return -1;
            else
               return index;
         }

         index += mAssetImageManager.GetNumAssets ();
         
         if (moduleType == AssetImageModule.ImageModuleType_PureModule)
         {
            if (imageModule.GetAssetImageModuleManager () != mAssetImagePureModuleManager)
               return -1;
            else
               return index;
         }
         
         index += mAssetImagePureModuleManager.GetNumAssets ();
         
         if (moduleType == AssetImageModule.ImageModuleType_AssembledModule)
         {
            if (imageModule.GetAssetImageModuleManager () != mAssetImageAssembledModuleManager)
               return -1;
            else
               return index;
         }
         
         if (moduleType == AssetImageModule.ImageModuleType_SequencedModule)
         {
            if (imageModule.GetAssetImageModuleManager () == mAssetImageSequencedModuleManager)
            {
               index += mAssetImageAssembledModuleManager.GetNumAssets ();
               return index;
            }
         }
         
         return -1;
      }
      
      public function GetImageModuleByIndex (index:int):AssetImageModule
      {
         if (index >= 0)
         {
            if (index < mAssetImageManager.GetNumAssets ())
               return mAssetImageManager.GetAssetByAppearanceId (index) as AssetImageModule;
            
            index -= mAssetImageManager.GetNumAssets ();
            
            if (index < mAssetImagePureModuleManager.GetNumAssets ())
               return mAssetImagePureModuleManager.GetAssetByAppearanceId (index) as AssetImageModule;
            
            index -= mAssetImagePureModuleManager.GetNumAssets ();
            
            if (index < mAssetImageAssembledModuleManager.GetNumAssets ())
               return mAssetImageAssembledModuleManager.GetAssetByAppearanceId (index) as AssetImageModule;
            
            index -= mAssetImageAssembledModuleManager.GetNumAssets ();
            
            if (index < mAssetImageSequencedModuleManager.GetNumAssets ())
               return mAssetImageSequencedModuleManager.GetAssetByAppearanceId (index) as AssetImageModule;
         }
         
         return new AssetImageNullModule (); 
      }
      
      public function GetAssetSoundManager ():AssetSoundManager
      {
         return mAssetSoundManager;
      }
      
      public function GetSoundIndex (sound:AssetSound):int
      {
         if (sound == null)
            return -1;
         
         if (sound.GetAssetSoundManager () != mAssetSoundManager)
            return -1;
         
         return sound.GetAppearanceLayerId ();
      }
      
      public function GetSoundByIndex (soundIndex:int):AssetSound
      {
         if (soundIndex < 0 || soundIndex >= mAssetSoundManager.GetNumAssets ())
            return null;
         
         return mAssetSoundManager.GetAssetByAppearanceId (soundIndex) as AssetSound;
      }
      
//=================================================================================
//   session variables and pure functions
//=================================================================================
      
//=================================================================================
//   temp
//=================================================================================
      
      public function GetEntityContainer ():Scene
      {
         return mScenes [0] as Scene;
      }

      //public function GetCodeLibManager ():CodeLibManager
      //{
      //   return GetEntityContainer ().GetCodeLibManager ();
      //}
      
//=================================================================================
//   temp
//=================================================================================
//=================================================================================
//   functions
//=================================================================================
      
      protected var mCodeLibManager:CodeLibManager;

      public function GetCodeLibManager ():CodeLibManager
      {
         return mCodeLibManager;
      }
      
//=================================================================================
//   collision categories
//=================================================================================
      
      protected var mCollisionCategoryManager:CollisionCategoryManager;

      public function GetCollisionCategoryManager ():CollisionCategoryManager
      {
         return mCollisionCategoryManager;
      }

      public function CreateCollisionCategoryFriendLink (categoryIndex1:int, categoryIndex2:int):void
      {
         var category1:CollisionCategory = mCollisionCategoryManager.GetCollisionCategoryByIndex (categoryIndex1);
         var category2:CollisionCategory = mCollisionCategoryManager.GetCollisionCategoryByIndex (categoryIndex2);

         if (category1 != null && category2 != null)
            mCollisionCategoryManager.CreateCollisionCategoryFriendLink (category1, category2);
      }
      
//=================================================================================
//   trigger system
//=================================================================================

      protected var mTriggerEngine:TriggerEngine;

      public function GetTriggerEngine ():TriggerEngine
      {
         return mTriggerEngine;
      }

   }
}


