
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
   import editor.trigger.VariableSpaceSession;
   
   import editor.trigger.FunctionDeclaration_PreDefined;
   import editor.trigger.FunctionDeclaration_Core;
   import editor.trigger.FunctionDeclaration_EventHandler;

   import common.trigger.CoreFunctionDeclarations;
   import common.trigger.CoreEventDeclarations;
   import common.trigger.CoreFunctionIds;
   import common.trigger.ValueTypeDefine;

   import common.Define;
   import common.ValueAdjuster;

   public class World
   {
      public function World ()
      {
         // ...
         
         InitFunctionDeclarations ();
         
         // ...
         
         CreateNewScene ("Default Scene");
         
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
         mRegisterVariableSpace_Array             = new VariableSpaceRegister (/*this, */ValueTypeDefine.ValueType_Array);
         
         // session variable space
         
         //mSessionVariableSpace = new VariableSpaceSession (/*this*/);
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
      
      public function CreateNewScene (name:String, afterIndex:int = -1):int
      {
         var newScene:Scene = new Scene (this);
         newScene.SetName (name);
         
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
         mScenes.splice (index, 1);
         
         if (updateDataProvider)
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
         
         var scene:Scene = mScenes [fromIndex];
         mScenes.splice (fromIndex, 1);
         mScenes.splice (targetIndex, 0, scene);
         
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
            scene.SetSceneIndex (i);
            
            mSceneListDataProvider.push ({mName: i + "> " + scene.GetName (), mIndex: i, mDataTip: scene.GetName (), mData: scene});
         }
      }
      
      // !!! revert some bad changes in revison 2b7b691dca3f454921e229eb20163850675adda1 - now ccats and functions are edit in dialogs
      public function ConvertRegisterVariablesToGlobalVariables ():void
      {
         for each (var scene:Scene in mScenes)
         {
            scene.ConvertRegisterVariablesToGlobalVariables ();
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
      private var mRegisterVariableSpace_Array            :VariableSpaceRegister;
      
      // session variables
      //private var mSessionVariableSpace:VariableSpaceSession;
      
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
            case ValueTypeDefine.ValueType_Array:
               return mRegisterVariableSpace_Array;
            default:
               return null;
         }
      }
      
      //public function GetSessionVariableSpace ():VariableSpaceSession
      //{
      //   return mSessionVariableSpace;
      //}
   }
}


