package editor.asset {

   import flash.geom.Point;

   public class IntentMoveSelectedAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      protected var mMoveBodyTexture:Boolean;
      
      protected var mPerformPointSelectOnUpIfZeroMouseMove:Boolean;
      
      public function IntentMoveSelectedAssets (assetManagerPanel:AssetManagerPanel, moveBodyTexture:Boolean, performPointSelectOnUpIfZeroMouseMove:Boolean)
      {
         mAssetManagerPanel = assetManagerPanel;
         
         mMoveBodyTexture = moveBodyTexture;
         
         mPerformPointSelectOnUpIfZeroMouseMove = performPointSelectOnUpIfZeroMouseMove;
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
         
         mAssetManagerPanel.MoveSelectedAssets (mMoveBodyTexture, dx, dy, false);
         
         //
         var startPanelPoint:Point = mAssetManagerPanel.ManagerToPanel (new Point (mLastX, mLastY));
         var endPanelPoint:Point = mAssetManagerPanel.ManagerToPanel (new Point (mCurrentX, mCurrentY));
         dx = endPanelPoint.x - startPanelPoint.x;
         dy = endPanelPoint.y - startPanelPoint.y;
         
         mAssetManagerPanel.MoveScaleRotateFlipHandlers (dx, dy);
         
         //
         
         mLastX = mCurrentX;
         mLastY = mCurrentY;
         
         super.Process (finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         mAssetManagerPanel.MoveSelectedAssets (mMoveBodyTexture, 0, 0, true);
         
         if (! passively)
         {
            //if (mAssetManagerPanel.IsMouseZeroMoveSinceLastDown ())
            //if (mAssetManagerPanel.IsMouseZeroMoveSinceLastDownInCookieMode ())
            if (mAssetManagerPanel.IsMouseZeroMoveSinceLastDown () && (mPerformPointSelectOnUpIfZeroMouseMove || mAssetManagerPanel.IsCookieSelectMode ()))
            {
               mAssetManagerPanel.PointSelectAsset (mCurrentX, mCurrentY); //mAssetManager.mouseX, mAssetManager.mouseY);
            }
         }
         
         super.TerminateInternal (passively);
      }
      
  }
   
}
