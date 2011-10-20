package editor.image.vector
{
   import flash.display.DisplayObject; 
   import flash.geom.Point;
   
   import editor.selection.SelectionProxy;
   
   import common.Transform2D;
   
   public class VectorShapeTextForEditing extends VectorShapeRectangleForEditing
   {
      override public function OnCreating (points:Array):Point
      {
         return super.OnCreating (points);
      }
      
      override public function CreateSprite ():DisplayObject
      {
         return null;
      }
      
      override public function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         //
      }
   }
}
