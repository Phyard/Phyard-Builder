package common.trigger.define
{
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTargetDefine_Null extends ValueTargetDefine
   {
      public function ValueTargetDefine_Null ()
      {
         super (ValueTargetTypeDefine.ValueTarget_Null);
      }
      
      override public function Clone ():ValueTargetDefine
      {
         return new ValueTargetDefine_Null ();
      }
   }
   
}