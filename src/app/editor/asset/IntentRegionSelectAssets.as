package editor.asset {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;

   public class IntentRegionSelectAssets extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      protected var mOldSelectedAssets:Array;
      
      public function IntentRegionSelectAssets (assetManagerPanel:AssetManagerPanel, oldSelectedAssets:Array)
      {
         mAssetManagerPanel = assetManagerPanel;
         
         mOldSelectedAssets = oldSelectedAssets;
      }
      
   //================================================================
   // to override 
   //================================================================
      
      private var mBoxShape:Shape = null;

      override protected function Process (triggeredByMouseUp:Boolean):void
      {
         var left:Number   = mStartX < mCurrentX ? mStartX : mCurrentX;
         var right:Number  = mStartX >= mCurrentX ? mStartX : mCurrentX;
         var top:Number    = mStartY < mCurrentY ? mStartY : mCurrentY;
         var bottom:Number = mStartY >= mCurrentY ? mStartY : mCurrentY;
         
         var w:int = right - left;
         var h:int = bottom - top;
         
         var point1:Point = mAssetManagerPanel.ManagerToView (new Point (left, top));
         var point2:Point = mAssetManagerPanel.ManagerToView (new Point (right, bottom));
         
         if (mBoxShape == null)
         {
            mBoxShape = new Shape ();
            mAssetManagerPanel.mForegroundLayer.addChild (mBoxShape);
         }
         
         GraphicsUtil.ClearAndDrawRect (mBoxShape, point1.x, point1.y, point2.x - point1.x, point2.y - point1.y);
         
         mAssetManagerPanel.RegionSelectAssets (left, top, right, bottom, mOldSelectedAssets);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         if (mBoxShape != null && mAssetManagerPanel.mForegroundLayer.contains (mBoxShape))
         {
            mAssetManagerPanel.mForegroundLayer.removeChild (mBoxShape);
         }
         
         if (passively && mAssetManagerPanel.IsMouseZeroMove ())
         {
            mAssetManagerPanel.PointSelectAsset (mCurrentX, mCurrentY); // (mAssetManager.mouseX, mAssetManager.mouseY)
         }
      }

   }
   
}

