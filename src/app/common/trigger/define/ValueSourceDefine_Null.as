package common.trigger.define
{
   import common.trigger.ValueSourceTypeDefine;
   
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