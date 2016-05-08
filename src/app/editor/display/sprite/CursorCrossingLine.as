
package editor.display.sprite {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   
   public class CursorCrossingLine extends Sprite 
   {
      public function CursorCrossingLine ()
      {
         GraphicsUtil.DrawLine (this, -5, 0, 5, 0);
         GraphicsUtil.DrawLine (this, 0, -5, 0, 5);
      }
   }
   
}
