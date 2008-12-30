package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.entity.EntityJointHinge;
   import editor.entity.SubEntityHingeAnchor;
   
   import common.Define;
   
   public class ModeCreateHinge extends Mode
   {
      public function ModeCreateHinge (mainView:WorldView)
      {
         super (mainView);
      }
      
      private var mEntityJointHinge:EntityJointHinge = null;
      
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
         if (isCancelled && mEntityJointHinge != null)
            mMainView.DestroyEntity (mEntityJointHinge);
         
         mEntityJointHinge = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         mEntityJointHinge = mMainView.CreateHinge (0, 0);
         if (mEntityJointHinge == null)
         {
            Reset ();
            return
         }
         
         mEntityJointHinge.GetAnchor ().visible = false;
         mEntityJointHinge.visible = false;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         mEntityJointHinge.GetAnchor ().visible = true;
         mEntityJointHinge.visible = false;
         
         mEntityJointHinge.GetAnchor ().SetPosition (posX, posY);
         
         mEntityJointHinge.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         mEntityJointHinge.GetAnchor ().UpdateSelectionProxy ();
         
         ResetSession (false);
         
         mMainView.CalSelectedEntitiesCenterPoint ();
         mMainView.SetCurrentCreateMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJointHinge == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJointHinge == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJointHinge == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}