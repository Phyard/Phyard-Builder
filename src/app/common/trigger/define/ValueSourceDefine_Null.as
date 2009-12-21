package common.trigger.define
{
   import flash.utils.ByteArray;
   
   import common.trigger.ValueSourceTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
   public class ValueSourceDefine_Null extends ValueSourceDefine
   {
      public function ValueSourceDefine_Null ()
      {
         super (ValueSourceTypeDefine.ValueSource_Null);
      }
      
      override public function Clone ():ValueSourceDefine
      {
         return new ValueSourceDefine_Null ();
      }
   }
   
}