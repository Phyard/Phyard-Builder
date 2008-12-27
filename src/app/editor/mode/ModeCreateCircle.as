package editor.mode {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.entity.EntityShapeCircle;
   
   public class ModeCreateCircle extends ModeCreateShape
   {
      public function ModeCreateCircle (mainView:WorldView, filledColor:uint, isStatic:Boolean)
      {
         super (mainView, filledColor, isStatic);
      }
      
      private var mCenterX:Number;
      private var mCenterY:Number;
      private var mRadius:Number;
      
      private var mCircleEntity:EntityShapeCircle = null;
      
      
      override public function Reset ():void
      {
         ResetSession (true);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      protected function ResetSession (isCancelled:Boolean):void
      {
         if (isCancelled)
         {
            if (mCircleEntity != null)
               mMainView.DestroyEntity (mCircleEntity);
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
         ResetSession (true);
         
         mCenterX = startX;
         mCenterY = startY;
         
         mCircleEntity = mMainView.CreateCircle (mCenterX, mCenterY, 0, mFilledColor, mIsStatic);
         
         UpdateSession (startX, startY);
      }
      
      protected function UpdateSession (endX:Number, endY:Number):void
      {
         var startPoint:Point = new Point (mCenterX, mCenterY);
         var endPoint  :Point = new Point (endX, endY);
         
         mRadius = Point.distance (startPoint, endPoint);
         
         if (mRadius > EditorSetting.MaxCircleRadium)
            mRadius = EditorSetting.MaxCircleRadium;
         
         mCircleEntity.SetRadius (mRadius);
         mCircleEntity.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         if (mRadius < EditorSetting.MinCircleRadium)
         {
            ResetSession (true);
            
            return;
         }
         
         mCircleEntity.UpdateSelectionProxy ();
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