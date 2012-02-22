
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.BitmapData;
   
   import flash.geom.Rectangle;
   import flash.geom.Point;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import common.Transform2D;
  
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageBitmapModule extends AssetImageModule
   {
      public function AssetImageBitmapModule (assetImageModuleManager:AssetImageModuleManager)
      {
         super (assetImageModuleManager);
      }
      
      public function GetBitmapData ():BitmapData
      {
         return null; // to override
      }
   }
}