package editor.asset {

   public class IntentDrag extends Intent
   {  
      public function IntentDrag ()
      {
      }
      
      protected var mStarted:Boolean = false;
      protected var mStartX:Number;
      protected var mStartY:Number;
      protected var mCurrentX:Number;
      protected var mCurrentY:Number;
      
   //================================================================
   // override 
   //================================================================
      
      override protected function OnMouseDownInternal (managerX:Number, managerY:Number):void
      {
         if (mStarted)
            return;
         
         mStarted = true;
         
         mStartX = managerX;
         mStartY = managerY;
         
         mCurrentX = mStartX;
         mCurrentY = mStartY;
      }
      
      override protected function OnMouseMoveInternal (managerX:Number, managerY:Number, isHold:Boolean):void
      {
         if (isHold)
         {
            mCurrentX = managerX;
            mCurrentY = managerY;
            
            Process (false);
         }
         else if (ShouldTerminateIfNotHoldInMoving ())
         {
            Terminate (true);
         }
      }
      
      override protected function OnMouseUpInternal (managerX:Number, managerY:Number):void
      {
         mCurrentX = managerX;
         mCurrentY = managerY;
         
         Process (true);
         
         Terminate (false);
      }
      
   //================================================================
   // to override 
   //================================================================
      
      protected function ShouldTerminateIfNotHoldInMoving ():Boolean
      {
         return true;
      }
      
      protected function Process (finished:Boolean):void
      {
      }

   }
   
}
