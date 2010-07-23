
package editor.controls {
   
   public class FunctionCallingBlockData
   {
      public var mIndentLevel:int;
      
      public var mIsValid:Boolean;
      
      public var mOwnerBlock:FunctionCallingBlockData; // the owner block, null means top block
      public var mOwnerBranch:FunctionCallingBranchData; // the branch contains this block. Must be a branch of mOwnerBlock
      
      public var mFirstBranch:FunctionCallingBranchData;
      public var mLastBranch:FunctionCallingBranchData;
      
      public var mStartCallingLine:FunctionCallingLineData;
      public var mEndCallingLine:FunctionCallingLineData;
      
      public var mSupportBreakCalling:Boolean;
      
      public var mNumElseBranches:int = 0; // valid for if-block only
      
      public function FunctionCallingBlockData ()
      {
      }
      
      public function GetFirstCallingFunctionId ():int
      {
         return mStartCallingLine == null ? -1 : mStartCallingLine.mFunctionId;
      }
      
      public function GetFirstLineNumber ():int
      {
         return mStartCallingLine == null ? -1 : mStartCallingLine.mLineNumber;
      }
   }
}
