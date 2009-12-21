package common.trigger.define
{
   import common.trigger.ValueTargetTypeDefine;
   import common.trigger.ValueSpaceTypeDefine;
   import common.trigger.ValueTypeDefine;
   
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