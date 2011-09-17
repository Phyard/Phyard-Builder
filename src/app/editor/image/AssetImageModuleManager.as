
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
      public function GetModuleIconSize ():Number
      {
         return 86;
      }
      
   }
}
