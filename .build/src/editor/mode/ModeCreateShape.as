
package editor.mode {
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   public class ModeCreateShape extends Mode
   {
      protected var mFilledColor:uint = 0xffffff;
      protected var mIsStatic:Boolean = false;
      
      public function ModeCreateShape (mainView:WorldView, color:uint, isStatic:Boolean)
      {
         super (mainView);
         
         mFilledColor = color;
         mIsStatic = isStatic;
      }
      
   }
   
}