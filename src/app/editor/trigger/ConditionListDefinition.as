package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.Define;
   
   public class ConditionListDefinition extends FunctionDefinition
   {
      protected var mIsAnd:Boolean = true;
      protected var mIsNot:Boolean = false;
      
      protected var mFunctionCallings:Array = new Array ();
      protected var mConditionInverteds:Array = new Array ();
      
      public function ConditionListDefinition (functionDeclatation:FunctionDeclaration = null)
      {
         super (functionDeclatation);
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
      
      public function ClearConditions ():void
      {
         mFunctionCallings.splice (0, mFunctionCallings.length);
         
         mConditionInverteds.splice (0, mConditionInverteds.length);
      }
      
      public function SetConditions (funcCallings:Array, conditionInverteds:Array):void
      {
         mFunctionCallings = funcCallings;
         
         mConditionInverteds = conditionInverteds;
         
         ValidateArrayLenthes ();
      }
      
      public function AddCondition (funcCalling:FunctionCalling, contitionInverted:Boolean):void
      {
         ValidateArrayLenthes ();
         
         mFunctionCallings.push (funcCalling);
         
         mConditionInverteds.push (contitionInverted);
      }
      
      public function GetNumConditions ():int
      {
         ValidateArrayLenthes ();
         
         return mFunctionCallings.length;
      }
      
      public function GetConditionAt (index:int):FunctionCalling
      {
         if (index < 0 || index >= mFunctionCallings.length)
            return null;
         
         return mFunctionCallings [index];
      }
      
      public function IsConditionInverted (index:int):Boolean
      {
         if (index < 0 || index >= mConditionInverteds.length)
            return false;
         
         return mConditionInverteds [index];
      }
      
      override public function ValidateValueSources ():void
      {
         ValidateArrayLenthes ();
         
         var func_calling:FunctionCalling;
         for (var i:int = 0; i < mFunctionCallings.length; ++ i)
         {
            func_calling = mFunctionCallings [i] as FunctionCalling;
            if (func_calling != null)
               func_calling.ValidateValueSources ();
         }
      }
      
      private function ValidateArrayLenthes ():void
      {
         var old_len:int = mConditionInverteds.length;
         
         if (old_len != mFunctionCallings.length)
         {
            mConditionInverteds.length = mFunctionCallings.length;
         
            if (mConditionInverteds.length > old_len)
            {
               for (var i:int = old_len; i < mConditionInverteds.length; ++ i)
                  mConditionInverteds [i] = false;
            }
         }
      }
   }
}

