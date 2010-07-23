
package editor.controls {
   
   public class FunctionCallingBranchData
   {
      public var mIndentLevel:int;
      
      public var mIsValid:Boolean;
      
      public var mOwnerBlock:FunctionCallingBlockData; // the owner block, null means top branch
      public var mNextBranch:FunctionCallingBranchData = null; // next branch in the owner block
      
      public var mFirstCallingLine:FunctionCallingLineData; // generally, it is a branch calling
      public var mLastCallingLine:FunctionCallingLineData; // the calling before next branch or before block end
      
      public var mSupportBreakCalling:Boolean;
      public var mNumDirectBreakCallings:int = 0;
      
      public var mNumDirectReturnCallings:int = 0;
      
      public function FunctionCallingBranchData ()
      {
      }
      
      public function GetFirstLineNumber ():int
      {
         return mFirstCallingLine == null ? -1 : mFirstCallingLine.mLineNumber;
      }
   }
}
