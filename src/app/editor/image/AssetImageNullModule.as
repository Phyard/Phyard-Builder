
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   
   import flash.geom.Rectangle;
   import flash.geom.Point;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
      
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.LocalImageLoader;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   import editor.asset.AssetManager;
   
   import common.Transform2D;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageNullModule extends AssetImageModule
   {
      public function AssetImageNullModule ()
      {
         super (null); // no manager
         
         removeEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown); // added in super class
      }
      
      override public function ToCodeString ():String
      {
         return "None";
      }
      
//=============================================================
//   
//=============================================================

      override public function BuildImageModuleAppearance (container:Sprite, transform:Transform2D = null):void
      {
         var moduleSize:Number = 50;
         var halfModuleSize:Number = 0.5 * moduleSize;
         
         var rectShape:Shape = new Shape ();
         GraphicsUtil.DrawRect (rectShape, - halfModuleSize, - halfModuleSize, moduleSize, moduleSize,
                                       0x0000FF, -1, true, 0xD0FFD0, false);
         
         if (transform != null)
            transform.TransformUntransformedDisplayObject (rectShape);
         
         container.addChild (rectShape);
      }
      
      override public function BuildImageModulePhysicsAppearance (container:Sprite, transform:Transform2D = null):void
      {
      }
      
      override public function BuildImageModuleSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         var moduleSize:Number = 50;
         var halfModuleSize:Number = 0.5 * moduleSize;
         
         selectionProxy.AddRectangleShapeHalfWH (halfModuleSize, halfModuleSize, transform);
      }
      
  }
}
