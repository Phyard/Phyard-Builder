package editor.undo {
   
   import common.Define;
   
   public class WorldState
   {
      private var mPrevWorldState:WorldState = null;
      private var mNextWorldState:WorldState = null;
      
      private var mEditActions:Array = null;
      
      public var mUserData:Object = null; // temp
      
      public function WorldState (editActions:Array)
      {
         mEditActions = editActions;
      }
      
      public function GetPrevWorldState ():WorldState
      {
         return mPrevWorldState;
      }
      
      public function GetNextWorldState ():WorldState
      {
         return mNextWorldState;
      }
      
      public function SetPrevWorldState (prev:WorldState):void
      {
         mPrevWorldState = prev;
      }
      
      public function SetNextWorldState (next:WorldState):void
      {
         mNextWorldState = next;
      }
   }
   
}