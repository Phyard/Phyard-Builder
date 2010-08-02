package common.trigger.define
{
   public class ValueTargetDefine
   {
      protected var mValueTargetType:int;
      
      public function ValueTargetDefine (targetType:int)
      {
         mValueTargetType = targetType;
      }
      
      public function GetValueTargetType ():int
      {
         return mValueTargetType;
      }
      
      public function Clone ():ValueTargetDefine
      {
         return null; // to override
      }
   }
   
}