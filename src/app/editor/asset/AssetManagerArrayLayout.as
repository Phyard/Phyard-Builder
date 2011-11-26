
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.geom.Rectangle;
   
   import flash.events.Event;
   
   import editor.selection.SelectionEngine;
   
   import editor.core.EditorObject;
   
   import editor.runtime.Runtime;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetManagerArrayLayout extends AssetManager 
   {
      public function GetAssetSpriteSize ():Number
      {
         return 100;
      }
      
      public function GetAssetSpriteGap ():Number
      {
         return 10;
      }
      
//========================================================
// 
//========================================================
      
      override public function SupportScaleRotateFlipTransforms ():Boolean
      {
         return false;
      }
      
      override public function SetPosition (px:Number, py:Number):void
      {
         super.SetPosition (px, py);
         
         RearrangeAssetPositions ();
      }
      
      override public function SetScale (s:Number):void
      {
         super.SetScale (s);
         
         RearrangeAssetPositions ();
      }
      
      override public function SetViewportSize (parentViewWidth:Number, parentViewHeight:Number):void
      {
         super.SetViewportSize (parentViewWidth, parentViewHeight);
         
         RearrangeAssetPositions ();
      }
      
      override public function MoveSelectedAssets (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         // temp do nothing
      }
      
      override public function DeleteSelectedAssets (passively:Boolean = false):Boolean
      {
         var result:Boolean = super.DeleteSelectedAssets ();
         
         RearrangeAssetPositions (true);
         
         return result;
      }
      
//========================================================
// 
//========================================================

      protected var mNumColumns:int = 0;
      protected var mContentWidth:Number;
      protected var mContentHeight:Number;
      
      public function RearrangeAssetPositions (forcely:Boolean = false):void
      {
         if (parent == null)
            return;
         
         mViewWidth  = parent.width  / this.scaleX;
         mViewHeight = parent.height / this.scaleY;
         
         var cellSize:Number = GetAssetSpriteSize () + GetAssetSpriteGap ();
         var numCols:int = Math.floor ((mViewWidth - GetAssetSpriteGap ()) / cellSize);
         if (numCols < 1)
            numCols = 1;
         
         if (numCols != mNumColumns || forcely)
         {
            mNumColumns = numCols;
            
            mContentWidth  = GetAssetSpriteGap () + mNumColumns * cellSize;
            mContentHeight = GetAssetSpriteGap ();
            
            var col:int = 0;
            var maxRowHeight:Number = 0;
            var numAssets:int = GetNumAssets ();
            for (var i:int = 0; i < numAssets; ++ i)
            {
               var asset:Asset = GetAssetByAppearanceId (i);
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
         
         if (mContentWidth < mViewWidth)
            x = 0;
         else if (x > 0)
            x = 0;
         else
         {
            var minX:Number = (mViewWidth - mContentWidth) * this.scaleX;
            if (x < minX)
            {
               x = minX;
            }
         }
         
         if (mContentHeight < mViewHeight)
            y = 0;
         else if (y > 0)
            y = 0;
         else
         {
            var minY:Number = (mViewHeight - mContentHeight) * this.scaleY;
            if (y < minY)
            {
               y = minY;
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

