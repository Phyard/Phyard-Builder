package common.trigger.define
{
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTargetDefine_Property extends ValueTargetDefine
   {
      public var mEntityValueSourceDefine:ValueSourceDefine;
      public var mSpacePackageId:int;
               // before v2.03, it is always 0. In file, it is saved as a short.
               // from v2.03, it is viewed as ValueTargetDefine_Variable.mSpaceType.
               // in fact, only one byte is used, another byte is reserved.
               // value 0 <=> ValueSpace_EntityProperties
      public var mPropertyId:int;
               // it is viewed as ValueTargetDefine_Variable.mVariableIndex
      
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