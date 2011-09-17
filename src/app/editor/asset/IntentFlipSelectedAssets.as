package editor.asset {

   import flash.geom.Point;

   public class IntentFlipSelectedAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      protected var mCenterX:Number; // handler positon
      protected var mCenterY:Number;
      protected var mFlipPosition:Boolean;
      protected var mFlipSelf:Boolean;
      
      public function IntentFlipSelectedAssets (assetManagerPanel:AssetManagerPanel, centerX:Number, centerY:Number, flipPosition:Boolean, flipSelf:Boolean)
      {
         mAssetManagerPanel = assetManagerPanel;
         mCenterX = centerX;
         mCenterY = centerY;
         mFlipPosition = flipPosition;
         mFlipSelf = flipSelf;
      }
      
   //================================================================
   // to override 
   //================================================================
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         var viewStartPoint:Point = mAssetManagerPanel.ManagerToView (new Point (mCenterX, mCenterY));
         var viewEndPoint:Point = mAssetManagerPanel.ManagerToView (new Point (mCurrentX, mCurrentY));
         var dx:Number = viewEndPoint.x - viewStartPoint.x;
         var dy:Number = viewEndPoint.y - viewStartPoint.y;
         var length:Number = Math.sqrt (dx * dx + dy * dy);
         if (length < 8)
         {
            mAssetManagerPanel.FlipSelectedAssets (mCenterX, mFlipPosition, mFlipSelf, true);
         }
      }
      
  }
   
}
