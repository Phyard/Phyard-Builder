
package common.trigger.parse {
   
   public class FunctionCallingBranchInfo
   {
      public var mIndentLevel:int;
      
      public var mIsValid:Boolean;
      
      public var mOwnerBlock:FunctionCallingBlockInfo; // the owner block, null means top branch
      public var mNextBranch:FunctionCallingBranchInfo = null; // next branch in the owner block
      
      public var mFirstCallingLine:FunctionCallingLineInfo; // generally, it is a branch calling
      public var mLastCallingLine:FunctionCallingLineInfo; // the calling before next branch or before block end
      
      public var mOwnerBlockSupportBreak:FunctionCallingBlockInfo; // for break callings convenience
      public var mNumDirectBreakCallings:int = 0;
      public var mOwnerBlockSupportContinue:FunctionCallingBlockInfo; // for continue callings convenience
      public var mNumDirectContinueCallings:int = 0;
      
      public var mNumValidCallings:int = 0;
      public var mNumDirectReturnCallings:int = 0;
      
      public function FunctionCallingBranchInfo ()
      {
      }
      
      public function GetFirstLineNumber ():int
      {
         return mFirstCallingLine == null ? -1 : mFirstCallingLine.mLineNumber;
      }
   }
}
