
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.events.Event;
   
   import editor.selection.SelectionEngine;
   
   import editor.core.EditorObject;
   
   import editor.runtime.Runtime;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetManager extends AssetManager 
   {
      
      override public function SupportScaleRotateFlipTransforms ():Boolean
      {
         return false;
      }
   }
}

