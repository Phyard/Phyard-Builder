

package common.trigger {
   
   public class ValueTypeDefine
   {
      // best to keep the max valye type id < 256.
      // 
      
      public static const ValueType_Void:int = 0x00;
      
      public static const ValueType_Boolean:int = 0x01;
      public static const ValueType_String:int  = 0x02;
      public static const ValueType_Number:int  = 0x03;
      
      public static const ValueType_Entity:int            = 0x50;
      public static const ValueType_CollisionCategory:int = 0x51;
      
      public static const ValyeType_Array:int = 0x70;
      public static const ValyeType_Function:int = 0x71;
      
      
      
   }
}
