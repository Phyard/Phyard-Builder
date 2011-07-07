
package common {
   
   public class WorldDefine
   {
   // ...
      
      public var mForRestartLevel:Boolean = false;
      
      public var mPlayerWorldHints:Object; // not used now. When and why is it added? 
      
   // ...
      public var mVersion:int;
      
      public var mAuthorName:String = "";
      public var mAuthorHomepage:String = "";
      
      public var mShareSourceCode:Boolean = false;
      public var mPermitPublishing:Boolean = false;
      
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
   }
}

