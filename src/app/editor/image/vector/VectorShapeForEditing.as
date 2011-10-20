package editor.image.vector
{
   import flash.display.DisplayObject; 
   import flash.geom.Point;
   
   import editor.selection.SelectionProxy;
   
   import common.Transform2D;
   
   public interface VectorShapeForEditing
   {
      function OnCreating (points:Array):Point;
      
      function CreateSprite ():DisplayObject;
      
      function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void;
   }
}
