

package common.trigger {
   
   public class ValueTypeDefine
   {
      public static const NumberTypeMask_Basic:int = 0xFFFF;
      
      public static const NumberTypeMask_Detail:int = 0x000F0000;
      
      public static const NumberTypeMask_Usage:int = 0x02F00000;
      
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
      
      public static const NumberTypeDetail_Double :int = 0 << 16; // 64 bits float, default
      public static const NumberTypeDetail_Single :int = 1 << 16; // 32 bits float
      public static const NumberTypeDetail_Integer:int = 2 << 16; // 32 bits int
      
      public static const NumberTypeUsage_General             :int = 0 << 20;
      public static const NumberTypeUsage_PositionX           :int = 1 << 20;
      public static const NumberTypeUsage_PositionY           :int = 2 << 20;
      public static const NumberTypeUsage_Rotation            :int = 3 << 20;
      public static const NumberTypeUsage_Length              :int = 4 << 20;
      public static const NumberTypeUsage_Area                :int = 5 << 20;
      public static const NumberTypeUsage_LinearSpeed         :int = 6 << 20;
      public static const NumberTypeUsage_AngularSpeed        :int = 7 << 20;
      public static const NumberTypeUsage_Mass                :int = 8 << 20;
      public static const NumberTypeUsage_Inertia             :int = 9 << 20;
      public static const NumberTypeUsage_Force               :int = 10 << 20;
      public static const NumberTypeUsage_LinearAcceleration  :int = 11 << 20;
      public static const NumberTypeUsage_Torque              :int = 12 << 20;
      public static const NumberTypeUsage_AngularAcceleration :int = 13 << 20;
      public static const NumberTypeUsage_Momentum            :int = 14 << 20; // also impulse 
      public static const NumberTypeUsage_AngularMomentum     :int = 15 << 20; // also angular impulse 
      
      // 1 << 26
   }
}
