package editor.image.dialog {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.asset.IntentDrag;

   public class IntentDragDivision extends IntentDrag
   {
      protected var mAssetImageDividePanel:AssetImageDividePanel;
      
      public function IntentDragDivision (assetImageDividingPanel:AssetImageDividePanel)
      {
         mAssetImageDividePanel = assetImageDividingPanel;
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
         
         var point1:Point = mAssetImageDividePanel.ManagerToPanel (new Point (left, top));
         var point2:Point = mAssetImageDividePanel.ManagerToPanel (new Point (right, bottom));
         
         if (mBoxShape == null)
         {
            mBoxShape = new Shape ();
            mAssetImageDividePanel.mForegroundLayer.addChild (mBoxShape);
            mBoxShape.alpha = 0.5;
         }
         
         GraphicsUtil.ClearAndDrawRect (mBoxShape, point1.x, point1.y, point2.x - point1.x, point2.y - point1.y, 0x0000FF, 0, true, 0xC0C0FF, false);

         if (finished)
         {
            mAssetImageDividePanel.CreateImageDivision (left, top, right, bottom);
         }
      }
      
      override protected function ShouldTerminateIfNotHoldInMoving ():Boolean
      {
         return false;
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         if (mBoxShape != null && mAssetImageDividePanel.mForegroundLayer.contains (mBoxShape))
         {
            mAssetImageDividePanel.mForegroundLayer.removeChild (mBoxShape);
         }
      }

   }
   
}
