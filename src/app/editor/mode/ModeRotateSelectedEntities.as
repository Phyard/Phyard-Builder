package editor.mode {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   
   
   public class ModeRotateSelectedEntities extends Mode
   {
      public function ModeRotateSelectedEntities (mainView:WorldView)
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
      
      private var mStartRotation:Number;
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession ();
         
         mStartX = startX;
         mStartY = startY;
         
         mIsStarted = true;
         
         var dx1:Number = mStartX - mMainView.GetSelectedEntitiesCenterX ();
         var dy1:Number = mStartY - mMainView.GetSelectedEntitiesCenterY ();
         
         mStartRotation = Math.atan2 (dy1, dx1);
      }
      
      private var mLastRotation:Number = 0.0;
      protected function UpdateSession (endX:Number, endY:Number, updateSelectionProxy:Boolean):void
      {
         var dx1:Number = mStartX - mMainView.GetSelectedEntitiesCenterX ();
         var dy1:Number = mStartY - mMainView.GetSelectedEntitiesCenterY ();
         var dx2:Number = endX - mMainView.GetSelectedEntitiesCenterX ();
         var dy2:Number = endY - mMainView.GetSelectedEntitiesCenterY ();
         
         var radians1:Number = Math.atan2 (dy1, dx1);
         var radians2:Number = Math.atan2 (dy2, dx2);
         
         mStartX = endX;
         mStartY = endY;
         
         mLastRotation = radians2;
         
         mMainView.RotateSelectedEntities (radians2 - radians1, updateSelectionProxy);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY, true);
         
         ResetSession ();
         
         if (mLastRotation != mStartRotation)
         {
            mMainView.CreateUndoPoint ("Rotate");
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