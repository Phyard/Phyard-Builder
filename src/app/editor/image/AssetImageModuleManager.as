
package editor.image {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import editor.asset.AssetManagerArrayLayout; 
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageModuleManager extends AssetManagerArrayLayout
   {
      override public function GetAssetSpriteSize ():Number
      {
         return 100;
      }

      override public function GetAssetSpriteGap ():Number
      {
         return 10;
      }
      
//==========================================================      
// 
//==========================================================      
      
      public function GetModuleIconSize ():Number
      {
         return 86;
      }
      
   }
}
