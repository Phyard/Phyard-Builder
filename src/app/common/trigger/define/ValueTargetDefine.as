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
      
      protected function SetValueTargetType (targetType:int):void
      {
         mValueTargetType = targetType;
      }
      
      public function Clone ():ValueTargetDefine
      {
         return null; // to override
      }
   }
   
}