package common.trigger.define
{
   public class FunctionDefine
   {
      public var mKey:String  = null; // from v2.01
      public var mTimeModified:Number = 0; // from v2.01
      public var mToLoadNewData:Boolean = false; // from v2.01. A temp runtime value, not saved in file.
      
      public var mName:String; // for custom function only
      public var mPosX:int; // for custom function only
      public var mPosY:int; // for custom function only
      public var mDesignDependent:Boolean; // for custom function only
      
      public var mInputVariableDefines:Array = new Array (); // For custom function only
      
      public var mOutputVariableDefines:Array = new Array (); // only the mValueType in ValueSourceDefine_Direct is valid. For custom function only
      public var mLocalVariableDefines:Array = new Array ();  // only the mValueType in ValueSourceDefine_Direct is valid
      
      public var mCodeSnippetDefine:CodeSnippetDefine = null;
   }
   
}