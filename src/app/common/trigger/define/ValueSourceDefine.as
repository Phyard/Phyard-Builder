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
      
      public function Clone ():ValueSourceDefine
      {
         return null; // to override
      }
   }
   
}