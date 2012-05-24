
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
   import editor.trigger.CodeSnippet;

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
   import editor.entity.Entity;
   
   import editor.trigger.entity.EntityCodeSnippetHolder;

   import common.Define;
   import common.ValueAdjuster;

   public class World // extends EntityContainer
   {
      public var mEntityContainer:Scene;
      
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
      
      // !!! revert some bad changes in revison 2b7b691dca3f454921e229eb20163850675adda1 - now ccats and functions are edit in dialogs
      public function ConvertRegisterVariablesToGlobalVariables ():void
      {
         var oldNumGlobalVariables:int = mTriggerEngine.GetGlobalVariableSpace ().GetNumVariableInstances ();
         
         //
         
         var variableMapTable:Dictionary = new Dictionary ();
         var codeSnippet:CodeSnippet;
         
         // check script holders
         
         var numAssets:int = GetEntityContainer ().GetNumAssets ();
         
         for (var createId:int = 0; createId < numAssets; ++ createId)
         {
            var entity:Entity = GetEntityContainer ().GetAssetByCreationId (createId) as Entity;
            if (entity is EntityCodeSnippetHolder)
            {
               codeSnippet = (entity as EntityCodeSnippetHolder).GetCodeSnippet () as CodeSnippet;
               if (codeSnippet != null)
               {
                  codeSnippet.ConvertRegisterVariablesToGlobalVariables (this);
               }
            }
         }
         
         // check custom functions
         
         var numFunctions:int = GetCodeLibManager ().GetNumFunctions ();
         for (var functionId:int = 0; functionId < numFunctions; ++ functionId)
         {
            var functionAsset:AssetFunction = GetCodeLibManager ().GetFunctionByIndex (functionId);
            
            codeSnippet = functionAsset.GetCodeSnippet ();
            if (codeSnippet != null)
            {
               codeSnippet.ConvertRegisterVariablesToGlobalVariables (this);
            }
         }
         
         // ...
         
         if (oldNumGlobalVariables != mTriggerEngine.GetGlobalVariableSpace ().GetNumVariableInstances ())
         {
            mTriggerEngine.NotifyGlobalVariableSpaceModified ();
         }
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


