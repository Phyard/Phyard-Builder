
package common.trigger {
   
   import flash.utils.ByteArray;
   
   import common.ValueAdjuster;
   
   public class ValueSourceTypeDefine
   {
      public static const ValueSource_Null:int = 0x0;
      public static const ValueSource_Direct:int = 0x1;
      public static const ValueSource_Variable:int = 0x2;
      //public static const ValueSource_Property:int = 0x3;
      
      
      
      //public static const PropertyOwner_Void:int = 0x0;
      //public static const PropertyOwner_Global:int = 0x1;
      //public static const PropertyOwner_World:int = 0x2;
      //public static const PropertyOwner_Entity:int = 0x3;
      
//=========================================================
// used in files, 
//=========================================================
      
      //public static const ValueSourceId_Null:int                           = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_Void;
      //
      //public static const ValueSourceId_DirectAny:int                      = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_Void;
      //
      //public static const ValueSourceId_DirectBoolean:int                  = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_Boolean;
      //public static const ValueSourceId_DirectNumber:int                   = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_String;
      //public static const ValueSourceId_DirectString:int                   = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_Number;
      //public static const ValueSourceId_DirectEntity:int                   = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_Entity;
      //public static const ValueSourceId_DirectCollisionCategory:int        = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_CollisionCategory;
      //
      //public static const ValueSourceId_VariableGlobal:int                 = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Global        << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_VariableInput:int                  = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Input         << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_VariableLocal:int                  = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_Local         << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_VariableRegister:int               = (ValueSourceTypeDefine.PropertyOwner_Void   << 24) | (ValueSpaceTypeDefine.ValueSpace_GlobalRegister      << 16) | ValueTypeDefine.ValueType_Void;
      //
      //public static const ValueSourceId_PropertyGlobal:int                 = (ValueSourceTypeDefine.PropertyOwner_Global << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_PropertyWorld:int                  = (ValueSourceTypeDefine.PropertyOwner_World  << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_PropertyEntityDirect:int           = (ValueSourceTypeDefine.PropertyOwner_Entity << 24) | (ValueSpaceTypeDefine.ValueSpace_Void          << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_PropertyEntityVarialbeGlobal:int   = (ValueSourceTypeDefine.PropertyOwner_Entity << 24) | (ValueSpaceTypeDefine.ValueSpace_Global        << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_PropertyEntityVarialbeInput:int    = (ValueSourceTypeDefine.PropertyOwner_Entity << 24) | (ValueSpaceTypeDefine.ValueSpace_Input         << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_PropertyEntityVarialbeLocal:int    = (ValueSourceTypeDefine.PropertyOwner_Entity << 24) | (ValueSpaceTypeDefine.ValueSpace_Local         << 16) | ValueTypeDefine.ValueType_Void;
      //public static const ValueSourceId_PropertyEntityVarialbeRegister:int = (ValueSourceTypeDefine.PropertyOwner_Entity << 24) | (ValueSpaceTypeDefine.ValueSpace_GlobalRegister      << 16) | ValueTypeDefine.ValueType_Void;
   }
}
