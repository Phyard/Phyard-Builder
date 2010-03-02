package editor.mode {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.entity.EntityCollisionCategory;
   
   import editor.CollisionManagerView;
   
   import common.Define;
   
   public class CollisionCategoryModeCreateCategoryFriendLink extends CollisionCategoryMode
   {
      public function CollisionCategoryModeCreateCategoryFriendLink (mainView:CollisionManagerView, ccat:EntityCollisionCategory)
      {
         super (mainView);
         
         mFromCategory = ccat;
      }
      
      private var mFromCategory:EntityCollisionCategory = null;
      private var mFromManagerDisplayX:Number = 0;
      private var mFromManagerDisplayY:Number = 0;
      
      private var mLineShape:Shape = null;
      
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
         
         mFromManagerDisplayX = posX;
         mFromManagerDisplayY = posY;
         
         mLineShape = new Shape ();
         mMainView.mForegroundSprite.addChild (mLineShape);
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         var point1:Point = mMainView.ManagerToView ( new Point (mFromManagerDisplayX, mFromManagerDisplayY) );
         var point2:Point = mMainView.ManagerToView ( new Point (posX, posY) );
         
         GraphicsUtil.ClearAndDrawLine (mLineShape, point1.x, point1.y, point2.x, point2.y, 0x0000FF, 2);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         ResetSession ();
         
         mMainView.SetCurrentCreateMode (null);
         
         mMainView.CreateOrBreakCollisionCategoryFriendLink (mFromCategory, endX, endY);
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