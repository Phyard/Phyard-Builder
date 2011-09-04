package editor.image {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.asset.IntentDrag;

   public class IntentDragDivision extends IntentDrag
   {
      protected var mAssetImageDividingPanel:AssetImageDividingPanel;
      
      public function IntentDragDivision (assetImageDividingPanel:AssetImageDividingPanel)
      {
         mAssetImageDividingPanel = assetImageDividingPanel;
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
         
         var point1:Point = mAssetImageDividingPanel.ManagerToView (new Point (left, top));
         var point2:Point = mAssetImageDividingPanel.ManagerToView (new Point (top, bottom));
         
         if (mBoxShape == null)
         {
            mBoxShape = new Shape ();
            mAssetImageDividingPanel.mForegroundLayer.addChild (mBoxShape);
            mBoxShape.alpha = 0.5;
         }
         
         GraphicsUtil.ClearAndDrawRect (mBoxShape, point1.x, point1.y, w, h, 0x00FF00, 0, true, 0xC0C0FF, false);

         if (finished)
         {
            mAssetImageDividingPanel.CreateImageDivision (left, top, right, bottom);
         }
      }
      
      override protected function ShouldTerminateIfNotHoldInMoving ():Boolean
      {
         return false;
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         if (mBoxShape != null && mAssetImageDividingPanel.mForegroundLayer.contains (mBoxShape))
         {
            mAssetImageDividingPanel.mForegroundLayer.removeChild (mBoxShape);
         }
      }

   }
   
}
