package editor.mode {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.entity.Entity;
   import editor.WorldView;
   import editor.setting.EditorSetting;
   
   import editor.trigger.entity.Linkable;
   
   import common.Define;
   
   public class ModeCreateEntityLink extends Mode
   {
      public function ModeCreateEntityLink (mainView:WorldView, linkable:Linkable)
      {
         super (mainView);
         
         mFromLinkable = linkable;
      }
      
      private var mFromLinkable:Linkable = null;
      private var mFromWorldDisplayX:Number = 0;
      private var mFromWorldDisplayY:Number = 0;
      
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
         
         mFromWorldDisplayX = posX;
         mFromWorldDisplayY = posY;
         
         mLineShape = new Shape ();
         mMainView.mForegroundSprite.addChild (mLineShape);
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         var point1:Point = mMainView.WorldToView ( new Point (mFromWorldDisplayX, mFromWorldDisplayY) );
         var point2:Point = mMainView.WorldToView ( new Point (posX, posY) );
         
         GraphicsUtil.ClearAndDrawLine (mLineShape, point1.x, point1.y, point2.x, point2.y, 0x0000FF, 2);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         ResetSession ();
         
         mMainView.SetCurrentCreateMode (null);
         
      // creat link
         
         var created:Boolean = false;
         
         // first round
         var entities:Array = mMainView.GetEditorWorld ().GetEntitiesAtPoint (endX, endY);
         var entity:Entity;
         var linkable:Linkable;
         var i:int;
         for (i = 0; !created && i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            if (entity is Linkable)
            {
               linkable = entity as Linkable;
               created = mFromLinkable.TryToCreateLink (mFromWorldDisplayX, mFromWorldDisplayY, linkable as Entity, endX, endY);
               if (! created && mFromLinkable is Entity)
                  created = linkable.TryToCreateLink (endX, endY, mFromLinkable as Entity, mFromWorldDisplayX, mFromWorldDisplayY);
            }
         }
         
         // second round
         for (i = 0; !created && i < entities.length; ++ i)
         {
            entity = entities [i] as Entity;
            if (! (entity is Linkable) )
            {
               created = mFromLinkable.TryToCreateLink (mFromWorldDisplayX, mFromWorldDisplayY, entity, endX, endY);
            }
         }
         
         /*
         var linkable:Linkable = mMainView.GetEditorWorld ().GetFirstLinkablesAtPoint (endX, endY);
         if (linkable != null && linkable is Entity)
         {
            created = mFromLinkable.TryToCreateLink (mFromWorldDisplayX, mFromWorldDisplayY, linkable as Entity, endX, endY);
            if (! created && mFromLinkable is Entity)
               created = linkable.TryToCreateLink (endX, endY, mFromLinkable as Entity, mFromWorldDisplayX, mFromWorldDisplayY);
         }
         if (! created)
         {
            var entities:Array = mMainView.GetEditorWorld ().GetEntitiesAtPoint (endX, endY);
            var entity:Entity;
            for (var i:int = 0; !created && i < entities.length; ++ i)
            {
               entity = entities [i] as Entity;
               if (entity != linkable)
                  created = mFromLinkable.TryToCreateLink (mFromWorldDisplayX, mFromWorldDisplayY, entity, endX, endY);
            }
         }
         */
         
         if (created)
            mMainView.RepaintEntityLinks ();
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