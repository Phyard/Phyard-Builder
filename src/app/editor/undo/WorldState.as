package editor.undo {
   
   import common.Define;
   
   public class WorldState
   {
      private var mPrevWorldState:WorldState = null;
      private var mNextWorldState:WorldState = null;
      
      private var mDescription:String;
      private var mEditActions:Array = null;
      
      public var mUserData:Object = null; // temp
      
      public function WorldState (description:String, editActions:Array)
      {
         mDescription = description;
         mEditActions = editActions;
      }
      
      public function GetDescription ():String
      {
         return mDescription;
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