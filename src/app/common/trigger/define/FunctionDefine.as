package common.trigger.define
{
   public class FunctionDefine
   {
      public var mName:String; // for custom function only
      public var mPosX:int; // for custom function only
      public var mPosY:int; // for custom function only
      
      public var mInputVariableDefines:Array = new Array (); // For custom function only
      
      public var mOutputVariableDefines:Array = new Array (); // only the mValueType in ValueSourceDefine_Direct is valid. For custom function only
      public var mLocalVariableDefines:Array = new Array ();  // only the mValueType in ValueSourceDefine_Direct is valid
      
      public var mCodeSnippetDefine:CodeSnippetDefine = null;
   }
   
}