package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.entity.EntityJointSlider;
   import editor.entity.SubEntitySliderAnchor;
   
   import common.Define;
   
   public class ModeCreateSlider extends Mode
   {
      public function ModeCreateSlider (mainView:WorldView)
      {
         super (mainView);
      }
      
      private var mCurrrentStep:int = 0;
      private var mStartX:Number = 0;
      private var mStartY:Number = 0;
      
      private var mEntityJointSlider:EntityJointSlider = null;
      
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
         if (isCancelled && mEntityJointSlider != null)
            mMainView.DestroyEntity (mEntityJointSlider);
         
         mEntityJointSlider = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         mEntityJointSlider = mMainView.CreateSlider (0, 0, 0, 0);
         if (mEntityJointSlider == null)
         {
            Reset ();
            return
         }
         
         mEntityJointSlider.GetAnchor1 ().visible = false;
         mEntityJointSlider.GetAnchor2 ().visible = false;
         mEntityJointSlider.visible = false;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         if (mCurrrentStep == 0)
         {
            mEntityJointSlider.GetAnchor1 ().visible = true;
            mEntityJointSlider.GetAnchor2 ().visible = false;
            mEntityJointSlider.visible = false;
            
            mEntityJointSlider.GetAnchor1 ().SetPosition (posX, posY);
         }
         else
         {
            mEntityJointSlider.GetAnchor1 ().visible = true;
            mEntityJointSlider.GetAnchor2 ().visible = true;
            mEntityJointSlider.visible = true;
            
            mEntityJointSlider.GetAnchor2 ().SetPosition (posX, posY);
         }
         
         
         mEntityJointSlider.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         mEntityJointSlider.GetAnchor1 ().UpdateSelectionProxy ();
         mEntityJointSlider.GetAnchor2 ().UpdateSelectionProxy ();
         
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
         if (mEntityJointSlider == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJointSlider == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}