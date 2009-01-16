package editor.mode {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.entity.EntityShapeRectangle;
   
   import common.Define;
   
   public class ModeCreateRectangle extends ModeCreateShape
   {
      
      public function ModeCreateRectangle (mainView:WorldView, filledColor:uint, isStatic:Boolean, isSquare:Boolean = false, minSideLength:Number = EditorSetting.MinRectSideLength, maxSideLength:Number = EditorSetting.MaxRectSideLength)
      {
         super (mainView, filledColor, isStatic);
         
         if (maxSideLength < minSideLength)
         {
            var temp:Number = maxSideLength;
            maxSideLength = minSideLength;
            minSideLength = temp;
         }
         
         mIsSquare = isSquare;
         
         if (minSideLength < EditorSetting.MinRectSideLength)
            mMinSideLength = EditorSetting.MinRectSideLength;
         else if (minSideLength > EditorSetting.MaxRectSideLength)
            mMinSideLength = EditorSetting.MaxRectSideLength;
         else
            mMinSideLength = minSideLength;
         
         if (maxSideLength < EditorSetting.MinRectSideLength)
            mMaxSideLength = EditorSetting.MinRectSideLength;
         else if (maxSideLength > EditorSetting.MaxRectSideLength)
            mMaxSideLength = EditorSetting.MaxRectSideLength;
         else
            mMaxSideLength = maxSideLength;
      }
      
      private var mStartX:Number;
      private var mStartY:Number;
      private var mEndX:Number;
      private var mEndY:Number;
      
      private var mIsSquare:Boolean;
      private var mMinSideLength:Number;
      private var mMaxSideLength:Number;
      
      private var mRectEntity:EntityShapeRectangle = null;
      
      override public function Reset ():void
      {
         ResetSession (true);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      protected function ResetSession (isCancelled:Boolean):void
      {
         if (isCancelled)
         {
            if (mRectEntity != null)
               mMainView.DestroyEntity (mRectEntity);
         }
         else
         {
            if (mRectEntity != null)
                mMainView.SetTheOnlySelectedEntity (mRectEntity);
         }
         
         mRectEntity = null;
      }
      
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession (true);
         
         mStartX = startX;
         mStartY = startY;
         
         mRectEntity = mMainView.CreateRectangle (mStartX, mStartY, mStartX, mStartY, mFilledColor, mIsStatic);
          if (mRectEntity == null)
         {
            Reset ();
            return
         }
         
         UpdateSession (startX, startY);
      }
      
      private function UpdateSession (endX:Number, endY:Number):void
      {
         var startPoint:Point = new Point (mStartX, mStartY);
         var endPoint  :Point = new Point (endX, endY);
         
         var w:Number = startPoint.x - endPoint.x; if (w < 0) w = - w;
         var h:Number = startPoint.y - endPoint.y; if (h < 0) h = - h;
         
         if (w <= mMaxSideLength && h <= mMaxSideLength && w * h <= EditorSetting.MaxRectArea)
         {
            mEndX = endPoint.x;
            mEndY = endPoint.y;
         }
         else
         {
            if (w * h <= EditorSetting.MaxRectArea)
            {
               if (w <= mMaxSideLength)
                  mEndX = endPoint.x;
               if (h <= mMaxSideLength)
                  mEndY = endPoint.y;
            }
            
            endPoint = new Point (mEndX, mEndY);
         }
         
         w = startPoint.x - endPoint.x; if (w < 0) w = - w;
         h = startPoint.y - endPoint.y; if (h < 0) h = - h;
         
         var centerX:Number = (startPoint.x + endPoint.x) * 0.5;
         var centerY:Number = (startPoint.y + endPoint.y) * 0.5;
         
         mRectEntity.SetPosition (centerX, centerY);
         mRectEntity.SetHalfWidth  (w * 0.5, false);
         mRectEntity.SetHalfHeight (h * 0.5, false);
         mRectEntity.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         var w:Number = mEndX - mStartX; if (w < 0) w = -w;
         var h:Number = mEndY - mStartY; if (h < 0) h = -h;
         
         if (w < mMinSideLength || h < mMinSideLength)
         {
            ResetSession (true);
            
            return;
         }
         
         mRectEntity.UpdateSelectionProxy ();
         ResetSession (false);
         
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
         if (mRectEntity == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mRectEntity == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}