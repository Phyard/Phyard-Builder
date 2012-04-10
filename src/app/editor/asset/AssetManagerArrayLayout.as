
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.geom.Rectangle;
   
   import flash.events.Event;
   
   import editor.selection.SelectionEngine;
   
   import editor.core.EditorObject;
   
   import common.CoordinateSystem;
   
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
      
      override public function SupportMoveSelectedAssets ():Boolean
      {
         return false;
      }
      
//========================================================
// 
//========================================================

      protected var mNumColumns:int = 0;
      protected var mContentWidth:Number;
      protected var mContentHeight:Number;
      
      override public function DoLayout (forcely:Boolean = false):void
      {
         if (mAssetManager.parent == null)
            return;
         
         mAssetManager.mViewWidth  = mAssetManager.parent.width  / mAssetManager.scaleX;
         mAssetManager.mViewHeight = mAssetManager.parent.height / mAssetManager.scaleY;
         
         var cellSize:Number = GetAssetSpriteSize () + GetAssetSpriteGap ();
         var numCols:int = Math.floor ((mAssetManager.mViewWidth - GetAssetSpriteGap ()) / cellSize);
         if (numCols < 1)
            numCols = 1;
         
         if (numCols != mNumColumns || forcely)
         {
            mNumColumns = numCols;
            
            mContentWidth  = GetAssetSpriteGap () + mNumColumns * cellSize;
            mContentHeight = GetAssetSpriteGap ();
            
            var col:int = 0;
            var maxRowHeight:Number = 0;
            var numAssets:int = mAssetManager.GetNumAssets ();
            for (var i:int = 0; i < numAssets; ++ i)
            {
               var asset:Asset = mAssetManager.GetAssetByAppearanceId (i);
               var boundRect:Rectangle = asset.getBounds (asset);
               if (boundRect.height > maxRowHeight)
                  maxRowHeight = boundRect.height;
               
               asset.SetPosition (GetAssetSpriteGap () + col * cellSize - boundRect.left, mContentHeight - boundRect.top);
               asset.UpdateSelectionProxy ();
               
               if (++ col == mNumColumns || i == numAssets)
               {
                  mContentHeight += maxRowHeight + GetAssetSpriteGap ();
                  col = 0;
                  maxRowHeight = 0;
               }
            }
         }
         
         if (mContentWidth < mAssetManager.mViewWidth)
            mAssetManager.x = 0;
         else if (mAssetManager.x > 0)
            mAssetManager.x = 0;
         else
         {
            var minX:Number = (mAssetManager.mViewWidth - mContentWidth) * mAssetManager.scaleX;
            if (mAssetManager.x < minX)
            {
               mAssetManager.x = minX;
            }
         }
         
         if (mContentHeight < mAssetManager.mViewHeight)
            mAssetManager.y = 0;
         else if (mAssetManager.y > 0)
            mAssetManager.y = 0;
         else
         {
            var minY:Number = (mAssetManager.mViewHeight - mContentHeight) * mAssetManager.scaleY;
            if (mAssetManager.y < minY)
            {
               mAssetManager.y = minY;
            }
         }
      }
      
      // ?
      //protected function GetAssetIdBeforeModuleId (posX:Number, posY:Number):int
      //{
      //   return 0;
      //}
   }
}

