package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.entity.dialog.WorldView;
   
   
   public class ModeMoveSelectedEntities extends Mode
   {
      
      public function ModeMoveSelectedEntities (mainView:WorldView)
      {
         super (mainView);
      }
      
      private var mStartX:Number;
      private var mStartY:Number;
      
      private var mIsStarted:Boolean = false;
      
      
      override public function Destroy ():void
      {
         if (mIsStarted)
            UpdateSession (mStartX, mStartY, true);
         
         ResetSession ();
      }
      
      protected function ResetSession ():void
      {
         mIsStarted = false;
      }
      
      private var mOriginalStartX:Number;
      private var mOriginalStartY:Number;
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession ();
         
         mOriginalStartX = mStartX = startX;
         mOriginalStartY = mStartY = startY;
         
         mIsStarted = true;
      }
      
      private function UpdateSession (endX:Number, endY:Number, updateSelectionProxy:Boolean):void
      {
         var dx:Number = endX - mStartX;
         var dy:Number = endY - mStartY;
         
         mStartX = endX;
         mStartY = endY;
         
         mMainView.MoveSelectedEntities (dx, dy, updateSelectionProxy);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY, true);
         
         ResetSession ();
         
         if (mOriginalStartX != endX || mOriginalStartY != endY)
         {
            mMainView.CreateUndoPoint ("Move entities");
         }
         
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