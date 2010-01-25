package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.Define;
   import common.CoordinateSystem;
   
   public class CodeSnippet
   {
      protected var mOwnerFunctionDefinition:FunctionDefinition = null;
      
      protected var mName:String = "";
      
      protected var mFunctionCallings:Array = new Array ();
      
      public function CodeSnippet (ownerFunctionDefinition:FunctionDefinition = null)
      {
         mOwnerFunctionDefinition = ownerFunctionDefinition;
      }
      
      public function GetOwnerFunctionDefinition ():FunctionDefinition
      {
         return mOwnerFunctionDefinition;
      }
      
      public function SetName (newName:String):void
      {
         if (newName == null)
            newName = "";
         
         if (newName.length > Define.MaxLogicComponentNameLength)
            newName = newName.substr (0, Define.MaxLogicComponentNameLength);
         
         mName = newName;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function ClearFunctionCallings ():void
      {
         mFunctionCallings.splice (0, mFunctionCallings.length);
      }
      
      public function AssignFunctionCallings (funcCallings:Array):void
      {
         if (funcCallings == null)
            funcCallings = new Array ();
         
         mFunctionCallings = funcCallings;
      }
      
      public function AddFunctionCalling (funcCalling:FunctionCalling):void
      {
         mFunctionCallings.push (funcCalling);
      }
      
      public function GetNumFunctionCallings ():int
      {
         return mFunctionCallings.length;
      }
      
      public function GetFunctionCallingAt (index:int):FunctionCalling
      {
         if (index < 0 || index >= mFunctionCallings.length)
            return null;
         
         return mFunctionCallings [index];
      }
      
      public function ValidateValueSources ():void
      {
         var func_calling:FunctionCalling;
         for (var i:int = 0; i < mFunctionCallings.length; ++ i)
         {
            func_calling = mFunctionCallings [i] as FunctionCalling;
            if (func_calling != null)
               func_calling.ValidateValueSources ();
         }
      }
      
//====================================================================
//
//====================================================================
      
      public function CopyCallingsFrom (codeSnippet:CodeSnippet, insertAt:int = 0, callingIds:Array = null):void
      {
         if (codeSnippet == null)
            return;
         
         var i:int;
         var count:int = codeSnippet.GetNumFunctionCallings ();
         
         if (callingIds == null)
         {
            callingIds = new Array (count);
            
            for (i = 0; i < count; ++ i)
               callingIds [i] = i;
         }
         
         var num:int = callingIds.length;
         
         var callingId:int;
         var clonedCallings:Array = new Array (callingIds.length);
         var clonedCount:int = 0;
         
         for (i = 0; i < num; ++ i)
         {
            callingId = callingIds [i];
            if (callingId >= 0 && callingId < count)
            {
               clonedCallings [clonedCount ++] = codeSnippet.GetFunctionCallingAt (callingId).Clone (mOwnerFunctionDefinition);
            }
         }
         
         if (insertAt < 0)
            insertAt = 0;
         else if (insertAt > mFunctionCallings.length)
            insertAt = mFunctionCallings.length;
         
         for (i = 0; i < clonedCount; ++ i)
            mFunctionCallings.splice (insertAt ++, 0, clonedCallings [i]);
      }
      
//====================================================================
//
//====================================================================
      
      public function Clone (ownerFunctionDefinition:FunctionDefinition):CodeSnippet
      {
         if (ownerFunctionDefinition == null)
            ownerFunctionDefinition = mOwnerFunctionDefinition;
         
         var codeSnippet:CodeSnippet = new CodeSnippet (ownerFunctionDefinition);
         
         codeSnippet.SetName (mName);
         
         var i:int;
         var num:int = mFunctionCallings.length;
         var callingsArray:Array = new Array (num);
         for (i = 0; i < num; ++ i)
         {
            callingsArray [i] = (mFunctionCallings [i] as FunctionCalling).Clone (ownerFunctionDefinition);
         }
         codeSnippet.AssignFunctionCallings (callingsArray);
         
         return codeSnippet;
      }
      
      public function DisplayValues2PhysicsValues (coordinateSystem:CoordinateSystem):void
      {
         var i:int;
         var num:int = mFunctionCallings.length;
         for (i = 0; i < num; ++ i)
         {
           (mFunctionCallings [i] as FunctionCalling).DisplayValues2PhysicsValues (coordinateSystem);
         }
      }
      
      public function PhysicsValues2DisplayValues (coordinateSystem:CoordinateSystem):void
      {
         var i:int;
         var num:int = mFunctionCallings.length;
         for (i = 0; i < num; ++ i)
         {
           (mFunctionCallings [i] as FunctionCalling).PhysicsValues2DisplayValues (coordinateSystem);
         }
      }
      
      public function AdjustNumberPrecisions ():void
      {
         var i:int;
         var num:int = mFunctionCallings.length;
         for (i = 0; i < num; ++ i)
         {
           (mFunctionCallings [i] as FunctionCalling).AdjustNumberPrecisions ();
         }
      }
   }
}

