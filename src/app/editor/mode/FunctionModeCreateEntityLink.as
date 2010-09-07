package editor.mode {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.entity.Entity;
   import editor.FunctionEditingView;
   
   import editor.trigger.entity.Linkable;
   
   import common.Define;
   
   public class FunctionModeCreateEntityLink extends FunctionMode
   {
      public function FunctionModeCreateEntityLink (mainView:FunctionEditingView, linkable:Linkable)
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
      
      override public function Destroy ():void
      {
         ResetSession ();
      }
      
      protected function ResetSession ():void
      {
         if (mLineShape != null && mMainView.mForegroundLayer.contains (mLineShape))
            mMainView.mForegroundLayer.removeChild (mLineShape);
         
         mLineShape = null;
      }
      
      protected function StartSession (posX:Number, posY:Number):void
      {
         ResetSession ();
         
         mFromWorldDisplayX = posX;
         mFromWorldDisplayY = posY;
         
         mLineShape = new Shape ();
         mMainView.mForegroundLayer.addChild (mLineShape);
      }
      
      protected function UpdateSession (posX:Number, posY:Number):void
      {
         var point1:Point = mMainView.ManagerToView ( new Point (mFromWorldDisplayX, mFromWorldDisplayY) );
         var point2:Point = mMainView.ManagerToView ( new Point (posX, posY) );
         
         GraphicsUtil.ClearAndDrawLine (mLineShape, point1.x, point1.y, point2.x, point2.y, 0x0000FF, 2);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         ResetSession ();
         
         mMainView.SetCurrentCreateMode (null);
         
      // creat link
         
         var created:Boolean = false;
         
         // first round
         var entities:Array = mMainView.GetFunctionManager ().GetEntitiesAtPoint (endX, endY);
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
         
         // second round, link general entity with a linkable
         
         for (i = 0; i < entities.length; ++ i)
         {
            entity = (entities [i] as Entity).GetMainEntity ();
            if (! (entity is Linkable) )
            {
               created = mFromLinkable.TryToCreateLink (mFromWorldDisplayX, mFromWorldDisplayY, entity, endX, endY);
               if (created)
                  break;
            }
         }
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