package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.entity.EntityJointSpring;
   import editor.entity.SubEntitySpringAnchor;
   
   import common.Define;
   
   public class ModeCreateSpring extends Mode
   {
      public function ModeCreateSpring (mainView:WorldView)
      {
         super (mainView);
      }
      
      private var mCurrrentStep:int = 0;
      private var mStartX:Number = 0;
      private var mStartY:Number = 0;
      
      private var mEntityJointSpring:EntityJointSpring = null;
      
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
         if (isCancelled && mEntityJointSpring != null)
            mMainView.DestroyEntity (mEntityJointSpring);
         
         mEntityJointSpring = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         mEntityJointSpring = mMainView.CreateSpring (0, 0, 0, 0);
         if (mEntityJointSpring == null)
         {
            Reset ();
            return
         }
         
         mEntityJointSpring.GetAnchor1 ().visible = false;
         mEntityJointSpring.GetAnchor2 ().visible = false;
         mEntityJointSpring.visible = false;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         if (mCurrrentStep == 0)
         {
            mEntityJointSpring.GetAnchor1 ().visible = true;
            mEntityJointSpring.GetAnchor2 ().visible = false;
            mEntityJointSpring.visible = false;
            
            mEntityJointSpring.GetAnchor1 ().SetPosition (posX, posY);
         }
         else
         {
            mEntityJointSpring.GetAnchor1 ().visible = true;
            mEntityJointSpring.GetAnchor2 ().visible = true;
            mEntityJointSpring.visible = true;
            
            mEntityJointSpring.GetAnchor2 ().SetPosition (posX, posY);
         }
         
         mEntityJointSpring.UpdateAppearance ();
         
         mMainView.UpdateEntityInfoOnStatusBar ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         mEntityJointSpring.GetAnchor1 ().UpdateSelectionProxy ();
         mEntityJointSpring.GetAnchor2 ().UpdateSelectionProxy ();
         
         
         ResetSession (false);
         
         mMainView.CalSelectedEntitiesCenterPoint ();
         mMainView.SetCurrentCreateMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         mCurrrentStep = 1;
         
         mStartX = mouseX;
         mStartY = mouseY;
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJointSpring == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJointSpring == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}