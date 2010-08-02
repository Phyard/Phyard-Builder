package common.trigger.define
{
   import common.trigger.ValueSourceTypeDefine;
   
   public class ValueSourceDefine_Property extends ValueSourceDefine
   {
      public var mEntityValueSourceDefine:ValueSourceDefine;
      public var mSpacePackageId:int;
      public var mPropertyId:int;
      
      public function ValueSourceDefine_Property (entityValueSourceDefine:ValueSourceDefine, spaceId:int, propertyId:int)
      {
         super (ValueSourceTypeDefine.ValueSource_Property);
         
         mEntityValueSourceDefine = entityValueSourceDefine;
         mSpacePackageId = spaceId;
         mPropertyId = propertyId;
      }
      
      override public function Clone ():ValueSourceDefine
      {
         return new ValueSourceDefine_Property (mEntityValueSourceDefine.Clone (), mSpacePackageId, mPropertyId);
      }
   }
   
}