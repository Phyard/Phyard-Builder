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
      protected var mLastHintSpriteCenterX:Number = 0x7FFFFFFF;
      protected var mLastHintSpriteCenterY:Number = 0x7FFFFFFF;
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
            var insertionInfo:Array = layout.GetInsertionInfo (new Point (mCurrentX, mCurrentY));
            var beforeIndex:int = insertionInfo [0];
            var correctedPointX:Number = insertionInfo [1];
            var correctedPointY:Number = insertionInfo [2];
            var isVerticalHint:Boolean = insertionInfo [3];
            
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
               var panelPoint1:Point;
               var panelPoint2:Point;
               var hintSpriteEndWidth:Number;
               var hintSpriteEndHeight:Number;
               
               if (isVerticalHint)
               {
                  panelPoint1 = mAssetManagerPanel.ManagerToPanel (new Point (0, 0));
                  panelPoint2 = mAssetManagerPanel.ManagerToPanel (new Point (0, layout.GetAssetSpriteHeight ()));
   
                  hintSpriteEndWidth = 5;
                  hintSpriteEndHeight = Math.abs (panelPoint2.y - panelPoint1.y);
               }
               else
               {
                  panelPoint1 = mAssetManagerPanel.ManagerToPanel (new Point (0, 0));
                  panelPoint2 = mAssetManagerPanel.ManagerToPanel (new Point (layout.GetAssetSpriteWidth (), 0));
   
                  hintSpriteEndWidth = Math.abs (panelPoint2.x - panelPoint1.x);
                  hintSpriteEndHeight = 5;
               }
               
               var insertionPoint:Point = mAssetManagerPanel.ManagerToPanel (new Point (correctedPointX, correctedPointY));
               
               if (mLastHintSpriteCenterX != insertionPoint.x || mLastHintSpriteCenterY != insertionPoint.y
                  || mLastHintSpriteWidth != hintSpriteEndWidth || mLastHintSpriteHeight != hintSpriteEndHeight)
               {
                  GraphicsUtil.ClearAndDrawRect (mInsertionHintSprite, 
                                                 insertionPoint.x - 0.5 * hintSpriteEndWidth,
                                                 insertionPoint.y - 0.5 * hintSpriteEndHeight, 
                                                 hintSpriteEndWidth, 
                                                 hintSpriteEndHeight, 
                                                 0x0, -1, true, 0x008000);
                  
                  mLastHintSpriteCenterX = insertionPoint.x;
                  mLastHintSpriteCenterY = insertionPoint.y;
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
