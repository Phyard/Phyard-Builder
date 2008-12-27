
package editor.setting {
   
   import common.Define;
   
   public class EditorSetting
   {
      
      
      
      public static const BodyCloneOffsetX:uint = 20;
      public static const BodyCloneOffsetY:uint = 0;
      
      public static const MinCircleRadium:uint = Define.MinCircleRadium;
      public static const MaxCircleRadium:uint = Define.MaxCircleRadium;
      
      public static const MinRectSideLength:uint = 2;
      public static const MaxRectSideLength:uint = 600;
      public static const MaxRectArea:uint = 600 * 200;
      
      //public static const HingeRadium:uint = 4;
      
      public static const BorderColorSelectedObject:uint = 0xFF0000FF;
      public static const BorderColorUnselectedObject:uint = Define.ColorObjectBorder;
      
      
      public static const ColorStaticObject:uint = Define.ColorStaticObject;
      public static const ColorMovableObject:uint = Define.ColorMovableObject;
      
      public static const ColorBreakableObject:uint = Define.ColorBreakableObject;
      
      public static const ColorInfectedObject:uint = Define.ColorInfectedObject;;
      public static const ColorUninfectedObject:uint = Define.ColorUninfectedObject;
      public static const ColorDontInfectObject:uint = Define.ColorDontInfectObject;
      
   }
   
}