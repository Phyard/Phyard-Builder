
package editor.world {

   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;

   import com.tapirgames.util.Logger;

   import editor.entity.Entity;

   import editor.entity.EntityVectorShape;
   import editor.entity.EntityVectorShapeCircle;
   import editor.entity.EntityVectorShapeRectangle;
   import editor.entity.EntityVectorShapePolygon;
   import editor.entity.EntityVectorShapePolyline;
   import editor.entity.EntityVectorShapeText;
   import editor.entity.EntityVectorShapeTextButton;
   import editor.entity.EntityVectorShapeGravityController;
   
   import editor.entity.EntityShapeImageModule;
   import editor.entity.EntityShapeImageModuleButton;

   import editor.entity.EntityUtility;
   import editor.entity.EntityUtilityCamera;
   import editor.entity.EntityUtilityPowerSource;

   import editor.entity.EntityJoint;
   import editor.entity.EntityJointDistance;
   import editor.entity.EntityJointHinge;
   import editor.entity.EntityJointSlider;
   import editor.entity.EntityJointSpring;
   import editor.entity.EntityJointWeld;
   import editor.entity.EntityJointDummy;

   import editor.entity.SubEntityJointAnchor;

   import editor.trigger.entity.EntityLogic;
   import editor.trigger.entity.EntityBasicCondition;
   import editor.trigger.entity.EntityConditionDoor;
   import editor.trigger.entity.EntityTask;
   import editor.trigger.entity.EntityInputEntityAssigner;
   import editor.trigger.entity.EntityInputEntityPairAssigner;
   import editor.trigger.entity.EntityInputEntityScriptFilter;
   import editor.trigger.entity.EntityInputEntityPairScriptFilter;
   import editor.trigger.entity.EntityInputEntityRegionSelector;
   import editor.trigger.entity.EntityEventHandler;
   import editor.trigger.entity.EntityEventHandler_Timer;
   import editor.trigger.entity.EntityEventHandler_TimerWithPrePostHandling;
   import editor.trigger.entity.EntityEventHandler_Keyboard;
   import editor.trigger.entity.EntityEventHandler_Mouse;
   import editor.trigger.entity.EntityEventHandler_Contact;
   import editor.trigger.entity.EntityEventHandler_JointReachLimit;
   import editor.trigger.entity.EntityEventHandler_ModuleLoopToEnd;
   import editor.trigger.entity.EntityEventHandler_GameLostOrGotFocus;
   import editor.trigger.entity.EntityAction;

   //import editor.trigger.entity.EntityFunctionPackage;
   //import editor.trigger.entity.EntityFunction;

   import editor.entity.VertexController;

   //import editor.entity.EntityCollisionCategory;

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

   import common.Define;
   import common.ValueAdjuster;

   public class World // extends EntityContainer
   {
      public var mEntityContainer:EntityContainer;
      
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
         mEntityContainer = new EntityContainer ();
         
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

      //>>1.51
      private var mViewerUiFlags:int = Define.DefaultPlayerUiFlags;
      private var mPlayBarColor:uint = 0x606060;

      private var mViewportWidth:int = Define.DefaultPlayerWidth;
      private var mViewportHeight:int = Define.DefaultPlayerHeight;
      //<<

      //>>v1.60
      private var mPauseOnFocusLost:Boolean = false;
      //<<

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
      
      public function SetViewerUiFlags (flags:int):void
      {
         mViewerUiFlags = flags;
      }

      public function GetViewerUiFlags ():int
      {
         return mViewerUiFlags;
      }

      public function SetPlayBarColor (color:uint):void
      {
         mPlayBarColor = color;
      }

      public function GetPlayBarColor ():uint
      {
         return mPlayBarColor;
      }

      public function SetViewportWidth (width:int):void
      {
         mViewportWidth = width;
      }

      public function GetViewportWidth ():int
      {
         return mViewportWidth;
      }

      public function SetViewportHeight (height:int):void
      {
         mViewportHeight = height;
      }

      public function GetViewportHeight ():int
      {
         return mViewportHeight;
      }

      public function ValidateViewportSize ():void
      {
         if (mViewportWidth > Define.MaxViewportSize)
            mViewportWidth = Define.MaxViewportSize;
         if (mViewportWidth < Define.MinViewportSize)
            mViewportWidth = Define.MinViewportSize;

         if (mViewportHeight > Define.MaxViewportSize)
            mViewportHeight = Define.MaxViewportSize;
         if (mViewportHeight < Define.MinViewportSize)
            mViewportHeight = Define.MinViewportSize;
      }
      
      public function IsPauseOnFocusLost ():Boolean
      {
         return mPauseOnFocusLost;
      }
      
      public function SetPauseOnFocusLost (pauseOnFocusLost:Boolean):void
      {
         mPauseOnFocusLost = pauseOnFocusLost;
      }
      
//=================================================================================
//   collision categories
//=================================================================================

      public function GetEntityContainer ():EntityContainer
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


