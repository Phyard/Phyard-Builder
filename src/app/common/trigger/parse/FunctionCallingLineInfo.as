
package common.trigger.parse {
   
   import player.trigger.FunctionCalling;
   
   import common.trigger.define.FunctionCallingDefine;
   
   public class FunctionCallingLineInfo
   {
      public var mFunctionId:int;
      public var mIsCoreDeclaration:Boolean;
      
      private var _mIndentLevel:int = 0;
      
      public var mOwnerBlock:FunctionCallingBlockInfo;
      public var mOwnerBranch:FunctionCallingBranchInfo; // may be null
      
      public var mOwnerBlockSupportBreak:FunctionCallingBlockInfo; // for break callings only
      public var mOwnerBlockSupportContinue:FunctionCallingBlockInfo; // for continue callings only
      
      private var _mIsValid:Boolean = true;
      
      private var _mLineNumber:int;
      
      public var mHtmlText:String = null; // only for eidting
      public var mIndentChanged:Boolean = false; // only for eidting
      
      public var mFunctionCallingDefine:FunctionCallingDefine; // only for playing
      public var mFunctionCallingForPlaying:FunctionCalling = null; // only for playing
      public var mNextValidCallingLine:FunctionCallingLineInfo = null; // only for playing
      public var mNextGoodCallingLine:FunctionCallingLineInfo = null; // only for playing optimize
      
      public function set mIsValid (valid:Boolean):void
      {
         if (_mIsValid != valid)
         {
            mHtmlText = null;
            _mIsValid = valid;
         }
      }
      
      public function get mIsValid ():Boolean
      {
         return _mIsValid;
      }
      
      public function set mLineNumber (lineNumber:int):void
      {
         _mLineNumber = lineNumber;
      }
      
      public function get mLineNumber ():int
      {
         return _mLineNumber;
      }
      
      public function set mIndentLevel (indentLevel:int):void
      {
         if (_mIndentLevel != indentLevel)
         {
            mIndentChanged = true;
            _mIndentLevel = indentLevel;
         }
      }
      
      public function get mIndentLevel ():int
      {
         return _mIndentLevel;
      }
   }
}
