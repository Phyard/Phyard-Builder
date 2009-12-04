

package common.trigger {
   
   public class ValueTypeDefine
   {
      public static const ValueTypeMask_Basic:int = 0xFFFF;
      
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
      
      public static const ValueTypeHint_Number_Double :int = 0 << 16; // 32 bits float
      public static const ValueTypeHint_Number_Single :int = 1 << 16; // 32 bits float
      public static const ValueTypeHint_Number_Integer:int = 2 << 16; // 32 bits int
      
      public static const ValueTypeHint_Number_General             :int = 0 << 20;
      public static const ValueTypeHint_Number_PositionX           :int = 1 << 20;
      public static const ValueTypeHint_Number_PositionY           :int = 2 << 20;
      public static const ValueTypeHint_Number_Rotation            :int = 3 << 20;
      public static const ValueTypeHint_Number_Length              :int = 4 << 20;
      public static const ValueTypeHint_Number_Area                :int = 5 << 20;
      public static const ValueTypeHint_Number_LinearSpeed         :int = 6 << 20;
      public static const ValueTypeHint_Number_AngularSpeed        :int = 7 << 20;
      public static const ValueTypeHint_Number_Mass                :int = 8 << 20;
      public static const ValueTypeHint_Number_Inertia             :int = 9 << 20;
      public static const ValueTypeHint_Number_Force               :int = 10 << 20;
      public static const ValueTypeHint_Number_LinearAcceleration  :int = 11 << 20;
      public static const ValueTypeHint_Number_Torque              :int = 12 << 20;
      public static const ValueTypeHint_Number_AngularAcceleration :int = 13 << 20;
      public static const ValueTypeHint_Number_Momentum            :int = 14 << 20; // also impulse 
      public static const ValueTypeHint_Number_AngularMomentum     :int = 15 << 20; // also angular impulse 
      
      // 1 << 26
   }
}
