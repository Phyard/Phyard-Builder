package common.trigger.define
{
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTargetDefine_Property extends ValueTargetDefine
   {
      public var mEntityValueSourceDefine:ValueSourceDefine;
      public var mSpacePackageId:int;
      public var mPropertyId:int;
      
      public function ValueTargetDefine_Property (entityValueSourceDefine:ValueSourceDefine, spaceId:int, propertyId:int)
      {
         super (ValueTargetTypeDefine.ValueTarget_Property);
         
         mEntityValueSourceDefine = entityValueSourceDefine;
         mSpacePackageId = spaceId;
         mPropertyId = propertyId;
      }
      
      override public function Clone ():ValueTargetDefine
      {
         return new ValueTargetDefine_Property (mEntityValueSourceDefine.Clone (), mSpacePackageId, mPropertyId);
      }
   }
   
}