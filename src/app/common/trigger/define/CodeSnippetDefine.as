package common.trigger.define
{
   import common.CoordinateSystem;
   
   public class CodeSnippetDefine
   {
      public var mName:String;
      
      public var mNumCallings:int;
      public var mFunctionCallingDefines:Array;
      
//====================================================================
//
//====================================================================
      
      public function Clone ():CodeSnippetDefine
      {
         var codeSnippetDefine:CodeSnippetDefine = new CodeSnippetDefine ();
         
         codeSnippetDefine.mName = mName;
         codeSnippetDefine.mNumCallings = mNumCallings;
         codeSnippetDefine.mFunctionCallingDefines = new Array (mNumCallings);
         
         for (var i:int = 0; i < mNumCallings; ++ i)
         {
            codeSnippetDefine.mFunctionCallingDefines [i] = (mFunctionCallingDefines [i] as FunctionCallingDefine).Clone ();
         }
         
         return codeSnippetDefine;
      }
      
//====================================================================
//
//====================================================================
      
      public function DisplayValues2PhysicsValues (coordinateSystem:CoordinateSystem):void
      {
         var callingDefine:FunctionCallingDefine;
         
         for (var i:int = 0; i < mNumCallings; ++ i)
         {
            (mFunctionCallingDefines [i] as FunctionCallingDefine).DisplayValues2PhysicsValues (coordinateSystem);
         }
      }
      
      public function PhysicsValues2DisplayValues (coordinateSystem:CoordinateSystem):void
      {
         var callingDefine:FunctionCallingDefine;
         
         for (var i:int = 0; i < mNumCallings; ++ i)
         {
            (mFunctionCallingDefines [i] as FunctionCallingDefine).PhysicsValues2DisplayValues (coordinateSystem);
         }
      }
      
   }
   
}