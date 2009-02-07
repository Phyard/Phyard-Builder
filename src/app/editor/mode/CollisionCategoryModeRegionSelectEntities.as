package editor.mode {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.CollisionManagerView;
   import editor.setting.EditorSetting;
   
   public class CollisionCategoryModeRegionSelectEntities extends CollisionCategoryMode
   {
      
      public function CollisionCategoryModeRegionSelectEntities (mainView:CollisionManagerView)
      {
         super (mainView);
      }
      
      private var mBoxShape:Shape = null;
      private var mStartX:Number;
      private var mStartY:Number;
      private var mEndX:Number;
      private var mEndY:Number;
      
      override public function Destroy ():void
      {
         ResetSession ();
      }
      
      override public function Reset ():void
      {
         ResetSession ();
         
         mMainView.SetCurrentEditMode (null);
      }
      
      protected function ResetSession ():void
      {
         if ( mBoxShape != null && mMainView.mForegroundSprite.contains (mBoxShape) )
            mMainView.mForegroundSprite.removeChild (mBoxShape);
         
         mBoxShape = null;
      }
      
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession ();
         
         mBoxShape = new Shape ();
         mMainView.mForegroundSprite.addChild (mBoxShape);
         
          mStartX = startX;
          mStartY = startY;
         
         UpdateSession (mStartX, mStartY);
      }
      
      private function UpdateSession (endX:Number, endY:Number):void
      {
         var left:Number   = mStartX < endX ? mStartX : endX;
         var right:Number  = mStartX >= endX ? mStartX : endX;
         var top:Number    = mStartY < endY ? mStartY : endY;
         var bottom:Number = mStartY >= endY ? mStartY : endY;
         
         var w:int = right - left;
         var h:int = bottom - top;
         
         mEndX = endX;
         mEndY = endY;
         
         var point1:Point = mMainView.ManagerToView ( new Point (left, top) );
         var point2:Point = mMainView.ManagerToView ( new Point (top, bottom) );
         
         GraphicsUtil.ClearAndDrawRect (mBoxShape, point1.x, point1.y, w, h);
         
         mMainView.RegionSelectEntities (left, top, right, bottom);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         ResetSession ();
         
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
         if (mBoxShape == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mBoxShape == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}