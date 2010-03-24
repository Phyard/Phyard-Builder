package editor.mode {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   
   
   import editor.entity.EntityShapePolygon;
   
   import common.Define;
   
   public class ModeCreatePolygon extends ModeCreateShape
   {
      
      public function ModeCreatePolygon (mainView:WorldView, ciAiType:int, filledColor:uint, isStatic:Boolean, isSquare:Boolean = false, minSideLength:Number = Define.MinRectSideLength) //, maxSideLength:Number = Define.MaxRectSideLength)
      {
         super (mainView, ciAiType, filledColor, isStatic);
         
         //if (maxSideLength < minSideLength)
         //{
         //   var temp:Number = maxSideLength;
         //   maxSideLength = minSideLength;
         //   minSideLength = temp;
         //}
         
         if (minSideLength < Define.MinRectSideLength)
            mMinSideLength = Define.MinRectSideLength;
         else if (minSideLength > Define.MaxRectSideLength)
            mMinSideLength = Define.MaxRectSideLength;
         else
            mMinSideLength = minSideLength;
         
         //if (maxSideLength < Define.MinRectSideLength)
         //   mMaxSideLength = Define.MinRectSideLength;
         //else if (maxSideLength > Define.MaxRectSideLength)
         //   mMaxSideLength = Define.MaxRectSideLength;
         //else
         //   mMaxSideLength = maxSideLength;
      }
      
      private var mMinSideLength:Number;
      //private var mMaxSideLength:Number;
      
      private var mPolygonEntity:EntityShapePolygon = null;
      
      private var mStartVertexPointX:Number;
      private var mStartVertexPointY:Number;
      private var mLastVertexPointX:Number;
      private var mLastVertexPointY:Number;
      
      override public function Initialize ():void
      {
         StartSession ();
      }
      
      override public function Reset ():void
      {
         ResetSession (true);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      protected function ResetSession (isCancelled:Boolean):void
      {
         if (isCancelled)
         {
            if (mPolygonEntity != null)
               mMainView.DestroyEntity (mPolygonEntity);
         }
         else
         {
            if (mPolygonEntity != null)
                mMainView.SetTheOnlySelectedEntity (mPolygonEntity);
         }
         
         mPolygonEntity = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         mPolygonEntity = mMainView.CreatePolygon (mFilledColor, mIsStatic);
         mPolygonEntity.SetAiType (mCiAiType);
         if (mPolygonEntity == null)
         {
            Reset ();
            return;
         }
      }
      
      private function CreateVertexPoint (pointX:Number, pointY:Number):void
      {
         if (mPolygonEntity == null)
            return;
         
         if (mPolygonEntity.GetVertexPointsCount () != 0)
         {
            // check validity
            
            var point1:Point = mMainView.WorldToView (new Point (pointX, pointY));
            var point2:Point = mMainView.WorldToView (new Point (mLastVertexPointX, mLastVertexPointY));
            
            var dx1:Number = point1.x - point2.x;
            var dy1:Number = point1.y - point2.y;
            var ds1:Number = Math.sqrt (dx1 * dx1 + dy1 * dy1);
            
            var point:Point = mPolygonEntity.GetVertexPointAt (0);
            point2 = mMainView.WorldToView (point);
            var dx2:Number = point1.x - point2.x;
            var dy2:Number = point1.y - point2.y;
            var ds2:Number = Math.sqrt (dx2 * dx2 + dy2 * dy2);
            
            if (ds1 < mMinSideLength || ds2 < mMinSideLength)
            {
               if (mPolygonEntity.GetVertexPointsCount () < 4)
               {
                  Reset ();
               }
               else
               {
                  FinishSession ();
               }
               
               return;
            }
         }
         else
         {
            mStartVertexPointX = pointX;
            mStartVertexPointY = pointY;
            mPolygonEntity.AddVertexPoint (pointX, pointY);
         }
         
         mPolygonEntity.AddVertexPoint (pointX, pointY);
         
         mLastVertexPointX = pointX;
         mLastVertexPointY = pointY;
         
         mPolygonEntity.UpdateVertexPointAt (pointX, pointY, mPolygonEntity.GetVertexPointsCount () - 2);
         
         mPolygonEntity.UpdateAppearance ();
         
         //UpdateSession (pointX, pointY);
      }
      
      protected function UpdateSession (pointX:Number, pointY:Number):void
      {
         if (mPolygonEntity == null)
            return;
         
         if (mPolygonEntity.GetVertexPointsCount () == 0)
            return;
         
         mPolygonEntity.UpdateVertexPointAt (pointX, pointY, mPolygonEntity.GetVertexPointsCount () - 1);
         
         mPolygonEntity.UpdateAppearance ();
         
         mMainView.CalSelectedEntitiesCenterPoint ();
      }
      
      protected function FinishSession ():void
      {
         mPolygonEntity.RemoveVertexPointAt (mPolygonEntity.GetVertexPointsCount () - 1);
         
         mPolygonEntity.UpdateAppearance ();
         mPolygonEntity.UpdateSelectionProxy ();
         
         mMainView.CreateUndoPoint ("New polygon");
         
         ResetSession (false);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
         if (mPolygonEntity == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mPolygonEntity == null)
            return;
         
         CreateVertexPoint (mouseX, mouseY);
      }
   }
   
}