
package editor.world {

   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;

   import com.tapirgames.util.Logger;

   import editor.image.AssetImageModule;
   import editor.image.AssetImageNullModule;

   import editor.image.AssetImageManager;
   import editor.image.AssetImagePureModuleManager;
   import editor.image.AssetImageCompositeModuleManager;
   
   import editor.sound.AssetSound;
   import editor.sound.AssetSoundManager;
   
   import editor.entity.Scene;
   
   import editor.trigger.VariableSpaceRegister;
   import editor.trigger.VariableSpaceCommonGlobal;
   import editor.trigger.VariableSpaceCommonEntityProperties;
   import editor.trigger.VariableSpaceWorld;
   import editor.trigger.VariableSpaceGameSave;
   
   import editor.trigger.FunctionDeclaration_PreDefined;
   import editor.trigger.FunctionDeclaration_Core;
   import editor.trigger.FunctionDeclaration_EventHandler;
   
   import editor.core.EditorObject;

   import common.trigger.CoreFunctionDeclarations;
   import common.trigger.CoreEventDeclarations;
   import common.trigger.CoreFunctionIds;
   import common.trigger.ValueTypeDefine;

   import common.Define;
   import common.ValueAdjuster;

   public class World
   {
      public function World (key:String)
      {
         SetKey (key);
         
         // ...
         
         InitFunctionDeclarations ();
         
         // ...
         
         CreateNewScene (null, "Default Scene");
         
         // images
         
         mAssetImageManager = new AssetImageManager ();
         mAssetImagePureModuleManager = new AssetImagePureModuleManager ();
         mAssetImageAssembledModuleManager = new AssetImageCompositeModuleManager (false);
         mAssetImageSequencedModuleManager = new AssetImageCompositeModuleManager (true);
         
         // sounds
         
         mAssetSoundManager = new AssetSoundManager ();
         
         // register variable spaces
         
         mRegisterVariableSpace_Boolean           = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_Boolean);
         mRegisterVariableSpace_String            = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_String);
         mRegisterVariableSpace_Number            = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_Number);
         mRegisterVariableSpace_Entity            = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_Entity);
         mRegisterVariableSpace_CollisionCategory = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_CollisionCategory);
         mRegisterVariableSpace_Module            = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_Module);
         mRegisterVariableSpace_Sound            = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_Sound);
         mRegisterVariableSpace_Scene            = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_Scene); // useless in fact.
         mRegisterVariableSpace_Array             = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_Array);
         
         // scene common variable spaces
         
         mCommonSceneGlobalVariableSpace = new VariableSpaceCommonGlobal (/*this*/);
         mCommonCustomEntityVariableSpace = new VariableSpaceCommonEntityProperties (/*this*/);
         
         // world session variable space
         
         mWorldVariableSpace = new VariableSpaceWorld (/*this*/);
         mGameSaveVariableSpace = new VariableSpaceGameSave  (/*this*/);
      }

      public function Destroy ():void
      {
         for each (var aScene:Scene in mScenes)
         {
            aScene.Destroy ();
         }
         
         // iamges
         
         mAssetImageManager.Destroy ();
         mAssetImagePureModuleManager.Destroy ();
         mAssetImageAssembledModuleManager.Destroy ();
         mAssetImageSequencedModuleManager.Destroy ();
         
         // sounds 
         mAssetSoundManager.Destroy ();
         
         // variable spaces
         mRegisterVariableSpace_Boolean = null;
         mRegisterVariableSpace_String = null;
         mRegisterVariableSpace_Number = null;
         mRegisterVariableSpace_Entity = null;
         mRegisterVariableSpace_CollisionCategory = null;
         mRegisterVariableSpace_Module = null;
         mRegisterVariableSpace_Sound = null;
         mRegisterVariableSpace_Scene = null;
         mRegisterVariableSpace_Array = null;
         
         mCommonSceneGlobalVariableSpace = null;
         mCommonCustomEntityVariableSpace = null;
         mWorldVariableSpace = null;
         mGameSaveVariableSpace = null;
      }

      //override 
      public function DestroyAllAssets ():void
      {
         for each (var aScene:Scene in mScenes)
         {
            aScene.Destroy ();
         }
         
         // images
         
         mAssetImageSequencedModuleManager.DestroyAllAssets ();
         mAssetImageAssembledModuleManager.DestroyAllAssets ();
         mAssetImagePureModuleManager.DestroyAllAssets ();
         mAssetImageManager.DestroyAllAssets ();
         
         // sounds
         
         mAssetSoundManager.DestroyAllAssets ();
      }
      
      public function SetKey (key:String):void
      {
         if (key == null || key.length == 0)
            key = EditorObject.BuildWorldKey ();
         
         mKey = key;
      }
      
      public function GetKey ():String
      {
         return mKey;
      }

//=================================================================================
//   settings
//=================================================================================

      private var mKey:String = null;
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
      
//============================================================================
// scene lookup tables
//============================================================================
      
      private var mSceneLookupTableByKey:Dictionary = new Dictionary ();
      
      public function GetSceneByKey (key:String):Scene
      {
         return mSceneLookupTableByKey [key] as Scene;
      }
      
      // todo: lookup table by name
      
//=================================================================================
//   scenes
//=================================================================================
      
      private var mScenes:Array = new Array ();
      
      public function GetEntryScene ():Scene
      {
         return mScenes [0] as Scene;
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
      
      public function GetSceneIndex (scene:Scene):int
      {
         if (scene == null || scene.GetWorld () != this)
            return -1;
         
         return scene.GetSceneIndex ();
      }
      
      private var mAccSceneId:int = 0;
      
      public function GetAccSceneId ():int
      {
         return mAccSceneId;
      }
      
      public function CreateNewScene (key:String, name:String, afterIndex:int = -1):int
      {
         //>> maybe, should be moved into DataFormat2.AdjustNumberValuesInWorldDefine ()
         var v200SceneKeyPrefix:String = "scene/"; // only in v2.00
         if (key != null && key.length >= v200SceneKeyPrefix.length && key.substring (0, v200SceneKeyPrefix.length) == v200SceneKeyPrefix)
            key = key.substring (v200SceneKeyPrefix.length);
         //<<
         
         if (key != null && key.length == 0)
            key = null;
         while (key == null || mSceneLookupTableByKey [key] != null)
         {
            key = EditorObject.BuildKey (GetAccSceneId ());
         }
         
         var newScene:Scene = new Scene (this, key);
         mSceneLookupTableByKey [key] = newScene;
         
         newScene.SetName (name);
         
         ++ mAccSceneId; // never decrease
         
         if (afterIndex >= 0)
            ++ afterIndex;
         
         if (afterIndex < 0 || afterIndex > mScenes.length)
            afterIndex = mScenes.length;
         
         mScenes.splice (afterIndex, 0, newScene);
         
         UpdateSceneListDataProvider ();
         
         return afterIndex;
      }
      
      public function DeleteSceneByIndex (index:int, updateDataProvider:Boolean = true):int
      {
         if (index < 0 || index >= mScenes.length)
            return -1;
         
         if (mScenes.length <= 1)
            return -1;
         
         var sceneToDelete:Scene = mScenes [index];
         sceneToDelete.Destroy ();
         sceneToDelete.SetSceneIndex (-1);
         mScenes.splice (index, 1);
         
         delete mSceneLookupTableByKey [sceneToDelete.GetKey ()];
         
         if (updateDataProvider)
            UpdateSceneListDataProvider ();
         
         return index >= mScenes.length  ? mScenes.length - 1 : index;
      }
      
      public function ChangeSceneIndex (fromIndex:int, targetIndex:int):int
      {
         if (fromIndex < 0 || fromIndex >= mScenes.length)
            return -1;
         
         if (targetIndex < 0 || targetIndex >= mScenes.length)
            return -1;
         
         if (targetIndex != fromIndex)
         {
            var scene:Scene = mScenes [fromIndex];
            mScenes.splice (fromIndex, 1);
            mScenes.splice (targetIndex, 0, scene);
            
            UpdateSceneListDataProvider ();
         }
         
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
      
      public function GetSceneListDataProviderItem (index:int):Object
      {
         if (index < 0 || index >= mSceneListDataProvider.length)
            return null;
         
         return mSceneListDataProvider [index];
      }
      
      public function UpdateSceneListDataProvider ():void
      {
         mSceneListDataProvider.splice (0, mSceneListDataProvider.length);
         
         for (var i:int = 0; i < mScenes.length; ++ i)
         {
            var scene:Scene = mScenes [i] as Scene;
            scene.SetSceneIndex (i);
            
            mSceneListDataProvider.push ({mName: i + "> " + scene.GetName (), mIndex: i, mDataTip: scene.GetName (), mData: scene});
         }
      }
      
//=================================================================================
//   
//=================================================================================
      
      // !!! revert some bad changes in revison 2b7b691dca3f454921e229eb20163850675adda1 - now ccats and functions are edit in dialogs
      public function ConvertRegisterVariablesToGlobalVariables ():void
      {
         for each (var scene:Scene in mScenes)
         {
            scene.ConvertRegisterVariablesToGlobalVariables ();
         }
      }
      
//=================================================================================
//   select list
//=================================================================================

      public function GetSceneSelectListDataProvider ():Array
      {
         var list:Array = new Array ();

         list.push ({label:"-1: null", mSceneIndex:-1});

         for each (var scene:Scene in mScenes)
         {
            var item:Object = new Object ();
            item.label = scene.GetSceneIndex () + ": " + scene.GetName ();
            item.mSceneIndex = scene.GetSceneIndex ();
            list.push (item);
         }

         return list;
      }

      public static function SceneIndex2SelectListSelectedIndex (sceneIndex:int, dataProvider:Array):int
      {
         for (var i:int = 0; i < dataProvider.length; ++ i)
         {
            if (dataProvider[i].mSceneIndex == sceneIndex)
               return i;
         }

         return 0;
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
      
      public function GetNumImageModules ():int
      {
         return mAssetImageManager.GetNumAssets ()
              + mAssetImagePureModuleManager.GetNumAssets ()
              + mAssetImageAssembledModuleManager.GetNumAssets ()
              + mAssetImageSequencedModuleManager.GetNumAssets ()
              ;
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
//   function/event declarations
//=================================================================================
      
      private static var mFunctionDeclarationsInited:Boolean = false;
      private static function InitFunctionDeclarations ():void
      {
         if (mFunctionDeclarationsInited)
            return;
         
         // APIs
         
         CoreFunctionDeclarations.Initialize ();
         CoreEventDeclarations.Initialize ();
         
         CoreFunctionDeclarationsForPlaying.Initialize ();
         CoreEventDeclarationsForPlaying.Initialize ();
         
         // ...
         mFunctionDeclarationsInited = true;
      }
      
      public static function GetEventDeclarationById (event_id:int):FunctionDeclaration_EventHandler
      {
         return CoreEventDeclarationsForPlaying.GetEventDeclarationById (event_id);
      }
      
      public static function GetPlayerCoreFunctionDeclarationById (func_id:int):FunctionDeclaration_Core
      {
         return CoreFunctionDeclarationsForPlaying.GetCoreFunctionDeclarationById (func_id);
      }
      
      // some special ones
      
      public static function GetVoidFunctionDeclaration ():FunctionDeclaration_PreDefined
      {
         return CoreFunctionDeclarationsForPlaying.GetPreDefinedFunctionDeclarationById (CoreFunctionIds.ID_Void);
      }
      
      public static function GetBoolFunctionDeclaration ():FunctionDeclaration_PreDefined
      {
         return CoreFunctionDeclarationsForPlaying.GetPreDefinedFunctionDeclarationById (CoreFunctionIds.ID_Bool);
      }
      
      public static function GetEntityFilterFunctionDeclaration ():FunctionDeclaration_PreDefined
      {
         return CoreFunctionDeclarationsForPlaying.GetPreDefinedFunctionDeclarationById (CoreFunctionIds.ID_EntityFilter);
      }
      
      public static function GetEntityPairFilterFunctionDeclaration ():FunctionDeclaration_PreDefined
      {
         return CoreFunctionDeclarationsForPlaying.GetPreDefinedFunctionDeclarationById (CoreFunctionIds.ID_EntityPairFilter);
      }
      
//=================================================================================
//   session variables and pure functions
//   register variables (in fact, register variables are scene dependent in playing)
//=================================================================================
      
      // register variables
      private var mRegisterVariableSpace_Boolean          :VariableSpaceRegister;
      private var mRegisterVariableSpace_String           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Number           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Entity           :VariableSpaceRegister;
      private var mRegisterVariableSpace_CollisionCategory:VariableSpaceRegister;
      private var mRegisterVariableSpace_Module           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Sound           :VariableSpaceRegister;
      private var mRegisterVariableSpace_Scene           :VariableSpaceRegister; // useless in fact
      private var mRegisterVariableSpace_Array            :VariableSpaceRegister;
      
      // common variables
      private var mCommonSceneGlobalVariableSpace:VariableSpaceCommonGlobal;
      private var mCommonCustomEntityVariableSpace:VariableSpaceCommonEntityProperties;
      private var mWorldVariableSpace:VariableSpaceWorld;
      private var mGameSaveVariableSpace:VariableSpaceGameSave;
      
      public function GetRegisterVariableSpace (valueType:int):VariableSpaceRegister
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return mRegisterVariableSpace_Boolean;
            case ValueTypeDefine.ValueType_String:
               return mRegisterVariableSpace_String;
            case ValueTypeDefine.ValueType_Number:
               return mRegisterVariableSpace_Number;
            case ValueTypeDefine.ValueType_Entity:
               return mRegisterVariableSpace_Entity;
            case ValueTypeDefine.ValueType_CollisionCategory:
               return mRegisterVariableSpace_CollisionCategory;
            case ValueTypeDefine.ValueType_Module:
               return mRegisterVariableSpace_Module;
            case ValueTypeDefine.ValueType_Sound:
               return mRegisterVariableSpace_Sound;
            case ValueTypeDefine.ValueType_Scene:
               return mRegisterVariableSpace_Scene;
            case ValueTypeDefine.ValueType_Array:
               return mRegisterVariableSpace_Array;
            default:
               return null;
         }
      }
      
      public function GetCommonSceneGlobalVariableSpace ():VariableSpaceCommonGlobal
      {
         return mCommonSceneGlobalVariableSpace;
      }
      
      public function GetCommonCustomEntityVariableSpace ():VariableSpaceCommonEntityProperties
      {
         return mCommonCustomEntityVariableSpace;
      }
      
      public function GetWorldVariableSpace ():VariableSpaceWorld
      {
         return mWorldVariableSpace;
      }
      
      public function GetGameSaveVariableSpace ():VariableSpaceGameSave
      {
         return mGameSaveVariableSpace;
      }
   }
}


