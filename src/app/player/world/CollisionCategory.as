
package player.world 
{
   public class CollisionCategory
   {
      // the index is the index assigned in edtor,
      // in fact, the index of this CollisionCategory in array is mCategoryIndex + 1
      // generally, this index is useless. It can used in the debug trace messages
      internal var mCategoryIndexInEditor:int = -1;
      internal var mCategoryIndex:int; // for the reason of merging, this may be different with mCategoryIndexInEditor
      
      // this is the real index in category array
      internal var mArrayIndex:int; // == mCategoryIndex + 1
      
      internal var mEnemyTable:Array;
      
      public function GetCategoryIndexInEditor ():int
      {
         return mCategoryIndexInEditor;
      }
      
      public function GetCategoryIndex ():int
      {
         return mCategoryIndex;
      }
      
      public function GetArrayIndex ():int
      {
         return mArrayIndex;
      }
      
      public function ToString ():String
      {
         return "CollisionCategory#" + mCategoryIndex;
      }
      
      internal function SetTableLength (length:int):void
      {
         var startIndex:int;
         if (mEnemyTable != null) // for merging
         {
            startIndex = mEnemyTable.length;
            mEnemyTable.length = length; // for c/java, more need to do
         }
         else
         {
            startIndex = 0;
            mEnemyTable = new Array (length);
         }

         for (var i:int = startIndex; i < length; ++ i)
         {
            mEnemyTable [i] = true; // default
         }
      }
   }
}
