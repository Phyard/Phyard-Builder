package common.trigger.define
{
   public class VariableInstanceDefine
   {
      public var mKey:String = null; // from v2.03
      
      public var mName:String;
      
      // for output prams, only the mValueType in ValueSourceDefine_Direct is valid
      public var mDirectValueSourceDefine:ValueSourceDefine_Direct;
   }
   
}