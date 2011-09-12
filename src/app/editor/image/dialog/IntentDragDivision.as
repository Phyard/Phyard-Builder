package editor.image.dialog {

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
         var left:int   = mStartX < mCurrentX ? mStartX : mCurrentX;
         var right:int = mStartX >= mCurrentX ? mStartX : mCurrentX;
         var top:int    = mStartY < mCurrentY ? mStartY : mCurrentY;
         var bottom:int = mStartY >= mCurrentY ? mStartY : mCurrentY;
         
         var w:int = right - left;
         var h:int = bottom - top;
         
         var point1:Point = mAssetImageDividingPanel.ManagerToView (new Point (left, top));
         var point2:Point = mAssetImageDividingPanel.ManagerToView (new Point (right, bottom));
         
         if (mBoxShape == null)
         {
            mBoxShape = new Shape ();
            mAssetImageDividingPanel.mForegroundLayer.addChild (mBoxShape);
            mBoxShape.alpha = 0.5;
         }
         
         GraphicsUtil.ClearAndDrawRect (mBoxShape, point1.x, point1.y, point2.x - point1.x, point2.y - point1.y, 0x0000FF, 0, true, 0xC0C0FF, false);

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
