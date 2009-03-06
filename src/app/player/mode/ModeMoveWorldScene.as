package player.mode {

   import flash.geom.Point;
   
   import com.tapirgames.util.DisplayObjectUtil;
   
   import player.world.World;
   
   public class ModeMoveWorldScene extends Mode
   {
      
      public function ModeMoveWorldScene (world:World)
      {
         super (world);
      }
      
      private var mStartX:Number;
      private var mStartY:Number;
      
      private var mIsStarted:Boolean = false;
      
      
      override public function Reset ():void
      {
         ResetSession ();
         
         mWorld.SetCurrentMode (null);
      }
      
      protected function ResetSession ():void
      {
         mIsStarted = false;
      }
      
      protected function StartSession (startX:Number, startY:Number):void
      {
         ResetSession ();
         
         mStartX = startX;
         mStartY = startY;
         
         mIsStarted = true;
      }
      
      private function UpdateSession (endX:Number, endY:Number):void
      {
         var startWorldPoint:Point = mWorld.globalToLocal (new Point (mStartX, mStartY));
         var endWorldPoint:Point = mWorld.globalToLocal (new Point (endX, endY));
         
         var dx:Number = endWorldPoint.x - startWorldPoint.x;
         var dy:Number = endWorldPoint.y - startWorldPoint.y;
         
         mStartX = endX;
         mStartY = endY;
         
         mWorld.MoveWorldScene (dx, dy);
      }
      
      protected function FinishSession (endX:Number, endY:Number):void
      {
         UpdateSession (endX, endY);
         
         ResetSession ();
         
         mWorld.SetCurrentMode (null);
      }
      
      override public function Update (escapedTime:Number):void
      {
         
      }
      
      private var _lastMouseX:Number;
      private var _lastMouseY:Number;
      
      override public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         _lastMouseX = mouseX;
         _lastMouseY = mouseY;
         
         StartSession (mouseX, mouseY);
      }
      
      override public function OnMouseMove (mouseX:Number, mouseY:Number, buttonDown:Boolean = true):void
      {
         if (! mIsStarted)
            return;
         
         if (buttonDown)
            UpdateSession (mouseX, mouseY);
         else
            FinishSession (_lastMouseX, _lastMouseY);
         
         _lastMouseX = mouseX;
         _lastMouseY = mouseY;
         
      }
      
      override public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (! mIsStarted)
            return;
         
         FinishSession (mouseX, mouseY);
      }
   }
   
}