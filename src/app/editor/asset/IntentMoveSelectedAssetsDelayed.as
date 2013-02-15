package editor.asset {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;

   public class IntentMoveSelectedAssetsDelayed extends IntentDrag
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      
      // the layout of assetManagerPanel must be ArrayLayout or ListLayout
      public function IntentMoveSelectedAssetsDelayed (assetManagerPanel:AssetManagerPanel)
      {
         mAssetManagerPanel = assetManagerPanel;
      }
      
   //================================================================
   // to override 
   //================================================================
      
      protected var mMoveIntentConfirmed:Boolean = false;
      
      protected var mInsertionHintSprite:Shape = null;
      protected var mLastHintSpriteStartX:Number = 0x7FFFFFFF;
      protected var mLastHintSpriteStartY:Number = 0x7FFFFFFF;
      protected var mLastHintSpriteWidth:Number = 0x7FFFFFFF;
      protected var mLastHintSpriteHeight:Number = 0x7FFFFFFF;
      
      override protected function Process (finished:Boolean):void
      {
         var layout:AssetManagerLayout = mAssetManagerPanel.GetAssetManager ().GetLayout ();
         if (layout == null)
            return;
         
         var cellSize:Number = layout.GetAssetSpriteWidth ();
         if (cellSize > layout.GetAssetSpriteHeight ())
            cellSize = layout.GetAssetSpriteHeight ();
         
         if (! mMoveIntentConfirmed)
         {
            var dx:Number = mCurrentX - mStartX;
            var dy:Number = mCurrentY - mStartY;
            
            if (Math.sqrt (dx * dx + dy * dy) > 0.5 * cellSize)
            {
               mMoveIntentConfirmed = true;
            }
         }
         
         if (mMoveIntentConfirmed)
         {
            var insertionPoint:Point = new Point ();
            var beforeIndex:int = layout.GetInsertionInfo (new Point (mCurrentX, mCurrentY), insertionPoint);
            if (finished)
            {
               mAssetManagerPanel.GetAssetManager ().MoveSelectedAssetsToIndex (beforeIndex);
               mAssetManagerPanel.GetAssetManager ().UpdateLayout (true);
            }
            else
            {
               if (mInsertionHintSprite == null)
               {
                  mInsertionHintSprite = new Shape ();
                  mInsertionHintSprite.alpha = 0.7;
                  mAssetManagerPanel.mForegroundLayer.addChild (mInsertionHintSprite);
               }
               
               // assume manager has no angle offset to panel
               var panelPoint1:Point = mAssetManagerPanel.ManagerToPanel (new Point (0, 0));
               var panelPoint2:Point = mAssetManagerPanel.ManagerToPanel (new Point (0, layout.GetAssetSpriteHeight ()));
               insertionPoint = mAssetManagerPanel.ManagerToPanel (insertionPoint);
               
               var hintSpriteStartX:Number = insertionPoint.x;
               var hintSpriteStartY:Number = insertionPoint.y;
               var hintSpriteEndWidth:Number = 5;
               var hintSpriteEndHeight:Number = Math.abs (panelPoint2.y - panelPoint1.y);
               
               if (mLastHintSpriteStartX != hintSpriteStartX || mLastHintSpriteStartY != hintSpriteStartY
                  || mLastHintSpriteWidth != hintSpriteEndWidth || mLastHintSpriteHeight != hintSpriteEndHeight)
               {
                  GraphicsUtil.ClearAndDrawRect (mInsertionHintSprite, 
                                                 hintSpriteStartX - 0.5 * hintSpriteEndWidth,
                                                 hintSpriteStartY - 0.5 * hintSpriteEndHeight, 
                                                 hintSpriteEndWidth, 
                                                 hintSpriteEndHeight, 
                                                 0x0, -1, true, 0x008000);
                  
                  mLastHintSpriteStartX = hintSpriteStartX;
                  mLastHintSpriteStartY = hintSpriteStartY;
                  mLastHintSpriteWidth = hintSpriteEndWidth;
                  mLastHintSpriteHeight = hintSpriteEndHeight;
               }
            }
         }
      }
      
      override protected function TerminateInternal (passively:Boolean):void
      {
         if (mInsertionHintSprite != null && mAssetManagerPanel.mForegroundLayer.contains (mInsertionHintSprite))
         {
            mAssetManagerPanel.mForegroundLayer.removeChild (mInsertionHintSprite);
         }
         
         if (! passively)
         {
            // confirm moving selected entities
         }
         
         super.TerminateInternal (passively);
      }
      
  }
   
}
