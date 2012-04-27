package editor.asset {

   public class IntentMoveSelectedAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      protected var mMoveBodyTexture:Boolean;
      
      public function IntentMoveSelectedAssets (assetManagerPanel:AssetManagerPanel, moveBodyTexture:Boolean)
      {
         mAssetManagerPanel = assetManagerPanel;
         
         mMoveBodyTexture = moveBodyTexture;
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
         
         mAssetManagerPanel.MoveSelectedAssets (mMoveBodyTexture, dx, dy, false);
         
         super.Process (finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         mAssetManagerPanel.MoveSelectedAssets (mMoveBodyTexture, 0, 0, true);
         
trace ("222 passively = " + passively);
         if (! passively)
         {
trace ("222 mAssetManagerPanel.IsMouseZeroMoveSinceLastDownInCookieMode () = " + mAssetManagerPanel.IsMouseZeroMoveSinceLastDownInCookieMode ());
            if (mAssetManagerPanel.IsMouseZeroMoveSinceLastDownInCookieMode ())
               mAssetManagerPanel.PointSelectAsset (mCurrentX, mCurrentY); //mAssetManager.mouseX, mAssetManager.mouseY);
         }
         
         super.TerminateInternal (passively);
      }
      
  }
   
}
