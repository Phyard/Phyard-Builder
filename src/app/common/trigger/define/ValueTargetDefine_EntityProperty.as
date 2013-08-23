package common.trigger.define
{
   import common.trigger.ValueTargetTypeDefine;
   
   public class ValueTargetDefine_EntityProperty extends ValueTargetDefine
   {
      public var mEntityValueSourceDefine:ValueSourceDefine;
      
      //public var mSpacePackageId:int;
      //         // before v2.03, it is always 0. In file, it is saved as a short.
      //         // from v2.03, it is viewed as ValueTargetDefine_Variable.mSpaceType.
      //         // in fact, only one byte is used, another byte is reserved.
      //         // value 0 <=> ValueSpace_EntityProperties
      //public var mPropertyId:int;
      //         // it is viewed as ValueTargetDefine_Variable.mVariableIndex
      
      public var mPropertyValueTargetDefine:ValueTargetDefine_Variable; 
                 // since v2.05, may be Variable or Object Property
      
      //public function ValueTargetDefine_EntityProperty (entityValueSourceDefine:ValueSourceDefine, spaceId:int, propertyId:int)
      public function ValueTargetDefine_EntityProperty (entityValueSourceDefine:ValueSourceDefine, propertyValueTargetDefine:ValueTargetDefine_Variable)
      {
         super (ValueTargetTypeDefine.ValueTarget_EntityProperty);
         
         mEntityValueSourceDefine = entityValueSourceDefine;
         //mSpacePackageId = spaceId;
         //mPropertyId = propertyId;
         mPropertyValueTargetDefine = propertyValueTargetDefine;
      }
      
      override public function Clone ():ValueTargetDefine
      {
         //return new ValueTargetDefine_EntityProperty (mEntityValueSourceDefine.Clone (), mSpacePackageId, mPropertyId);
         return new ValueTargetDefine_EntityProperty (mEntityValueSourceDefine.Clone (), mPropertyValueTargetDefine.Clone () as ValueTargetDefine_Variable);
      }
   }
   
}