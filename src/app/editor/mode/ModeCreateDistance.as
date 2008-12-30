package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.entity.EntityJointDistance;
   import editor.entity.SubEntityDistanceAnchor;
   
   import common.Define;
   
   public class ModeCreateDistance extends Mode
   {
      public function ModeCreateDistance (mainView:WorldView)
      {
         super (mainView);
      }
      
      private var mCurrrentStep:int = 0;
      private var mStartX:Number = 0;
      private var mStartY:Number = 0;
      
      private var mEntityJointDistance:EntityJointDistance = null;
      
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
         if (isCancelled && mEntityJointDistance != null)
            mMainView.DestroyEntity (mEntityJointDistance);
         
         mEntityJointDistance = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         mEntityJointDistance = mMainView.CreateDistance (0, 0, 0, 0);
         if (mEntityJointDistance == null)
         {
            Reset ();
            return
         }
         
         mEntityJointDistance.GetAnchor1 ().visible = false;
         mEntityJointDistance.GetAnchor2 ().visible = false;
         mEntityJointDistance.visible = false;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         if (mCurrrentStep == 0)
         {
            mEntityJointDistance.GetAnchor1 ().visible = true;
            mEntityJointDistance.GetAnchor2 ().visible = false;
            mEntityJointDistance.visible = false;
            
            mEntityJointDistance.GetAnchor1 ().SetPosition (posX, posY);
         }
         else
         {
            mEntityJointDistance.GetAnchor1 ().visible = true;
            mEntityJointDistance.GetAnchor2 ().visible = true;
            mEntityJointDistance.visible = true;
            
            mEntityJointDistance.GetAnchor2 ().SetPosition (posX, posY);
         }
         
         
         mEntityJointDistance.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         mEntityJointDistance.GetAnchor1 ().UpdateSelectionProxy ();
         mEntityJointDistance.GetAnchor2 ().UpdateSelectionProxy ();
         
         
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
         if (mEntityJointDistance == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJointDistance == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}