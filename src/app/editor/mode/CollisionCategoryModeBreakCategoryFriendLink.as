package editor.mode {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.CollisionManagerView;
   
   
   import common.Define;
   
   public class CollisionCategoryModeBreakCategoryFriendLink extends CollisionCategoryMode
   {
      public function CollisionCategoryModeBreakCategoryFriendLink (mainView:CollisionManagerView)
      {
         super (mainView);
      }
      
      private var mLineShape:Shape = null;
      private var mStartX:Number = 0;
      private var mStartY:Number = 0;
      
      override public function Initialize ():void
      {
      }
      
      override public function Reset ():void
      {
         ResetSession ();
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      protected function ResetSession ():void
      {
         if (mLineShape != null && mMainView.mForegroundSprite.contains (mLineShape))
            mMainView.mForegroundSprite.removeChild (mLineShape);
         
         mLineShape = null;
      }
      
      protected function StartSession (posX:Number, posY:Number):void
      {
         ResetSession ();
         
         mLineShape = new Shape ();
         mMainView.mForegroundSprite.addChild (mLineShape);
         
         mStartX = posX;
         mStartY = posY;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         var point1:Point = mMainView.ManagerToView ( new Point (mStartX, mStartY) );
         var point2:Point = mMainView.ManagerToView ( new Point (posX, posY) );
         
         GraphicsUtil.ClearAndDrawLine (mLineShape, point1.x, point1.y, point2.x, point2.y, 0x0, 1);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         ResetSession ();
         
         mMainView.SetCurrentCreateMode (null);
         
         mMainView.BreakCollisionCategoryFriendLink (mStartX, mStartY, endX, endY);
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
         if (mLineShape == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mLineShape == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}