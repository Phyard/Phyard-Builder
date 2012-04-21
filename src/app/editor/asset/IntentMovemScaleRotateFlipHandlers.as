package editor.asset {

   import flash.geom.Point;

   public class IntentMovemScaleRotateFlipHandlers extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      public function IntentMovemScaleRotateFlipHandlers (assetManagerPanel:AssetManagerPanel)
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
         
         var startPoint:Point = mAssetManagerPanel.ManagerToPanel (new Point (mLastX, mLastY));
         var endPoint:Point = mAssetManagerPanel.ManagerToPanel (new Point (mCurrentX, mCurrentY));
         var dx:Number = endPoint.x - startPoint.x;
         var dy:Number = endPoint.y - startPoint.y;
         
         mLastX = mCurrentX;
         mLastY = mCurrentY;
         
         mAssetManagerPanel.MoveScaleRotateFlipHandlers (dx, dy);
         
         super.Process (finished);
      }
      
  }
   
}
