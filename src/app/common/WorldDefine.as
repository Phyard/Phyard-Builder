
package common {
   
   public class WorldDefine
   {
      public var mVersion:int;
      
      public var mAuthorName:String = "";
      public var mAuthorHomepage:String = "";
      
      public var mShareSourceCode:Boolean = false;
      public var mPermitPublishing:Boolean = false;
      
      public var mSettings:Object = new Object ();
      
      public var mEntityDefines:Array = new Array ();
      
      public var mBrotherGroupDefines:Array = new Array ();
      
      public var mCollisionCategoryDefines:Array = new Array ();
      public var mDefaultCollisionCategoryIndex:int = Define.CollisionCategoryId_HiddenCategory;
      public var mCollisionCategoryFriendLinkDefines:Array = new Array ();
   }
}

