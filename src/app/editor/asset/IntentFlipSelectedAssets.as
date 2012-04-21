package editor.asset {

   import flash.geom.Point;

   public class IntentFlipSelectedAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      protected var mCenterX:Number;
      protected var mCenterY:Number;
      protected var mHandlerY:Number;
      protected var mFlipPosition:Boolean;
      protected var mFlipSelf:Boolean;
      protected var mFlipVertically:Boolean = false;
      
      protected var mFlipBodyTexture:Boolean;
      
      public function IntentFlipSelectedAssets (assetManagerPanel:AssetManagerPanel, flipBodyTexture:Boolean, centerX:Number, centerY:Number, handlerY:Number, flipPosition:Boolean, flipSelf:Boolean, flipVertically:Boolean)
      {
         mAssetManagerPanel = assetManagerPanel;
         mCenterX = centerX;
         mCenterY = centerY;
         mHandlerY = handlerY;
         mFlipPosition = flipPosition;
         mFlipSelf = flipSelf;
         mFlipVertically = flipVertically;
         
         mFlipBodyTexture = flipBodyTexture;
      }
      
   //================================================================
   // to override 
   //================================================================
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         var viewStartPoint:Point = mAssetManagerPanel.ManagerToPanel (new Point (mCenterX, mHandlerY));
         var viewEndPoint:Point = mAssetManagerPanel.ManagerToPanel (new Point (mCurrentX, mCurrentY));
         var dx:Number = viewEndPoint.x - viewStartPoint.x;
         var dy:Number = viewEndPoint.y - viewStartPoint.y;
         var length:Number = Math.sqrt (dx * dx + dy * dy);
         if (length < 8)
         {
            if (mFlipVertically)
               mAssetManagerPanel.RotateSelectedAssets (mFlipBodyTexture, mCenterX, mCenterY, Math.PI, mFlipPosition, mFlipSelf, false);
            
            mAssetManagerPanel.FlipSelectedAssets (mFlipBodyTexture, mCenterX, mFlipPosition, mFlipSelf, true);
         }
      }
      
  }
   
}
