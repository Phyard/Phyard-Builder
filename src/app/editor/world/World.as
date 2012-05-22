
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
   import editor.codelib.AssetFunction;
   
   import editor.entity.Scene;

   import common.Define;
   import common.ValueAdjuster;

   public class World // extends EntityContainer
   {
      public var mEntityContainer:Scene;
      public var mScenes:Array;
      
      //public var mCollisionManager:CollisionManager;
      public var mCollisionCategoryManager:CollisionCategoryManager;

      public var mTriggerEngine:TriggerEngine;

      //public var mFunctionManager:FunctionManager;
      public var mCodeLibManager:CodeLibManager;

      protected var mAssetImageManager:AssetImageManager;
      protected var mAssetImagePureModuleManager:AssetImagePureModuleManager;
      protected var mAssetImageAssembledModuleManager:AssetImageCompositeModuleManager;
      protected var mAssetImageSequencedModuleManager:AssetImageCompositeModuleManager;
      protected var mAssetSoundManager:AssetSoundManager;

      // temp the 2 is not used
      // somewhere need to be modified to use the 2
      public var mNumGravityControllers:int = 0;
      public var mNumCameraEntities:int = 0;

      public function World ()
      {
         super ();

      //
         mEntityContainer = new Scene ();
         mEntityContainer.SetName ("Default Scene");
         mScenes = new Array ();
         mScenes.push (mEntityContainer);
         UpdateSceneListDataProvider ();
         
         //mCollisionManager = new CollisionManager ();
         mCollisionCategoryManager = new CollisionCategoryManager ();

         mTriggerEngine = new TriggerEngine ();

         //mFunctionManager = new FunctionManager (this);
         mCodeLibManager = new CodeLibManager (this);

         mCodeLibManager.SetFunctionMenuGroup (PlayerFunctionDefinesForEditing.sCustomMenuGroup);

         mAssetImageManager = new AssetImageManager ();
         mAssetImagePureModuleManager = new AssetImagePureModuleManager ();
         mAssetImageAssembledModuleManager = new AssetImageCompositeModuleManager (false);
         mAssetImageSequencedModuleManager = new AssetImageCompositeModuleManager (true);
         mAssetSoundManager = new AssetSoundManager ();
      }

      //override 
      public function Destroy ():void
      {
         mEntityContainer.Destroy ();
         //mCollisionManager.Destroy ();
         mCollisionCategoryManager.Destroy ();
         mCodeLibManager.Destroy ();
         mAssetImageManager.Destroy ();
         mAssetImagePureModuleManager.Destroy ();
         mAssetImageAssembledModuleManager.Destroy ();
         mAssetImageSequencedModuleManager.Destroy ();
         mAssetSoundManager.Destroy ();

      //   super.Destroy ();
      }

      //override 
      public function DestroyAllEntities ():void
      {
         mEntityContainer..DestroyAllAssets ();
         //mCollisionManager.DestroyAllEntities ();
         mCollisionCategoryManager.DestroyAllAssets ();
         mCodeLibManager.DestroyAllAssets ();
         mAssetImageSequencedModuleManager.DestroyAllAssets ();
         mAssetImageAssembledModuleManager.DestroyAllAssets ();
         mAssetImagePureModuleManager.DestroyAllAssets ();
         mAssetImageManager.DestroyAllAssets ();
         mAssetSoundManager.DestroyAllAssets ();

      //   super.DestroyAllEntities ();
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
//   collision categories
//=================================================================================

      public function GetEntityContainer ():Scene
      {
         return mEntityContainer;
      }
      
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
      
      public function CreateNewSceneAfterIndex (name:String, afterIndex:int):int
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
      
      public function ChangeSceneNameByIndex (index:int, newName:String):int
      {
         if (index < 0 || index >= mScenes.length)
            return -1;
         
         var scene:Scene = mScenes [index];
         scene.SetName (newName);
         
         UpdateSceneListDataProvider ();
         
         return index;
      }
      
//=================================================================================
//   collision categories
//=================================================================================

      //public function GetCollisionManager ():CollisionManager
      //{
      //   return mCollisionManager;
      //}
      //
      //public function CreateEntityCollisionCategoryFriendLink (categoryIndex1:int, categoryIndex2:int):void
      //{
      //   var category1:EntityCollisionCategory = mCollisionManager.GetCollisionCategoryByIndex (categoryIndex1);
      //   var category2:EntityCollisionCategory = mCollisionManager.GetCollisionCategoryByIndex (categoryIndex2);
      //
      //   if (category1 != null && category2 != null)
      //      mCollisionManager.CreateEntityCollisionCategoryFriendLink (category1, category2);
      //}
      
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
//   functions
//=================================================================================

      //public function GetFunctionManager ():FunctionManager
      //{
      //   return mFunctionManager;
      //}
      
      public function GetCodeLibManager ():CodeLibManager
      {
         return mCodeLibManager
      }

//=================================================================================
//   trigger system
//=================================================================================

      public function GetTriggerEngine ():TriggerEngine
      {
         return mTriggerEngine;
      }

//=================================================================================
//   image asset. (Will move to Runtime if multiple worlds is supported later)
//=================================================================================

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
   }
}


