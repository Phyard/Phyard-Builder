
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Matrix;
   
   import flash.events.Event;
   
   import editor.selection.SelectionEngine;
   
   import editor.core.EditorObject;
   
   import editor.runtime.Runtime;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetManagerListLayout extends AssetManager 
   {
//==========================================================      
// 
//==========================================================    

      public function GetAssetSpriteWidth ():Number
      {
         return (parent == null? 100 : parent.width / scaleX) - 2 * GetAssetSpriteMargin ();
      }
      
      public function GetAssetSpriteHeight ():Number
      {
         return 100;
      }
      
      public function GetAssetSpriteMargin ():Number
      {
         return 10;
      }
      
//==========================================================      
// 
//==========================================================    
      
      override public function SupportScaleRotateFlipTransforms ():Boolean
      {
         return false;
      }
      
//==========================================================      
// 
//==========================================================  
      
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
      
      protected var mContentWidth:Number;
      protected var mContentHeight:Number;
      
      public function RearrangeAssetPositions (forcely:Boolean = false):void
      {
         if (parent == null)
            return;
         
         mViewWidth  = parent.width  / this.scaleX;
         mViewHeight = parent.height / this.scaleY;
         
         var rowHeight:Number = GetAssetSpriteHeight ();
         var margin:Number = GetAssetSpriteMargin ();
         
         if (forcely)
         {
            mContentWidth  = rowHeight;
            mContentHeight = margin;
            
            var numAssets:int = GetNumAssets ();
            for (var i:int = 0; i < numAssets; ++ i)
            {
               var asset:Asset = GetAssetByAppearanceId (i);
               var boundRect:Rectangle = asset.getBounds (asset);
               
               asset.SetPosition (- boundRect.left + margin, mContentHeight - boundRect.top);
               asset.UpdateAppearance ();
               asset.UpdateSelectionProxy ();
               
               mContentHeight += boundRect.height + margin;
            }
            
            mContentHeight += margin;
         }
         
         x = 0;
         
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

   }
}

