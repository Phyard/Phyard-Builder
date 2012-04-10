package editor.mode {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.entity.dialog.WorldView;
   
   
   public class ModeScaleSelectedEntities extends Mode
   {
      public function ModeScaleSelectedEntities (mainView:WorldView)
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
      
      protected function UpdateSession (endX:Number, endY:Number, updateSelectionProxy:Boolean):void
      {
         var dx1:Number = mStartX - mMainView.GetSelectedEntitiesCenterX ();
         var dy1:Number = mStartY - mMainView.GetSelectedEntitiesCenterY ();
         var dx2:Number = endX - mMainView.GetSelectedEntitiesCenterX ();
         var dy2:Number = endY - mMainView.GetSelectedEntitiesCenterY ();
         
         var distance1:Number = Math.sqrt (dy1 * dy1 + dx1 * dx1);
         var distance2:Number = Math.sqrt (dy2 * dy2 + dx2 * dx2);
         
         if (distance1 > Number.MIN_VALUE && distance2 > Number.MIN_VALUE)
         {
            mStartX = endX;
            mStartY = endY;
            
            mMainView.ScaleSelectedEntities (distance2 / distance1, updateSelectionProxy);
         }
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY, true);
         
         ResetSession ();
         
         if (mOriginalStartX != endX || mOriginalStartY != endY)
         {
            mMainView.CreateUndoPoint ("Scale");
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