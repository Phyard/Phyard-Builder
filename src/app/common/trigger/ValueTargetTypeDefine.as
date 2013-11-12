
package common.trigger {
   
   import flash.utils.ByteArray;
   
   import common.ValueAdjuster;
   
   public class ValueTargetTypeDefine
   {
      public static const ValueTarget_Null:int = 0x0; // used in editor
      //public static const ValueTarget_Self:int = 0x1; // maybe used in player, hidden to users. (not used in fact)
                                                        // now ValueTarget_Self is removed from editor.trigger.*
      public static const ValueTarget_Variable:int = 0x2; // both
      public static const ValueTarget_EntityProperty:int = 0x3; // both
      public static const ValueTarget_ObjectProperty:int = 0x4; // both
   }
}