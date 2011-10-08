package editor.asset {

   public class IntentRotateSelectedAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      protected var mCenterX:Number;
      protected var mCenterY:Number;
      protected var mRotatePosition:Boolean;
      protected var mRotateSelf:Boolean;
      
      public function IntentRotateSelectedAssets (assetManagerPanel:AssetManagerPanel, centerX:Number, centerY:Number, rotatePosition:Boolean, rotateSelf:Boolean)
      {
         mAssetManagerPanel = assetManagerPanel;
         mCenterX = centerX;
         mCenterY = centerY;
         mRotatePosition = rotatePosition;
         mRotateSelf = rotateSelf;
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
         
         var lastAngle:Number = Math.atan2 (mLastY - mCenterY, mLastX - mCenterX);
         var currentAngle:Number = Math.atan2 (mCurrentY - mCenterY, mCurrentX - mCenterX);
         
         mLastX = mCurrentX;
         mLastY = mCurrentY;
      
         if (currentAngle != lastAngle)
         {
            mAssetManagerPanel.RotateSelectedAssets (mCenterX, mCenterY, currentAngle - lastAngle, mRotatePosition, mRotateSelf, false);
         }
         
         super.Process (finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         mAssetManagerPanel.RotateSelectedAssets (mCenterX, mCenterY, 0, mRotatePosition, mRotateSelf, true);
         
         super.TerminateInternal (passively);
      }
      
  }
   
}
