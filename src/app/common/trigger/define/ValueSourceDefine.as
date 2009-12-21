package common.trigger.define
{
   import flash.utils.ByteArray;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
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