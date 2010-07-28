package editor.mode {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   
   
   import editor.entity.EntityShapeRectangle;
   
   import common.Define;
   
   public class ModeCreateRectangle extends ModeCreateShape
   {
      
      public function ModeCreateRectangle (mainView:WorldView, ciAiType:int, filledColor:uint, isStatic:Boolean, isSquare:Boolean = false, minSideLength:Number = Define.MinRectSideLength, maxSideLength:Number = Define.MaxRectSideLength)
      {
         super (mainView, ciAiType, filledColor, isStatic);
         
         if (maxSideLength < minSideLength)
         {
            var temp:Number = maxSideLength;
            maxSideLength = minSideLength;
            minSideLength = temp;
         }
         
         mIsSquare = isSquare;
         
         if (minSideLength < Define.MinRectSideLength)
            mMinSideLength = Define.MinRectSideLength;
         else if (minSideLength > Define.MaxRectSideLength)
            mMinSideLength = Define.MaxRectSideLength;
         else
            mMinSideLength = minSideLength;
         
         if (maxSideLength < Define.MinRectSideLength)
            mMaxSideLength = Define.MinRectSideLength;
         else if (maxSideLength > Define.MaxRectSideLength)
            mMaxSideLength = Define.MaxRectSideLength;
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
      
      override public function Destroy ():void
      {
         ResetSession (true);
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
         mRectEntity.SetAiType (mCiAiType);
          if (mRectEntity == null)
         {
            mMainView.CancelCurrentCreatingMode ();
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
         
         if (w <= mMaxSideLength && h <= mMaxSideLength && w * h <= Define.MaxRectArea)
         {
            mEndX = endPoint.x;
            mEndY = endPoint.y;
         }
         else
         {
            if (w * h <= Define.MaxRectArea)
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
         
         mMainView.CreateUndoPoint ("New rectangle", null, mRectEntity);
         
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