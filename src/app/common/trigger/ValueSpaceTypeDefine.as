

package common.trigger {
   
   public class ValueSpaceTypeDefine
   {
      public static const ValueSpace_Void:int = 0x0;
      public static const ValueSpace_Global:int  = 0x1;
      public static const ValueSpace_Input:int   = 0x2;
      public static const ValueSpace_Local:int   = 0x3;
      public static const ValueSpace_Output:int   = 0x4;
      public static const ValueSpace_Register:int   = 0x5; // ever called ValueSpace_GlobalRegister
      //public static const ValueSpace_LocalRegister:int   = 0x6; // never add this type. (may be good for hidden local variables)
      public static const ValueSpace_EntityProperties:int   = 0x7;
      public static const ValueSpace_Session:int   = 0x8;
      public static const ValueSpace_CommonGlobal:int   = 0x9;
      public static const ValueSpace_CommonEntityProperties:int   = 0xA;
      public static const ValueSpace_World:int   = 0xB;
      public static const ValueSpace_GameSave:int   = 0xC; 
   }
}
