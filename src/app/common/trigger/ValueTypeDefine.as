package common.trigger {
   
   import common.Define;
   
   public class ValueTypeDefine
   {
      public static function GetTypeName (valueType:int):String
      {
         switch (valueType)
         {
            case ValueType_Boolean:
               return "Boolean";
            case ValueType_Number:
               return "Number";
            case ValueType_String:
               return "String";
            case ValueType_CollisionCategory:
               return "CCat";
            case ValueType_Entity:
               return "Entity";
            case ValueType_Void:
            default:
               return "Void";
         }
      }
      
      // return a Boolean or Number or String
      public static function GetDefaultDirectDefineValue (valueType:int):Object
      {
         switch (valueType)
         {
            case ValueType_Boolean:
               return false;
            case ValueType_Number:
               return 0;
            case ValueType_String:
               return "";
            case ValueType_CollisionCategory:
               return -1;
            case ValueType_Entity:
               return Define.EntityId_None;
            case ValueType_Void:
            default:
               return undefined;
         }
      }
      
      public static function IsLevelRelatedDirectValue (valueType:int):Boolean
      {
         return valueType == ValueType_Entity || valueType == ValueType_CollisionCategory;
      }
      
//=============================================================================
// 
//=============================================================================
      
      public static const NumberTypeMask_Basic:uint = 0xFFFF;
      
      public static const NumberTypeMask_Detail:uint = 0x000F0000;
      
      public static const NumberTypeMask_Usage:uint = 0x0FF00000;
      
      public static const NumberTypeMask_Modifier:uint = 0xF0000000;
         public static const NumberTypeMask_Static:uint = 0x10000000;
         public static const NumberTypeMask_Final:uint = 0x20000000;
         public static const NumberTypeMask_Public:uint = 0x40000000;
         public static const NumberTypeMask_Private:uint = 0x80000000;
         public static const NumberTypeMask_Protected:uint = 0xC0000000;
      
//=============================================================================
// basic types 
//=============================================================================
      
      // best to keep the max valye type id < 256.
      // 
      
      public static const ValueType_Void:int = 0;
      
      public static const ValueType_Boolean:int = 1;
      public static const ValueType_String:int  = 2;
      public static const ValueType_Number:int  = 3;
      
      public static const ValueType_Array:int = 30;
      public static const ValueType_Function:int = 31;
      
      public static const ValueType_Entity:int            = 60;
      public static const ValueType_CollisionCategory:int = 61;
      
//=============================================================================
// value type hints, generally, the hints are only useful for saving input parameters
//=============================================================================
      
      // for direct numbers, default number is a double float (64 bits float), default is general number
      
      // most 16 details
      
      public static const NumberTypeDetail_Double :int = 0 << 16; // 64 bits float, default
      public static const NumberTypeDetail_Single :int = 1 << 16; // 32 bits float
      public static const NumberTypeDetail_Integer:int = 2 << 16; // 32 bits int
      
      // most 256 usages, assume offset_rotation must be zero
      
      public static const NumberTypeUsage_General                          :int = 0 << 20;
      public static const NumberTypeUsage_PositionX                        :int = 1 << 20;
      public static const NumberTypeUsage_PositionY                        :int = 2 << 20;
      public static const NumberTypeUsage_RotationRadians                  :int = 3 << 20;
      public static const NumberTypeUsage_RotationDegrees                  :int = 4 << 20;
      public static const NumberTypeUsage_Length                           :int = 5 << 20;
      public static const NumberTypeUsage_Area                             :int = 6 << 20;
      public static const NumberTypeUsage_LinearVelocityX                  :int = 7 << 20;
      public static const NumberTypeUsage_LinearVelocityY                  :int = 8 << 20;
      public static const NumberTypeUsage_LinearVelocityMagnitude          :int = 9 << 20;
      public static const NumberTypeUsage_AngularVelocity                  :int = 10 << 20;
      public static const NumberTypeUsage_LinearAccelerationX              :int = 11 << 20;
      public static const NumberTypeUsage_LinearAccelerationY              :int = 12 << 20;
      public static const NumberTypeUsage_LinearAccelerationMagnitude      :int = 13 << 20;
      public static const NumberTypeUsage_AngularAcceleration              :int = 14 << 20;
      public static const NumberTypeUsage_Mass                             :int = 15 << 20;
      public static const NumberTypeUsage_Inertia                          :int = 16 << 20;
      public static const NumberTypeUsage_ForceX                           :int = 17 << 20;
      public static const NumberTypeUsage_ForceY                           :int = 18 << 20;
      public static const NumberTypeUsage_ForceMagnitude                   :int = 19 << 20;
      public static const NumberTypeUsage_Torque                           :int = 20 << 20;
      public static const NumberTypeUsage_MomentumX                        :int = 21 << 20;
      public static const NumberTypeUsage_MomentumY                        :int = 22 << 20;
      public static const NumberTypeUsage_MomentumMagnitude                :int = 23 << 20;
      public static const NumberTypeUsage_AngularMomentum                  :int = 24 << 20;
      public static const NumberTypeUsage_ImpulseX                         :int = 25 << 20;
      public static const NumberTypeUsage_ImpulseY                         :int = 26 << 20;
      public static const NumberTypeUsage_ImpulseMagnitude                 :int = 27 << 20;
      public static const NumberTypeUsage_AngularImpulse                   :int = 38 << 20;
      
      public static const NumberTypeUsage_LinearDeltaX                     :int = 29 << 20;
      public static const NumberTypeUsage_LinearDeltaY                     :int = 30 << 20;
      public static const NumberTypeUsage_LinearDyDx                       :int = 31 << 20;
      
      //
   }
}
