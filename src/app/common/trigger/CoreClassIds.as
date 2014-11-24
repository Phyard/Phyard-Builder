package common.trigger {
   
   import common.Define;
   
   public class CoreClassIds
   {

      
      //public static function GetTypeName (valueType:int):String
      //{
      //   switch (valueType)
      //   {
      //      case ValueType_Boolean:
      //         return "Boolean";
      //      case ValueType_Number:
      //         return "Number";
      //      case ValueType_String:
      //         return "String";
      //      case ValueType_CollisionCategory:
      //         return "CCat";
      //      case ValueType_Entity:
      //         return "Entity";
      //      case ValueType_Module:
      //         return "Module";
      //      case ValueType_Sound:
      //         return "Sound";
      //      case ValueType_Scene:
      //         return "Scene";
      //      case ValueType_Array:
      //         return "Array";
      //      case ValueType_Void:
      //      default:
      //         return "Void";
      //   }
      //}
      
      // return a Boolean or Number or String
      //public static function GetDefaultDirectDefineValue (valueType:int):Object
      //{
      //   switch (valueType)
      //   {
      //      case ValueType_Boolean:
      //         return false;
      //      case ValueType_Number:
      //         return 0;
      //      case ValueType_String:
      //         return "";
      //      case ValueType_CollisionCategory:
      //         return -1;
      //      case ValueType_Entity:
      //         return Define.EntityId_None;
      //      case ValueType_Module:
      //         return -1;
      //      case ValueType_Sound:
      //         return -1;
      //      case ValueType_Scene:
      //         return -1;
      //      case ValueType_Array:
      //         return null;
      //      case ValueType_Void:
      //      default:
      //         return undefined;
      //   }
      //}
      
      //public static function IsLevelRelatedDirectValue (valueType:int):Boolean
      //{
      //   return valueType == ValueType_Entity 
      //       || valueType == ValueType_CollisionCategory
      //       || valueType == ValueType_Module
      //       || valueType == ValueType_Sound
      //       || valueType == ValueType_Scene
      //       ;
      //}
      
//=============================================================================
// basic types 
//=============================================================================
      
      // best to keep the max valye type id < 256.
      // 
      
      public static const ValueType_Void:int = 0;
      
      public static const ValueType_Boolean:int = 1;
      public static const ValueType_String:int  = 2;
      public static const ValueType_Number:int  = 3;
      
      public static const ValueType_Class:int = 20; // or "type" type, type is a type
      public static const ValueType_Object:int = 21;

      public static const ValueType_Array:int = 30;
      //public static const ValueType_Function:int = 31;
      
      public static const ValueType_ByteArray:int = 50; // sicne v2.06
      public static const ValueType_ByteArrayStream:int = 55; // sicne v2.06
      
      public static const ValueType_Entity:int            = 60;
      public static const ValueType_CollisionCategory:int = 61;
      
      public static const ValueType_Module:int            = 70;

      public static const ValueType_Sound:int            = 90; 
      
      //public static const ValueType_Bitmap:int            = 92;
      
      public static const ValueType_MultiplePlayerInstance:int     = 95;
      public static const ValueType_MultiplePlayerInstanceDefine:int     = 96;
      public static const ValueType_MultiplePlayerInstanceChannelDefine:int     = 97;
      
      public static const ValueType_Scene:int            = 100;
      
      public static const ValueType_Advertisement:int            = 110;
      
      public static const NumCoreClasses:int            = 128;
      
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
// number value type hints, generally, the hints are only useful for saving input parameters
//=============================================================================
      
      // for direct numbers, default number is a double float (64 bits float), default is general number
      
      // most 16 details (DON'T change this values)
      
      public static const NumberTypeDetail_DoubleNumber  :int = 0;
      public static const NumberTypeDetail_Int8Number    :int = 1;
      public static const NumberTypeDetail_Int16Number   :int = 2;
      public static const NumberTypeDetail_FloatNumber   :int = 3;
      public static const NumberTypeDetail_Int32Number   :int = 4;
      
      public static const NumberTypeDetailBit_Double :int = NumberTypeDetail_DoubleNumber << 16; // 64 bits float, default, don't change its value.
      public static const NumberTypeDetailBit_Single :int = NumberTypeDetail_FloatNumber  << 16; // 32 bits float
      public static const NumberTypeDetailBit_Integer:int = NumberTypeDetail_Int32Number  << 16; // 32 bits int
      
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
      
      // the 2 are not used now. Maybe they are will be used later.
      //public static const NumberTypeUsage_DeltaRotationRadians                     :int = 32 << 20;
      //public static const NumberTypeUsage_DeltaRotationDegrees                     :int = 33 << 20;

      //
      
//=============================================================================
// array type hints, generally, the hints are only useful for saving input parameters
//=============================================================================

      public static const ArrayTypeUsage_General                         :int = 0 << 20;
      public static const ArrayTypeUsage_Position                        :int = 1 << 20; // x0,y0,x1,y1,...

   }
}
