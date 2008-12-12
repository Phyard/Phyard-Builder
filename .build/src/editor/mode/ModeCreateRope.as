package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.entity.EntityJointRope;
   import editor.entity.SubEntityRopeAnchor;
   
   public class ModeCreateRope extends Mode
   {
      public function ModeCreateRope (mainView:WorldView)
      {
         super (mainView);
      }
      
      private var mCurrrentStep:int = 0;
      private var mStartX:Number = 0;
      private var mStartY:Number = 0;
      
      private var mEntityJointRope:EntityJointRope = null;
      
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
         if (isCancelled && mEntityJointRope != null)
            mMainView.DestroyEntity (mEntityJointRope);
         
         mEntityJointRope = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         mEntityJointRope = mMainView.CreateRope (0, 0, 0, 0);
         mEntityJointRope.GetAnchor1 ().visible = false;
         mEntityJointRope.GetAnchor2 ().visible = false;
         mEntityJointRope.visible = false;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         if (mCurrrentStep == 0)
         {
            mEntityJointRope.GetAnchor1 ().visible = true;
            mEntityJointRope.GetAnchor2 ().visible = false;
            mEntityJointRope.visible = false;
            
            mEntityJointRope.GetAnchor1 ().SetPosition (posX, posY);
         }
         else
         {
            mEntityJointRope.GetAnchor1 ().visible = true;
            mEntityJointRope.GetAnchor2 ().visible = true;
            mEntityJointRope.visible = true;
            
            mEntityJointRope.GetAnchor2 ().SetPosition (posX, posY);
         }
         
         
         mEntityJointRope.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         mEntityJointRope.GetAnchor1 ().UpdateSelectionProxy ();
         mEntityJointRope.GetAnchor2 ().UpdateSelectionProxy ();
         
         
         ResetSession (false);
         
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
         if (mEntityJointRope == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJointRope == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}