package editor.undo {
   
   import common.Define;
   
   public class WorldHistoryManager
   {
      private static const MaxHistories:int = 32;
      
      private var mCurrentWorldState:WorldState = null;
      
      public function WorldHistoryManager ()
      {
         ClearHistories ();
      }
      
      public function ClearHistories ():void
      {
         mCurrentWorldState = null;
      }
      
      public function GetCurrentWorldState ():WorldState
      {
         return mCurrentWorldState;
      }
      
      public function GetPrevWorldState ():WorldState
      {
         if (mCurrentWorldState == null)
            return null;
         
         return mCurrentWorldState.GetPrevWorldState ();
      }
      
      public function GetNextWorldState ():WorldState
      {
         if (mCurrentWorldState == null)
            return null;
         
         return mCurrentWorldState.GetNextWorldState ();
      }
      
      public function AddHistory (worldState:WorldState):void
      {
         if (worldState == null)
            return;
         
         worldState.SetPrevWorldState (mCurrentWorldState);
         worldState.SetNextWorldState (null);
         if (mCurrentWorldState != null)
            mCurrentWorldState.SetNextWorldState (worldState);
         
         mCurrentWorldState = worldState;
         
         var prev:WorldState = mCurrentWorldState;
         var numHistories:int = MaxHistories;
         while (prev != null)
         {
            if (numHistories -- < 0)
            {
               prev.SetPrevWorldState (null);
               break;
            }
            
            prev = prev.GetPrevWorldState ();
         }
      }
      
      public function UndoHistory ():WorldState
      {
         if (GetPrevWorldState () == null)
            return null;
         
         mCurrentWorldState = mCurrentWorldState.GetPrevWorldState ();
         
         return mCurrentWorldState;
      }
      
      public function RedoHistory ():WorldState
      {
         if (GetNextWorldState () == null)
            return null;
         
         mCurrentWorldState = mCurrentWorldState.GetNextWorldState ();
         
         return mCurrentWorldState;
      }
   }
   
   
   
}