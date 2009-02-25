
package editor.mode {
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class ModeCreateShape extends Mode
   {
      protected var mFilledColor:uint = 0xffffff;
      protected var mIsStatic:Boolean = false;
      protected var mCiAiType:int = Define.ShapeAiType_Unknown;
      
      
      public function ModeCreateShape (mainView:WorldView, ciAiType:int, color:uint, isStatic:Boolean)
      {
         super (mainView);
         
         mFilledColor = color;
         mIsStatic = isStatic;
         
         mCiAiType = ciAiType;
      }
      
   }
   
}