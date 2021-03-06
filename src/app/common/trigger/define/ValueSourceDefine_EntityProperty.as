package common.trigger.define
{
   import common.trigger.ValueSourceTypeDefine;
   
   public class ValueSourceDefine_EntityProperty extends ValueSourceDefine
   {
      public var mEntityValueSourceDefine:ValueSourceDefine;
      
      //public var mSpacePackageId:int; // is always 0 now.
      //         // before v2.03, it is always 0. In file, it is saved as a short.
      //         // from v2.03, it is viewed as ValueSourceDefine_Variable.mSpaceType.
      //         // in fact, only one byte is used, another byte is reserved.
      //         // value 0 <=> ValueSpace_EntityProperties
      //public var mPropertyId:int;
      //         // it is viewed as ValueSourcetDefine_Variable.mVariableIndex
      
      public var mPropertyValueSourceDefine:ValueSourceDefine_Variable; 
                 // since v2.05, may be Variable or Object Property
      
      //public function ValueSourceDefine_EntityProperty (entityValueSourceDefine:ValueSourceDefine, spaceId:int, propertyId:int)
      public function ValueSourceDefine_EntityProperty (entityValueSourceDefine:ValueSourceDefine, propertyValueSourceDefine:ValueSourceDefine_Variable)
      {
         super (ValueSourceTypeDefine.ValueSource_EntityProperty);
         
         mEntityValueSourceDefine = entityValueSourceDefine;
         //mSpacePackageId = spaceId;
         //mPropertyId = propertyId;
         mPropertyValueSourceDefine = propertyValueSourceDefine;
      }
      
      override public function Clone ():ValueSourceDefine
      {
         //return new ValueSourceDefine_EntityProperty (mEntityValueSourceDefine.Clone (), mSpacePackageId, mPropertyId);
         return new ValueSourceDefine_EntityProperty (mEntityValueSourceDefine.Clone (), mPropertyValueSourceDefine.Clone () as ValueSourceDefine_Variable);
      }
   }
   
}