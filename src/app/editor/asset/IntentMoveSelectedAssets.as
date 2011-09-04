package editor.asset {

   public class IntentMoveSelectedAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      public function IntentMoveSelectedAssets (assetManagerPanel:AssetManagerPanel)
      {
         mAssetManagerPanel = assetManagerPanel;
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
         
         mAssetManagerPanel.MoveSelectedAssets (dx, dy, finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         mAssetManagerPanel.MoveSelectedAssets (0, 0, true);
      }
      
  }
   
}
