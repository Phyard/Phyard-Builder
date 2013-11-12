package common.trigger.define
{
   public class ValueSourceDefine
   {
      protected var mValueSourceType:int;
      
      public function ValueSourceDefine (sourceType:int)
      {
         mValueSourceType = sourceType;
      }
      
      public function GetValueSourceType ():int
      {
         return mValueSourceType;
      }
      
      protected function SetValueSourceType (sourceType:int):void
      {
         mValueSourceType = sourceType;
      }
      
      public function Clone ():ValueSourceDefine
      {
         return null; // to override
      }
   }
   
}