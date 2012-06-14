
package common {
   
   public class WorldDefine
   {
   // ...
      
      public var mCurrentSceneId:int = 0; // for editing, added from v2.00
      
      public var mForRestartLevel:Boolean = false; // for playing
      
      public var mPlayerWorldHints:Object; // not used now. When and why it is added? 
      
   // ...
      
      public var mVersion:int;
      
      public var mAuthorName:String = "";
      public var mAuthorHomepage:String = "";
      
      public var mShareSourceCode:Boolean = false;
      public var mPermitPublishing:Boolean = false;
      
      public var mSceneDefines:Array = new Array ();
      
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
      
      public var mImageDefines:Array = new Array ();
      public var mPureImageModuleDefines:Array = new Array ();
      public var mAssembledModuleDefines:Array = new Array ();
      public var mSequencedModuleDefines:Array = new Array ();
      
      public var mSoundDefines:Array = new Array ();
   }
}

