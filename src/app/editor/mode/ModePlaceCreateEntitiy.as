package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   
   
   import editor.entity.Entity;
   
   import common.Define;
   
   public class ModePlaceCreateEntitiy extends Mode
   {
      public static const StageStart:int = 0;
      public static const StageFinished:int = 1;
      
   //================================
      
      private var mEntityCreateFunction:Function = null;
      private var mEntityCreateOptions:Object = null;
      
      public function ModePlaceCreateEntitiy (mainView:WorldView, createFunc:Function, createOptions:Object = undefined)
      {
         super (mainView);
         
         mEntityCreateFunction = createFunc;
         mEntityCreateOptions = createOptions;
         if (mEntityCreateOptions == null)
            mEntityCreateOptions = new Object ();
      }
      
      private var mEntity:Entity = null;
      
      override public function Initialize ():void
      {
         StartSession ();
      }
      
      override public function Destroy ():void
      {
         ResetSession (true);
      }
      
      protected function ResetSession (isCancelled:Boolean):void
      {
         if (isCancelled && mEntity != null)
            mMainView.DestroyEntity (mEntity);
         
         mEntity = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         if (mEntityCreateFunction != null)
         {
            mEntityCreateOptions.stage = StageStart;
            mEntity = mEntityCreateFunction (mEntityCreateOptions);
         }
         
         if (mEntity == null)
         {
            mMainView.CancelCurrentCreatingMode ();
            return;
         }
         
         mEntity.visible = false;
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         mEntity.visible = true;
         
         mEntity.SetPosition (posX, posY);
         
         mEntity.UpdateAppearance ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         mEntity.UpdateSelectionProxy ();
         
         if (mEntityCreateFunction != null)
         {
            mEntityCreateOptions.entity = mEntity;
            mEntityCreateOptions.stage = StageFinished;
            mEntityCreateFunction (mEntityCreateOptions);
         }
         
         mMainView.CreateUndoPoint ("Create new " + mEntity.GetTypeName ().toLowerCase ());
         
         ResetSession (false);
         
         mMainView.CalSelectedEntitiesCenterPoint ();
         
         mMainView.SetCurrentCreateMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         if (mEntity == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
         if (mEntity == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntity == null)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}