
package editor.asset {
   
   public class Intent
   {
      public function Intent ()
      {
      }
      
      private var mTerminated:Boolean = false;
      
      final public function IsTerminated ():Boolean
      {
         return mTerminated;
      }
      
      final public function Terminate (passively:Boolean = true):void
      {
         if (mTerminated)
            return;
         
         TerminateInternal (passively);
         
         mTerminated = true;
      }
      
      final public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         if (mTerminated)
            return;
         
         OnMouseDownInternal (mouseX, mouseY);
      }
      
      final public function OnMouseMove (mouseX:Number, mouseY:Number, isHold:Boolean):void
      {
         if (mTerminated)
            return;
         
         OnMouseMoveInternal (mouseX, mouseY, isHold);
      }
      
      final public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
         if (mTerminated)
            return;
         
         OnMouseUpInternal (mouseX, mouseY);
      }
      
   //================================================================
   // to override 
   //================================================================
      
      protected function TerminateInternal (passively:Boolean):void
      {
      }
      
      protected function OnMouseDownInternal (mouseX:Number, mouseY:Number):void
      {
      }
      
      protected function OnMouseMoveInternal (mouseX:Number, mouseY:Number, isHold:Boolean):void
      {
      }
      
      protected function OnMouseUpInternal (mouseX:Number, mouseY:Number):void
      {
      }
   }
   
}
