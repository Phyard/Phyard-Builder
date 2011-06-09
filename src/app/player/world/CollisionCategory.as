
package player.world 
{
   public class CollisionCategory
   {
      // the index is the index assigned in edtor,
      // in fact, the index of this CollisionCategory in array is mCategoryIndex + 1
      // generally, this index is useless. It can used in the debug trace messages
      internal var mCategoryIndex:int;
      
      // this is the real index in category array
      internal var mArrayIndex:int; // == mCategoryIndex + 1
      
      internal var mEnemyTable:Array;
      
      public function GetIndexInEditor ():int
      {
         return mCategoryIndex;
      }
      
      public function ToString ():String
      {
         return "CollisionCategory#" + mCategoryIndex;
      }
      
      internal function SetTableLength (length:int):void
      {
         mEnemyTable = new Array (length);
         for (var i:int = 0; i < length; ++ i)
         {
            mEnemyTable [i] = true; // default
         }
      }
   }
}
