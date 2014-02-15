
package common {
   
   public class WorldDefine
   {
   // ...

      public var mViewerParams:Object;
      
      public var mCurrentSceneId:int = 0; // for editing undo scene, added from v2.00
                                          // also for playing to load/merge a specified scene
      
      public var mForRestartLevel:Boolean = false; // for playing, add from v1.5?. For fast loading
      
      public var mPlayerWorldHints:Object; // not used now. When and why it is added? 
      
      // the two are used for global data now. SceneDefine also has two such properties.
      public var mDontFillMissedFields:Boolean = false; // from v2.00. For fast loading
      public var mDontAdjustNumberValues:Boolean = false; // from v2.00. For fast loading
      
      public var mDontReloadGlobalAssets:Boolean = false; // from v2.00. For fast loading
      
      public var mWorldCrossStagesData:Object; // from v2.06. For reused some data of last player world instance.
            
   // ...
      
      public var mVersion:int;
      
      public var mKey:String = null; // from v2.03
      
      public var mAuthorName:String = "";
      public var mAuthorHomepage:String = "";
      
      public var mShareSourceCode:Boolean = false;
      public var mPermitPublishing:Boolean = false;
      
      public var mPreferences:Object = new Object (); // from v2.06
      
      public var mSceneDefines:Array = new Array (); // for undo point or scene-exporting, except one scene, only key is stored for other scenes
      
      //>> moved into SceneDefine since v2.00
      /* 
         public var mSettings:Object = new Object ();
         
         public var mEntityDefines:Array = new Array ();
         
         public var mEntityAppearanceOrder:Array = new Array ();
         
         public var mBrotherGroupDefines:Array = new Array ();
         
         public var mCollisionCategoryDefines:Array = new Array ();
         public var mDefaultCollisionCategoryIndex:int = Define.CCatId_Hidden;
         public var mCollisionCategoryFriendLinkDefines:Array = new Array ();
         
         public var mSessionVariableDefines:Array = new Array (); // from v1.57
         //public var mGlobalVariableSpaceDefines:Array = new Array (); // v1.52 only
         //public var mEntityPropertySpaceDefines:Array = new Array (); // v1.52 only
         public var mGlobalVariableDefines:Array = new Array ();
         public var mEntityPropertyDefines:Array = new Array ();
         
         public var mFunctionDefines:Array = new Array ();
      */
      //<<
      
      public var mWorldVariableDefines:Array = new Array (); // from v2.03
      public var mGameSaveVariableDefines:Array = new Array (); // from v2.03
      
      public var mCommonGlobalVariableDefines:Array = new Array (); // from v2.03
      public var mCommonEntityPropertyDefines:Array = new Array (); // from v2.03
      
      public var mAreSimpleGlobalAssetDefines:Boolean = false; // for scene undo point, set it as true
      
      public var mImageDefines:Array = new Array (); // for undo point, only key is stored
      public var mPureImageModuleDefines:Array = new Array (); // for undo point, only key is stored
      public var mAssembledModuleDefines:Array = new Array (); // for undo point, only key is stored
      public var mSequencedModuleDefines:Array = new Array (); // for undo point, only key is stored
      
      public var mSoundDefines:Array = new Array ();// for undo point, this is a UUID array
   }
}

