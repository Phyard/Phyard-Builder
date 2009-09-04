package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.Define;
   
   public class ConditionListDefinition extends CodeSnippet
   {
      protected var mIsAnd:Boolean = true;
      protected var mIsNot:Boolean = false;
      
      protected var mIsConditionCallings:Array = new Array ();
      protected var mIsConditionResultInverteds:Array = new Array ();
      
      public function ConditionListDefinition (ownerFunctionDefinition:FunctionDefinition = null)
      {
         super (ownerFunctionDefinition);
      }
      
      public function SetAsAnd (isAnd:Boolean):void
      {
         mIsAnd = isAnd;
      }
      
      public function SetAsNot (isNot:Boolean):void
      {
         mIsNot = isNot;
      }
      
      public function IsAnd ():Boolean
      {
         return mIsAnd;
      }
      
      public function IsNot ():Boolean
      {
         return mIsNot;
      }
      
      override public function ClearFunctionCallings ():void
      {
         super.ClearFunctionCallings ();
         
         ValidateArrayLenthes ();
      }
      
      public function AssignFunctionCallingProperties (isConditionCallings:Array, resultInverteds:Array):void
      {
         if (isConditionCallings == null)
            isConditionCallings = new Array ();
         if (resultInverteds == null)
            resultInverteds = new Array ();
         
         mIsConditionCallings = isConditionCallings;
         mIsConditionResultInverteds = resultInverteds;
         
         ValidateArrayLenthes ();
      }
      
      public function IsConditionCalling (index:int):Boolean
      {
         if (index < 0 || index >= mIsConditionCallings.length)
            return false;
         
         return mIsConditionCallings [index];
      }
      
      public function IsConditionResultInverted (index:int):Boolean
      {
         if (index < 0 || index >= mIsConditionResultInverteds.length)
            return false;
         
         return mIsConditionResultInverteds [index];
      }
      
      override public function ValidateValueSources ():void
      {
         ValidateArrayLenthes ();
         
         super.ValidateValueSources ();
      }
      
      private function ValidateArrayLenthes ():void
      {
         var old_len:int;
         var i:int;
         
         old_len = mIsConditionCallings.length;
         
         if (old_len != mFunctionCallings.length)
         {
            mIsConditionCallings.length = mFunctionCallings.length;
         
            if (mIsConditionCallings.length > old_len)
            {
               for (i = old_len; i < mIsConditionCallings.length; ++ i)
                  mIsConditionCallings [i] = false;
            }
         }
         
         old_len = mIsConditionResultInverteds.length;
         
         if (old_len != mFunctionCallings.length)
         {
            mIsConditionResultInverteds.length = mFunctionCallings.length;
         
            if (mIsConditionResultInverteds.length > old_len)
            {
               for (i = old_len; i < mIsConditionResultInverteds.length; ++ i)
                  mIsConditionResultInverteds [i] = false;
            }
         }
      }
   }
}

