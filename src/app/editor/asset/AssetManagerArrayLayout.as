
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Matrix;
   
   import flash.events.Event;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetManagerArrayLayout extends AssetManagerLayout 
   {
      private var mAssetManager:AssetManager;
      
      public function AssetManagerArrayLayout (assetManager:AssetManager, assetSpriteSize:Number = 100, assetSpriteGap:Number = 10)
      {
         mAssetManager = assetManager;
         
         mAssetSpriteSize = assetSpriteSize;
         mAssetSpriteGap = assetSpriteGap;
      }
      
      private var mAssetSpriteSize:Number = 100;
      
      private function GetAssetSpriteSize ():Number
      {
         return mAssetSpriteSize;
      }

      override public function GetAssetSpriteWidth ():Number
      {
         return mAssetSpriteSize;
      }
      
      override public function GetAssetSpriteHeight ():Number
      {
         return mAssetSpriteSize;
      }
      
      private var mAssetSpriteGap:Number = 10;
      
      override public function GetAssetSpriteGap ():Number
      {
         return mAssetSpriteGap;
      }
      
//========================================================
// 
//========================================================
      
      override public function SupportScaleRotateFlipTransforms ():Boolean
      {
         return false;
      }
      
      //override public function SupportSmoothMoveSelectedAssets ():Boolean
      //{
      //   return false;
      //}
      
      override public function GetMoveSelectedAssetsStyle ():int
      {
         return AssetManagerPanel.kMoveSelectedAssetsStyle_Delayed;
      }
      
//========================================================
// 
//========================================================

      protected var mNumColumns:int = 0;
      protected var mContentWidth:Number;
      protected var mContentHeight:Number;
      
      override public function DoLayout (forcely:Boolean = false, alsoUpdateAssetAppearance:Boolean = false):void
      {
         DoLayoutOrGetInsertionInfo (forcely, alsoUpdateAssetAppearance);
      }
      
      private function DoLayoutOrGetInsertionInfo (forcely:Boolean = false, alsoUpdateAssetAppearance:Boolean = false, insertionPoint:Point = null):Array
      {
         if (mAssetManager.parent != null)
         {
            var managerViewWidth:Number  = mAssetManager.parent.width  / mAssetManager.scaleX;
            var managerViewHeight:Number = mAssetManager.parent.height / mAssetManager.scaleY;
            
            var cellSize:Number = GetAssetSpriteSize () + GetAssetSpriteGap ();
            var numCols:int = Math.floor ((managerViewWidth - GetAssetSpriteGap ()) / cellSize);
            if (numCols < 1)
               numCols = 1;
            
            var numAssets:int = mAssetManager.GetNumAssets ();
   
            if (numCols != mNumColumns || forcely)
            {
               mNumColumns = numCols;
               
               mContentWidth  = GetAssetSpriteGap () + mNumColumns * cellSize;
               mContentHeight = GetAssetSpriteGap ();
               
               var col:int = 0;
               var maxRowHeight:Number = 0;
               for (var i:int = 0; i < numAssets; ++ i)
               {
                  var asset:Asset = mAssetManager.GetAssetByAppearanceId (i);
                  if (alsoUpdateAssetAppearance)
                     asset.UpdateAppearance ();
                  
                  var boundRect:Rectangle = asset.getBounds (asset);
                  if (boundRect.height > maxRowHeight)
                     maxRowHeight = boundRect.height;
                  
                  asset.SetPosition (GetAssetSpriteGap () + col * cellSize - boundRect.left, mContentHeight - boundRect.top);
                  asset.UpdateSelectionProxy ();
                  
                  if (insertionPoint != null)
                  {
                     if (insertionPoint.y < asset.GetPositionY () + boundRect.top
                         || insertionPoint.x < asset.GetPositionX () + 0.5 * (boundRect.left + boundRect.right)
                            && insertionPoint.y < asset.GetPositionY () + boundRect.bottom)
                     {
                        return [i, 
                                asset.GetPositionX () + boundRect.left - 0.5 * GetAssetSpriteGap (), 
                                asset.GetPositionY () + 0.5 * (boundRect.top + boundRect.bottom),
                                true
                                ];
                     }
                     else if (i == numAssets - 1)
                     {
                        return [numAssets, 
                                asset.GetPositionX () + boundRect.right + 0.5 * GetAssetSpriteGap (), 
                                asset.GetPositionY () + 0.5 * (boundRect.top + boundRect.bottom),
                                true
                                ];
                     }
                  }
                  
                  if (++ col == mNumColumns || (i == numAssets - 1))
                  {
                     mContentHeight += maxRowHeight + GetAssetSpriteGap ();
                     col = 0;
                     maxRowHeight = 0;
                  }
               }
            }
            
            if (mContentWidth < managerViewWidth)
               mAssetManager.x = 0;
            else if (mAssetManager.x > 0)
               mAssetManager.x = 0;
            else
            {
               var minX:Number = (managerViewWidth - mContentWidth) * mAssetManager.scaleX;
               if (mAssetManager.x < minX)
               {
                  mAssetManager.x = minX;
               }
            }
            
            if (mContentHeight < managerViewHeight)
               mAssetManager.y = 0;
            else if (mAssetManager.y > 0)
               mAssetManager.y = 0;
            else
            {
               var minY:Number = (managerViewHeight - mContentHeight) * mAssetManager.scaleY;
               if (mAssetManager.y < minY)
               {
                  mAssetManager.y = minY;
               }
            }
         }
         
         return null;
      }
      
      override public function GetInsertionInfo (insertionPoint:Point):Array
      {
         return DoLayoutOrGetInsertionInfo (true, false, insertionPoint);
      }
   }
}

