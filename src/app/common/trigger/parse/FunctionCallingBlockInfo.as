
package common.trigger.parse {
   
   public class FunctionCallingBlockInfo
   {
      public var mIndentLevel:int;
      
      public var mIsValid:Boolean;
      
      public var mOwnerBlock:FunctionCallingBlockInfo; // the owner block, null means top block
      public var mOwnerBranch:FunctionCallingBranchInfo; // the branch contains this block. Must be a branch of mOwnerBlock
      
      public var mOwnerBlockSupportBreak:FunctionCallingBlockInfo = null; // for break callings convenience. The value is self if this support break callings
      public var mOwnerBlockSupportContinue:FunctionCallingBlockInfo = null; // for continue callings convenience. The value is self if this support continue callings
      
      public var mFirstBranch:FunctionCallingBranchInfo;
      public var mLastBranch:FunctionCallingBranchInfo;
      
      public var mStartCallingLine:FunctionCallingLineInfo;
      public var mEndCallingLine:FunctionCallingLineInfo;
      
      public var mNumValidCallings:int = 0;
      
      public var mNumElseBranches:int = 0; // valid for if-block only
      
      public function FunctionCallingBlockInfo ()
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
