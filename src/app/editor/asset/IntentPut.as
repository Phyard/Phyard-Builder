package editor.asset {

   public class IntentPut extends Intent
   {
      protected var mCallbackOnPutting:Function;
      protected var mCallbackOnCancel:Function;
      
      public function IntentPut (callbackOnPutting:Function = null, callbackOnCancel:Function = null)
      {  
         mCallbackOnPutting = callbackOnPutting;
         mCallbackOnCancel = callbackOnCancel;
      }
      
      protected var mCurrentX:Number;
      protected var mCurrentY:Number;
      
   //================================================================
   // override 
   //================================================================
      
      override protected function OnMouseDownInternal (managerX:Number, managerY:Number):void
      {
      }
      
      override protected function OnMouseMoveInternal (managerX:Number, managerY:Number, isHold:Boolean):void
      {
         mCurrentX = managerX;
         mCurrentY = managerY;
         
         Process (false);
      }
      
      override protected function OnMouseUpInternal (managerX:Number, managerY:Number):void
      {
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
      
      protected function Process (finished:Boolean):void
      {
         if (mCallbackOnPutting != null)
         {
            mCallbackOnPutting (finished);
         }
      }

   }
   
}
