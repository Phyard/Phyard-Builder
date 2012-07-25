package editor.undo {
   
   import common.Define;
   
   public class HistoryManager
   {
      private static const MaxHistories:int = 32;
      
      private var mCurrentHistoryState:HistoryState = null;
      
      public function HistoryManager ()
      {
         ClearHistories ();
      }
      
      public function ClearHistories ():void
      {
         mCurrentHistoryState = null;
      }
      
      public function GetCurrentHistoryState ():HistoryState
      {
         return mCurrentHistoryState;
      }
      
      public function GetPrevHistoryState ():HistoryState
      {
         if (mCurrentHistoryState == null)
            return null;
         
         return mCurrentHistoryState.GetPrevHistoryState ();
      }
      
      public function GetNextHistoryState ():HistoryState
      {
         if (mCurrentHistoryState == null)
            return null;
         
         return mCurrentHistoryState.GetNextHistoryState ();
      }
      
      public function AddHistory (worldState:HistoryState):void
      {
         if (worldState == null)
            return;
         
         worldState.SetPrevHistoryState (mCurrentHistoryState);
         worldState.SetNextHistoryState (null);
         if (mCurrentHistoryState != null)
            mCurrentHistoryState.SetNextHistoryState (worldState);
         
         mCurrentHistoryState = worldState;
         
         var prev:HistoryState = mCurrentHistoryState;
         var numHistories:int = MaxHistories;
         while (prev != null)
         {
            if (numHistories -- < 0)
            {
               prev.SetPrevHistoryState (null);
               break;
            }
            
            prev = prev.GetPrevHistoryState ();
         }
      }
      
      public function UndoHistory ():HistoryState
      {
         if (GetPrevHistoryState () == null)
            return null;
         
         mCurrentHistoryState = mCurrentHistoryState.GetPrevHistoryState ();
         
         return mCurrentHistoryState;
      }
      
      public function RedoHistory ():HistoryState
      {
         if (GetNextHistoryState () == null)
            return null;
         
         mCurrentHistoryState = mCurrentHistoryState.GetNextHistoryState ();
         
         return mCurrentHistoryState;
      }
   }
   
   
   
}