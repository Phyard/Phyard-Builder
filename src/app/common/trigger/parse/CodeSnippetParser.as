
package common.trigger.parse {
   
   import common.trigger.CoreFunctionIds;
   
   public class CodeSnippetParser
   {
      public static function ParseCodeSnippet (callingInfos:Array):int
      {
         var topBlock:FunctionCallingBlockInfo = new FunctionCallingBlockInfo ();
         topBlock.mIndentLevel = -1;
         topBlock.mIsValid = true;
         topBlock.mOwnerBranch = null;
         topBlock.mStartCallingLine = topBlock.mEndCallingLine = null;
         
         var topBranch:FunctionCallingBranchInfo = new FunctionCallingBranchInfo ();
         topBranch.mIndentLevel = -1;
         topBranch.mIsValid = true;
         topBranch.mOwnerBlock = topBlock;
         topBranch.mFirstCallingLine = topBranch.mLastCallingLine = null;
         topBranch.mOwnerBlockSupportBreak = null;
         
         topBlock.mFirstBranch = topBranch;
         topBlock.mLastBranch = topBranch;
         
         var currentBlock:FunctionCallingBlockInfo = topBlock;
         var currentBranch:FunctionCallingBranchInfo = topBranch;
         var currentCallingLineInfo:FunctionCallingLineInfo = null;
         
         //var block:FunctionCallingBlockInfo;
         //var branch:FunctionCallingBranchInfo;
         
         var callingLineOldValid:Boolean;
         var callingLineOldIndent:int;
         
         var numValidCallings:int = 0;
         
         var numCallings:int = callingInfos.length;
         for (var lineNumber:int = 0; lineNumber < numCallings; ++ lineNumber)
         {
            currentCallingLineInfo = callingInfos [lineNumber] as FunctionCallingLineInfo;
            
            callingLineOldValid = currentCallingLineInfo.mIsValid;
            callingLineOldIndent = currentCallingLineInfo.mIndentLevel;
            
            currentCallingLineInfo.mLineNumber = lineNumber;
            
            switch (currentCallingLineInfo.mFunctionId)
            {
               case CoreFunctionIds.ID_StartIf:
               case CoreFunctionIds.ID_StartWhile:
                  if (currentBranch == null) // for example: between switch and the first case
                  {
                     currentCallingLineInfo.mIsValid = false;
                     currentCallingLineInfo.mIndentLevel = currentBlock.mIndentLevel + 1;
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = null;
                  }
                  else
                  {
                     currentBlock = new FunctionCallingBlockInfo ();
                     currentBlock.mIndentLevel = currentBranch.mIndentLevel + 1;
                     currentBlock.mIsValid = currentBranch.mIsValid && (currentBranch.mNumDirectReturnCallings == 0)
                                             && ((currentBranch.mOwnerBlockSupportBreak == null) || (currentBranch.mNumDirectBreakCallings == 0));
                     currentBlock.mOwnerBlock = currentBranch.mOwnerBlock;
                     currentBlock.mOwnerBranch = currentBranch;
                     currentBlock.mStartCallingLine = currentCallingLineInfo;
                     if (currentCallingLineInfo.mFunctionId == CoreFunctionIds.ID_StartIf)
                     {
                        currentBlock.mOwnerBlockSupportBreak = currentBranch.mOwnerBlockSupportBreak;
                     }
                     else if (currentCallingLineInfo.mFunctionId == CoreFunctionIds.ID_StartWhile)
                     {
                        currentBlock.mOwnerBlockSupportBreak = currentBlock;
                     }
                     
                     currentBranch = new FunctionCallingBranchInfo ();
                     currentBranch.mIndentLevel = currentBlock.mIndentLevel;
                     currentBranch.mIsValid = currentBlock.mIsValid;
                     currentBranch.mOwnerBlock = currentBlock;
                     currentBranch.mFirstCallingLine = currentCallingLineInfo;
                     currentBranch.mOwnerBlockSupportBreak = currentBlock.mOwnerBlockSupportBreak;
                     
                     currentBlock.mFirstBranch = currentBranch;
                     currentBlock.mLastBranch = currentBranch;
                     
                     currentCallingLineInfo.mIsValid = currentBranch.mIsValid;
                     currentCallingLineInfo.mIndentLevel = currentBranch.mIndentLevel;
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = currentBranch;
                     
                     currentBranch.mLastCallingLine = currentCallingLineInfo;
                  }
                  break;
               case CoreFunctionIds.ID_Else:
                  if (currentBranch == null) // for example: between switch and the first case
                  {
                     currentCallingLineInfo.mIsValid = false;
                     currentCallingLineInfo.mIndentLevel = currentBlock.mIndentLevel + 1;
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = null;
                  }
                  else if (currentBlock.GetFirstCallingFunctionId () != CoreFunctionIds.ID_StartIf)
                  {
                     currentCallingLineInfo.mIsValid = false;
                     currentCallingLineInfo.mIndentLevel = currentBranch.mIndentLevel + 1;
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = currentBranch;
                  }
                  else
                  {
                     currentBranch = new FunctionCallingBranchInfo ();
                     currentBranch.mIndentLevel = currentBlock.mIndentLevel;
                     currentBranch.mIsValid = currentBlock.mIsValid && (currentBlock.mNumElseBranches == 0);
                     currentBranch.mOwnerBlock = currentBlock;
                     currentBranch.mFirstCallingLine = currentCallingLineInfo;
                     currentBranch.mOwnerBlockSupportBreak = currentBlock.mOwnerBlockSupportBreak;
                     
                     currentCallingLineInfo.mIsValid = currentBranch.mIsValid;
                     currentCallingLineInfo.mIndentLevel = currentBranch.mIndentLevel;
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = currentBranch;
                     
                     currentBlock.mLastBranch.mNextBranch = currentBranch;
                     currentBlock.mLastBranch = currentBranch;
                     currentBlock.mNumElseBranches ++;
                     
                     currentBranch.mLastCallingLine = currentCallingLineInfo;
                  }
                  break;
               case CoreFunctionIds.ID_EndIf:
               case CoreFunctionIds.ID_EndWhile:
                  if (  currentCallingLineInfo.mFunctionId == CoreFunctionIds.ID_EndIf    && currentBlock.GetFirstCallingFunctionId () != CoreFunctionIds.ID_StartIf
                     || currentCallingLineInfo.mFunctionId == CoreFunctionIds.ID_EndWhile && currentBlock.GetFirstCallingFunctionId () != CoreFunctionIds.ID_StartWhile)
                  {
                     currentCallingLineInfo.mIsValid = false;
                     currentCallingLineInfo.mIndentLevel = (currentBranch != null ? currentBranch.mIndentLevel + 1 : currentBlock.mIndentLevel + 1);
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = currentBranch;
                     
                     if (currentBranch != null)
                        currentBranch.mLastCallingLine = currentCallingLineInfo;
                  }
                  else
                  {
                     currentCallingLineInfo.mIsValid = currentBlock.mIsValid;
                     currentCallingLineInfo.mIndentLevel = currentBlock.mIndentLevel;
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = null;
                     
                     currentBlock.mEndCallingLine = currentCallingLineInfo;
                     
                     currentBranch = currentBlock.mOwnerBranch;
                     currentBlock = currentBlock.mOwnerBlock;
                  }
                  break;
               default:
               {
                  if (currentBranch == null) // for example: between switch and the first case
                  {
                     currentCallingLineInfo.mIsValid = false;
                     currentCallingLineInfo.mIndentLevel = currentBlock.mIndentLevel + 1;
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = null;
                  }
                  else
                  {
                     currentCallingLineInfo.mIsValid = currentBranch.mIsValid && (currentBranch.mNumDirectReturnCallings == 0)
                                                   && ((currentBranch.mOwnerBlockSupportBreak == null) || (currentBranch.mNumDirectBreakCallings == 0));
                     currentCallingLineInfo.mIndentLevel = currentBranch.mIndentLevel + 1;
                     currentCallingLineInfo.mOwnerBlock = currentBlock;
                     currentCallingLineInfo.mOwnerBranch = currentBranch;
                     
                     currentBranch.mLastCallingLine = currentCallingLineInfo;
                     
                     switch (currentCallingLineInfo.mFunctionId)
                     {
                        case CoreFunctionIds.ID_Break:
                           currentBranch.mNumDirectBreakCallings ++;
                           
                           currentCallingLineInfo.mOwnerBlockSupportBreak = currentBranch.mOwnerBlockSupportBreak;
                           
                           // correct
                           currentCallingLineInfo.mIsValid = currentCallingLineInfo.mIsValid && (currentBranch.mOwnerBlockSupportBreak != null);
                           
                           break;
                        case CoreFunctionIds.ID_Return:
                           currentBranch.mNumDirectReturnCallings ++;
                           break;
                        case CoreFunctionIds.ID_Comment:
                        case CoreFunctionIds.ID_Blank:
                           currentCallingLineInfo.mIsValid = false;
                           break;
                        default:
                        {
                        }
                     }
                  }
               }
            }
            
            if (currentCallingLineInfo.mIsValid)
            {
               if (currentCallingLineInfo.mOwnerBranch != null)
               {
                  ++ currentCallingLineInfo.mOwnerBranch.mNumValidCallings;
               }
               
               ++ numValidCallings;
            }
         }
         
         while (true)
         {
            if (currentBranch != null && currentBranch != topBranch)
            {
               currentBranch.mLastCallingLine = null;
               currentBlock = currentBranch.mOwnerBlock;
               currentBranch = null;
            }
            else if (currentBlock != topBlock)
            {
               currentBlock.mEndCallingLine = null;
               currentBranch = currentBlock.mOwnerBranch;
               currentBlock = currentBlock.mOwnerBlock;
            }
            else
            {
               break;
            }
         }
         
         return numValidCallings;
      }
   }
}
