

package common.trigger {
   
   public class ValueTypeDefine
   {
      public static const NumberTypeMask_Basic:int = 0xFFFF;
      
      public static const NumberTypeMask_Detail:int = 0x000F0000;
      
      public static const NumberTypeMask_Usage:int = 0x07F00000;
      
//=============================================================================
// basic types
//=============================================================================
      
      // best to keep the max valye type id < 256.
      // 
      
      public static const ValueType_Void:int = 0;
      
      public static const ValueType_Boolean:int = 1;
      public static const ValueType_String:int  = 2;
      public static const ValueType_Number:int  = 3;
      
      public static const ValyeType_Array:int = 30;
      public static const ValyeType_Function:int = 31;
      
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
      
      // most 64 usages
      
      public static const NumberTypeUsage_General                          :int = 0 << 20;
      public static const NumberTypeUsage_PositionX                        :int = 1 << 20;
      public static const NumberTypeUsage_PositionY                        :int = 2 << 20;
      public static const NumberTypeUsage_Rotation                         :int = 3 << 20;
      public static const NumberTypeUsage_Length                           :int = 4 << 20;
      public static const NumberTypeUsage_Area                             :int = 5 << 20;
      public static const NumberTypeUsage_LinearVelocityX                  :int = 6 << 20;
      public static const NumberTypeUsage_LinearVelocityY                  :int = 7 << 20;
      public static const NumberTypeUsage_LinearVelocityMagnitude          :int = 8 << 20;
      public static const NumberTypeUsage_AngularVelocity                  :int = 9 << 20;
      public static const NumberTypeUsage_LinearAccelerationX              :int = 10 << 20;
      public static const NumberTypeUsage_LinearAccelerationY              :int = 11 << 20;
      public static const NumberTypeUsage_LinearAccelerationMagnitude      :int = 12 << 20;
      public static const NumberTypeUsage_AngularAcceleration              :int = 13 << 20;
      public static const NumberTypeUsage_Mass                             :int = 14 << 20;
      public static const NumberTypeUsage_Inertia                          :int = 15 << 20;
      public static const NumberTypeUsage_ForceX                           :int = 16 << 20;
      public static const NumberTypeUsage_ForceY                           :int = 17 << 20;
      public static const NumberTypeUsage_ForceMagnitude                   :int = 18 << 20;
      public static const NumberTypeUsage_Torque                           :int = 19 << 20;
      public static const NumberTypeUsage_MomentumX                        :int = 20 << 20;
      public static const NumberTypeUsage_MomentumY                        :int = 21 << 20;
      public static const NumberTypeUsage_MomentumMagnitude                :int = 22 << 20;
      public static const NumberTypeUsage_AngularMomentum                  :int = 23 << 20;
      public static const NumberTypeUsage_ImpulseX                         :int = 24 << 20;
      public static const NumberTypeUsage_ImpulseY                         :int = 25 << 20;
      public static const NumberTypeUsage_ImpulseMagnitude                 :int = 26 << 20;
      public static const NumberTypeUsage_AngularImpulse                   :int = 27 << 20;
      
      // 1 << 26
   }
}
