package editor.mode {

   import flash.display.Shape;
   import flash.geom.Point;

   import com.tapirgames.util.GraphicsUtil;

   import editor.entity.dialog.WorldView;

   import editor.entity.EntityVectorShapeCircle;

   import common.Define;

   public class ModeCreateCircle extends ModeCreateShape
   {
      public function ModeCreateCircle (mainView:WorldView, ciAiType:int, filledColor:uint, isStatic:Boolean, minRadius:Number = Define.MinCircleRadius, maxRadius:Number = Define.MaxCircleRadius)
      {
         super (mainView, ciAiType, filledColor, isStatic);

         mMinRadius = minRadius;
         mMaxRadius = maxRadius;
      }

      private var mStarted:Boolean = false;

      private var mCenterX:Number;
      private var mCenterY:Number;
      private var mRadius:Number;

      private var mMinRadius:Number;
      private var mMaxRadius:Number;

      private var mCircleEntity:EntityVectorShapeCircle = null;

      override public function Destroy ():void
      {
         ResetSession (true);
      }

      protected function ResetSession (isCancelled:Boolean):void
      {
         if (isCancelled)
         {
            if (mCircleEntity != null)
               mMainView.DestroyEntity (mCircleEntity);

            mStarted = false;
         }
         else
         {
            if (mCircleEntity != null)
                mMainView.SetTheOnlySelectedEntity (mCircleEntity);
         }

         mCircleEntity = null;
      }

      protected function StartSession (startX:Number, startY:Number):void
      {
         if (mStarted)
            return;

         mStarted = true;

         ResetSession (true);

         mCenterX = startX;
         mCenterY = startY;

         mCircleEntity = mMainView.CreateCircle (mCenterX, mCenterY, 0, mFilledColor, mIsStatic);
         mCircleEntity.SetAiType (mCiAiType);
         if (mCircleEntity == null)
         {
            mMainView.CancelCurrentCreatingMode ();
            return;
         }

         UpdateSession (startX, startY);
      }

      protected function UpdateSession (endX:Number, endY:Number):void
      {
         var startPoint:Point = new Point (mCenterX, mCenterY);
         var endPoint  :Point = new Point (endX, endY);

         mRadius = Point.distance (startPoint, endPoint);

         if (mRadius > mMaxRadius)
            mRadius = mMaxRadius;

         mCircleEntity.SetRadius (mRadius);
         mCircleEntity.UpdateAppearance ();
      }

      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);

         if (mRadius < mMinRadius)
         {
            ResetSession (true);

            return;
         }

         mCircleEntity.UpdateSelectionProxy ();
         ResetSession (false);

         mMainView.CreateUndoPoint ("Create circle", null, mCircleEntity);

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
         if (mCircleEntity == null)
            return;

         UpdateSession (mouseX, mouseY);
      }

      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mCircleEntity == null)
            return;

         FinishSession (mouseX, mouseY);
      }
   }

}
