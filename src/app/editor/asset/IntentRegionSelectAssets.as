package editor.asset {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;

   public class IntentRegionSelectAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      protected var mOldSelectedAssets:Array;
      
      protected var mHasAsstsUnderStartPoint:Boolean; // for cookie mode only
      
      public function IntentRegionSelectAssets (assetManagerPanel:AssetManagerPanel, oldSelectedAssets:Array, hasAsstsUnderStartPoint:Boolean = false)
      {
         mAssetManagerPanel = assetManagerPanel;
         
         mOldSelectedAssets = oldSelectedAssets;
         
         mHasAsstsUnderStartPoint = hasAsstsUnderStartPoint;
      }
      
   //================================================================
   // to override 
   //================================================================
      
      private var mBoxShape:Shape = null;

      override protected function Process (finished:Boolean):void
      {
         var left:Number   = mStartX < mCurrentX ? mStartX : mCurrentX;
         var right:Number  = mStartX >= mCurrentX ? mStartX : mCurrentX;
         var top:Number    = mStartY < mCurrentY ? mStartY : mCurrentY;
         var bottom:Number = mStartY >= mCurrentY ? mStartY : mCurrentY;
         
         var w:int = right - left;
         var h:int = bottom - top;
         
         var point1:Point = mAssetManagerPanel.ManagerToPanel (new Point (left, top));
         var point2:Point = mAssetManagerPanel.ManagerToPanel (new Point (right, bottom));
         
         if (mBoxShape == null)
         {
            mBoxShape = new Shape ();
            mAssetManagerPanel.mForegroundLayer.addChild (mBoxShape);
         }
         
         GraphicsUtil.ClearAndDrawRect (mBoxShape, point1.x, point1.y, point2.x - point1.x, point2.y - point1.y);
         
         mAssetManagerPanel.RegionSelectAssets (left, top, right, bottom, mOldSelectedAssets);
         
         super.Process (finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         if (mBoxShape != null && mAssetManagerPanel.mForegroundLayer.contains (mBoxShape))
         {
            mAssetManagerPanel.mForegroundLayer.removeChild (mBoxShape);
         }
         
trace ("111 passively = " + passively);
         if (! passively)
         {
trace ("111 mAssetManagerPanel.IsMouseZeroMoveSinceLastDownInCookieMode () = " + mAssetManagerPanel.IsMouseZeroMoveSinceLastDownInCookieMode ());
            if ((! mHasAsstsUnderStartPoint) && mAssetManagerPanel.IsMouseZeroMoveSinceLastDownInCookieMode ())
               mAssetManagerPanel.CancelAllAssetSelections ();
         }
         
         super.TerminateInternal (passively);
      }

   }
   
}

