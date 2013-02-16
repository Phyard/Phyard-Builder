
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Matrix;
   
   import flash.events.Event;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetManagerListLayout extends AssetManagerLayout 
   {
      private var mAssetManager:AssetManager;
      
      public function AssetManagerListLayout (assetManager:AssetManager, assetSpriteHeight:Number = 100, assetSpriteGap:Number = 10)
      {
         mAssetManager = assetManager;
         
         mAssetSpriteHeight = assetSpriteHeight;
         mAssetSpriteGap = assetSpriteGap;
      }

      override public function GetAssetSpriteWidth ():Number
      {
         return (mAssetManager.parent == null? 100 : mAssetManager.parent.width / mAssetManager.scaleX) - 2 * GetAssetSpriteGap ();
      }
      
      private var mAssetSpriteHeight:Number = 100;
      
      override public function GetAssetSpriteHeight ():Number
      {
         return mAssetSpriteHeight;
      }
      
      private var mAssetSpriteGap:Number = 10;
      
      override public function GetAssetSpriteGap ():Number
      {
         return mAssetSpriteGap;
      }
      
//==========================================================      
// 
//==========================================================    
      
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
      
//==========================================================      
// 
//==========================================================  
      
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
            
            var rowHeight:Number = GetAssetSpriteHeight ();
            var gap:Number = GetAssetSpriteGap ();
            
            if (forcely)
            {
               mContentWidth  = rowHeight;
               mContentHeight = gap;
               
               var numAssets:int = mAssetManager.GetNumAssets ();
               for (var i:int = 0; i < numAssets; ++ i)
               {
                  var asset:Asset = mAssetManager.GetAssetByAppearanceId (i);
                  if (alsoUpdateAssetAppearance)
                     asset.UpdateAppearance ();
                  
                  var boundRect:Rectangle = asset.getBounds (asset);
                  
                  asset.SetPosition (- boundRect.left + gap, mContentHeight - boundRect.top);
                  asset.UpdateAppearance ();
                  asset.UpdateSelectionProxy ();
                     
                  if (insertionPoint != null)
                  {
                     if (insertionPoint.y < asset.GetPositionY () + 0.5 * (boundRect.top + boundRect.bottom))
                     {
                        return [i, 
                                asset.GetPositionX () + 0.5 * (boundRect.left + boundRect.right),
                                asset.GetPositionY () + boundRect.top - 0.5 * GetAssetSpriteGap (), 
                                false
                                ];
                     }
                     else if (i == numAssets - 1)
                     {
                        return [numAssets, 
                                asset.GetPositionX () + 0.5 * (boundRect.left + boundRect.right),
                                asset.GetPositionY () + boundRect.bottom + 0.5 * GetAssetSpriteGap (), 
                                false
                                ];
                     }
                  }
                  
                  mContentHeight += boundRect.height + gap;
               }
               
               mContentHeight += gap;
            }
            
            mAssetManager.x = 0;
            
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

