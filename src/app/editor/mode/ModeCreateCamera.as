package editor.mode {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   
   
   import editor.entity.EntityShapeText;
   
   import common.Define;
   
   public class ModeCreateText extends Mode
   {
      
      public function ModeCreateText (mainView:WorldView)
      {
         super (mainView);
      }
      
      private var mStartX:Number;
      private var mStartY:Number;
      private var mEndX:Number;
      private var mEndY:Number;
      
      private var mTextEntity:EntityShapeText = null;
      
      override public function Reset ():void
      {
         ResetSession (true);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      protected function ResetSession (isCancelled:Boolean):void
      {
         if (isCancelled)
         {
            if (mTextEntity != null)
               mMainView.DestroyEntity (mTextEntity);
         }
         else
         {
            if (mTextEntity != null)
                mMainView.SetTheOnlySelectedEntity (mTextEntity);
         }
         
         mTextEntity = null;
      }
      
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession (true);
         
         mStartX = startX;
         mStartY = startY;
         
         mTextEntity = mMainView.CreateText (mStartX, mStartY, mStartX, mStartY);
         if (mTextEntity == null)
         {
            Reset ();
            return;
         }
         
         UpdateSession (startX, startY);
      }
      
      private function UpdateSession (endX:Number, endY:Number):void
      {
         var startPoint:Point = new Point (mStartX, mStartY);
         var endPoint  :Point = new Point (endX, endY);
         
         var w:Number = startPoint.x - endPoint.x; if (w < 0) w = - w;
         var h:Number = startPoint.y - endPoint.y; if (h < 0) h = - h;
         
         mEndX = endPoint.x;
         mEndY = endPoint.y;
         
         w = startPoint.x - endPoint.x; if (w < 0) w = - w;
         h = startPoint.y - endPoint.y; if (h < 0) h = - h;
         
         var centerX:Number = (startPoint.x + endPoint.x) * 0.5;
         var centerY:Number = (startPoint.y + endPoint.y) * 0.5;
         
         mTextEntity.SetPosition (centerX, centerY);
         mTextEntity.SetHalfWidth  (w * 0.5, false);
         mTextEntity.SetHalfHeight (h * 0.5, false);
         mTextEntity.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         var w:Number = mEndX - mStartX; if (w < 0) w = -w;
         var h:Number = mEndY - mStartY; if (h < 0) h = -h;
         
         if (w < Define.MinTextSideLength || h < Define.MinTextSideLength)
         {
            ResetSession (true);
            
            return;
         }
         
         mTextEntity.UpdateSelectionProxy ();
         ResetSession (false);
         
         mMainView.CreateUndoPoint ();
         
         mMainView.SetCurrentCreateMode (null);
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
         if (mTextEntity == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mTextEntity == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}