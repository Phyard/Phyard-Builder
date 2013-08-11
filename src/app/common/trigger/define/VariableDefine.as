package common.trigger.define
{
   public class VariableDefine
   {
      public var mKey:String = null; // from v2.03, for game save only
                                     // from v2.04, use (sceneId << 16) | sessionVarialbeId as the key of a session variable
      
      public var mName:String;
      
      // for output prams, only the mValueType in ValueSourceDefine_Direct is valid
      //public var mDirectValueSourceDefine:ValueSourceDefine_Direct;
               // use the belows now
      public var mClassType:int; // since v2.05
      public var mValueType:int;
      public var mValueObject:Object;
      
   }
   
}