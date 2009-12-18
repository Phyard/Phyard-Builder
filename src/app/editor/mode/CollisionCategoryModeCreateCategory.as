package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.CollisionManagerView;
   
   
   import editor.entity.EntityCollisionCategory;
   
   import common.Define;
   
   public class CollisionCategoryModeCreateCategory extends CollisionCategoryMode
   {
      public function CollisionCategoryModeCreateCategory (mainView:CollisionManagerView)
      {
         super (mainView);
      }
      
      private var mEntityCollisionCategory:EntityCollisionCategory = null;
      
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
         if (isCancelled && mEntityCollisionCategory != null)
            mMainView.DestroyEntity (mEntityCollisionCategory);
         
         mEntityCollisionCategory = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         mEntityCollisionCategory = mMainView.CreateCollisionCategory (0, 0);
         if (mEntityCollisionCategory == null)
         {
            Reset ();
            return
         }
         
         mEntityCollisionCategory.visible = false;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         mEntityCollisionCategory.visible = true;
         
         mEntityCollisionCategory.SetPosition (posX, posY);
         
         mEntityCollisionCategory.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         mEntityCollisionCategory.UpdateSelectionProxy ();
         
         ResetSession (false);
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         if (mEntityCollisionCategory == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
         if (mEntityCollisionCategory == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntityCollisionCategory == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}