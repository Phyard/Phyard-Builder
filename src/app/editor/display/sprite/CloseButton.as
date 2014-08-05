
package editor.display.sprite {
   
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CloseButton extends Sprite 
   {
      public static const ButtonHalfSize:int = 7;
      public static const CloseHalfSize:int = 5;
      
      private var mBorder:Shape = new Shape ();
      private var mClose:Shape = new Shape ();
      private var mBG:Shape = new Shape ();
      
      private var mOnCloseCallback:Function = null;
      
      public function CloseButton (closeFunc:Function)
      {
         mOnCloseCallback = closeFunc;
         
         mBG.graphics.beginFill (0xFFFFFF);
         mBG.graphics.drawRect (- ButtonHalfSize, - ButtonHalfSize, ButtonHalfSize + ButtonHalfSize, ButtonHalfSize + ButtonHalfSize);
         mBG.graphics.endFill ();
         addChild (mBG);
         mBG.visible = false;
         
         mClose.graphics.lineStyle(1, 0x000000);
         mClose.graphics.moveTo (- CloseHalfSize, - CloseHalfSize);
         mClose.graphics.lineTo (CloseHalfSize, CloseHalfSize);
         mClose.graphics.moveTo (- CloseHalfSize, CloseHalfSize);
         mClose.graphics.lineTo (CloseHalfSize, - CloseHalfSize);
         addChild (mClose);
         
         mBorder.graphics.lineStyle(1, 0x000000);
         mBorder.graphics.drawRect (- ButtonHalfSize, - ButtonHalfSize, ButtonHalfSize + ButtonHalfSize, ButtonHalfSize + ButtonHalfSize);
         addChild (mBorder);
         
         addEventListener (MouseEvent.CLICK, OnMouseClick);
         addEventListener (MouseEvent.MOUSE_OUT, OnMouseOut);
         addEventListener (MouseEvent.MOUSE_OVER, OnMouseOver);
      }
      
      private function OnMouseClick (event:MouseEvent):void
      {
         if (mOnCloseCallback != null)
         {
            mOnCloseCallback ();
         }
      }
      
      private function OnMouseOut (event:MouseEvent):void
      {
         mBG.visible = false;
      }
      
      private function OnMouseOver (event:MouseEvent):void
      {
         mBG.visible = true;
      }
   }
   
}
