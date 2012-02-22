package editor.asset {

   public class IntentScaleSelectedAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      protected var mCenterX:Number;
      protected var mCenterY:Number;
      protected var mScalePosition:Boolean;
      protected var mScaleSelf:Boolean;
      
      public function IntentScaleSelectedAssets (assetManagerPanel:AssetManagerPanel, centerX:Number, centerY:Number, scalePosition:Boolean, scaleSelf:Boolean)
      {
         mAssetManagerPanel = assetManagerPanel;
         mCenterX = centerX;
         mCenterY = centerY;
         mScalePosition = scalePosition;
         mScaleSelf = scaleSelf;
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
         
         var startLength:Number    = Math.sqrt ((mStartY    - mCenterY) * (mStartY    - mCenterY) + (mStartX    - mCenterX) * (mStartX    - mCenterX));
         var lastLength:Number    = Math.sqrt ((mLastY    - mCenterY) * (mLastY    - mCenterY) + (mLastX    - mCenterX) * (mLastX    - mCenterX));
         var currentLength:Number = Math.sqrt ((mCurrentY - mCenterY) * (mCurrentY - mCenterY) + (mCurrentX - mCenterX) * (mCurrentX - mCenterX));
         
         if (currentLength > 0 && currentLength != lastLength)
         {
            mLastX = mCurrentX;
            mLastY = mCurrentY;
            mAssetManagerPanel.ScaleSelectedAssets (mCenterX, mCenterY, currentLength / lastLength, mScalePosition, mScaleSelf, false);
            mAssetManagerPanel.RepositionScaleRotateFlipHandlers (currentLength / startLength, 0.0);
         }
         
         super.Process (finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         mAssetManagerPanel.ScaleSelectedAssets (mCenterX, mCenterY, 1.0, mScalePosition, mScaleSelf, true);
         mAssetManagerPanel.RepositionScaleRotateFlipHandlers (1.0, 0.0);
         
         super.TerminateInternal (passively);
      }
      
  }
   
}
