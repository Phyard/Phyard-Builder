
package editor.controls {
   
   public class FunctionCallingBlockData
   {
      public var mIndentLevel:int;
      
      public var mParentBlock:FunctionCallingBlockData; // null means most top level
      public var mMainBlock:FunctionCallingBlockData; // null means this is a main block
      public var mNextBranchBlock:FunctionCallingBlockData; // next branch block in current main block
      
      public var mFirstCallingLine:FunctionCallingLineData;
      public var mLastCallingLine:FunctionCallingLineData;
      
      public function FunctionCallingBlockData ()
      {
      }
   }
}
