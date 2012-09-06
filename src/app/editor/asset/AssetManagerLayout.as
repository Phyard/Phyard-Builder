
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.utils.Dictionary;
   
   import editor.selection.SelectionEngine;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetManagerLayout
   {
      public function AssetManagerLayout ()
      {
      }
      
      public function SupportScaleRotateFlipTransforms ():Boolean
      {
         return true;
      }
      
      public function SupportMoveSelectedAssets ():Boolean
      {
         return true;
      }

      public function GetAssetSpriteWidth ():Number
      {
         return 100;
      }
      
      public function GetAssetSpriteHeight ():Number
      {
         return 100;
      }
      
      public function GetAssetSpriteGap ():Number
      {
         return 10;
      }
      
      public function DoLayout (forcely:Boolean = false, alsoUpdateAssetAppearance:Boolean = false):void
      {
         
      }
   }
}

