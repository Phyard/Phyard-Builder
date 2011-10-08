package editor.asset {

   public class IntentDrag extends Intent
   {
      protected var mCallbackOnDragging:Function;
      protected var mCallbackOnCancel:Function;
      
      public function IntentDrag (callbackOnDragging:Function = null, callbackOnCancel:Function = null)
      {
         mCallbackOnDragging = callbackOnDragging;
         mCallbackOnCancel = callbackOnCancel;
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
         if (! mStarted)
            return;
         
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
         if (! mStarted)
            return;
         
         mCurrentX = managerX;
         mCurrentY = managerY;
         
         Process (true);
         
         Terminate (false);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         if (passively && mCallbackOnCancel != null)
         {
            mCallbackOnCancel ();
         }
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
         if (mStarted && mCallbackOnDragging != null)
         {
            mCallbackOnDragging (mStartX, mStartY, mCurrentX, mCurrentY, finished);
         }
      }

   }
   
}
