package editor.asset {

   public class IntentRotateSelectedAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      protected var mCenterX:Number;
      protected var mCenterY:Number;
      protected var mRotatePosition:Boolean;
      protected var mRotateSelf:Boolean;
      
      protected var mRotateBodyTexture:Boolean;
      
      public function IntentRotateSelectedAssets (assetManagerPanel:AssetManagerPanel, rotateBodyTexture:Boolean, centerX:Number, centerY:Number, rotatePosition:Boolean, rotateSelf:Boolean)
      {
         mAssetManagerPanel = assetManagerPanel;
         mCenterX = centerX;
         mCenterY = centerY;
         mRotatePosition = rotatePosition;
         mRotateSelf = rotateSelf;
         
         mRotateBodyTexture = rotateBodyTexture;
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
         
         var startAngle:Number = Math.atan2 (mStartY - mCenterY, mStartX - mCenterX);
         var lastAngle:Number = Math.atan2 (mLastY - mCenterY, mLastX - mCenterX);
         var currentAngle:Number = Math.atan2 (mCurrentY - mCenterY, mCurrentX - mCenterX);
         
         mLastX = mCurrentX;
         mLastY = mCurrentY;
      
         if (currentAngle != lastAngle)
         {
            mAssetManagerPanel.RotateSelectedAssets (mRotateBodyTexture, mCenterX, mCenterY, currentAngle - lastAngle, mRotatePosition, mRotateSelf, false);
            
            mAssetManagerPanel.RepositionScaleRotateFlipHandlers (1.0, currentAngle - startAngle);
         }
         
         super.Process (finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         mAssetManagerPanel.RotateSelectedAssets (mRotateBodyTexture, mCenterX, mCenterY, 0, mRotatePosition, mRotateSelf, true);
         
         mAssetManagerPanel.RepositionScaleRotateFlipHandlers (1.0, 0.0);
         
         super.TerminateInternal (passively);
      }
      
  }
   
}
