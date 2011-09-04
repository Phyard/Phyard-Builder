
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
      
      final public function OnMouseDown (managerX:Number, managerY:Number):void
      {
         if (mTerminated)
            return;
         
         OnMouseDownInternal (managerX, managerY);
      }
      
      final public function OnMouseMove (managerX:Number, managerY:Number, isHold:Boolean):void
      {
         if (mTerminated)
            return;
         
         OnMouseMoveInternal (managerX, managerY, isHold);
      }
      
      final public function OnMouseUp (managerX:Number, managerY:Number):void
      {
         if (mTerminated)
            return;
         
         OnMouseUpInternal (managerX, managerY);
      }
      
   //================================================================
   // to override 
   //================================================================
      
      protected function TerminateInternal (passively:Boolean):void
      {
      }
      
      protected function OnMouseDownInternal (managerX:Number, managerY:Number):void
      {
      }
      
      protected function OnMouseMoveInternal (managerX:Number, managerY:Number, isHold:Boolean):void
      {
      }
      
      protected function OnMouseUpInternal (managerX:Number, managerY:Number):void
      {
      }
   }
   
}
