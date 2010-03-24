package editor.mode {

   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.WorldView;
   
   
   import editor.entity.EntityJoint;
   import editor.entity.SubEntityJointAnchor;
   
   import common.Define;
   
   public class ModeCreateJoint extends Mode
   {
      private var mEntityCreateFunction:Function = null;
      
      public function ModeCreateJoint (mainView:WorldView, createFunc:Function)
      {
         super (mainView);
         
         mEntityCreateFunction = createFunc;
      }
      
      private var mCurrrentStep:int = 0;
      private var mStartX:Number = 0;
      private var mStartY:Number = 0;
      
      private var mEntityJoint:EntityJoint = null;
      
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
         if (isCancelled && mEntityJoint != null)
            mMainView.DestroyEntity (mEntityJoint);
         
         mEntityJoint = null;
      }
      
      protected function StartSession ():void
      {
         ResetSession (true);
         
         mEntityJoint = mEntityCreateFunction ();
         if (mEntityJoint == null)
         {
            Reset ();
            return;
         }
         
         var anchors:Array = mEntityJoint.GetSubEntities ();
         var anchor1:SubEntityJointAnchor = anchors [0] as SubEntityJointAnchor;
         var anchor2:SubEntityJointAnchor = anchors.length < 2 ? null : anchors [1] as SubEntityJointAnchor;
         
         mEntityJoint.visible = false;
         anchor1.visible = false;
         if (anchor2 != null)
         {
           anchor2.visible = false;
         }
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         var anchors:Array = mEntityJoint.GetSubEntities ();
         var anchor1:SubEntityJointAnchor = anchors [0] as SubEntityJointAnchor;
         var anchor2:SubEntityJointAnchor = anchors.length < 2 ? null : anchors [1] as SubEntityJointAnchor;
         
         if (mCurrrentStep == 0)
         {
            mEntityJoint.visible = false;
            anchor1.visible = true;
            if (anchor2 != null)
            {
               anchor2.visible = false;
            }
            
            anchor1.SetPosition (posX, posY);
         }
         else
         {
            mEntityJoint.visible = true;
            anchor1.visible = true;
            if (anchor2 != null)
            {
               anchor2.visible = true;
               anchor2.SetPosition (posX, posY);
            }
            else
            {
               anchor1.SetPosition (posX, posY);
            }
         }
         
         mEntityJoint.NotifyAnchorPositionChanged ();
         
         mMainView.UpdateSelectedEntityInfo ();
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         var anchors:Array = mEntityJoint.GetSubEntities ();
         var anchor1:SubEntityJointAnchor = anchors [0] as SubEntityJointAnchor;
         var anchor2:SubEntityJointAnchor = anchors.length < 2 ? null : anchors [1] as SubEntityJointAnchor;
         
         anchor1.UpdateSelectionProxy ();
         if (anchor2 != null)
         {
            anchor2.UpdateSelectionProxy ();
         }
         
         ResetSession (false);
         
         mMainView.CreateUndoPoint ("New joint");
         
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
         if (mEntityJoint == null)
            return;
         
         UpdateSession (mouseX, mouseY);
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mEntityJoint == null)
            return;
         
         if (mCurrrentStep == 0) // this is caused by dragging mouse from out of world field.
         {
            Reset ();
            return;
         }
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}