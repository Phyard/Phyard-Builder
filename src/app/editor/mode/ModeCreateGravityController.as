package editor.mode {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   
   
   import editor.entity.EntityShapeGravityController;
   
   import common.Define;
   
   public class ModeCreateGravityController extends Mode
   {
      public function ModeCreateGravityController (mainView:WorldView)
      {
         super (mainView);
         
         mMinRadius = Define.MinGravityControllerRadium;
         mMaxRadius = Define.MaxGravityControllerRadium;
      }
      
      private var mCenterX:Number;
      private var mCenterY:Number;
      private var mRadius:Number;
      
      private var mMinRadius:Number;
      private var mMaxRadius:Number;
      
      private var mGravityControllerEntity:EntityShapeGravityController = null;
      
      override public function Reset ():void
      {
         ResetSession (true);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      protected function ResetSession (isCancelled:Boolean):void
      {
         if (isCancelled)
         {
            if (mGravityControllerEntity != null)
               mMainView.DestroyEntity (mGravityControllerEntity);
         }
         else
         {
            if (mGravityControllerEntity != null)
                mMainView.SetTheOnlySelectedEntity (mGravityControllerEntity);
         }
         
         mGravityControllerEntity = null;
      }
      
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession (true);
         
         mCenterX = startX;
         mCenterY = startY;
         
         mGravityControllerEntity = mMainView.CreateGravityController (mCenterX, mCenterY, 0);
         if (mGravityControllerEntity == null)
         {
            Reset ();
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
         
         mGravityControllerEntity.SetRadius (mRadius);
         mGravityControllerEntity.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         if (mRadius < mMinRadius)
         {
            ResetSession (true);
            
            return;
         }
         
         mMainView.CreateUndoPoint ();
         
         mGravityControllerEntity.UpdateSelectionProxy ();
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
         if (mGravityControllerEntity == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mGravityControllerEntity == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}