package editor.asset {

   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;

   public class IntentDragLink extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      private var mStartLinkable:Linkable;
      
      public function IntentDragLink (assetManagerPanel:AssetManagerPanel, startLinkable:Linkable)
      {
         mAssetManagerPanel = assetManagerPanel;
         
         mStartLinkable = startLinkable;
      }
      
   //================================================================
   // to override 
   //================================================================
   
      private var mLineShape:Shape = null;
      
      override protected function Process (finished:Boolean):void
      {
         if (finished)
         {
            mAssetManagerPanel.CreateOrBreakAssetLink (mStartLinkable, mStartX, mStartY, mCurrentX, mCurrentY);
         }
         else
         {
            var point1:Point = mAssetManagerPanel.ManagerToPanel (new Point (mStartX, mStartY));
            var point2:Point = mAssetManagerPanel.ManagerToPanel (new Point (mCurrentX, mCurrentY));
            
            if (mLineShape == null)
            {
               mLineShape = new Shape ();
               mAssetManagerPanel.mForegroundLayer.addChild (mLineShape);
            }
            
            GraphicsUtil.ClearAndDrawLine (mLineShape, point1.x, point1.y, point2.x, point2.y, 0x0000FF, 2);
         }
         
         super.Process (finished);
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         if (mLineShape != null && mAssetManagerPanel.mForegroundLayer.contains (mLineShape))
         {
            mAssetManagerPanel.mForegroundLayer.removeChild (mLineShape);
         }
         
         super.TerminateInternal (passively);
      }

   }
   
}
