
package common {
   
   public class SceneDefine
   {
      public var mDontFillMissedFields:Boolean = false; // from v2.00. For fast loading
      public var mDontAdjustNumberValues:Boolean = false; // from v2.00. For fast loading
      
      public var mKey:String;
      public var mName:String;
      
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
      
      public var mClassDefines:Array = new Array (); // since v2.05
      public var mPackageDefines:Array = new Array (); // since v2.05
   }
}

