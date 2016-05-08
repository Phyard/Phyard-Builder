package editor.asset {

   public class IntentMoveControlPoint extends IntentDrag
   {
      protected var mControlPoint:ControlPoint;
      
      public function IntentMoveControlPoint (controlPoint:ControlPoint)
      {
         mControlPoint = controlPoint;
      }
      
   //================================================================
   // to override 
   //================================================================
      
      protected var mFirstTime:Boolean = true;
      protected var mLastX:Number;
      protected var mLastY:Number;
      
      override protected function Process (finished:Boolean):void
      {
         if (mFirstTime)
         {
            mLastX = mStartX;
            mLastY = mStartY;
            mFirstTime = false;
         }
         
         var dx:Number = mCurrentX - mLastX;
         var dy:Number = mCurrentY - mLastY;
         
         mLastX = mCurrentX;
         mLastY = mCurrentY;
         
         mControlPoint.GetOwnerAsset ().MoveControlPoint (mControlPoint, dx, dy, false);
         
         super.Process (finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         mControlPoint.GetOwnerAsset ().MoveControlPoint (mControlPoint, 0, 0, true);
         
         super.TerminateInternal (passively);
      }
  }
   
}
