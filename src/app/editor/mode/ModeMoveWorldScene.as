package editor.mode {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   
   
   public class ModeMoveWorldScene extends Mode
   {
      
      public function ModeMoveWorldScene (mainView:WorldView)
      {
         super (mainView);
      }
      
      private var mStartX:Number;
      private var mStartY:Number;
      
      private var mIsStarted:Boolean = false;
      
      
      override public function Reset ():void
      {
         ResetSession ();
         
         mMainView.SetCurrentEditMode (null);
      }
      
      protected function ResetSession ():void
      {
         mIsStarted = false;
      }
      
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession ();
         
         var viewPoint:Point = mMainView.WorldToView (new Point (startX, startY));
         
         mStartX = viewPoint.x;
         mStartY = viewPoint.y;
         
         mIsStarted = true;
      }
      
      private function UpdateSession (endX:Number, endY:Number, updateSelectionProxy:Boolean):void
      {
         var worldPoint:Point = mMainView.ViewToWorld (new Point (mStartX, mStartY));
         
         var dx:Number = endX - worldPoint.x;
         var dy:Number = endY - worldPoint.y;
         
         var viewPoint:Point = mMainView.WorldToView (new Point (endX, endY));
         
         mStartX = viewPoint.x;
         mStartY = viewPoint.y;
         
         mMainView.MoveWorldScene (dx, dy);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY, true);
         
         ResetSession ();
         
         mMainView.SetCurrentEditMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         StartSession (mouseX, mouseY);
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
         if (! mIsStarted)
            return;
         
         UpdateSession (mouseX, mouseY, false);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (! mIsStarted)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}