package editor.undo {
   
   import common.Define;
   
   public class HistoryState
   {
      private var mPrevHistoryState:HistoryState = null;
      private var mNextHistoryState:HistoryState = null;
      
      private var mDescription:String;
      private var mEditActions:Array = null;
      
      public var mUserData:Object = null; // temp
      
      public function HistoryState (description:String, editActions:Array)
      {
         mDescription = description;
         mEditActions = editActions;
      }
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function GetPrevHistoryState ():HistoryState
      {
         return mPrevHistoryState;
      }
      
      public function GetNextHistoryState ():HistoryState
      {
         return mNextHistoryState;
      }
      
      public function SetPrevHistoryState (prev:HistoryState):void
      {
         mPrevHistoryState = prev;
      }
      
      public function SetNextHistoryState (next:HistoryState):void
      {
         mNextHistoryState = next;
      }
   }
   
}