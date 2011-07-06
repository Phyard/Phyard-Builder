

package common.trigger {
   
   public class ValueSpaceTypeDefine
   {
      public static const ValueSpace_Void:int = 0x0;
      public static const ValueSpace_Global:int  = 0x1;
      public static const ValueSpace_Input:int   = 0x2;
      public static const ValueSpace_Local:int   = 0x3;
      public static const ValueSpace_Output:int   = 0x4;
      public static const ValueSpace_GlobalRegister:int   = 0x5;
      //public static const ValueSpace_LocalRegister:int   = 0x6; // seems not a good idea
      public static const ValueSpace_Entity:int   = 0x7;
      public static const ValueSpace_Session:int   = 0x8;
   }
}
